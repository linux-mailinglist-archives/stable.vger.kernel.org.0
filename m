Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7273BF4B2D
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732263AbfKHLiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:38:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:51022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732127AbfKHLiK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:38:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9E6421D7E;
        Fri,  8 Nov 2019 11:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213089;
        bh=VKcieq0ARls4eteR5hLrrJ5YCzzxNlWyVtNRCKYMwmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NnIXmJ8D92HwCOi0oov+xwxdefXtZE4FfHpsImyNQoX77K6ejf04sWj+ouS52ieti
         oL6rDSy2VX7yFryTX4sp4XtfmKpdaA4fKYRVNNfx4leIHlo2J4QK9RuMbcDB9fhEAe
         l3DoblNiuMD4FFYCPNIOVxWslzUuyRgW0KRwkjCA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 014/205] y2038: make do_gettimeofday() and get_seconds() inline
Date:   Fri,  8 Nov 2019 06:34:41 -0500
Message-Id: <20191108113752.12502-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 33e26418193f58d1895f2f968e1953b1caf8deb7 ]

get_seconds() and do_gettimeofday() are only used by a few modules now any
more (waiting for the respective patches to get accepted), and they are
among the last holdouts of code that is not y2038 safe in the core kernel.

Move the implementation into the timekeeping32.h header to clean up
the core kernel and isolate the old interfaces further.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/timekeeping32.h | 15 +++++++++++++--
 kernel/time/time.c            | 15 +++++++++------
 kernel/time/timekeeping.c     | 24 ------------------------
 3 files changed, 22 insertions(+), 32 deletions(-)

diff --git a/include/linux/timekeeping32.h b/include/linux/timekeeping32.h
index 8762c2f45f8bf..479da36be8c82 100644
--- a/include/linux/timekeeping32.h
+++ b/include/linux/timekeeping32.h
@@ -6,8 +6,19 @@
  * over time so we can remove the file here.
  */
 
-extern void do_gettimeofday(struct timeval *tv);
-unsigned long get_seconds(void);
+static inline void do_gettimeofday(struct timeval *tv)
+{
+	struct timespec64 now;
+
+	ktime_get_real_ts64(&now);
+	tv->tv_sec = now.tv_sec;
+	tv->tv_usec = now.tv_nsec/1000;
+}
+
+static inline unsigned long get_seconds(void)
+{
+	return ktime_get_real_seconds();
+}
 
 static inline struct timespec current_kernel_time(void)
 {
diff --git a/kernel/time/time.c b/kernel/time/time.c
index be057d6579f13..f7d4fa5ddb9e2 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -144,9 +144,11 @@ SYSCALL_DEFINE2(gettimeofday, struct timeval __user *, tv,
 		struct timezone __user *, tz)
 {
 	if (likely(tv != NULL)) {
-		struct timeval ktv;
-		do_gettimeofday(&ktv);
-		if (copy_to_user(tv, &ktv, sizeof(ktv)))
+		struct timespec64 ts;
+
+		ktime_get_real_ts64(&ts);
+		if (put_user(ts.tv_sec, &tv->tv_sec) ||
+		    put_user(ts.tv_nsec / 1000, &tv->tv_usec))
 			return -EFAULT;
 	}
 	if (unlikely(tz != NULL)) {
@@ -227,10 +229,11 @@ COMPAT_SYSCALL_DEFINE2(gettimeofday, struct compat_timeval __user *, tv,
 		       struct timezone __user *, tz)
 {
 	if (tv) {
-		struct timeval ktv;
+		struct timespec64 ts;
 
-		do_gettimeofday(&ktv);
-		if (compat_put_timeval(&ktv, tv))
+		ktime_get_real_ts64(&ts);
+		if (put_user(ts.tv_sec, &tv->tv_sec) ||
+		    put_user(ts.tv_nsec / 1000, &tv->tv_usec))
 			return -EFAULT;
 	}
 	if (tz) {
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index c2708e1f0c69f..81ee5b83c9200 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1214,22 +1214,6 @@ int get_device_system_crosststamp(int (*get_time_fn)
 }
 EXPORT_SYMBOL_GPL(get_device_system_crosststamp);
 
-/**
- * do_gettimeofday - Returns the time of day in a timeval
- * @tv:		pointer to the timeval to be set
- *
- * NOTE: Users should be converted to using getnstimeofday()
- */
-void do_gettimeofday(struct timeval *tv)
-{
-	struct timespec64 now;
-
-	getnstimeofday64(&now);
-	tv->tv_sec = now.tv_sec;
-	tv->tv_usec = now.tv_nsec/1000;
-}
-EXPORT_SYMBOL(do_gettimeofday);
-
 /**
  * do_settimeofday64 - Sets the time of day.
  * @ts:     pointer to the timespec64 variable containing the new time
@@ -2177,14 +2161,6 @@ void getboottime64(struct timespec64 *ts)
 }
 EXPORT_SYMBOL_GPL(getboottime64);
 
-unsigned long get_seconds(void)
-{
-	struct timekeeper *tk = &tk_core.timekeeper;
-
-	return tk->xtime_sec;
-}
-EXPORT_SYMBOL(get_seconds);
-
 void ktime_get_coarse_real_ts64(struct timespec64 *ts)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
-- 
2.20.1

