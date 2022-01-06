Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431F3486667
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 16:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240242AbiAFPAE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 10:00:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240274AbiAFPAE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 10:00:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1A7C061201;
        Thu,  6 Jan 2022 07:00:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B223B8222B;
        Thu,  6 Jan 2022 15:00:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36792C36AF4;
        Thu,  6 Jan 2022 15:00:01 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1n5UFE-000sMR-BB;
        Thu, 06 Jan 2022 10:00:00 -0500
Message-ID: <20220106150000.180196154@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 06 Jan 2022 09:57:18 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: [for-linus][PATCH 2/3] tracing: Fix check for trace_percpu_buffer validity in
 get_trace_buf()
References: <20220106145716.663267282@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>

With the new osnoise tracer, we are seeing the below splat:
    Kernel attempted to read user page (c7d880000) - exploit attempt? (uid: 0)
    BUG: Unable to handle kernel data access on read at 0xc7d880000
    Faulting instruction address: 0xc0000000002ffa10
    Oops: Kernel access of bad area, sig: 11 [#1]
    LE PAGE_SIZE=64K MMU=Radix SMP NR_CPUS=2048 NUMA pSeries
    ...
    NIP [c0000000002ffa10] __trace_array_vprintk.part.0+0x70/0x2f0
    LR [c0000000002ff9fc] __trace_array_vprintk.part.0+0x5c/0x2f0
    Call Trace:
    [c0000008bdd73b80] [c0000000001c49cc] put_prev_task_fair+0x3c/0x60 (unreliable)
    [c0000008bdd73be0] [c000000000301430] trace_array_printk_buf+0x70/0x90
    [c0000008bdd73c00] [c0000000003178b0] trace_sched_switch_callback+0x250/0x290
    [c0000008bdd73c90] [c000000000e70d60] __schedule+0x410/0x710
    [c0000008bdd73d40] [c000000000e710c0] schedule+0x60/0x130
    [c0000008bdd73d70] [c000000000030614] interrupt_exit_user_prepare_main+0x264/0x270
    [c0000008bdd73de0] [c000000000030a70] syscall_exit_prepare+0x150/0x180
    [c0000008bdd73e10] [c00000000000c174] system_call_vectored_common+0xf4/0x278

osnoise tracer on ppc64le is triggering osnoise_taint() for negative
duration in get_int_safe_duration() called from
trace_sched_switch_callback()->thread_exit().

The problem though is that the check for a valid trace_percpu_buffer is
incorrect in get_trace_buf(). The check is being done after calculating
the pointer for the current cpu, rather than on the main percpu pointer.
Fix the check to be against trace_percpu_buffer.

Link: https://lkml.kernel.org/r/a920e4272e0b0635cf20c444707cbce1b2c8973d.1640255304.git.naveen.n.rao@linux.vnet.ibm.com

Cc: stable@vger.kernel.org
Fixes: e2ace001176dc9 ("tracing: Choose static tp_printk buffer by explicit nesting count")
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 88de94da596b..e1f55851e53f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3217,7 +3217,7 @@ static char *get_trace_buf(void)
 {
 	struct trace_buffer_struct *buffer = this_cpu_ptr(trace_percpu_buffer);
 
-	if (!buffer || buffer->nesting >= 4)
+	if (!trace_percpu_buffer || buffer->nesting >= 4)
 		return NULL;
 
 	buffer->nesting++;
-- 
2.33.0
