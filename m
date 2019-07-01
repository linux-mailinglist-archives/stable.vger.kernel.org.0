Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEFB346FFE
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 14:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbfFOMnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 08:43:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726700AbfFOMnO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 Jun 2019 08:43:14 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11DDD2184C;
        Sat, 15 Jun 2019 12:43:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hc81Z-0006de-5P; Sat, 15 Jun 2019 08:43:13 -0400
Message-Id: <20190615124313.055864181@goodmis.org>
User-Agent: quilt/0.65
Date:   Sat, 15 Jun 2019 08:42:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Eiichi Tsukata <devel@etsukata.com>
Subject: [for-linus][PATCH 4/7] tracing/uprobe: Fix NULL pointer dereference in trace_uprobe_create()
References: <20190615124216.188179157@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eiichi Tsukata <devel@etsukata.com>

Just like the case of commit 8b05a3a7503c ("tracing/kprobes: Fix NULL
pointer dereference in trace_kprobe_create()"), writing an incorrectly
formatted string to uprobe_events can trigger NULL pointer dereference.

Reporeducer:

  # echo r > /sys/kernel/debug/tracing/uprobe_events

dmesg:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 8000000079d12067 P4D 8000000079d12067 PUD 7b7ab067 PMD 0
  Oops: 0000 [#1] PREEMPT SMP PTI
  CPU: 0 PID: 1903 Comm: bash Not tainted 5.2.0-rc3+ #15
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-2.fc30 04/01/2014
  RIP: 0010:strchr+0x0/0x30
  Code: c0 eb 0d 84 c9 74 18 48 83 c0 01 48 39 d0 74 0f 0f b6 0c 07 3a 0c 06 74 ea 19 c0 83 c8 01 c3 31 c0 c3 0f 1f 84 00 00 00 00 00 <0f> b6 07 89 f2 40 38 f0 75 0e eb 13 0f b6 47 01 48 83 c
  RSP: 0018:ffffb55fc0403d10 EFLAGS: 00010293

  RAX: ffff993ffb793400 RBX: 0000000000000000 RCX: ffffffffa4852625
  RDX: 0000000000000000 RSI: 000000000000002f RDI: 0000000000000000
  RBP: ffffb55fc0403dd0 R08: ffff993ffb793400 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
  R13: ffff993ff9cc1668 R14: 0000000000000001 R15: 0000000000000000
  FS:  00007f30c5147700(0000) GS:ffff993ffda00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000000 CR3: 000000007b628000 CR4: 00000000000006f0
  Call Trace:
   trace_uprobe_create+0xe6/0xb10
   ? __kmalloc_track_caller+0xe6/0x1c0
   ? __kmalloc+0xf0/0x1d0
   ? trace_uprobe_create+0xb10/0xb10
   create_or_delete_trace_uprobe+0x35/0x90
   ? trace_uprobe_create+0xb10/0xb10
   trace_run_command+0x9c/0xb0
   trace_parse_run_command+0xf9/0x1eb
   ? probes_open+0x80/0x80
   __vfs_write+0x43/0x90
   vfs_write+0x14a/0x2a0
   ksys_write+0xa2/0x170
   do_syscall_64+0x7f/0x200
   entry_SYSCALL_64_after_hwframe+0x49/0xbe

Link: http://lkml.kernel.org/r/20190614074026.8045-1-devel@etsukata.com

Cc: stable@vger.kernel.org
Fixes: 0597c49c69d5 ("tracing/uprobes: Use dyn_event framework for uprobe events")
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Eiichi Tsukata <devel@etsukata.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_uprobe.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index eb7e06b54741..a88c692e3b8a 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -443,10 +443,17 @@ static int trace_uprobe_create(int argc, const char **argv)
 	ret = 0;
 	ref_ctr_offset = 0;
 
-	/* argc must be >= 1 */
-	if (argv[0][0] == 'r')
+	switch (argv[0][0]) {
+	case 'r':
 		is_return = true;
-	else if (argv[0][0] != 'p' || argc < 2)
+		break;
+	case 'p':
+		break;
+	default:
+		return -ECANCELED;
+	}
+
+	if (argc < 2)
 		return -ECANCELED;
 
 	if (argv[0][1] == ':')
-- 
2.20.1


