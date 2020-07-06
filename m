Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89DC8215BFB
	for <lists+stable@lfdr.de>; Mon,  6 Jul 2020 18:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729629AbgGFQie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 12:38:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729572AbgGFQiX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jul 2020 12:38:23 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31844206DF;
        Mon,  6 Jul 2020 16:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594053502;
        bh=/KPd09KdZKob2qkTyjIJHMXWlEwZQK9UHtQEP0K6TzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=algBxFbzt+IhTO6TY2upG/5ICNR7V0vVp5KgDNkWwGtyEXQoMMN4r/I89rXtG4fuJ
         S43jo+ERsY1zVo7Ic2QzHwhBLgyPgB+KYC8+JQnpg6eNvj+hcQDJQ+7TmyfBl7p1Lt
         xhzdnWnQ1Uupdil4uqFlLdqR4WeC7/U2TiWSjbv0=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jsU8K-009VkI-MG; Mon, 06 Jul 2020 17:38:20 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, stable@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v2 1/4] arm64: Introduce a way to disable the 32bit vdso
Date:   Mon,  6 Jul 2020 17:37:59 +0100
Message-Id: <20200706163802.1836732-2-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200706163802.1836732-1-maz@kernel.org>
References: <20200706163802.1836732-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: will@kernel.org, catalin.marinas@arm.com, daniel.lezcano@linaro.org, vincenzo.frascino@arm.com, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-team@android.com, stable@vger.kernel.org, mark.rutland@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We have a class of errata (grouped under the ARM64_WORKAROUND_1418040
banner) that force the trapping of counter access from 32bit EL0.

We would normally disable the whole vdso for such defect, except that
it would disable it for 64bit userspace as well, which is a shame.

Instead, add a new vdso_clock_mode, which signals that the vdso
isn't usable for compat tasks.  This gets checked in the new
vdso_clocksource_ok() helper, now provided for the 32bit vdso.

Cc: stable@vger.kernel.org
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/vdso/clocksource.h         | 7 +++++--
 arch/arm64/include/asm/vdso/compat_gettimeofday.h | 8 +++++++-
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/vdso/clocksource.h b/arch/arm64/include/asm/vdso/clocksource.h
index df6ea65c1dec..b054d9febfb5 100644
--- a/arch/arm64/include/asm/vdso/clocksource.h
+++ b/arch/arm64/include/asm/vdso/clocksource.h
@@ -2,7 +2,10 @@
 #ifndef __ASM_VDSOCLOCKSOURCE_H
 #define __ASM_VDSOCLOCKSOURCE_H
 
-#define VDSO_ARCH_CLOCKMODES	\
-	VDSO_CLOCKMODE_ARCHTIMER
+#define VDSO_ARCH_CLOCKMODES					\
+	/* vdso clocksource for both 32 and 64bit tasks */	\
+	VDSO_CLOCKMODE_ARCHTIMER,				\
+	/* vdso clocksource for 64bit tasks only */		\
+	VDSO_CLOCKMODE_ARCHTIMER_NOCOMPAT
 
 #endif
diff --git a/arch/arm64/include/asm/vdso/compat_gettimeofday.h b/arch/arm64/include/asm/vdso/compat_gettimeofday.h
index b6907ae78e53..9a625e8947ff 100644
--- a/arch/arm64/include/asm/vdso/compat_gettimeofday.h
+++ b/arch/arm64/include/asm/vdso/compat_gettimeofday.h
@@ -111,7 +111,7 @@ static __always_inline u64 __arch_get_hw_counter(s32 clock_mode)
 	 * update. Return something. Core will do another round and then
 	 * see the mode change and fallback to the syscall.
 	 */
-	if (clock_mode == VDSO_CLOCKMODE_NONE)
+	if (clock_mode != VDSO_CLOCKMODE_ARCHTIMER)
 		return 0;
 
 	/*
@@ -152,6 +152,12 @@ static __always_inline const struct vdso_data *__arch_get_vdso_data(void)
 	return ret;
 }
 
+static inline bool vdso_clocksource_ok(const struct vdso_data *vd)
+{
+	return vd->clock_mode == VDSO_CLOCKMODE_ARCHTIMER;
+}
+#define vdso_clocksource_ok	vdso_clocksource_ok
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* __ASM_VDSO_GETTIMEOFDAY_H */
-- 
2.27.0

