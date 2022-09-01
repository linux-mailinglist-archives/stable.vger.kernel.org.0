Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F985AA318
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 00:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbiIAWcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 18:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233729AbiIAWcd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 18:32:33 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC49108B
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 15:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1662071552; x=1693607552;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=G8JdlIx2Xac+lqUhtF+N0rOmQq6A+lDdpJ+RpnSepcs=;
  b=q3TeuQj68Y8dU3R8Xeh02AQ2/4FuEmvtW6lSIWBuLBRY+CVHSmCUbmc4
   qNpH//hn/6o2r2Z6k/0HdvZVQuo3Qgs6tZjjKpff6EYXHDJMKmAx36JiT
   THxubwGhKwwhF9bEEj+M9ohRMGEI1YAjKklUoRdvMG6iHEe8EExK8q6Mk
   s=;
X-IronPort-AV: E=Sophos;i="5.93,281,1654560000"; 
   d="scan'208";a="125868115"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-87b71607.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 22:32:15 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-87b71607.us-east-1.amazon.com (Postfix) with ESMTPS id 66456142CA0;
        Thu,  1 Sep 2022 22:32:12 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 1 Sep 2022 22:32:11 +0000
Received: from dev-dsk-kuniyu-2c-0edd2a20.us-west-2.amazon.com (10.43.161.172)
 by EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 1 Sep 2022 22:32:09 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <stable@vger.kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Ayushman Dutta <ayudutta@amazon.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        "Anil S Keshavamurthy" <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Wang Nan <wangnan0@huawei.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH stable 5.4 5.10 5.15] kprobes: don't call disarm_kprobe() for disabled kprobes
Date:   Thu, 1 Sep 2022 22:32:05 +0000
Message-ID: <20220901223205.11648-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.172]
X-ClientProxiedBy: EX13D31UWA002.ant.amazon.com (10.43.160.82) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 9c80e79906b4ca440d09e7f116609262bb747909 upstream.

The assumption in __disable_kprobe() is wrong, and it could try to disarm
an already disarmed kprobe and fire the WARN_ONCE() below. [0]  We can
easily reproduce this issue.

1. Write 0 to /sys/kernel/debug/kprobes/enabled.

  # echo 0 > /sys/kernel/debug/kprobes/enabled

2. Run execsnoop.  At this time, one kprobe is disabled.

  # /usr/share/bcc/tools/execsnoop &
  [1] 2460
  PCOMM            PID    PPID   RET ARGS

  # cat /sys/kernel/debug/kprobes/list
  ffffffff91345650  r  __x64_sys_execve+0x0    [FTRACE]
  ffffffff91345650  k  __x64_sys_execve+0x0    [DISABLED][FTRACE]

3. Write 1 to /sys/kernel/debug/kprobes/enabled, which changes
   kprobes_all_disarmed to false but does not arm the disabled kprobe.

  # echo 1 > /sys/kernel/debug/kprobes/enabled

  # cat /sys/kernel/debug/kprobes/list
  ffffffff91345650  r  __x64_sys_execve+0x0    [FTRACE]
  ffffffff91345650  k  __x64_sys_execve+0x0    [DISABLED][FTRACE]

4. Kill execsnoop, when __disable_kprobe() calls disarm_kprobe() for the
   disabled kprobe and hits the WARN_ONCE() in __disarm_kprobe_ftrace().

  # fg
  /usr/share/bcc/tools/execsnoop
  ^C

Actually, WARN_ONCE() is fired twice, and __unregister_kprobe_top() misses
some cleanups and leaves the aggregated kprobe in the hash table.  Then,
__unregister_trace_kprobe() initialises tk->rp.kp.list and creates an
infinite loop like this.

  aggregated kprobe.list -> kprobe.list -.
                                     ^    |
                                     '.__.'

In this situation, these commands fall into the infinite loop and result
in RCU stall or soft lockup.

  cat /sys/kernel/debug/kprobes/list : show_kprobe_addr() enters into the
                                       infinite loop with RCU.

  /usr/share/bcc/tools/execsnoop : warn_kprobe_rereg() holds kprobe_mutex,
                                   and __get_valid_kprobe() is stuck in
				   the loop.

To avoid the issue, make sure we don't call disarm_kprobe() for disabled
kprobes.

