Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2D033E04F
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 22:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233148AbhCPVR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 17:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbhCPVRJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 17:17:09 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B3FC06175F;
        Tue, 16 Mar 2021 14:17:08 -0700 (PDT)
Date:   Tue, 16 Mar 2021 21:17:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615929425;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xw6nNRh3N9kof/ooR7FnSsxqyrCJ/QtG04AagLWg0iE=;
        b=a9z/XNvKvm6U4PMi2dYOeVlkeWmm+SCQgmgzTYhwg5sCMk+cGHzsWEA1SbhScNS9nRuMVs
        W7nCkMWjTQMzaOrtW/r4ytBQrVOG8/xic7RWgRlwSN/TIZZIjizIDykMNJtyImOtrRrJQR
        P0IV00eM20Rgs3Ru1Zl6hj6HdXccvTBsOHw0xvyNkwWuEqJiMfGj9f5uMHsiYfkKw6cDrI
        1YmdsfdOPxJmJvaqFgcKi49dr8VvTIlYhP928Zvk567lzETrdIZbN4Pm9MXJXvJaTkFtrJ
        s8Oc/AF2wWpxN/klIEhtaoHB305m7nA/hciQ3CwuLs+HE9ADskN3MoIKgM6Z0w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615929425;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xw6nNRh3N9kof/ooR7FnSsxqyrCJ/QtG04AagLWg0iE=;
        b=g4vR915yWSKEse+7D+NTxX2BbNGlJrm3hNqS6XoP8lUWFVvCYYAzUd3ChlFeanmbuj1Gxz
        Z+HCgpjJcRalAwAQ==
From:   "tip-bot2 for Oleg Nesterov" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] kernel, fs: Introduce and use set_restart_fn() and
 arch_set_restart_data()
Cc:     Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210201174641.GA17871@redhat.com>
References: <20210201174641.GA17871@redhat.com>
MIME-Version: 1.0
Message-ID: <161592942528.398.3161222812902818660.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     5abbe51a526253b9f003e9a0a195638dc882d660
Gitweb:        https://git.kernel.org/tip/5abbe51a526253b9f003e9a0a195638dc882d660
Author:        Oleg Nesterov <oleg@redhat.com>
AuthorDate:    Mon, 01 Feb 2021 18:46:41 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 16 Mar 2021 22:13:10 +01:00

kernel, fs: Introduce and use set_restart_fn() and arch_set_restart_data()

Preparation for fixing get_nr_restart_syscall() on X86 for COMPAT.

Add a new helper which sets restart_block->fn and calls a dummy
arch_set_restart_data() helper.

Fixes: 609c19a385c8 ("x86/ptrace: Stop setting TS_COMPAT in ptrace code")
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210201174641.GA17871@redhat.com

---
 fs/select.c                    | 10 ++++------
 include/linux/thread_info.h    | 13 +++++++++++++
 kernel/futex.c                 |  3 +--
 kernel/time/alarmtimer.c       |  2 +-
 kernel/time/hrtimer.c          |  2 +-
 kernel/time/posix-cpu-timers.c |  2 +-
 6 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index 37aaa83..945896d 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -1055,10 +1055,9 @@ static long do_restart_poll(struct restart_block *restart_block)
 
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
 
@@ -1080,7 +1079,6 @@ SYSCALL_DEFINE3(poll, struct pollfd __user *, ufds, unsigned int, nfds,
 		struct restart_block *restart_block;
 
 		restart_block = &current->restart_block;
-		restart_block->fn = do_restart_poll;
 		restart_block->poll.ufds = ufds;
 		restart_block->poll.nfds = nfds;
 
@@ -1091,7 +1089,7 @@ SYSCALL_DEFINE3(poll, struct pollfd __user *, ufds, unsigned int, nfds,
 		} else
 			restart_block->poll.has_timeout = 0;
 
-		ret = -ERESTART_RESTARTBLOCK;
+		ret = set_restart_fn(restart_block, do_restart_poll);
 	}
 	return ret;
 }
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index 9b2158c..157762d 100644
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
diff --git a/kernel/futex.c b/kernel/futex.c
index e68db77..00febd6 100644
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
diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 98d7a15..4d94e2b 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -854,9 +854,9 @@ static int alarm_timer_nsleep(const clockid_t which_clock, int flags,
 	if (flags == TIMER_ABSTIME)
 		return -ERESTARTNOHAND;
 
-	restart->fn = alarm_timer_nsleep_restart;
 	restart->nanosleep.clockid = type;
 	restart->nanosleep.expires = exp;
+	set_restart_fn(restart, alarm_timer_nsleep_restart);
 	return ret;
 }
 
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 788b9d1..5c9d968 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1957,9 +1957,9 @@ long hrtimer_nanosleep(ktime_t rqtp, const enum hrtimer_mode mode,
 	}
 
 	restart = &current->restart_block;
-	restart->fn = hrtimer_nanosleep_restart;
 	restart->nanosleep.clockid = t.timer.base->clockid;
 	restart->nanosleep.expires = hrtimer_get_expires_tv64(&t.timer);
+	set_restart_fn(restart, hrtimer_nanosleep_restart);
 out:
 	destroy_hrtimer_on_stack(&t.timer);
 	return ret;
diff --git a/kernel/time/posix-cpu-timers.c b/kernel/time/posix-cpu-timers.c
index a71758e..9abe152 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1480,8 +1480,8 @@ static int posix_cpu_nsleep(const clockid_t which_clock, int flags,
 		if (flags & TIMER_ABSTIME)
 			return -ERESTARTNOHAND;
 
-		restart_block->fn = posix_cpu_nsleep_restart;
 		restart_block->nanosleep.clockid = which_clock;
+		set_restart_fn(restart_block, posix_cpu_nsleep_restart);
 	}
 	return error;
 }
