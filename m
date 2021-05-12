Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE8937CC76
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239610AbhELQpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:45:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243137AbhELQgw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:36:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB7AD61CC4;
        Wed, 12 May 2021 16:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835260;
        bh=hqvy69HtMm1rNbYf/Vz4kiHG2W7xUeNDEF+DV6STzGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uf3rXhAKq+Og7gftjSdPco+1qyJBPZPPlQr0RQCFZItUf+av11KvMdMZcfkenWpa0
         Mdt/l1w1SEUeGnP6Pz629kECYQ3a6bLj4Zp3mh/mzBTWrixnkUX+Q0dOUXnjqfTgqL
         MouolZrYOD3rg1QE/SS5m782wBZ0orjQrllsfoOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 273/677] clocksource/drivers/timer-ti-dm: Add missing set_state_oneshot_stopped
Date:   Wed, 12 May 2021 16:45:19 +0200
Message-Id: <20210512144846.293261985@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit ac4daf737674b4d29e19b7c300caff3bcf7160d8 ]

To avoid spurious timer interrupts when KTIME_MAX is used, we need to
configure set_state_oneshot_stopped(). Although implementing this is
optional, it still affects things like power management for the extra
timer interrupt.

For more information, please see commit 8fff52fd5093 ("clockevents:
Introduce CLOCK_EVT_STATE_ONESHOT_STOPPED state") and commit cf8c5009ee37
("clockevents/drivers/arm_arch_timer: Implement
->set_state_oneshot_stopped()").

Fixes: 52762fbd1c47 ("clocksource/drivers/timer-ti-dm: Add clockevent and clocksource support")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210304072135.52712-4-tony@atomide.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-ti-dm-systimer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/timer-ti-dm-systimer.c b/drivers/clocksource/timer-ti-dm-systimer.c
index 422376680c8a..3fae9ebb58b8 100644
--- a/drivers/clocksource/timer-ti-dm-systimer.c
+++ b/drivers/clocksource/timer-ti-dm-systimer.c
@@ -554,6 +554,7 @@ static int __init dmtimer_clockevent_init(struct device_node *np)
 	dev->set_state_shutdown = dmtimer_clockevent_shutdown;
 	dev->set_state_periodic = dmtimer_set_periodic;
 	dev->set_state_oneshot = dmtimer_clockevent_shutdown;
+	dev->set_state_oneshot_stopped = dmtimer_clockevent_shutdown;
 	dev->tick_resume = dmtimer_clockevent_shutdown;
 	dev->cpumask = cpu_possible_mask;
 
-- 
2.30.2



