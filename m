Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD8E201304
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392619AbgFSPTx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:19:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392598AbgFSPS4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:18:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B9A52158C;
        Fri, 19 Jun 2020 15:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579934;
        bh=Kjt7P2a4tbw5TuKZhyerlZXQZ4Y6YzQHMoiX4ctDvCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JhCxhHjZV3hBKJbljR/erFnDBxkl75WPxnGtOZw9oWb+KODHjO+0x/Ccr/UuNa8kC
         AusmEXFTS6qEEFOdlehOO2ELSEas2MBRVBZS1U8lq1IZ5pGXx3izuFhx8L4B2f9NT8
         u13SW0KCYo8m5/5amZAOsVu2c2fDJiYmd1xbBIsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
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
Subject: [PATCH 5.7 060/376] clocksource: dw_apb_timer: Make CPU-affiliation being optional
Date:   Fri, 19 Jun 2020 16:29:38 +0200
Message-Id: <20200619141713.194570064@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



