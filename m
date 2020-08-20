Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A87824B946
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730715AbgHTLlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:41:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729221AbgHTKEd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:04:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14FD222B43;
        Thu, 20 Aug 2020 10:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917872;
        bh=WJ9ZT0O1YGpSVm1T84ZpeJOMhTdeLBMnwR3HruRUL44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KujQB+GuGP784lCVglgrSR/1ctau+tAqB+zTNHrnzAgvDNwoRQHMo/oA8qpd+iJKE
         YMYkmdtJjOSodsmR5dGBR6yIezbi72PxGJM3lOCJBtwZCGTUc6g9p0Hr+aXJY/0M/b
         Y1TwV1jZhfBem88CdDHwbAqEb9cl9xXnjdS13W7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Chengming Zhou <zhouchengming@bytedance.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.9 187/212] kprobes: Fix NULL pointer dereference at kprobe_ftrace_handler
Date:   Thu, 20 Aug 2020 11:22:40 +0200
Message-Id: <20200820091611.833577167@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

commit 0cb2f1372baa60af8456388a574af6133edd7d80 upstream.

We found a case of kernel panic on our server. The stack trace is as
follows(omit some irrelevant information):

  BUG: kernel NULL pointer dereference, address: 0000000000000080
  RIP: 0010:kprobe_ftrace_handler+0x5e/0xe0
  RSP: 0018:ffffb512c6550998 EFLAGS: 00010282
  RAX: 0000000000000000 RBX: ffff8e9d16eea018 RCX: 0000000000000000
  RDX: ffffffffbe1179c0 RSI: ffffffffc0535564 RDI: ffffffffc0534ec0
  RBP: ffffffffc0534ec1 R08: ffff8e9d1bbb0f00 R09: 0000000000000004
  R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
  R13: ffff8e9d1f797060 R14: 000000000000bacc R15: ffff8e9ce13eca00
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000080 CR3: 00000008453d0005 CR4: 00000000003606e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   <IRQ>
   ftrace_ops_assist_func+0x56/0xe0
   ftrace_call+0x5/0x34
   tcpa_statistic_send+0x5/0x130 [ttcp_engine]

The tcpa_statistic_send is the function being kprobed. After analysis,
the root cause is that the fourth parameter regs of kprobe_ftrace_handler
is NULL. Why regs is NULL? We use the crash tool to analyze the kdump.

  crash> dis tcpa_statistic_send -r
         <tcpa_statistic_send>: callq 0xffffffffbd8018c0 <ftrace_caller>

The tcpa_statistic_send calls ftrace_caller instead of ftrace_regs_caller.
So it is reasonable that the fourth parameter regs of kprobe_ftrace_handler
is NULL. In theory, we should call the ftrace_regs_caller instead of the
ftrace_caller. After in-depth analysis, we found a reproducible path.

  Writing a simple kernel module which starts a periodic timer. The
  timer's handler is named 'kprobe_test_timer_handler'. The module
  name is kprobe_test.ko.

  1) insmod kprobe_test.ko
  2) bpftrace -e 'kretprobe:kprobe_test_timer_handler {}'
  3) echo 0 > /proc/sys/kernel/ftrace_enabled
  4) rmmod kprobe_test
  5) stop step 2) kprobe
  6) insmod kprobe_test.ko
  7) bpftrace -e 'kretprobe:kprobe_test_timer_handler {}'

We mark the kprobe as GONE but not disarm the kprobe in the step 4).
The step 5) also do not disarm the kprobe when unregister kprobe. So
we do not remove the ip from the filter. In this case, when the module
loads again in the step 6), we will replace the code to ftrace_caller
via the ftrace_module_enable(). When we register kprobe again, we will
not replace ftrace_caller to ftrace_regs_caller because the ftrace is
disabled in the step 3). So the step 7) will trigger kernel panic. Fix
this problem by disarming the kprobe when the module is going away.

Link: https://lkml.kernel.org/r/20200728064536.24405-1-songmuchun@bytedance.com

Cc: stable@vger.kernel.org
Fixes: ae6aa16fdc16 ("kprobes: introduce ftrace based optimization")
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/kprobes.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2029,6 +2029,13 @@ static void kill_kprobe(struct kprobe *p
 	 * the original probed function (which will be freed soon) any more.
 	 */
 	arch_remove_kprobe(p);
+
+	/*
+	 * The module is going away. We should disarm the kprobe which
+	 * is using ftrace.
+	 */
+	if (kprobe_ftrace(p))
+		disarm_kprobe_ftrace(p);
 }
 
 /* Disable one kprobe */


