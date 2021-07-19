Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5F33CDCD8
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238843AbhGSOyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:54:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240506AbhGSOuv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:50:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A18E160FED;
        Mon, 19 Jul 2021 15:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708690;
        bh=xHmw9rIkTYrCitBM6MNePylESTtvb48ggqCovF/IbNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vqIpYQN7K1hQQKC2rGlyuW2IMMHoRPY+7DVLQl1KEvMHB+7OYESdczfb9XP+KBhXd
         uFRM0QQECqyRU16vqwtJ1ov2mdWQbEzyCa/u1y1ggSEWCOv3SrNGLfMnUDpl00JLcf
         MEA6fLzghxLLZ5wYvaAxKPCGLhrCN9W8NfQB8xE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Mason <clm@fb.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Feng Tang <feng.tang@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 090/421] clocksource: Retry clock read if long delays detected
Date:   Mon, 19 Jul 2021 16:48:21 +0200
Message-Id: <20210719144949.233772985@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit db3a34e17433de2390eb80d436970edcebd0ca3e ]

When the clocksource watchdog marks a clock as unstable, this might be due
to that clock being unstable or it might be due to delays that happen to
occur between the reads of the two clocks.  Yes, interrupts are disabled
across those two reads, but there are no shortage of things that can delay
interrupts-disabled regions of code ranging from SMI handlers to vCPU
preemption.  It would be good to have some indication as to why the clock
was marked unstable.

Therefore, re-read the watchdog clock on either side of the read from the
clock under test.  If the watchdog clock shows an excessive time delta
between its pair of reads, the reads are retried.

The maximum number of retries is specified by a new kernel boot parameter
clocksource.max_cswd_read_retries, which defaults to three, that is, up to
four reads, one initial and up to three retries.  If more than one retry
was required, a message is printed on the console (the occasional single
retry is expected behavior, especially in guest OSes).  If the maximum
number of retries is exceeded, the clock under test will be marked
unstable.  However, the probability of this happening due to various sorts
of delays is quite small.  In addition, the reason (clock-read delays) for
the unstable marking will be apparent.

Reported-by: Chris Mason <clm@fb.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Feng Tang <feng.tang@intel.com>
Link: https://lore.kernel.org/r/20210527190124.440372-1-paulmck@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |  6 +++
 kernel/time/clocksource.c                     | 53 ++++++++++++++++---
 2 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 558332df02a8..6795e9d187d0 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -558,6 +558,12 @@
 			loops can be debugged more effectively on production
 			systems.
 
+	clocksource.max_cswd_read_retries= [KNL]
+			Number of clocksource_watchdog() retries due to
+			external delays before the clock will be marked
+			unstable.  Defaults to three retries, that is,
+			four attempts to read the clock under test.
+
 	clearcpuid=BITNUM[,BITNUM...] [X86]
 			Disable CPUID feature X for the kernel. See
 			arch/x86/include/asm/cpufeatures.h for the valid bit
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index f80bb104c41a..221f8e7464c5 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -142,6 +142,13 @@ static void __clocksource_change_rating(struct clocksource *cs, int rating);
 #define WATCHDOG_INTERVAL (HZ >> 1)
 #define WATCHDOG_THRESHOLD (NSEC_PER_SEC >> 4)
 
+/*
+ * Maximum permissible delay between two readouts of the watchdog
+ * clocksource surrounding a read of the clocksource being validated.
+ * This delay could be due to SMIs, NMIs, or to VCPU preemptions.
+ */
+#define WATCHDOG_MAX_SKEW (100 * NSEC_PER_USEC)
+
 static void clocksource_watchdog_work(struct work_struct *work)
 {
 	/*
@@ -202,12 +209,45 @@ void clocksource_mark_unstable(struct clocksource *cs)
 	spin_unlock_irqrestore(&watchdog_lock, flags);
 }
 
+static ulong max_cswd_read_retries = 3;
+module_param(max_cswd_read_retries, ulong, 0644);
+
+static bool cs_watchdog_read(struct clocksource *cs, u64 *csnow, u64 *wdnow)
+{
+	unsigned int nretries;
+	u64 wd_end, wd_delta;
+	int64_t wd_delay;
+
+	for (nretries = 0; nretries <= max_cswd_read_retries; nretries++) {
+		local_irq_disable();
+		*wdnow = watchdog->read(watchdog);
+		*csnow = cs->read(cs);
+		wd_end = watchdog->read(watchdog);
+		local_irq_enable();
+
+		wd_delta = clocksource_delta(wd_end, *wdnow, watchdog->mask);
+		wd_delay = clocksource_cyc2ns(wd_delta, watchdog->mult,
+					      watchdog->shift);
+		if (wd_delay <= WATCHDOG_MAX_SKEW) {
+			if (nretries > 1 || nretries >= max_cswd_read_retries) {
+				pr_warn("timekeeping watchdog on CPU%d: %s retried %d times before success\n",
+					smp_processor_id(), watchdog->name, nretries);
+			}
+			return true;
+		}
+	}
+
+	pr_warn("timekeeping watchdog on CPU%d: %s read-back delay of %lldns, attempt %d, marking unstable\n",
+		smp_processor_id(), watchdog->name, wd_delay, nretries);
+	return false;
+}
+
 static void clocksource_watchdog(struct timer_list *unused)
 {
-	struct clocksource *cs;
 	u64 csnow, wdnow, cslast, wdlast, delta;
-	int64_t wd_nsec, cs_nsec;
 	int next_cpu, reset_pending;
+	int64_t wd_nsec, cs_nsec;
+	struct clocksource *cs;
 
 	spin_lock(&watchdog_lock);
 	if (!watchdog_running)
@@ -224,10 +264,11 @@ static void clocksource_watchdog(struct timer_list *unused)
 			continue;
 		}
 
-		local_irq_disable();
-		csnow = cs->read(cs);
-		wdnow = watchdog->read(watchdog);
-		local_irq_enable();
+		if (!cs_watchdog_read(cs, &csnow, &wdnow)) {
+			/* Clock readout unreliable, so give it up. */
+			__clocksource_unstable(cs);
+			continue;
+		}
 
 		/* Clocksource initialized ? */
 		if (!(cs->flags & CLOCK_SOURCE_WATCHDOG) ||
-- 
2.30.2



