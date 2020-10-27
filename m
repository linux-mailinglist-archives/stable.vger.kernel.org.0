Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E60C29B4F4
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1766453AbgJ0PH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:07:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1790956AbgJ0PFK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:05:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1DBB206E5;
        Tue, 27 Oct 2020 15:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811109;
        bh=NP8NCLQ/w23IKhJMnePi70YMMpzjNPvccqTfFQ2QYvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s8L42FtDsuYcbmKKTybzUCxUurKoodCp3H91OcHKRZi34megTmZ175fGDIYuY4xyx
         EvZEc/uFA9/Q72VzzQ1CDLvD/KW/ww1RFlg7wxv1IIGixhNJk1zeErDulZJls1+Q9b
         2KeFT5a4yxH37oO8CBerX+VSjyZ3+K937/xANigY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 375/633] perf intel-pt: Fix "context_switch event has no tid" error
Date:   Tue, 27 Oct 2020 14:51:58 +0100
Message-Id: <20201027135540.295536520@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 7d537a8d2e76bc4fc71e34545ceaa463ac2cd928 ]

A context_switch event can have no tid because pids can be detached from
a task while the task is still running (in do_exit()). Note this won't
happen with per-task contexts because then tracing stops at
perf_event_exit_task()

If a task with no tid gets preempted, or a dying task gets preempted and
its parent releases it, when it subsequently gets switched back in,
Intel PT will not be able to determine what task is running and prints
an error "context_switch event has no tid". However, it is not really an
error because the task is in kernel space and the decoder can continue
to decode successfully. Fix by changing the error to be only a logged
message, and make allowance for tid == -1.

Example:

  Using 5.9-rc4 with Preemptible Kernel (Low-Latency Desktop) e.g.
  $ uname -r
  5.9.0-rc4
  $ grep PREEMPT .config
  # CONFIG_PREEMPT_NONE is not set
  # CONFIG_PREEMPT_VOLUNTARY is not set
  CONFIG_PREEMPT=y
  CONFIG_PREEMPT_COUNT=y
  CONFIG_PREEMPTION=y
  CONFIG_PREEMPT_RCU=y
  CONFIG_PREEMPT_NOTIFIERS=y
  CONFIG_DRM_I915_PREEMPT_TIMEOUT=640
  CONFIG_DEBUG_PREEMPT=y
  # CONFIG_PREEMPT_TRACER is not set
  # CONFIG_PREEMPTIRQ_DELAY_TEST is not set

Before:

  $ cat forkit.c

  #include <sys/types.h>
  #include <unistd.h>
  #include <sys/wait.h>

  int main()
  {
          pid_t child;
          int status = 0;

          child = fork();
          if (child == 0)
                  return 123;
          wait(&status);
          return 0;
  }

  $ gcc -o forkit forkit.c
  $ sudo ~/bin/perf record --kcore -a -m,64M -e intel_pt/cyc/k &
  [1] 11016
  $ taskset 2 ./forkit
  $ sudo pkill perf
  $ [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 17.262 MB perf.data ]

  [1]+  Terminated              sudo ~/bin/perf record --kcore -a -m,64M -e intel_pt/cyc/k
  $ sudo ~/bin/perf script --show-task-events --show-switch-events --itrace=iqqe-o -C 1 --ns | grep -C 2 forkit
  context_switch event has no tid
           taskset 11019 [001] 66663.270045029:          1 instructions:k:  ffffffffb1d9f844 strnlen_user+0xb4 ([kernel.kallsyms])
           taskset 11019 [001] 66663.270201816:          1 instructions:k:  ffffffffb1a83121 unmap_page_range+0x561 ([kernel.kallsyms])
            forkit 11019 [001] 66663.270327553: PERF_RECORD_COMM exec: forkit:11019/11019
            forkit 11019 [001] 66663.270420028:          1 instructions:k:  ffffffffb1db9537 __clear_user+0x27 ([kernel.kallsyms])
            forkit 11019 [001] 66663.270648704:          1 instructions:k:  ffffffffb18829e6 do_user_addr_fault+0xf6 ([kernel.kallsyms])
            forkit 11019 [001] 66663.270833163:          1 instructions:k:  ffffffffb230a825 irqentry_exit_to_user_mode+0x15 ([kernel.kallsyms])
            forkit 11019 [001] 66663.271092359:          1 instructions:k:  ffffffffb1aea3d9 lock_page_memcg+0x9 ([kernel.kallsyms])
            forkit 11019 [001] 66663.271207092: PERF_RECORD_FORK(11020:11020):(11019:11019)
            forkit 11019 [001] 66663.271234775: PERF_RECORD_SWITCH_CPU_WIDE OUT          next pid/tid: 11020/11020
            forkit 11020 [001] 66663.271238407: PERF_RECORD_SWITCH_CPU_WIDE IN           prev pid/tid: 11019/11019
            forkit 11020 [001] 66663.271312066:          1 instructions:k:  ffffffffb1a88140 handle_mm_fault+0x10 ([kernel.kallsyms])
            forkit 11020 [001] 66663.271476225: PERF_RECORD_EXIT(11020:11020):(11019:11019)
            forkit 11020 [001] 66663.271497488: PERF_RECORD_SWITCH_CPU_WIDE OUT preempt  next pid/tid: 11019/11019
            forkit 11019 [001] 66663.271500523: PERF_RECORD_SWITCH_CPU_WIDE IN           prev pid/tid: 11020/11020
            forkit 11019 [001] 66663.271517241:          1 instructions:k:  ffffffffb24012cd error_entry+0x6d ([kernel.kallsyms])
            forkit 11019 [001] 66663.271664080: PERF_RECORD_EXIT(11019:11019):(1386:1386)

