Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0BD442254
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 22:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhKAVJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 17:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbhKAVJO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 17:09:14 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B927C061714
        for <stable@vger.kernel.org>; Mon,  1 Nov 2021 14:06:39 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b126-20020a251b84000000b005bd8aca71a2so27707583ybb.4
        for <stable@vger.kernel.org>; Mon, 01 Nov 2021 14:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=NbXQXdCm8kL6XOVXwUbDjKsclIV2Hv/kcZR/mnYlPiQ=;
        b=P+sG6Tyx/RAYZxuYCTVG+ENBNDPdEZi8ReyQeRGGMpCSdpwOHruyUY5xWQoxGuTgxL
         PqTexgRctbwcSyWdAVnepX0cdTG6oxhIzNHZtBOUVx2u8dTuKHvJACATySGhfViNvDqt
         fXI72aZAX4FPI9sTXMqYEWGAJAN0MBW9TiMpqGnPR4YsCpBUoKBYjgiUNZdlN9Igp3j7
         cMS0DTdthahFhCw115p10G4+ozZKdMe0pKD5gsFraHq3Xba4E+Y1wp9dxDFxinzY5DqL
         7TglPxPF9/Jn8fxWm8lqf0yBgSZOdZIYtkI2Zg8XtjTgyWGyHr9JppbzzeSaidpIRmlj
         vsiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=NbXQXdCm8kL6XOVXwUbDjKsclIV2Hv/kcZR/mnYlPiQ=;
        b=X5cQ0bF1YETQalDTMCDez11KywMkLO2SDzIQyHzy4b1pLCso9rxF6XFjWXqQBZxD2U
         X6vbzUOJlq66IJg7swtB/qE+qE8jIgu+vtKDRO+TzUGHNzqOllsGJ4AAG21iey20yvGR
         mIDPS+S0IPh40BrDd0DU5I6HfK4lcZMowzIjOORbuuFVneRbRhWtsgpDUgcY9pBNvWqS
         uxZHhuMWriJlTKnXUNGhJqOjTUgdKup62QI/M6hMgu5wfWiOU//xPSYik+riP3rex4HO
         6M4mW6oyuj6AseG5KYrbbEntlozu5PpllrddhOD4pDIQvIJn9tfDv0VdzSwVtPzUH7dT
         BUsg==
X-Gm-Message-State: AOAM531DMPX3I4kGElakP5EuPF+OFaTjkkw4RUKrwlIECDUof8HTdTYM
        Xsox+TI4ux4WlsIAshOnkc0fehQPoMM=
X-Google-Smtp-Source: ABdhPJydf/EslTxlaK3eKzUeqSkjq8nOhFcyhat8b59E4JQ66u+OuPAoCsMkCeHWZaMSUe5Do+lF/gvovSI=
X-Received: from mpratt.nyc.corp.google.com ([2620:0:1003:1213:253a:1c3f:ff38:b34e])
 (user=mpratt job=sendgmr) by 2002:a05:6902:4c6:: with SMTP id
 v6mr36271350ybs.160.1635800798839; Mon, 01 Nov 2021 14:06:38 -0700 (PDT)
Date:   Mon,  1 Nov 2021 17:06:15 -0400
Message-Id: <20211101210615.716522-1-mpratt@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH] posix-cpu-timers: Clear posix_cputimers_work in copy_process
From:   Michael Pratt <mpratt@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Rhys Hiltner <rhys@justin.tv>
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Gladkov <legion@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        David Hildenbrand <david@redhat.com>,
        Rolf Eike Beer <eb@emlix.com>, linux-kernel@vger.kernel.org,
        Michael Pratt <mpratt@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

copy_process currently copies task_struct.posix_cputimers_work as-is. If a
timer interrupt arrives while handling clone and before dup_task_struct
completes then the child task will have:

1. posix_cputimers_work.scheduled = true
2. posix_cputimers_work.work queued.

copy_process clears task_struct.task_works, so (2) will have no effect and
posix_cpu_timers_work will never run (not to mention it doesn't make sense
for two tasks to share a common linked list).

Since posix_cpu_timers_work never runs, posix_cputimers_work.scheduled is
never cleared. Since scheduled is set, future timer interrupts will skip
scheduling work, with the ultimate result that the task will never receive
timer expirations.

