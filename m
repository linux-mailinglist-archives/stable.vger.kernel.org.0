Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D39D6692E7
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404424AbfGOOk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:40:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404688AbfGOOk0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:40:26 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8F17204FD;
        Mon, 15 Jul 2019 14:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563201625;
        bh=JL6iMqfA0tjvko22FtNMB3NQ/VWXe4m24I16A6loeaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l+3W3T5BnuPEkZ/eaeueGbD/nQgJORXefQ63ap1yH8uwd4c4+HZbS8+j1H6SU1qXj
         +XPv7RCthAQNCZ9K8CDG6U6LgTBzEabx+5TyIPR+jThWsSX0EvShOak7TYs3tl/xxl
         tvdXcsPk9OKpo1ys6N5Cr8u/1Dhg3s/ghpPEE2YQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 57/73] clocksource/drivers/exynos_mct: Increase priority over ARM arch timer
Date:   Mon, 15 Jul 2019 10:36:13 -0400
Message-Id: <20190715143629.10893-57-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715143629.10893-1-sashal@kernel.org>
References: <20190715143629.10893-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 6282edb72bed5324352522d732080d4c1b9dfed6 ]

Exynos SoCs based on CA7/CA15 have 2 timer interfaces: custom Exynos MCT
(Multi Core Timer) and standard ARM Architected Timers.

There are use cases, where both timer interfaces are used simultanously.
One of such examples is using Exynos MCT for the main system timer and
ARM Architected Timers for the KVM and virtualized guests (KVM requires
arch timers).

Exynos Multi-Core Timer driver (exynos_mct) must be however started
before ARM Architected Timers (arch_timer), because they both share some
common hardware blocks (global system counter) and turning on MCT is
needed to get ARM Architected Timer working properly.

To ensure selecting Exynos MCT as the main system timer, increase MCT
timer rating. To ensure proper starting order of both timers during
suspend/resume cycle, increase MCT hotplug priority over ARM Archictected
Timers.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/exynos_mct.c | 4 ++--
 include/linux/cpuhotplug.h       | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index fb0cf8b74516..d32248e2ceab 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -211,7 +211,7 @@ static void exynos4_frc_resume(struct clocksource *cs)
 
 static struct clocksource mct_frc = {
 	.name		= "mct-frc",
-	.rating		= 400,
+	.rating		= 450,	/* use value higher than ARM arch timer */
 	.read		= exynos4_frc_read,
 	.mask		= CLOCKSOURCE_MASK(32),
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
@@ -466,7 +466,7 @@ static int exynos4_mct_starting_cpu(unsigned int cpu)
 	evt->set_state_oneshot_stopped = set_state_shutdown;
 	evt->tick_resume = set_state_shutdown;
 	evt->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
-	evt->rating = 450;
+	evt->rating = 500;	/* use value higher than ARM arch timer */
 
 	exynos4_mct_write(TICK_BASE_CNT, mevt->base + MCT_L_TCNTB_OFFSET);
 
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index c9447a689522..1ab0273560ae 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -77,10 +77,10 @@ enum cpuhp_state {
 	CPUHP_AP_PERF_ARM_HW_BREAKPOINT_STARTING,
 	CPUHP_AP_PERF_ARM_STARTING,
 	CPUHP_AP_ARM_L2X0_STARTING,
+	CPUHP_AP_EXYNOS4_MCT_TIMER_STARTING,
 	CPUHP_AP_ARM_ARCH_TIMER_STARTING,
 	CPUHP_AP_ARM_GLOBAL_TIMER_STARTING,
 	CPUHP_AP_JCORE_TIMER_STARTING,
-	CPUHP_AP_EXYNOS4_MCT_TIMER_STARTING,
 	CPUHP_AP_ARM_TWD_STARTING,
 	CPUHP_AP_METAG_TIMER_STARTING,
 	CPUHP_AP_QCOM_TIMER_STARTING,
-- 
2.20.1

