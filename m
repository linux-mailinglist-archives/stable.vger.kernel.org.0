Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38CC1F30F2
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 03:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbgFIBEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 21:04:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727119AbgFHXHb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:07:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F7AB20842;
        Mon,  8 Jun 2020 23:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657650;
        bh=Kjt7P2a4tbw5TuKZhyerlZXQZ4Y6YzQHMoiX4ctDvCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=njYHY3EIiURi4PbA97BlH/BC27GKJPQVQxo8/UaLPpv9vk2+PkJQyCaLnlrn67Gq3
         JG3kaA0DW2EPXaVKLbQG+loEe0JAR3vOW/sxWMKYvGw8BHaUlm/QZ8Iu02TzSJZJBa
         faZBSTTAYcFMlk7XO++ATU3O72eaQIEPWH4i291Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>, linux-mips@vger.kernel.org,
        linux-rtc@vger.kernel.org, devicetree@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.7 064/274] clocksource: dw_apb_timer: Make CPU-affiliation being optional
Date:   Mon,  8 Jun 2020 19:02:37 -0400
Message-Id: <20200608230607.3361041-64-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit cee43dbf2ee3f430434e2b66994eff8a1aeda889 ]

Currently the DW APB Timer driver binds each clockevent timers to a
particular CPU. This isn't good for multiple reasons. First of all seeing
the device is placed on APB bus (which makes it accessible from any CPU
core), accessible over MMIO and having the DYNIRQ flag set we can be sure
that manually binding the timer to any CPU just isn't correct. By doing
so we just set an extra limitation on device usage. This also doesn't
reflect the device actual capability, since by setting the IRQ affinity
we can make it virtually local to any CPU. Secondly imagine if you had a
real CPU-local timer with the same rating and the same CPU-affinity.
In this case if DW APB timer was registered first, then due to the
clockevent framework tick-timer selection procedure we'll end up with the
real CPU-local timer being left unselected for clock-events tracking. But
on most of the platforms (MIPS/ARM/etc) such timers are normally embedded
into the CPU core and are accessible with much better performance then
devices placed on APB. For instance in MIPS architectures there is
r4k-timer, which is CPU-local, assigned with the same rating, and normally
its clockevent device is registered after the platform-specific one.

So in order to fix all of these issues let's make the DW APB Timer CPU
affinity being optional and deactivated by passing a negative CPU id,
which will effectively set the DW APB clockevent timer cpumask to
'cpu_possible_mask'.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc: Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Paul Burton <paulburton@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: linux-mips@vger.kernel.org
Cc: linux-rtc@vger.kernel.org
Cc: devicetree@vger.kernel.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20200521204818.25436-5-Sergey.Semin@baikalelectronics.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/dw_apb_timer.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/dw_apb_timer.c b/drivers/clocksource/dw_apb_timer.c
index b207a77b0831..f5f24a95ee82 100644
--- a/drivers/clocksource/dw_apb_timer.c
+++ b/drivers/clocksource/dw_apb_timer.c
@@ -222,7 +222,8 @@ static int apbt_next_event(unsigned long delta,
 /**
  * dw_apb_clockevent_init() - use an APB timer as a clock_event_device
  *
- * @cpu:	The CPU the events will be targeted at.
+ * @cpu:	The CPU the events will be targeted at or -1 if CPU affiliation
+ *		isn't required.
  * @name:	The name used for the timer and the IRQ for it.
  * @rating:	The rating to give the timer.
  * @base:	I/O base for the timer registers.
@@ -257,7 +258,7 @@ dw_apb_clockevent_init(int cpu, const char *name, unsigned rating,
 	dw_ced->ced.max_delta_ticks = 0x7fffffff;
 	dw_ced->ced.min_delta_ns = clockevent_delta2ns(5000, &dw_ced->ced);
 	dw_ced->ced.min_delta_ticks = 5000;
-	dw_ced->ced.cpumask = cpumask_of(cpu);
+	dw_ced->ced.cpumask = cpu < 0 ? cpu_possible_mask : cpumask_of(cpu);
 	dw_ced->ced.features = CLOCK_EVT_FEAT_PERIODIC |
 				CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_DYNIRQ;
 	dw_ced->ced.set_state_shutdown = apbt_shutdown;
-- 
2.25.1