[0]
Failed to disarm kprobe-ftrace at __x64_sys_execve+0x0/0x40 (error -2)
WARNING: CPU: 6 PID: 2460 at kernel/kprobes.c:1130 __disarm_kprobe_ftrace.isra.19 (kernel/kprobes.c:1129)
Modules linked in: ena
CPU: 6 PID: 2460 Comm: execsnoop Not tainted 5.19.0+ #28
Hardware name: Amazon EC2 c5.2xlarge/, BIOS 1.0 10/16/2017
RIP: 0010:__disarm_kprobe_ftrace.isra.19 (kernel/kprobes.c:1129)
Code: 24 8b 02 eb c1 80 3d c4 83 f2 01 00 75 d4 48 8b 75 00 89 c2 48 c7 c7 90 fa 0f 92 89 04 24 c6 05 ab 83 01 e8 e4 94 f0 ff <0f> 0b 8b 04 24 eb b1 89 c6 48 c7 c7 60 fa 0f 92 89 04 24 e8 cc 94
RSP: 0018:ffff9e6ec154bd98 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffffffff930f7b00 RCX: 0000000000000001
RDX: 0000000080000001 RSI: ffffffff921461c5 RDI: 00000000ffffffff
RBP: ffff89c504286da8 R08: 0000000000000000 R09: c0000000fffeffff
R10: 0000000000000000 R11: ffff9e6ec154bc28 R12: ffff89c502394e40
R13: ffff89c502394c00 R14: ffff9e6ec154bc00 R15: 0000000000000000
FS:  00007fe800398740(0000) GS:ffff89c812d80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c00057f010 CR3: 0000000103b54006 CR4: 00000000007706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
<TASK>
 __disable_kprobe (kernel/kprobes.c:1716)
 disable_kprobe (kernel/kprobes.c:2392)
 __disable_trace_kprobe (kernel/trace/trace_kprobe.c:340)
 disable_trace_kprobe (kernel/trace/trace_kprobe.c:429)
 perf_trace_event_unreg.isra.2 (./include/linux/tracepoint.h:93 kernel/trace/trace_event_perf.c:168)
 perf_kprobe_destroy (kernel/trace/trace_event_perf.c:295)
 _free_event (kernel/events/core.c:4971)
 perf_event_release_kernel (kernel/events/core.c:5176)
 perf_release (kernel/events/core.c:5186)
 __fput (fs/file_table.c:321)
 task_work_run (./include/linux/sched.h:2056 (discriminator 1) kernel/task_work.c:179 (discriminator 1))
 exit_to_user_mode_prepare (./include/linux/resume_user_mode.h:49 kernel/entry/common.c:169 kernel/entry/common.c:201)
 syscall_exit_to_user_mode (./arch/x86/include/asm/jump_label.h:55 ./arch/x86/include/asm/nospec-branch.h:384 ./arch/x86/include/asm/entry-common.h:94 kernel/entry/common.c:133 kernel/entry/common.c:296)
 do_syscall_64 (arch/x86/entry/common.c:87)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
RIP: 0033:0x7fe7ff210654
Code: 15 79 89 20 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb be 0f 1f 00 8b 05 9a cd 20 00 48 63 ff 85 c0 75 11 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 3a f3 c3 48 83 ec 18 48 89 7c 24 08 e8 34 fc
RSP: 002b:00007ffdbd1d3538 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000008 RCX: 00007fe7ff210654
RDX: 0000000000000000 RSI: 0000000000002401 RDI: 0000000000000008
RBP: 0000000000000000 R08: 94ae31d6fda838a4 R0900007fe8001c9d30
R10: 00007ffdbd1d34b0 R11: 0000000000000246 R12: 00007ffdbd1d3600
R13: 0000000000000000 R14: fffffffffffffffc R15: 00007ffdbd1d3560
</TASK>

Link: https://lkml.kernel.org/r/20220813020509.90805-1-kuniyu@amazon.com
Fixes: 69d54b916d83 ("kprobes: makes kprobes/enabled works correctly for optimized kprobes.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reported-by: Ayushman Dutta <ayudutta@amazon.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Wang Nan <wangnan0@huawei.com>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: Kuniyuki Iwashima <kuni1840@gmail.com>
Cc: Ayushman Dutta <ayudutta@amazon.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/kprobes.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 3a3c0166bd1f..ed3f24a81549 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1705,11 +1705,12 @@ static struct kprobe *__disable_kprobe(struct kprobe *p)
 		/* Try to disarm and disable this/parent probe */
 		if (p == orig_p || aggr_kprobe_disabled(orig_p)) {
 			/*
-			 * If kprobes_all_disarmed is set, orig_p
-			 * should have already been disarmed, so
-			 * skip unneed disarming process.
+			 * Don't be lazy here.  Even if 'kprobes_all_disarmed'
+			 * is false, 'orig_p' might not have been armed yet.
+			 * Note arm_all_kprobes() __tries__ to arm all kprobes
+			 * on the best effort basis.
 			 */
-			if (!kprobes_all_disarmed) {
+			if (!kprobes_all_disarmed && !kprobe_disabled(orig_p)) {
 				ret = disarm_kprobe(orig_p, true);
 				if (ret) {
 					p->flags &= ~KPROBE_FLAG_DISABLED;
-- 
2.37.1

