Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7D74C91FB
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729097AbfJBTNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:13:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35364 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729093AbfJBTIJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:09 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyn-00035S-M1; Wed, 02 Oct 2019 20:08:05 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyn-0003au-9T; Wed, 02 Oct 2019 20:08:05 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jan Stancek" <jstancek@redhat.com>,
        "Michael Ellerman" <mpe@ellerman.id.au>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.926004973@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 14/87] powerpc/perf: add missing put_cpu_var in
 power_pmu_event_init
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Stancek <jstancek@redhat.com>

commit 68de8867ea5d99127e836c23f6bccf4d44859623 upstream.

One path in power_pmu_event_init() calls get_cpu_var(), but is
missing matching call to put_cpu_var(), which causes preemption
imbalance and crash in user-space:

  Page fault in user mode with in_atomic() = 1 mm = c000001fefa5a280
  NIP = 3fff9bf2cae0  MSR = 900000014280f032
  Oops: Weird page fault, sig: 11 [#23]
  SMP NR_CPUS=2048 NUMA PowerNV
  Modules linked in: <snip>
  CPU: 43 PID: 10285 Comm: a.out Tainted: G      D         4.0.0-rc5+ #1
  task: c000001fe82c9200 ti: c000001fe835c000 task.ti: c000001fe835c000
  NIP: 00003fff9bf2cae0 LR: 00003fff9bee4898 CTR: 00003fff9bf2cae0
  REGS: c000001fe835fea0 TRAP: 0401   Tainted: G      D          (4.0.0-rc5+)
  MSR: 900000014280f032 <SF,HV,VEC,VSX,EE,PR,FP,ME,IR,DR,RI>  CR: 22000028  XER: 00000000
  CFAR: 00003fff9bee4894 SOFTE: 1
   GPR00: 00003fff9bee494c 00003fffe01c2ee0 00003fff9c084410 0000000010020068
   GPR04: 0000000000000000 0000000000000002 0000000000000008 0000000000000001
   GPR08: 0000000000000001 00003fff9c074a30 00003fff9bf2cae0 00003fff9bf2cd70
   GPR12: 0000000052000022 00003fff9c10b700
  NIP [00003fff9bf2cae0] 0x3fff9bf2cae0
  LR [00003fff9bee4898] 0x3fff9bee4898
  Call Trace:
  ---[ end trace 5d3d952b5d4185d4 ]---

  BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:41
  in_atomic(): 1, irqs_disabled(): 0, pid: 10285, name: a.out
  INFO: lockdep is turned off.
  CPU: 43 PID: 10285 Comm: a.out Tainted: G      D         4.0.0-rc5+ #1
  Call Trace:
  [c000001fe835f990] [c00000000089c014] .dump_stack+0x98/0xd4 (unreliable)
  [c000001fe835fa10] [c0000000000e4138] .___might_sleep+0x1d8/0x2e0
  [c000001fe835faa0] [c000000000888da8] .down_read+0x38/0x110
  [c000001fe835fb30] [c0000000000bf2f4] .exit_signals+0x24/0x160
  [c000001fe835fbc0] [c0000000000abde0] .do_exit+0xd0/0xe70
  [c000001fe835fcb0] [c00000000001f4c4] .die+0x304/0x450
  [c000001fe835fd60] [c00000000088e1f4] .do_page_fault+0x2d4/0x900
  [c000001fe835fe30] [c000000000008664] handle_page_fault+0x10/0x30
  note: a.out[10285] exited with preempt_count 1

Reproducer:
  #include <stdio.h>
  #include <unistd.h>
  #include <syscall.h>
  #include <sys/types.h>
  #include <sys/stat.h>
  #include <linux/perf_event.h>
  #include <linux/hw_breakpoint.h>

  static struct perf_event_attr event = {
          .type = PERF_TYPE_RAW,
          .size = sizeof(struct perf_event_attr),
          .sample_type = PERF_SAMPLE_BRANCH_STACK,
          .branch_sample_type = PERF_SAMPLE_BRANCH_ANY_RETURN,
  };

  int main()
  {
          syscall(__NR_perf_event_open, &event, 0, -1, -1, 0);
  }

Signed-off-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/perf/core-book3s.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -1825,8 +1825,10 @@ static int power_pmu_event_init(struct p
 		cpuhw->bhrb_filter = ppmu->bhrb_filter_map(
 					event->attr.branch_sample_type);
 
-		if(cpuhw->bhrb_filter == -1)
+		if (cpuhw->bhrb_filter == -1) {
+			put_cpu_var(cpu_hw_events);
 			return -EOPNOTSUPP;
+		}
 	}
 
 	put_cpu_var(cpu_hw_events);

