Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F2F6AEBA4
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbjCGRrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:47:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbjCGRqr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:46:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4005A5D3
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:41:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F43EB819B4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE3CC433EF;
        Tue,  7 Mar 2023 17:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210901;
        bh=5E18SmOuoUTYxjoJgIVRwD/A4kSj9x1W7REQYiA2kQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TQeVgDT4rmM38sjA6EWqqDsJwX+Ybq2NjE47h6J9Z/Ne45knCEiCiRxM8Jyj95FQb
         1l7B0xHQMgo7a75GLnVgjj847AQSV20U2mcfJteqALarf65V3HbD5mOucz1dX4vOJZ
         S/YzmOHgd5HGv7Hi/tZfcKK3B6f5XKcb/AeZxuOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Feng Tang <feng.tang@intel.com>,
        Waiman Long <longman@redhat.com>,
        John Stultz <jstultz@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0659/1001] clocksource: Suspend the watchdog temporarily when high read latency detected
Date:   Tue,  7 Mar 2023 17:57:11 +0100
Message-Id: <20230307170050.204825431@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

[ Upstream commit b7082cdfc464bf9231300605d03eebf943dda307 ]

Bugs have been reported on 8 sockets x86 machines in which the TSC was
wrongly disabled when the system is under heavy workload.

 [ 818.380354] clocksource: timekeeping watchdog on CPU336: hpet wd-wd read-back delay of 1203520ns
 [ 818.436160] clocksource: wd-tsc-wd read-back delay of 181880ns, clock-skew test skipped!
 [ 819.402962] clocksource: timekeeping watchdog on CPU338: hpet wd-wd read-back delay of 324000ns
 [ 819.448036] clocksource: wd-tsc-wd read-back delay of 337240ns, clock-skew test skipped!
 [ 819.880863] clocksource: timekeeping watchdog on CPU339: hpet read-back delay of 150280ns, attempt 3, marking unstable
 [ 819.936243] tsc: Marking TSC unstable due to clocksource watchdog
 [ 820.068173] TSC found unstable after boot, most likely due to broken BIOS. Use 'tsc=unstable'.
 [ 820.092382] sched_clock: Marking unstable (818769414384, 1195404998)
 [ 820.643627] clocksource: Checking clocksource tsc synchronization from CPU 267 to CPUs 0,4,25,70,126,430,557,564.
 [ 821.067990] clocksource: Switched to clocksource hpet

This can be reproduced by running memory intensive 'stream' tests,
or some of the stress-ng subcases such as 'ioport'.

The reason for these issues is the when system is under heavy load, the
read latency of the clocksources can be very high.  Even lightweight TSC
reads can show high latencies, and latencies are much worse for external
clocksources such as HPET or the APIC PM timer.  These latencies can
result in false-positive clocksource-unstable determinations.

These issues were initially reported by a customer running on a production
system, and this problem was reproduced on several generations of Xeon
servers, especially when running the stress-ng test.  These Xeon servers
were not production systems, but they did have the latest steppings
and firmware.

Given that the clocksource watchdog is a continual diagnostic check with
frequency of twice a second, there is no need to rush it when the system
is under heavy load.  Therefore, when high clocksource read latencies
are detected, suspend the watchdog timer for 5 minutes.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Acked-by: Waiman Long <longman@redhat.com>
Cc: John Stultz <jstultz@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Feng Tang <feng.tang@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/clocksource.c | 45 ++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 13 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 9cf32ccda715d..8cd74b89d5776 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -384,6 +384,15 @@ void clocksource_verify_percpu(struct clocksource *cs)
 }
 EXPORT_SYMBOL_GPL(clocksource_verify_percpu);
 
+static inline void clocksource_reset_watchdog(void)
+{
+	struct clocksource *cs;
+
+	list_for_each_entry(cs, &watchdog_list, wd_list)
+		cs->flags &= ~CLOCK_SOURCE_WATCHDOG;
+}
+
+
 static void clocksource_watchdog(struct timer_list *unused)
 {
 	u64 csnow, wdnow, cslast, wdlast, delta;
@@ -391,6 +400,7 @@ static void clocksource_watchdog(struct timer_list *unused)
 	int64_t wd_nsec, cs_nsec;
 	struct clocksource *cs;
 	enum wd_read_status read_ret;
+	unsigned long extra_wait = 0;
 	u32 md;
 
 	spin_lock(&watchdog_lock);
@@ -410,13 +420,30 @@ static void clocksource_watchdog(struct timer_list *unused)
 
 		read_ret = cs_watchdog_read(cs, &csnow, &wdnow);
 
-		if (read_ret != WD_READ_SUCCESS) {
-			if (read_ret == WD_READ_UNSTABLE)
-				/* Clock readout unreliable, so give it up. */
-				__clocksource_unstable(cs);
+		if (read_ret == WD_READ_UNSTABLE) {
+			/* Clock readout unreliable, so give it up. */
+			__clocksource_unstable(cs);
 			continue;
 		}
 
+		/*
+		 * When WD_READ_SKIP is returned, it means the system is likely
+		 * under very heavy load, where the latency of reading
+		 * watchdog/clocksource is very big, and affect the accuracy of
+		 * watchdog check. So give system some space and suspend the
+		 * watchdog check for 5 minutes.
+		 */
+		if (read_ret == WD_READ_SKIP) {
+			/*
+			 * As the watchdog timer will be suspended, and
+			 * cs->last could keep unchanged for 5 minutes, reset
+			 * the counters.
+			 */
+			clocksource_reset_watchdog();
+			extra_wait = HZ * 300;
+			break;
+		}
+
 		/* Clocksource initialized ? */
 		if (!(cs->flags & CLOCK_SOURCE_WATCHDOG) ||
 		    atomic_read(&watchdog_reset_pending)) {
@@ -512,7 +539,7 @@ static void clocksource_watchdog(struct timer_list *unused)
 	 * pair clocksource_stop_watchdog() clocksource_start_watchdog().
 	 */
 	if (!timer_pending(&watchdog_timer)) {
-		watchdog_timer.expires += WATCHDOG_INTERVAL;
+		watchdog_timer.expires += WATCHDOG_INTERVAL + extra_wait;
 		add_timer_on(&watchdog_timer, next_cpu);
 	}
 out:
@@ -537,14 +564,6 @@ static inline void clocksource_stop_watchdog(void)
 	watchdog_running = 0;
 }
 
-static inline void clocksource_reset_watchdog(void)
-{
-	struct clocksource *cs;
-
-	list_for_each_entry(cs, &watchdog_list, wd_list)
-		cs->flags &= ~CLOCK_SOURCE_WATCHDOG;
-}
-
 static void clocksource_resume_watchdog(void)
 {
 	atomic_inc(&watchdog_reset_pending);
-- 
2.39.2



