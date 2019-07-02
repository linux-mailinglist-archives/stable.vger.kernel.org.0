Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52ADD5C752
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 04:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfGBC0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 22:26:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727059AbfGBC0b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jul 2019 22:26:31 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.35.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C21E621721;
        Tue,  2 Jul 2019 02:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562034390;
        bh=sIi7JzdlsTo1iHliJsIjDsN9QdPzoosxI9hpQTH4r1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g5A12Qyujq3xmBzQGsMnKow6eBHo2CAtK7MLz1rPj5SsuwVknRsGz69R2z4R00VNp
         qwxRmErmtdQO2Xn5MGuJn2BHSmgJFTKIayl1OvkBOk4KpKrD73NBdF+6rMUN2c6UQ2
         BY/rRcdLfNIPKKCP/80SEv+eeHMvIsiQ3VhyetRU=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 02/43] perf thread-stack: Fix thread stack return from kernel for kernel-only case
Date:   Mon,  1 Jul 2019 23:25:35 -0300
Message-Id: <20190702022616.1259-3-acme@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190702022616.1259-1-acme@kernel.org>
References: <20190702022616.1259-1-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Commit f08046cb3082 ("perf thread-stack: Represent jmps to the start of a
different symbol") had the side-effect of introducing more stack entries
before return from kernel space.

When user space is also traced, those entries are popped before entry to
user space, but when user space is not traced, they get stuck at the
bottom of the stack, making the stack grow progressively larger.

Fix by detecting a return-from-kernel branch type, and popping kernel
addresses from the stack then.

Note, the problem and fix affect the exported Call Graph / Tree but not
the callindent option used by "perf script --call-trace".

Example:

  perf-with-kcore record example -e intel_pt//k -- ls
  perf-with-kcore script example --itrace=bep -s ~/libexec/perf-core/scripts/python/export-to-sqlite.py example.db branches calls
  ~/libexec/perf-core/scripts/python/exported-sql-viewer.py example.db

  Menu option: Reports -> Context-Sensitive Call Graph

  Before: (showing Call Path column only)

    Call Path
    ▶ perf
    ▼ ls
      ▼ 12111:12111
        ▶ setup_new_exec
        ▶ __task_pid_nr_ns
        ▶ perf_event_pid_type
        ▶ perf_event_comm_output
        ▶ perf_iterate_ctx
        ▶ perf_iterate_sb
        ▶ perf_event_comm
        ▶ __set_task_comm
        ▶ load_elf_binary
        ▶ search_binary_handler
        ▶ __do_execve_file.isra.41
        ▶ __x64_sys_execve
        ▶ do_syscall_64
        ▼ entry_SYSCALL_64_after_hwframe
          ▼ swapgs_restore_regs_and_return_to_usermode
            ▼ native_iret
              ▶ error_entry
              ▶ do_page_fault
              ▼ error_exit
                ▼ retint_user
                  ▶ prepare_exit_to_usermode
                  ▼ native_iret
                    ▶ error_entry
                    ▶ do_page_fault
                    ▼ error_exit
                      ▼ retint_user
                        ▶ prepare_exit_to_usermode
                        ▼ native_iret
                          ▶ error_entry
                          ▶ do_page_fault
                          ▼ error_exit
                            ▼ retint_user
                              ▶ prepare_exit_to_usermode
                              ▶ native_iret

  After: (showing Call Path column only)

    Call Path
    ▶ perf
    ▼ ls
      ▼ 12111:12111
        ▶ setup_new_exec
        ▶ __task_pid_nr_ns
        ▶ perf_event_pid_type
        ▶ perf_event_comm_output
        ▶ perf_iterate_ctx
        ▶ perf_iterate_sb
        ▶ perf_event_comm
        ▶ __set_task_comm
        ▶ load_elf_binary
        ▶ search_binary_handler
        ▶ __do_execve_file.isra.41
        ▶ __x64_sys_execve
        ▶ do_syscall_64
        ▶ entry_SYSCALL_64_after_hwframe
        ▶ page_fault
        ▼ entry_SYSCALL_64
          ▼ do_syscall_64
            ▶ __x64_sys_brk
            ▶ __x64_sys_access
            ▶ __x64_sys_openat
            ▶ __x64_sys_newfstat
            ▶ __x64_sys_mmap
            ▶ __x64_sys_close
            ▶ __x64_sys_read
            ▶ __x64_sys_mprotect
            ▶ __x64_sys_arch_prctl
            ▶ __x64_sys_munmap
            ▶ exit_to_usermode_loop
            ▶ __x64_sys_set_tid_address
            ▶ __x64_sys_set_robust_list
            ▶ __x64_sys_rt_sigaction
            ▶ __x64_sys_rt_sigprocmask
            ▶ __x64_sys_prlimit64
            ▶ __x64_sys_statfs
            ▶ __x64_sys_ioctl
            ▶ __x64_sys_getdents64
            ▶ __x64_sys_write
            ▶ __x64_sys_exit_group

Committer notes:

The first arg to the perf-with-kcore needs to be the same for the
'record' and 'script' lines, otherwise we'll record the perf.data file
and kcore_dir/ files in one directory ('example') to then try to use it
from the 'bep' directory, fix the instructions above it so that both use
'example'.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org
Fixes: f08046cb3082 ("perf thread-stack: Represent jmps to the start of a different symbol")
Link: http://lkml.kernel.org/r/20190619064429.14940-2-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/thread-stack.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/thread-stack.c b/tools/perf/util/thread-stack.c
index c485186a8b6d..4c826a2e08d8 100644
--- a/tools/perf/util/thread-stack.c
+++ b/tools/perf/util/thread-stack.c
@@ -628,6 +628,23 @@ static int thread_stack__bottom(struct thread_stack *ts,
 				     true, false);
 }
 
+static int thread_stack__pop_ks(struct thread *thread, struct thread_stack *ts,
+				struct perf_sample *sample, u64 ref)
+{
+	u64 tm = sample->time;
+	int err;
+
+	/* Return to userspace, so pop all kernel addresses */
+	while (thread_stack__in_kernel(ts)) {
+		err = thread_stack__call_return(thread, ts, --ts->cnt,
+						tm, ref, true);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 static int thread_stack__no_call_return(struct thread *thread,
 					struct thread_stack *ts,
 					struct perf_sample *sample,
@@ -910,7 +927,18 @@ int thread_stack__process(struct thread *thread, struct comm *comm,
 			ts->rstate = X86_RETPOLINE_DETECTED;
 
 	} else if (sample->flags & PERF_IP_FLAG_RETURN) {
-		if (!sample->ip || !sample->addr)
+		if (!sample->addr) {
+			u32 return_from_kernel = PERF_IP_FLAG_SYSCALLRET |
+						 PERF_IP_FLAG_INTERRUPT;
+
+			if (!(sample->flags & return_from_kernel))
+				return 0;
+
+			/* Pop kernel stack */
+			return thread_stack__pop_ks(thread, ts, sample, ref);
+		}
+
+		if (!sample->ip)
 			return 0;
 
 		/* x86 retpoline 'return' doesn't match the stack */
-- 
2.20.1

