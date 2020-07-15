Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C943B220D7D
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 14:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731174AbgGOM4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 08:56:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbgGOM4Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 08:56:24 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04A76206E9;
        Wed, 15 Jul 2020 12:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594817784;
        bh=lLzzKnjPZFsQliwuK2UoN47QQgGtjviOYVT/55SWMgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JAvp8tbI65/xUAuhJY9HQpbBH+ZaBVACU7AG9v9EmvL6Dba9u4CmUdLUDpQDe4ZLj
         /Bbvlmfx1AeZdTyYqT7L33NQTFyacaETwHGpiRN9Zp3cNwvbbt53LmWpcSjV4+GXcn
         owv9fgcNXbQ1rCCW3+fFmWEbDPpuCLwZxkY30Ilg=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jvgxS-00Bzgo-HW; Wed, 15 Jul 2020 13:56:22 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     arnd@arndb.de, sashal@kernel.org, naresh.kamboju@linaro.org,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com
Subject: [Stable-5.4][PATCH 3/3] arm64: arch_timer: Disable the compat vdso for cores affected by ARM64_WORKAROUND_1418040
Date:   Wed, 15 Jul 2020 13:56:14 +0100
Message-Id: <20200715125614.3240269-4-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200715125614.3240269-1-maz@kernel.org>
References: <20200715125614.3240269-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: gregkh@linuxfoundation.org, stable@vger.kernel.org, arnd@arndb.de, sashal@kernel.org, naresh.kamboju@linaro.org, mark.rutland@arm.com, will@kernel.org, catalin.marinas@arm.com, daniel.lezcano@linaro.org, vincenzo.frascino@arm.com, linux@arm.linux.org.uk, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 4b661d6133c5d3a7c9aca0b4ee5a78c7766eff3f upstream.

ARM64_WORKAROUND_1418040 requires that AArch32 EL0 accesses to
the virtual counter register are trapped and emulated by the kernel.
This makes the vdso pretty pointless, and in some cases livelock
prone.

Provide a workaround entry that limits the vdso to 64bit tasks.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200706163802.1836732-4-maz@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/clocksource/arm_arch_timer.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index fd2a75f0af77..4be83b4de2a0 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -476,6 +476,14 @@ static const struct arch_timer_erratum_workaround ool_workarounds[] = {
 		.set_next_event_virt = erratum_set_next_event_tval_virt,
 	},
 #endif
+#ifdef CONFIG_ARM64_ERRATUM_1418040
+	{
+		.match_type = ate_match_local_cap_id,
+		.id = (void *)ARM64_WORKAROUND_1418040,
+		.desc = "ARM erratum 1418040",
+		.disable_compat_vdso = true,
+	},
+#endif
 };
 
 typedef bool (*ate_match_fn_t)(const struct arch_timer_erratum_workaround *,
-- 
2.27.0

