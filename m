Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42174890D7
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239592AbiAJH0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:26:17 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35512 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239397AbiAJHZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:25:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 011A8611B6;
        Mon, 10 Jan 2022 07:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9ACAC36AED;
        Mon, 10 Jan 2022 07:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799512;
        bh=HoqZXLDcG04ouLzunelHoKLB46IbJ9W5ooL+4DphyIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zW3+XIbuUJzICTt8MwQbEDJRXayaJ2IrIHRBd7AI3ia3YIxdlD3pXLtKS0pBGXAG9
         +9n/XDiTPrX6wz7szrd1VQ2ln2eLNZE0wJ5UbDN9qsvpDWDKQtWLaBRiVLD7ODuZsE
         /Rd+QV179U0LA2k+B8s5f/OTeqyEN+9FvNlw7I5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 4.9 02/21] tracing: Fix check for trace_percpu_buffer validity in get_trace_buf()
Date:   Mon, 10 Jan 2022 08:22:49 +0100
Message-Id: <20220110071812.889168188@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071812.806606886@linuxfoundation.org>
References: <20220110071812.806606886@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

commit 823e670f7ed616d0ce993075c8afe0217885f79d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2364,7 +2364,7 @@ static char *get_trace_buf(void)
 {
 	struct trace_buffer_struct *buffer = this_cpu_ptr(trace_percpu_buffer);
 
-	if (!buffer || buffer->nesting >= 4)
+	if (!trace_percpu_buffer || buffer->nesting >= 4)
 		return NULL;
 
 	buffer->nesting++;


