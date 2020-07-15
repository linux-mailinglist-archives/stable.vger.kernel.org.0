Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF055220D79
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 14:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731166AbgGOM4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 08:56:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731061AbgGOM4Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 08:56:24 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35560206D5;
        Wed, 15 Jul 2020 12:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594817783;
        bh=WCVwPnBbaSt5jW9rzfx4dsFgGFwETXzVHk1ed7SRJqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXqZlP5KodJmUWYlQ5fP3Ura0iztzpSgD68nwsFtfHs2/MypGShGMKDhwb0vWa5D7
         iYEkbbUq8i4oMivvY5EG0md1pX76RUcvR1nxCUp0LRnH1fnEe+H5y/B/pCncwwCLab
         K9bJFB645fAZ7ZxJIiXVZHHzE2BU5AHtf/PhEpaQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jvgxR-00Bzgo-Ot; Wed, 15 Jul 2020 13:56:21 +0100
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
Subject: [Stable-5.4][PATCH 2/3] arm64: arch_timer: Allow an workaround descriptor to disable compat vdso
Date:   Wed, 15 Jul 2020 13:56:13 +0100
Message-Id: <20200715125614.3240269-3-maz@kernel.org>
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

Commit c1fbec4ac0d701f350a581941d35643d5a9cd184 upstream.

As we are about to disable the vdso for compat tasks in some circumstances,
let's allow a workaround descriptor to express exactly that.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200706163802.1836732-3-maz@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
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
index 909fe093249e..fd2a75f0af77 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -562,6 +562,9 @@ void arch_timer_enable_workaround(const struct arch_timer_erratum_workaround *wa
 	if (wa->read_cntvct_el0) {
 		clocksource_counter.archdata.clock_mode = VDSO_CLOCKMODE_NONE;
 		vdso_default = VDSO_CLOCKMODE_NONE;
+	} else if (wa->disable_compat_vdso && vdso_default != VDSO_CLOCKMODE_NONE) {
+		vdso_default = VDSO_CLOCKMODE_ARCHTIMER_NOCOMPAT;
+		clocksource_counter.archdata.clock_mode = vdso_default;
 	}
 }
 
-- 
2.27.0

