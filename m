Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64FF635BE4E
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238174AbhDLI5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:57:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239037AbhDLIz3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:55:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AAA661244;
        Mon, 12 Apr 2021 08:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217708;
        bh=a2/KlIOhfZVE0ULLCyfKNEC2aC9EBC7sBfGewH1J7wc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LwdaxHVpTodQZ3yQqUF0x4018MyeFKWeDrTgGaFGGW3Chn7cgwPPaTUdpp3KVNqte
         33jNtHPfrlGIuD87ferEy/4ULaJgoWuTEaLy1bXgsns6bbDExLRMPp4E8H6Gn5jQUP
         0aAaGgTbCjDUsycD6BGI2VfBluqm87na7q7Ofpl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carlos Leija <cileija@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        Bryan Buckley <bryan.buckley@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        Carl Philipp Klemm <philipp@uvos.xyz>,
        Merlijn Wajer <merlijn@wizzup.org>,
        Ivan Jelincic <parazyd@dyne.org>, Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sre@kernel.org>,
        Tero Kristo <kristo@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/188] ARM: OMAP4: PM: update ROM return address for OSWR and OFF
Date:   Mon, 12 Apr 2021 10:40:13 +0200
Message-Id: <20210412084016.943877912@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Carlos Leija <cileija@ti.com>

[ Upstream commit b3d09a06d89f474cb52664e016849315a97e09d9 ]

We need to add a dummy smc call to the cpuidle wakeup path to force the
ROM code to save the return address after MMU is enabled again. This is
needed to prevent random hangs on secure devices like droid4.

Otherwise the system will eventually hang when entering deeper SoC idle
states with the core and mpu domains in open-switch retention (OSWR).
The hang happens as the ROM code tries to use the earlier physical return
address set by omap-headsmp.S with MMU off while waking up CPU1 again.

The hangs started happening in theory already with commit caf8c87d7ff2
("ARM: OMAP2+: Allow core oswr for omap4"), but in practise the issue went
unnoticed as various drivers were often blocking any deeper idle states
with hardware autoidle features.

This patch is based on an earlier TI Linux kernel tree commit 92f0b3028d9e
("OMAP4: PM: update ROM return address for OSWR and OFF") written by
Carlos Leija <cileija@ti.com>, Praneeth Bajjuri <praneeth@ti.com>, and
Bryan Buckley <bryan.buckley@ti.com>. A later version of the patch was
updated to use CPU_PM notifiers by Tero Kristo <t-kristo@ti.com>.

Signed-off-by: Carlos Leija <cileija@ti.com>
Signed-off-by: Praneeth Bajjuri <praneeth@ti.com>
Signed-off-by: Bryan Buckley <bryan.buckley@ti.com>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
Fixes: caf8c87d7ff2 ("ARM: OMAP2+: Allow core oswr for omap4")
Reported-by: Carl Philipp Klemm <philipp@uvos.xyz>
Reported-by: Merlijn Wajer <merlijn@wizzup.org>
Cc: Ivan Jelincic <parazyd@dyne.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Tero Kristo <kristo@kernel.org>
[tony@atomide.com: updated to apply, updated description]
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/omap-secure.c | 39 +++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/omap-secure.h |  1 +
 2 files changed, 40 insertions(+)

diff --git a/arch/arm/mach-omap2/omap-secure.c b/arch/arm/mach-omap2/omap-secure.c
index f70d561f37f7..0659ab4cb0af 100644
--- a/arch/arm/mach-omap2/omap-secure.c
+++ b/arch/arm/mach-omap2/omap-secure.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/arm-smccc.h>
+#include <linux/cpu_pm.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/io.h>
@@ -20,6 +21,7 @@
 
 #include "common.h"
 #include "omap-secure.h"
+#include "soc.h"
 
 static phys_addr_t omap_secure_memblock_base;
 
@@ -213,3 +215,40 @@ void __init omap_secure_init(void)
 {
 	omap_optee_init_check();
 }
+
+/*
+ * Dummy dispatcher call after core OSWR and MPU off. Updates the ROM return
+ * address after MMU has been re-enabled after CPU1 has been woken up again.
+ * Otherwise the ROM code will attempt to use the earlier physical return
+ * address that got set with MMU off when waking up CPU1. Only used on secure
+ * devices.
+ */
+static int cpu_notifier(struct notifier_block *nb, unsigned long cmd, void *v)
+{
+	switch (cmd) {
+	case CPU_CLUSTER_PM_EXIT:
+		omap_secure_dispatcher(OMAP4_PPA_SERVICE_0,
+				       FLAG_START_CRITICAL,
+				       0, 0, 0, 0, 0);
+		break;
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block secure_notifier_block = {
+	.notifier_call = cpu_notifier,
+};
+
+static int __init secure_pm_init(void)
+{
+	if (omap_type() == OMAP2_DEVICE_TYPE_GP || !soc_is_omap44xx())
+		return 0;
+
+	cpu_pm_register_notifier(&secure_notifier_block);
+
+	return 0;
+}
+omap_arch_initcall(secure_pm_init);
diff --git a/arch/arm/mach-omap2/omap-secure.h b/arch/arm/mach-omap2/omap-secure.h
index 4aaa95706d39..172069f31616 100644
--- a/arch/arm/mach-omap2/omap-secure.h
+++ b/arch/arm/mach-omap2/omap-secure.h
@@ -50,6 +50,7 @@
 #define OMAP5_DRA7_MON_SET_ACR_INDEX	0x107
 
 /* Secure PPA(Primary Protected Application) APIs */
+#define OMAP4_PPA_SERVICE_0		0x21
 #define OMAP4_PPA_L2_POR_INDEX		0x23
 #define OMAP4_PPA_CPU_ACTRL_SMP_INDEX	0x25
 
-- 
2.30.2