After:

  $ sudo ~/bin/perf script --show-task-events --show-switch-events --itrace=iqqe-o -C 1 --ns | grep -C 2 forkit
           taskset 11019 [001] 66663.270045029:          1 instructions:k:  ffffffffb1d9f844 strnlen_user+0xb4 ([kernel.kallsyms])
           taskset 11019 [001] 66663.270201816:          1 instructions:k:  ffffffffb1a83121 unmap_page_range+0x561 ([kernel.kallsyms])
            forkit 11019 [001] 66663.270327553: PERF_RECORD_COMM exec: forkit:11019/11019
            forkit 11019 [001] 66663.270420028:          1 instructions:k:  ffffffffb1db9537 __clear_user+0x27 ([kernel.kallsyms])
            forkit 11019 [001] 66663.270648704:          1 instructions:k:  ffffffffb18829e6 do_user_addr_fault+0xf6 ([kernel.kallsyms])
            forkit 11019 [001] 66663.270833163:          1 instructions:k:  ffffffffb230a825 irqentry_exit_to_user_mode+0x15 ([kernel.kallsyms])
            forkit 11019 [001] 66663.271092359:          1 instructions:k:  ffffffffb1aea3d9 lock_page_memcg+0x9 ([kernel.kallsyms])
            forkit 11019 [001] 66663.271207092: PERF_RECORD_FORK(11020:11020):(11019:11019)
            forkit 11019 [001] 66663.271234775: PERF_RECORD_SWITCH_CPU_WIDE OUT          next pid/tid: 11020/11020
            forkit 11020 [001] 66663.271238407: PERF_RECORD_SWITCH_CPU_WIDE IN           prev pid/tid: 11019/11019
            forkit 11020 [001] 66663.271312066:          1 instructions:k:  ffffffffb1a88140 handle_mm_fault+0x10 ([kernel.kallsyms])
            forkit 11020 [001] 66663.271476225: PERF_RECORD_EXIT(11020:11020):(11019:11019)
            forkit 11020 [001] 66663.271497488: PERF_RECORD_SWITCH_CPU_WIDE OUT preempt  next pid/tid: 11019/11019
            forkit 11019 [001] 66663.271500523: PERF_RECORD_SWITCH_CPU_WIDE IN           prev pid/tid: 11020/11020
            forkit 11019 [001] 66663.271517241:          1 instructions:k:  ffffffffb24012cd error_entry+0x6d ([kernel.kallsyms])
            forkit 11019 [001] 66663.271664080: PERF_RECORD_EXIT(11019:11019):(1386:1386)
            forkit 11019 [001] 66663.271688752: PERF_RECORD_SWITCH_CPU_WIDE OUT          next pid/tid:    -1/-1
               :-1    -1 [001] 66663.271692086: PERF_RECORD_SWITCH_CPU_WIDE IN           prev pid/tid: 11019/11019
                :-1    -1 [001] 66663.271707466:          1 instructions:k:  ffffffffb18eb096 update_load_avg+0x306 ([kernel.kallsyms])

Fixes: 86c2786994bd7c ("perf intel-pt: Add support for PERF_RECORD_SWITCH")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
Link: http://lore.kernel.org/lkml/20200909084923.9096-3-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/intel-pt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index 9357b5f62c273..bc88175e377ce 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -1071,6 +1071,8 @@ static void intel_pt_set_pid_tid_cpu(struct intel_pt *pt,
 
 	if (queue->tid == -1 || pt->have_sched_switch) {
 		ptq->tid = machine__get_current_tid(pt->machine, ptq->cpu);
+		if (ptq->tid == -1)
+			ptq->pid = -1;
 		thread__zput(ptq->thread);
 	}
 
@@ -2561,10 +2563,8 @@ static int intel_pt_context_switch(struct intel_pt *pt, union perf_event *event,
 		tid = sample->tid;
 	}
 
-	if (tid == -1) {
-		pr_err("context_switch event has no tid\n");
-		return -EINVAL;
-	}
+	if (tid == -1)
+		intel_pt_log("context_switch event has no tid\n");
 
 	intel_pt_log("context_switch: cpu %d pid %d tid %d time %"PRIu64" tsc %#"PRIx64"\n",
 		     cpu, pid, tid, sample->time, perf_time_to_tsc(sample->time,
-- 
2.25.1



