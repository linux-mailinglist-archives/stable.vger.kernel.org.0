Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75BDC3C8E2A
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237872AbhGNTqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:46:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237389AbhGNTp6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:45:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 716B261400;
        Wed, 14 Jul 2021 19:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291745;
        bh=iZXOwNIqvRVUKE7MeSSXOxAuhXS62VInPViWbCCromQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FS7906Sw+1OBZbnh+Uq6e0HOj6FnXjxIM/918FKpWqaQBNb92t+g81VVXHkLFg1WJ
         D1iBaadT5azexY9bCAVDJ16iVs/VznXVedD1kB0Nc/gSD1oUHeV5x+LcwbNBhNXGrR
         9fnh1fYYaBDQnkqGpIpCqCkgklglFDllrJD3atovrJ+k/7aIDZsk66DkfxwJZnbfXn
         Sz2k5gc/GuMGDPDlJOB0j4fR7Wx1NgRTbvSdRvO11Pz5twPPfq0wFvASUhXwjVMZ0O
         F9VUMSH2rq6N+0CCaRzo1BvkiMAPfRLCE6CGbx7QaWrtPwPLqoX+ipODNLgaEPjtbW
         iz8aCnRuBtOcQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Dave Gerlach <d-gerlach@ti.com>,
        Suman Anna <s-anna@ti.com>, Sasha Levin <sashal@kernel.org>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 076/102] ARM: OMAP2+: Block suspend for am3 and am4 if PM is not configured
Date:   Wed, 14 Jul 2021 15:40:09 -0400
Message-Id: <20210714194036.53141-76-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 093a474ce10d8ea3db3ef2922aca5a38f34bab1b ]

If the PM related modules are not loaded and PM firmware not configured,
the system suspend fails to resume. Let's fix this by adding initial
platform_suspend_ops to block suspend and warn about missing modules.

When pm33xx and wkup_m3_ipc have been loaded and m3 coprocessor booted
with it's firmware, pm33xx sets up working platform_suspend_ops. Note
that we need to configure at least PM_SUSPEND_STANDBY to have
suspend_set_ops().

Cc: Dave Gerlach <d-gerlach@ti.com>
Cc: Suman Anna <s-anna@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/pm33xx-core.c | 40 +++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/arch/arm/mach-omap2/pm33xx-core.c b/arch/arm/mach-omap2/pm33xx-core.c
index 56f2c0bcae5a..bf0d25fd2cea 100644
--- a/arch/arm/mach-omap2/pm33xx-core.c
+++ b/arch/arm/mach-omap2/pm33xx-core.c
@@ -8,6 +8,7 @@
 
 #include <linux/cpuidle.h>
 #include <linux/platform_data/pm33xx.h>
+#include <linux/suspend.h>
 #include <asm/cpuidle.h>
 #include <asm/smp_scu.h>
 #include <asm/suspend.h>
@@ -324,6 +325,44 @@ static struct am33xx_pm_platform_data *am33xx_pm_get_pdata(void)
 		return NULL;
 }
 
+#ifdef CONFIG_SUSPEND
+/*
+ * Block system suspend initially. Later on pm33xx sets up it's own
+ * platform_suspend_ops after probe. That depends also on loaded
+ * wkup_m3_ipc and booted am335x-pm-firmware.elf.
+ */
+static int amx3_suspend_block(suspend_state_t state)
+{
+	pr_warn("PM not initialized for pm33xx, wkup_m3_ipc, or am335x-pm-firmware.elf\n");
+
+	return -EINVAL;
+}
+
+static int amx3_pm_valid(suspend_state_t state)
+{
+	switch (state) {
+	case PM_SUSPEND_STANDBY:
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+static const struct platform_suspend_ops amx3_blocked_pm_ops = {
+	.begin = amx3_suspend_block,
+	.valid = amx3_pm_valid,
+};
+
+static void __init amx3_block_suspend(void)
+{
+	suspend_set_ops(&amx3_blocked_pm_ops);
+}
+#else
+static inline void amx3_block_suspend(void)
+{
+}
+#endif	/* CONFIG_SUSPEND */
+
 int __init amx3_common_pm_init(void)
 {
 	struct am33xx_pm_platform_data *pdata;
@@ -337,6 +376,7 @@ int __init amx3_common_pm_init(void)
 	devinfo.size_data = sizeof(*pdata);
 	devinfo.id = -1;
 	platform_device_register_full(&devinfo);
+	amx3_block_suspend();
 
 	return 0;
 }
-- 
2.30.2

