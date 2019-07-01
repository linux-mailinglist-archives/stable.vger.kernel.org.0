Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2712F264
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729442AbfE3EVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:21:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730169AbfE3DPO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:14 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93BCB245AC;
        Thu, 30 May 2019 03:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186113;
        bh=Ot1Y1CO3QazXGRibaCqGWuu+uo69Bq3D27qLPY5Vty0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cfBS2m5UMLKf5KFPfeeKVQGLMqLx9Z3MSd3SwOQWMmz0nHyFgyhQMWRWKDkUfr2Em
         Up5jQIJsySegAAYl9aD4JbhYr6Rf1qhAKxKIH82BD88GkIM6g7bt+ePXnDvL4a6ktA
         Lu99xYrt8bHsgf5wFj1/MtmnmMnHb6fmXjf9+dWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Hongbo Yao <yaohongbo@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 264/346] timekeeping: Force upper bound for setting CLOCK_REALTIME
Date:   Wed, 29 May 2019 20:05:37 -0700
Message-Id: <20190530030554.354330075@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7a8e61f8478639072d402a26789055a4a4de8f77 ]

Several people reported testing failures after setting CLOCK_REALTIME close
to the limits of the kernel internal representation in nanoseconds,
i.e. year 2262.

The failures are exposed in subsequent operations, i.e. when arming timers
or when the advancing CLOCK_MONOTONIC makes the calculation of
CLOCK_REALTIME overflow into negative space.

Now people start to paper over the underlying problem by clamping
calculations to the valid range, but that's just wrong because such
workarounds will prevent detection of real issues as well.

It is reasonable to force an upper bound for the various methods of setting
CLOCK_REALTIME. Year 2262 is the absolute upper bound. Assume a maximum
uptime of 30 years which is plenty enough even for esoteric embedded
systems. That results in an upper bound of year 2232 for setting the time.

Once that limit is reached in reality this limit is only a small part of
the problem space. But until then this stops people from trying to paper
over the problem at the wrong places.

Reported-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Reported-by: Hongbo Yao <yaohongbo@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lkml.kernel.org/r/alpine.DEB.2.21.1903231125480.2157@nanos.tec.linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/time64.h    | 21 +++++++++++++++++++++
 kernel/time/time.c        |  2 +-
 kernel/time/timekeeping.c |  6 +++---
 3 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/include/linux/time64.h b/include/linux/time64.h
index 05634afba0db6..4a45aea0f96e9 100644
--- a/include/linux/time64.h
+++ b/include/linux/time64.h
@@ -41,6 +41,17 @@ struct itimerspec64 {
 #define KTIME_MAX			((s64)~((u64)1 << 63))
 #define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
 
+/*
+ * Limits for settimeofday():
+ *
+ * To prevent setting the time close to the wraparound point time setting
+ * is limited so a reasonable uptime can be accomodated. Uptime of 30 years
+ * should be really sufficient, which means the cutoff is 2232. At that
+ * point the cutoff is just a small part of the larger problem.
+ */
+#define TIME_UPTIME_SEC_MAX		(30LL * 365 * 24 *3600)
+#define TIME_SETTOD_SEC_MAX		(KTIME_SEC_MAX - TIME_UPTIME_SEC_MAX)
+
 static inline int timespec64_equal(const struct timespec64 *a,
 				   const struct timespec64 *b)
 {
@@ -108,6 +119,16 @@ static inline bool timespec64_valid_strict(const struct timespec64 *ts)
 	return true;
 }
 
+static inline bool timespec64_valid_settod(const struct timespec64 *ts)
+{
+	if (!timespec64_valid(ts))
+		return false;
+	/* Disallow values which cause overflow issues vs. CLOCK_REALTIME */
+	if ((unsigned long long)ts->tv_sec >= TIME_SETTOD_SEC_MAX)
+		return false;
+	return true;
+}
+
 /**
  * timespec64_to_ns - Convert timespec64 to nanoseconds
  * @ts:		pointer to the timespec64 variable to be converted
diff --git a/kernel/time/time.c b/kernel/time/time.c
index 2edb5088a70b6..e7a3b9236f0b5 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -171,7 +171,7 @@ int do_sys_settimeofday64(const struct timespec64 *tv, const struct timezone *tz
 	static int firsttime = 1;
 	int error = 0;
 
-	if (tv && !timespec64_valid(tv))
+	if (tv && !timespec64_valid_settod(tv))
 		return -EINVAL;
 
 	error = security_settime64(tv, tz);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index ac5dbf2cd4a21..161b2728ac09e 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1221,7 +1221,7 @@ int do_settimeofday64(const struct timespec64 *ts)
 	unsigned long flags;
 	int ret = 0;
 
-	if (!timespec64_valid_strict(ts))
+	if (!timespec64_valid_settod(ts))
 		return -EINVAL;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
@@ -1278,7 +1278,7 @@ static int timekeeping_inject_offset(const struct timespec64 *ts)
 	/* Make sure the proposed value is valid */
 	tmp = timespec64_add(tk_xtime(tk), *ts);
 	if (timespec64_compare(&tk->wall_to_monotonic, ts) > 0 ||
-	    !timespec64_valid_strict(&tmp)) {
+	    !timespec64_valid_settod(&tmp)) {
 		ret = -EINVAL;
 		goto error;
 	}
@@ -1527,7 +1527,7 @@ void __init timekeeping_init(void)
 	unsigned long flags;
 
 	read_persistent_wall_and_boot_offset(&wall_time, &boot_offset);
-	if (timespec64_valid_strict(&wall_time) &&
+	if (timespec64_valid_settod(&wall_time) &&
 	    timespec64_to_ns(&wall_time) > 0) {
 		persistent_clock_exists = true;
 	} else if (timespec64_to_ns(&wall_time) != 0) {
-- 
2.20.1



