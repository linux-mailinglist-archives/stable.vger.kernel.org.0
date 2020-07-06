Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F775215BF8
	for <lists+stable@lfdr.de>; Mon,  6 Jul 2020 18:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbgGFQi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 12:38:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729591AbgGFQiX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jul 2020 12:38:23 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AE0A2073E;
        Mon,  6 Jul 2020 16:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594053503;
        bh=8J7g0mTG6pd6WaHeq7nH0DIA6WvRovEnq7lUeCX4BAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bto1XKX9+ReIM0ciBdBqA+6ppCIPvYTLd2rPlEo6RYcc7rljFF6diWMWmOs7pgqap
         vBsb2bv02t46fy3ooy2lh38mbx/z3wyQX6YTKE4wnXJargE2qGcwfYe5bbhgSG/Fnu
         UiGRm+R8/h39xZOAQLQI6apuS3UVzXm8oMRO9tfQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jsU8L-009VkI-PH; Mon, 06 Jul 2020 17:38:21 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, stable@vger.kernel.org
Subject: [PATCH v2 3/4] arm64: arch_timer: Disable the compat vdso for cores affected by ARM64_WORKAROUND_1418040
Date:   Mon,  6 Jul 2020 17:38:01 +0100
Message-Id: <20200706163802.1836732-4-maz@kernel.org>
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

ARM64_WORKAROUND_1418040 requires that AArch32 EL0 accesses to
the virtual counter register are trapped and emulated by the kernel.
This makes the vdso pretty pointless, and in some cases livelock
prone.

Provide a workaround entry that limits the vdso to 64bit tasks.

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/clocksource/arm_arch_timer.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index a8e4fb429f52..6c3e84180146 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -480,6 +480,14 @@ static const struct arch_timer_erratum_workaround ool_workarounds[] = {
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