Together, the complete flow is:

1. Task 1 calls clone(), enters kernel.
2. Timer interrupt fires, schedules task work on Task 1.
   2a. task_struct.posix_cputimers_work.scheduled = true
   2b. task_struct.posix_cputimers_work.work added to
       task_struct.task_works.
3. dup_task_struct copies Task 1 to Task 2.
4. copy_process clears task_struct.task_works for Task 2.
5. Future timer interrupts on Task 2 see
   task_struct.posix_cputimers_work.scheduled = true and skip scheduling
   work.

Fix this by explicitly clearing contents of
task_struct.posix_cputimers_work in copy_process. This was never meant to
be shared or inherited across tasks in the first place.

Signed-off-by: Michael Pratt <mpratt@google.com>
Reported-by: Rhys Hiltner <rhys@justin.tv>
Fixes: 1fb497dd0030 ("posix-cpu-timers: Provide mechanisms to defer timer handling to task_work")
Cc: <stable@vger.kernel.org>
---
This issue was discovered while investigating a flaky test in the Go
language standard libary, https://golang.org/issue/49065. After our testing
VMs upgraded from 5.4 to 5.10 kernels, several profiling tests started
failing ~1% of the time with threads not receiving their expected profiling
signals.

Bisection of problem by Rhys blamed b6b178e38f40 ("Merge tag
'timers-core-2020-08-14' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip"). This merge commit
introduced the broken commit 1fb497dd0030 ("posix-cpu-timers: Provide
mechanisms to defer timer handling to task_work") and its child
0099808553ad ("x86: Select POSIX_CPU_TIMERS_TASK_WORK"), which enables the
new codepath.

The C program below also reproduces the problem. Build with `gcc repro.c
-lrt -pthread -O2`.

The program starts a CPU timer on the main thread, which then spawns child
threads that create their own CPU timers and verify that they receive timer
signals. At HEAD and 0099808553ad this program fails with ~3-15 / 20000
threads not receiving signals.

Prior to 0099808553ad and with this patch, the program reports no failures.

// SPDX-License-Identifier: GPL-2.0
#include <pthread.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <sys/syscall.h>
#include <time.h>
#include <unistd.h>

__thread uint64_t signaled;

_Atomic int threads_bad;

void signal_handler(int signo, siginfo_t *siginfo, void *uctx)
{
	signaled++;
}

int gettid(void)
{
	return syscall(SYS_gettid);
}

timer_t setup_timer(void)
{
	struct sigevent sev = {
		.sigev_signo = SIGPROF,
		.sigev_notify = SIGEV_THREAD_ID,
		._sigev_un = {
			._tid = gettid(),
		},
	};
	struct itimerspec spec = {
		.it_interval = {
			.tv_nsec = 10*1000*1000, /* 10ms */
		},
		.it_value = {
			.tv_nsec = 10*1000*1000, /* 10ms */
		},
	};
	timer_t timerid;
	int ret;

	ret = timer_create(CLOCK_THREAD_CPUTIME_ID, &sev, &timerid);
	if (ret != 0) {
		perror("timer_create");
		_exit(1);
	}

	ret = timer_settime(timerid, 0, &spec, NULL);
	if (ret != 0) {
		perror("timer_settime");
		_exit(1);
	}

	return timerid;
}

uint64_t thread_cpu_ns(void)
{
	struct timespec ts;
	int ret;

	ret = clock_gettime(CLOCK_THREAD_CPUTIME_ID, &ts);
	if (ret != 0) {
		perror("clock_gettime");
		_exit(1);
	}
	return ts.tv_nsec + 1000*1000*1000*ts.tv_sec;
}

void *thread(void *arg)
{
	timer_t timerid;
	uint64_t start;
	int ret;

	timerid = setup_timer();

	start = thread_cpu_ns();
	while (1) {
		uint64_t now;

		/* 50ms passed? */
		now = thread_cpu_ns();
		if (now - start > 50*1000*1000)
			break;

		/* Busy loop */
		for (volatile int i = 0; i < 100000; i++)
			;
	}

	/*
	 * 50ms passed; we should certainly have received some profiling
	 * signals.
	 */
	if (signaled == 0) {
		printf("Thread %d received no profiling signals!\n", gettid());
		threads_bad++;
	}

	ret = timer_delete(timerid);
	if (ret != 0) {
		perror("timer_delete");
		_exit(1);
	}

	return NULL;
}

int main(void)
{
	struct sigaction sa = {
		.sa_sigaction = &signal_handler,
		.sa_flags = SA_SIGINFO | SA_RESTART,
	};
	int ret;
	sigset_t set;
	timer_t timerid;
	int bad;
	int thread_count = 0;

	ret = sigaction(SIGPROF, &sa, NULL);
	if (ret != 0) {
		perror("sigaction");
		return 1;
	}

	sigemptyset(&set);
	sigaddset(&set, SIGPROF);
	ret = sigprocmask(SIG_UNBLOCK, &set, NULL);
	if (ret != 0) {
		perror("sigprocmask");
		return 1;
	}

	timerid = setup_timer();

	while (thread_count < 20000) {
		pthread_t threads[10];

		for (int i = 0; i < 10; i++) {
			ret = pthread_create(&threads[i], NULL, &thread, NULL);
			if (ret != 0) {
				perror("pthread_create");
				return 1;
			}
			thread_count++;
		}

		/* Busy loop */
		for (volatile int i = 0; i < 100000; i++)
			;

		for (int i = 0; i < 10; i++) {
			ret = pthread_join(threads[i], NULL);
			if (ret != 0) {
				perror("pthread_join");
				return 1;
			}
		}

		if (thread_count % 100 == 0)
			printf("%d threads\n", thread_count);
	}

	bad = threads_bad;
	printf("Bad threads %d / %d = %f%%\n", threads_bad, thread_count,
	       100*((double)threads_bad) / ((double)thread_count));

	if (threads_bad > 0)
		return 1;
	return 0;
}

 include/linux/posix-timers.h   |  2 ++
 kernel/fork.c                  |  1 +
 kernel/time/posix-cpu-timers.c | 19 +++++++++++++++++--
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 00fef0064355..5bbcd280bfd2 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -184,8 +184,10 @@ static inline void posix_cputimers_group_init(struct posix_cputimers *pct,
 #endif
 
 #ifdef CONFIG_POSIX_CPU_TIMERS_TASK_WORK
+void clear_posix_cputimers_work(struct task_struct *p);
 void posix_cputimers_init_work(void);
 #else
+static inline void clear_posix_cputimers_work(struct task_struct *p) { }
 static inline void posix_cputimers_init_work(void) { }
 #endif
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 38681ad44c76..b1551c074b74 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2280,6 +2280,7 @@ static __latent_entropy struct task_struct *copy_process(
 	p->pdeath_signal = 0;
 	INIT_LIST_HEAD(&p->thread_group);
 	p->task_works = NULL;
+	clear_posix_cputimers_work(p);
 
 #ifdef CONFIG_KRETPROBES
 	p->kretprobe_instances.first = NULL;
diff --git a/kernel/time/posix-cpu-timers.c b/kernel/time/posix-cpu-timers.c
index 643d412ac623..96b4e7810426 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1158,14 +1158,29 @@ static void posix_cpu_timers_work(struct callback_head *work)
 	handle_posix_cpu_timers(current);
 }
 
+/*
+ * Clear existing posix CPU timers task work.
+ */
+void clear_posix_cputimers_work(struct task_struct *p)
+{
+	/*
+	 * A copied work entry from the old task is not meaningful, clear it.
+	 * N.B. init_task_work will not do this.
+	 */
+	memset(&p->posix_cputimers_work.work, 0,
+	       sizeof(p->posix_cputimers_work.work));
+	init_task_work(&p->posix_cputimers_work.work,
+		       posix_cpu_timers_work);
+	p->posix_cputimers_work.scheduled = false;
+}
+
 /*
  * Initialize posix CPU timers task work in init task. Out of line to
  * keep the callback static and to avoid header recursion hell.
  */
 void __init posix_cputimers_init_work(void)
 {
-	init_task_work(&current->posix_cputimers_work.work,
-		       posix_cpu_timers_work);
+	clear_posix_cputimers_work(current);
 }
 
 /*
-- 
2.33.1.1089.g2158813163f-goog

