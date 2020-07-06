Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E7D215BF5
	for <lists+stable@lfdr.de>; Mon,  6 Jul 2020 18:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbgGFQiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 12:38:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729525AbgGFQiX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jul 2020 12:38:23 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9C4720723;
        Mon,  6 Jul 2020 16:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594053502;
        bh=talTHVAw/bk/0lEmBLS3sFYQDt7e2jJLNTUE2ByRFqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZItyH060DXRNcfX7vkxjflo7vh+s+FDlytqzRu7BtILOh8R2lgOfRhfadquBWM6e/
         aWkwAfuUR2N5o14XDcmCpsGJ0Tl5yuYwmiKuX2Frm3p8+q5lvaMZzSWv2FgOZEHryh
         hamhxS/KQIKDrhRhYGPr+9ceQYEws7p7oDwwaDDI=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jsU8L-009VkI-9I; Mon, 06 Jul 2020 17:38:21 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, stable@vger.kernel.org
Subject: [PATCH v2 2/4] arm64: arch_timer: Allow an workaround descriptor to disable compat vdso
Date:   Mon,  6 Jul 2020 17:38:00 +0100
Message-Id: <20200706163802.1836732-3-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200706163802.1836732-1-maz@kernel.org>
References: <20200706163802.1836732-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: will@kernel.org, catalin.marinas@arm.com, daniel.lezcano@linaro.org, vincenzo.frascino@arm.com, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-team@android.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As we are about to disable the vdso for compat tasks in some circumstances,
let's allow a workaround descriptor to express exactly that.

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/arch_timer.h  | 1 +
 drivers/clocksource/arm_arch_timer.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index 7ae54d7d333a..9f0ec21d6327 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -58,6 +58,7 @@ struct arch_timer_erratum_workaround {
 	u64 (*read_cntvct_el0)(void);
 	int (*set_next_event_phys)(unsigned long, struct clock_event_device *);
 	int (*set_next_event_virt)(unsigned long, struct clock_event_device *);
+	bool disable_compat_vdso;
 };
 
 DECLARE_PER_CPU(const struct arch_timer_erratum_workaround *,
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index ecf7b7db2d05..a8e4fb429f52 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -566,6 +566,9 @@ void arch_timer_enable_workaround(const struct arch_timer_erratum_workaround *wa
 	if (wa->read_cntvct_el0) {
 		clocksource_counter.vdso_clock_mode = VDSO_CLOCKMODE_NONE;
 		vdso_default = VDSO_CLOCKMODE_NONE;
+	} else if (wa->disable_compat_vdso && vdso_default != VDSO_CLOCKMODE_NONE) {
+		vdso_default = VDSO_CLOCKMODE_ARCHTIMER_NOCOMPAT;
+		clocksource_counter.vdso_clock_mode = vdso_default;
 	}
 }
 
-- 
2.27.0

