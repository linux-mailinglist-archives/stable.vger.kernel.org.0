Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6856EFA597
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbfKMBwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:52:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:41086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728245AbfKMBwW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:52:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA6042245D;
        Wed, 13 Nov 2019 01:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609941;
        bh=3ayLFv0k4dmJmDRR22+QRFxIt+T75LA781mfdlC9tO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oO7KfoNF0GhElepM+MBbMMSPPyOCyzQPhXaEE0Qea/bLoPZCuY7165NuTnu8Su9Xf
         /JR+VZHb3AbWcvsTR+G1aaLh67bFwy9StuKqnLulPedKUAAZFfQp3BevTX+9CwRbNJ
         TDUefxGpKQ+cYfOM5nVVUn2nhyGFBhuiZNuArThI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 082/209] cpuidle: menu: Fix wakeup statistics updates for polling state
Date:   Tue, 12 Nov 2019 20:48:18 -0500
Message-Id: <20191113015025.9685-82-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

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

