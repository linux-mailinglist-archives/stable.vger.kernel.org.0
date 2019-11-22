Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEC7D106D6E
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730977AbfKVLAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:00:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:51708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728201AbfKVLAC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:00:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B69792071F;
        Fri, 22 Nov 2019 11:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420401;
        bh=DQTeCkJ2KBezvBPt10XsX8eI318QCbKRiA3j0R1qspQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EXHdMP2MPWl2vJwGGYdVjDyXGczYEOnc6jiOmOb73Lu4t4oJNWd91vgyDYt7rbx45
         TkaaeK6ZW2KwmTBARBImN1zV5+GkRNWUq0Go45G8boYGhIJA/tGTF0SW+nWrt3wsJv
         BCG1TcG+NISDKACvVtVHSQ6UGv2KDH4/dhtvUHO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 094/220] cpuidle: menu: Fix wakeup statistics updates for polling state
Date:   Fri, 22 Nov 2019 11:27:39 +0100
Message-Id: <20191122100919.455143250@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 5f26bdceb9c0a5e6c696aa2899d077cd3ae93413 ]

If the CPU exits the "polling" state due to the time limit in the
loop in poll_idle(), this is not a real wakeup and it just means
that the "polling" state selection was not adequate.  The governor
mispredicted short idle duration, but had a more suitable state been
selected, the CPU might have spent more time in it.  In fact, there
is no reason to expect that there would have been a wakeup event
earlier than the next timer in that case.

Handling such cases as regular wakeups in menu_update() may cause the
menu governor to make suboptimal decisions going forward, but ignoring
them altogether would not be correct either, because every time
menu_select() is invoked, it makes a separate new attempt to predict
the idle duration taking distinct time to the closest timer event as
input and the outcomes of all those attempts should be recorded.

For this reason, make menu_update() always assume that if the
"polling" state was exited due to the time limit, the next proper
wakeup event for the CPU would be the next timer event (not
including the tick).

Fixes: a37b969a61c1 "cpuidle: poll_state: Add time limit to poll_idle()"
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/governors/menu.c | 10 ++++++++++
 drivers/cpuidle/poll_state.c     |  6 +++++-
 include/linux/cpuidle.h          |  1 +
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index e26a40971b263..6d7f6b9bb373a 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -512,6 +512,16 @@ static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 		 * duration predictor do a better job next time.
 		 */
 		measured_us = 9 * MAX_INTERESTING / 10;
+	} else if ((drv->states[last_idx].flags & CPUIDLE_FLAG_POLLING) &&
+		   dev->poll_time_limit) {
+		/*
+		 * The CPU exited the "polling" state due to a time limit, so
+		 * the idle duration prediction leading to the selection of that
+		 * state was inaccurate.  If a better prediction had been made,
+		 * the CPU might have been woken up from idle by the next timer.
+		 * Assume that to be the case.
+		 */
+		measured_us = data->next_timer_us;
 	} else {
 		/* measured value */
 		measured_us = cpuidle_get_last_residency(dev);
diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
index 3f86d23c592ec..36ff5a1d94226 100644
--- a/drivers/cpuidle/poll_state.c
+++ b/drivers/cpuidle/poll_state.c
@@ -17,6 +17,8 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
 {
 	u64 time_start = local_clock();
 
+	dev->poll_time_limit = false;
+
 	local_irq_enable();
 	if (!current_set_polling_and_test()) {
 		unsigned int loop_count = 0;
@@ -27,8 +29,10 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
 				continue;
 
 			loop_count = 0;
-			if (local_clock() - time_start > POLL_IDLE_TIME_LIMIT)
+			if (local_clock() - time_start > POLL_IDLE_TIME_LIMIT) {
+				dev->poll_time_limit = true;
 				break;
+			}
 		}
 	}
 	current_clr_polling();
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 4325d6fdde9b6..317aecaed8970 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -81,6 +81,7 @@ struct cpuidle_device {
 	unsigned int		registered:1;
 	unsigned int		enabled:1;
 	unsigned int		use_deepest_state:1;
+	unsigned int		poll_time_limit:1;
 	unsigned int		cpu;
 
 	int			last_residency;
-- 
2.20.1



