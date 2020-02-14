Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC0415F0A4
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729555AbgBNRz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:55:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:40552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388260AbgBNP5b (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:57:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A03C24654;
        Fri, 14 Feb 2020 15:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695851;
        bh=ipx4Td6141LujbD+iqs7ftTylfFP+MA6LuFhN97F7WA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B5f+TVviQ74jcRhcSqC+Ntv50Y2Tt9x25cOulU6xYB1JLlib9pMq0jho6WeREBXdh
         R/i1X94nDfPuXHw10/Q0ed3Chl0NzffEbKcET9tp6A3RlyBE8Bf/9dslz7CR8rekJQ
         WANSkNnaAN14l5+BBJAyC5jlnKJKHZ+Q+0FCfoVU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Robert Richter <rrichter@marvell.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 400/542] watchdog/softlockup: Enforce that timestamp is valid on boot
Date:   Fri, 14 Feb 2020 10:46:32 -0500
Message-Id: <20200214154854.6746-400-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 11e31f608b499f044f24b20be73f1dcab3e43f8a ]

Robert reported that during boot the watchdog timestamp is set to 0 for one
second which is the indicator for a watchdog reset.

The reason for this is that the timestamp is in seconds and the time is
taken from sched clock and divided by ~1e9. sched clock starts at 0 which
means that for the first second during boot the watchdog timestamp is 0,
i.e. reset.

Use ULONG_MAX as the reset indicator value so the watchdog works correctly
right from the start. ULONG_MAX would only conflict with a real timestamp
if the system reaches an uptime of 136 years on 32bit and almost eternity
on 64bit.

Reported-by: Robert Richter <rrichter@marvell.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/87o8v3uuzl.fsf@nanos.tec.linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/watchdog.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index f41334ef09713..cbd3cf503c904 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -161,6 +161,8 @@ static void lockup_detector_update_enable(void)
 
 #ifdef CONFIG_SOFTLOCKUP_DETECTOR
 
+#define SOFTLOCKUP_RESET	ULONG_MAX
+
 /* Global variables, exported for sysctl */
 unsigned int __read_mostly softlockup_panic =
 			CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE;
@@ -274,7 +276,7 @@ notrace void touch_softlockup_watchdog_sched(void)
 	 * Preemption can be enabled.  It doesn't matter which CPU's timestamp
 	 * gets zeroed here, so use the raw_ operation.
 	 */
-	raw_cpu_write(watchdog_touch_ts, 0);
+	raw_cpu_write(watchdog_touch_ts, SOFTLOCKUP_RESET);
 }
 
 notrace void touch_softlockup_watchdog(void)
@@ -298,14 +300,14 @@ void touch_all_softlockup_watchdogs(void)
 	 * the softlockup check.
 	 */
 	for_each_cpu(cpu, &watchdog_allowed_mask)
-		per_cpu(watchdog_touch_ts, cpu) = 0;
+		per_cpu(watchdog_touch_ts, cpu) = SOFTLOCKUP_RESET;
 	wq_watchdog_touch(-1);
 }
 
 void touch_softlockup_watchdog_sync(void)
 {
 	__this_cpu_write(softlockup_touch_sync, true);
-	__this_cpu_write(watchdog_touch_ts, 0);
+	__this_cpu_write(watchdog_touch_ts, SOFTLOCKUP_RESET);
 }
 
 static int is_softlockup(unsigned long touch_ts)
@@ -383,7 +385,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 	/* .. and repeat */
 	hrtimer_forward_now(hrtimer, ns_to_ktime(sample_period));
 
-	if (touch_ts == 0) {
+	if (touch_ts == SOFTLOCKUP_RESET) {
 		if (unlikely(__this_cpu_read(softlockup_touch_sync))) {
 			/*
 			 * If the time stamp was touched atomically
-- 
2.20.1

