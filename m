Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12C0C15EC03
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391244AbgBNRYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:24:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:33538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390681AbgBNQJO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:09:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C38CB24681;
        Fri, 14 Feb 2020 16:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696554;
        bh=ipx4Td6141LujbD+iqs7ftTylfFP+MA6LuFhN97F7WA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R6FqUO4AZqHCUMWuCSfjiQTZfWynTojRN2qY86G1UZaHE4ETuEC9Z560SyKu+Fd63
         EXNpKDmlm2LUVp0Tp6pP2TVw65lQViku9GSqrRxb+fr1ZbCECu5d7cdCp3twwCokts
         H9cUu0FldBHJ+vmKFKorreytyWwt+BT3DgXW5RZ0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Robert Richter <rrichter@marvell.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 346/459] watchdog/softlockup: Enforce that timestamp is valid on boot
Date:   Fri, 14 Feb 2020 10:59:56 -0500
Message-Id: <20200214160149.11681-346-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
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

