Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13A537C494
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbhELPcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:32:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235481AbhELP2L (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:28:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA1B261920;
        Wed, 12 May 2021 15:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832393;
        bh=hqvy69HtMm1rNbYf/Vz4kiHG2W7xUeNDEF+DV6STzGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GuB/Z/uKtPPgqS1C6wrsrQs4lhE0YZQ+839DzmYJpJ6XEaLKymAfbmvu61bI30rkl
         MD5g6kxTgbsGhp/H1DBSfnpSFyVnvcVWQkZXt5qhv0Pnut8SuTBmzGoPE5ATKvZ1hM
         Cze1/t/RBerK2An0XXwF2ktiRm34bQPyunGEcqi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 217/530] clocksource/drivers/timer-ti-dm: Add missing set_state_oneshot_stopped
Date:   Wed, 12 May 2021 16:45:27 +0200
Message-Id: <20210512144826.967377350@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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



