Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A40B6EEBEA
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 03:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237872AbjDZB3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 21:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbjDZB3P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 21:29:15 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7576E4C02
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 18:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1682472554; x=1714008554;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fyRYcQ64aRHILt2GNWohxqCAsWhc+JXOVhL/DAt2EfQ=;
  b=IbK6zxcvSWFbtrXlI97kVnG1ipMfYgAEqW9qJ8r+Tji1JlrYqYkDijv0
   j1gOrO6Gd3hCLzm7s2ayWOhXnAWvB6SzExWHUqHfPsQ0OMOkXj0yUU/yX
   gILPVQAsOhzZoxzGZnSKmlwGCjDtSkrYIwYiUyF9pK6CyEDYPL4rvy62u
   g=;
X-IronPort-AV: E=Sophos;i="5.99,227,1677542400"; 
   d="scan'208";a="318429344"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-5eae960a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 01:29:09 +0000
Received: from EX19MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-5eae960a.us-west-2.amazon.com (Postfix) with ESMTPS id ACD894157E;
        Wed, 26 Apr 2023 01:29:08 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Wed, 26 Apr 2023 01:29:08 +0000
Received: from 88665a182662.ant.amazon.com (10.106.101.29) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 26 Apr 2023 01:29:06 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <stable@vger.kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>
Subject: [PATCH stable 5.10] seccomp: Move copy_seccomp() to no failure path.
Date:   Tue, 25 Apr 2023 18:28:57 -0700
Message-ID: <20230426012857.24643-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.101.29]
X-ClientProxiedBy: EX19D040UWA002.ant.amazon.com (10.13.139.113) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit a1140cb215fa13dcec06d12ba0c3ee105633b7c4 upstream.

Our syzbot instance reported memory leaks in do_seccomp() [0], similar
to the report [1].  It shows that we miss freeing struct seccomp_filter
and some objects included in it.

We can reproduce the issue with the program below [2] which calls one
seccomp() and two clone() syscalls.

The first clone()d child exits earlier than its parent and sends a
signal to kill it during the second clone(), more precisely before the
fatal_signal_pending() test in copy_process().  When the parent receives
the signal, it has to destroy the embryonic process and return -EINTR to
user space.  In the failure path, we have to call seccomp_filter_release()
to decrement the filter's refcount.

