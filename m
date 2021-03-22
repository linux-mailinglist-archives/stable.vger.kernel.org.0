Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202683441B1
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhCVMfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:35:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231339AbhCVMd4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:33:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8B5C61931;
        Mon, 22 Mar 2021 12:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416432;
        bh=4ApCq5kSsG3Vre4qH7LLuIO256H2tdp+EiyoHeMyt/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OYonQ+C+3ojWeQ49vFNLfFCQIfl022vmcKqzCkEP9SKj7DZvBb4AHZdBUthNeeATZ
         SL6BoYMPyMAQ5/aCqU0cgBocI8bEiuCU7RbY0QJvWI5WGA0zRFyCagXMGidO6u0RyS
         AJAUVSVRxvgZtvdBOwzEsfC1KtnxKcwdnlNj+9XM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.11 103/120] kernel, fs: Introduce and use set_restart_fn() and arch_set_restart_data()
Date:   Mon, 22 Mar 2021 13:28:06 +0100
Message-Id: <20210322121933.115766122@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

commit 5abbe51a526253b9f003e9a0a195638dc882d660 upstream.

Preparation for fixing get_nr_restart_syscall() on X86 for COMPAT.

Add a new helper which sets restart_block->fn and calls a dummy
arch_set_restart_data() helper.

Fixes: 609c19a385c8 ("x86/ptrace: Stop setting TS_COMPAT in ptrace code")
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210201174641.GA17871@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/select.c                    |   10 ++++------
 include/linux/thread_info.h    |   13 +++++++++++++
 kernel/futex.c                 |    3 +--
 kernel/time/alarmtimer.c       |    2 +-
 kernel/time/hrtimer.c          |    2 +-
 kernel/time/posix-cpu-timers.c |    2 +-
 6 files changed, 21 insertions(+), 11 deletions(-)

--- a/fs/select.c
+++ b/fs/select.c
@@ -1055,10 +1055,9 @@ static long do_restart_poll(struct resta
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	if (ret == -ERESTARTNOHAND) {
-		restart_block->fn = do_restart_poll;
-		ret = -ERESTART_RESTARTBLOCK;
-	}
+	if (ret == -ERESTARTNOHAND)
+		ret = set_restart_fn(restart_block, do_restart_poll);
+
 	return ret;
 }
 
@@ -1080,7 +1079,6 @@ SYSCALL_DEFINE3(poll, struct pollfd __us
 		struct restart_block *restart_block;
 
 		restart_block = &current->restart_block;
-		restart_block->fn = do_restart_poll;
 		restart_block->poll.ufds = ufds;
 		restart_block->poll.nfds = nfds;
 
@@ -1091,7 +1089,7 @@ SYSCALL_DEFINE3(poll, struct pollfd __us
 		} else
 			restart_block->poll.has_timeout = 0;
 
-		ret = -ERESTART_RESTARTBLOCK;
+		ret = set_restart_fn(restart_block, do_restart_poll);
 	}
 	return ret;
 }
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -11,6 +11,7 @@
 #include <linux/types.h>
 #include <linux/bug.h>
 #include <linux/restart_block.h>
+#include <linux/errno.h>
 
 #ifdef CONFIG_THREAD_INFO_IN_TASK
 /*
@@ -59,6 +60,18 @@ enum syscall_work_bit {
 
 #ifdef __KERNEL__
 
+#ifndef arch_set_restart_data
+#define arch_set_restart_data(restart) do { } while (0)
+#endif
+
+static inline long set_restart_fn(struct restart_block *restart,
+					long (*fn)(struct restart_block *))
+{
+	restart->fn = fn;
+	arch_set_restart_data(restart);
+	return -ERESTART_RESTARTBLOCK;
+}
+
 #ifndef THREAD_ALIGN
 #define THREAD_ALIGN	THREAD_SIZE
 #endif
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2728,14 +2728,13 @@ retry:
 		goto out;
 
 	restart = &current->restart_block;
-	restart->fn = futex_wait_restart;
 	restart->futex.uaddr = uaddr;
 	restart->futex.val = val;
 	restart->futex.time = *abs_time;
 	restart->futex.bitset = bitset;
 	restart->futex.flags = flags | FLAGS_HAS_TIMEOUT;
 
-	ret = -ERESTART_RESTARTBLOCK;
+	ret = set_restart_fn(restart, futex_wait_restart);
 
 out:
 	if (to) {
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -848,9 +848,9 @@ static int alarm_timer_nsleep(const cloc
 	if (flags == TIMER_ABSTIME)
 		return -ERESTARTNOHAND;
 
-	restart->fn = alarm_timer_nsleep_restart;
 	restart->nanosleep.clockid = type;
 	restart->nanosleep.expires = exp;
+	set_restart_fn(restart, alarm_timer_nsleep_restart);
 	return ret;
 }
 
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1957,9 +1957,9 @@ long hrtimer_nanosleep(ktime_t rqtp, con
 	}
 
 	restart = &current->restart_block;
-	restart->fn = hrtimer_nanosleep_restart;
 	restart->nanosleep.clockid = t.timer.base->clockid;
 	restart->nanosleep.expires = hrtimer_get_expires_tv64(&t.timer);
+	set_restart_fn(restart, hrtimer_nanosleep_restart);
 out:
 	destroy_hrtimer_on_stack(&t.timer);
 	return ret;
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1480,8 +1480,8 @@ static int posix_cpu_nsleep(const clocki
 		if (flags & TIMER_ABSTIME)
 			return -ERESTARTNOHAND;
 
-		restart_block->fn = posix_cpu_nsleep_restart;
 		restart_block->nanosleep.clockid = which_clock;
+		set_restart_fn(restart_block, posix_cpu_nsleep_restart);
 	}
 	return error;
 }


