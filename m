Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85E840D8F7
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 13:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235686AbhIPLoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 07:44:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237825AbhIPLoc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 07:44:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90FF960F5B;
        Thu, 16 Sep 2021 11:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631792592;
        bh=1mdg1sx3HZtE/807HwZbYD14B3iF4ZDUvNvlme6JzKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/1inP2ECpWlNdGBHjAksjkAX0Nej1dDRtpR2YhNWErHlWFEuZkn2Wb4lxmQguXfD
         gi5EnZUxNk7GFkafVINkzT5Jor1afqHGQ/V9qe5cqN456HYM80grFI+44fpOkK7S3e
         YPVpTzfoaMHKcyQcOa2rynLfYvEJHdmpDh20z93c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.14.5
Date:   Thu, 16 Sep 2021 13:42:48 +0200
Message-Id: <1631792482205152@kroah.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <1631792482198242@kroah.com>
References: <1631792482198242@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index e16a1a80074c..0eaa5623f406 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 14
-SUBLEVEL = 4
+SUBLEVEL = 5
 EXTRAVERSION =
 NAME = Opossums on Parade
 
diff --git a/include/linux/time64.h b/include/linux/time64.h
index 81b9686a2079..5117cb5b5656 100644
--- a/include/linux/time64.h
+++ b/include/linux/time64.h
@@ -25,9 +25,7 @@ struct itimerspec64 {
 #define TIME64_MIN			(-TIME64_MAX - 1)
 
 #define KTIME_MAX			((s64)~((u64)1 << 63))
-#define KTIME_MIN			(-KTIME_MAX - 1)
 #define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
-#define KTIME_SEC_MIN			(KTIME_MIN / NSEC_PER_SEC)
 
 /*
  * Limits for settimeofday():
@@ -126,13 +124,10 @@ static inline bool timespec64_valid_settod(const struct timespec64 *ts)
  */
 static inline s64 timespec64_to_ns(const struct timespec64 *ts)
 {
-	/* Prevent multiplication overflow / underflow */
-	if (ts->tv_sec >= KTIME_SEC_MAX)
+	/* Prevent multiplication overflow */
+	if ((unsigned long long)ts->tv_sec >= KTIME_SEC_MAX)
 		return KTIME_MAX;
 
-	if (ts->tv_sec <= KTIME_SEC_MIN)
-		return KTIME_MIN;
-
 	return ((s64) ts->tv_sec * NSEC_PER_SEC) + ts->tv_nsec;
 }
 
diff --git a/kernel/time/posix-cpu-timers.c b/kernel/time/posix-cpu-timers.c
index a002685f688d..517be7fd175e 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1346,6 +1346,8 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clkid,
 			}
 		}
 
+		if (!*newval)
+			return;
 		*newval += now;
 	}
 
