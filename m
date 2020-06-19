Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F81B201441
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391468AbgFSPGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:06:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391447AbgFSPGh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:06:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74DC321841;
        Fri, 19 Jun 2020 15:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579195;
        bh=/wDY0J7ZCbV+kbdSd0PMHEoJW6LCkYfxvOWL2ZHCfxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vBNFHgFx+J07nmymz6J96yBYCxn5RSArfvuwofpCAj74hg0NqCmRqV3MjQT5unkPd
         PP/5r8yBY751GWfIglQ271RRMuXcXo0bxV8aDAcqSs0McMRjsKPJ2q+Aua7P0KHoAf
         xrowFq/aVyyRragGrhQM6+do6cR5Rm6qoSKklqsM=
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
Subject: [PATCH 5.4 043/261] clocksource: dw_apb_timer_of: Fix missing clockevent timers
Date:   Fri, 19 Jun 2020 16:30:54 +0200
Message-Id: <20200619141651.995377300@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit 6d2e16a3181bafb77b535095c39ad1c8b9558c8c ]

Commit 100214889973 ("clocksource: dw_apb_timer_of: use
clocksource_of_init") replaced a publicly available driver
initialization method with one called by the timer_probe() method
available after CLKSRC_OF. In current implementation it traverses
all the timers available in the system and calls their initialization
methods if corresponding devices were either in dtb or in acpi. But
if before the commit any number of available timers would be installed
as clockevent and clocksource devices, after that there would be at most
two. The rest are just ignored since default case branch doesn't do
anything. I don't see a reason of such behaviour, neither the commit
message explains it. Moreover this might be wrong if on some platforms
these timers might be used for different purpose, as virtually CPU-local
clockevent timers and as an independent broadcast timer. So in order
to keep the compatibility with the platforms where the order of the
timers detection has some meaning, lets add the secondly discovered
timer to be of clocksource/sched_clock type, while the very first and
the others would provide the clockevents service.

Fixes: 100214889973 ("clocksource: dw_apb_timer_of: use clocksource_of_init")
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
Link: https://lore.kernel.org/r/20200521204818.25436-7-Sergey.Semin@baikalelectronics.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/dw_apb_timer_of.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
index 8c28b127759f..6921b91b61ef 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -147,10 +147,6 @@ static int num_called;
 static int __init dw_apb_timer_init(struct device_node *timer)
 {
 	switch (num_called) {
-	case 0:
-		pr_debug("%s: found clockevent timer\n", __func__);
-		add_clockevent(timer);
-		break;
 	case 1:
 		pr_debug("%s: found clocksource timer\n", __func__);
 		add_clocksource(timer);
@@ -161,6 +157,8 @@ static int __init dw_apb_timer_init(struct device_node *timer)
 #endif
 		break;
 	default:
+		pr_debug("%s: found clockevent timer\n", __func__);
+		add_clockevent(timer);
 		break;
 	}
 
-- 
2.25.1