Initially, we called it in free_task() called from the failure path, but
the commit 3a15fb6ed92c ("seccomp: release filter after task is fully
dead") moved it to release_task() to notify user space as early as possible
that the filter is no longer used.

To keep the change and current seccomp refcount semantics, let's move
copy_seccomp() just after the signal check and add a WARN_ON_ONCE() in
free_task() for future debugging.

[0]:
unreferenced object 0xffff8880063add00 (size 256):
  comm "repro_seccomp", pid 230, jiffies 4294687090 (age 9.914s)
  hex dump (first 32 bytes):
    01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
    ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
  backtrace:
    do_seccomp (./include/linux/slab.h:600 ./include/linux/slab.h:733 kernel/seccomp.c:666 kernel/seccomp.c:708 kernel/seccomp.c:1871 kernel/seccomp.c:1991)
    do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
    entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
unreferenced object 0xffffc90000035000 (size 4096):
  comm "repro_seccomp", pid 230, jiffies 4294687090 (age 9.915s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 00 00 00 00 05 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    __vmalloc_node_range (mm/vmalloc.c:3226)
    __vmalloc_node (mm/vmalloc.c:3261 (discriminator 4))
    bpf_prog_alloc_no_stats (kernel/bpf/core.c:91)
    bpf_prog_alloc (kernel/bpf/core.c:129)
    bpf_prog_create_from_user (net/core/filter.c:1414)
    do_seccomp (kernel/seccomp.c:671 kernel/seccomp.c:708 kernel/seccomp.c:1871 kernel/seccomp.c:1991)
    do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
    entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
unreferenced object 0xffff888003fa1000 (size 1024):
  comm "repro_seccomp", pid 230, jiffies 4294687090 (age 9.915s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    bpf_prog_alloc_no_stats (./include/linux/slab.h:600 ./include/linux/slab.h:733 kernel/bpf/core.c:95)
    bpf_prog_alloc (kernel/bpf/core.c:129)
    bpf_prog_create_from_user (net/core/filter.c:1414)
    do_seccomp (kernel/seccomp.c:671 kernel/seccomp.c:708 kernel/seccomp.c:1871 kernel/seccomp.c:1991)
    do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
    entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
unreferenced object 0xffff888006360240 (size 16):
  comm "repro_seccomp", pid 230, jiffies 4294687090 (age 9.915s)
  hex dump (first 16 bytes):
    01 00 37 00 76 65 72 6c e0 83 01 06 80 88 ff ff  ..7.verl........
  backtrace:
    bpf_prog_store_orig_filter (net/core/filter.c:1137)
    bpf_prog_create_from_user (net/core/filter.c:1428)
    do_seccomp (kernel/seccomp.c:671 kernel/seccomp.c:708 kernel/seccomp.c:1871 kernel/seccomp.c:1991)
    do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
    entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
unreferenced object 0xffff8880060183e0 (size 8):
  comm "repro_seccomp", pid 230, jiffies 4294687090 (age 9.915s)
  hex dump (first 8 bytes):
    06 00 00 00 00 00 ff 7f                          ........
  backtrace:
    kmemdup (mm/util.c:129)
    bpf_prog_store_orig_filter (net/core/filter.c:1144)
    bpf_prog_create_from_user (net/core/filter.c:1428)
    do_seccomp (kernel/seccomp.c:671 kernel/seccomp.c:708 kernel/seccomp.c:1871 kernel/seccomp.c:1991)
    do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
    entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)

[1]: https://syzkaller.appspot.com/bug?id=2809bb0ac77ad9aa3f4afe42d6a610aba594a987

[2]:

void main(void)
{
	struct sock_filter filter[] = {
		BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_ALLOW),
	};
	struct sock_fprog fprog = {
		.len = sizeof(filter) / sizeof(filter[0]),
		.filter = filter,
	};
	long i, pid;

	syscall(__NR_seccomp, SECCOMP_SET_MODE_FILTER, 0, &fprog);

	for (i = 0; i < 2; i++) {
		pid = syscall(__NR_clone, CLONE_NEWNET | SIGKILL, NULL, NULL, 0);
		if (pid == 0)
			return;
	}
}

Fixes: 3a15fb6ed92c ("seccomp: release filter after task is fully dead")
Reported-by: syzbot+ab17848fe269b573eb71@syzkaller.appspotmail.com
Reported-by: Ayushman Dutta <ayudutta@amazon.com>
Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220823154532.82913-1-kuniyu@amazon.com
---
 kernel/fork.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index a5bc0c6a00fd..c6a289317e89 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -441,6 +441,9 @@ void put_task_stack(struct task_struct *tsk)
 
 void free_task(struct task_struct *tsk)
 {
+#ifdef CONFIG_SECCOMP
+	WARN_ON_ONCE(tsk->seccomp.filter);
+#endif
 	scs_release(tsk);
 
 #ifndef CONFIG_THREAD_INFO_IN_TASK
@@ -2248,12 +2251,6 @@ static __latent_entropy struct task_struct *copy_process(
 
 	spin_lock(&current->sighand->siglock);
 
-	/*
-	 * Copy seccomp details explicitly here, in case they were changed
-	 * before holding sighand lock.
-	 */
-	copy_seccomp(p);
-
 	rseq_fork(p, clone_flags);
 
 	/* Don't start children in a dying pid namespace */
@@ -2268,6 +2265,14 @@ static __latent_entropy struct task_struct *copy_process(
 		goto bad_fork_cancel_cgroup;
 	}
 
+	/* No more failure paths after this point. */
+
+	/*
+	 * Copy seccomp details explicitly here, in case they were changed
+	 * before holding sighand lock.
+	 */
+	copy_seccomp(p);
+
 	init_task_pid_links(p);
 	if (likely(p->pid)) {
 		ptrace_init_task(p, (clone_flags & CLONE_PTRACE) || trace);
-- 
2.30.2

