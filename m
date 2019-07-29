Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 885437995B
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729166AbfG2UOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 16:14:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727823AbfG2T1e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:27:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26B0B2070B;
        Mon, 29 Jul 2019 19:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428453;
        bh=ShgKpm0eZJ7Plq1nkdU7/k8Ezm6faceNi+rb9OH4lOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yHyEiIl8kaUgbgk8yEm8BW97w59GKsDg8BQ3R6j6W+Lha+6qFAn2C3xDmR4uX8Mqt
         GLxxAgf8hx1MWDRj37j1dLv3F0HjK1/sqHJc5pmwmd9ldEBAumT49AZVKkdq3wi04l
         ZfOYXeQyTzXG8ZKKkPxSXEk1Jdu9aBFZ3oGdoumA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 081/293] clocksource/drivers/exynos_mct: Increase priority over ARM arch timer
Date:   Mon, 29 Jul 2019 21:19:32 +0200
Message-Id: <20190729190830.826229620@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index d55c30f6981d..aaf5bfa9bd9c 100644
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
index 0c78ad0cc515..0834eb5ea9e6 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -115,10 +115,10 @@ enum cpuhp_state {
 	CPUHP_AP_PERF_ARM_ACPI_STARTING,
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



