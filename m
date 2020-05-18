Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA7A1D726C
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 10:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbgERIBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 04:01:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56012 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgERIBa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 04:01:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aDKxDJZ/qZ1vmOI+jxTFnYHJknWNLi0bRyCoqCFOLwM=; b=rxcFsOE+JyNoqI/GUYEUadKR+0
        zhiJXye7AAB9w6UlXrNyVTptUwJDHPP5EvlB3aMqbUhc+K06Zlp+56BSBLjrWXmhFlRm4ffkgLYZc
        OfszTqFFSU4WbGkiH32YiWSK67LcnuXD5+G+lAM0PKth56wEG7gmMdKJIqgFa4fzvTwFmY60zaYw1
        eLx30A+GyyFobB4qlI9tlBzZybi76CXrDJ8KbMuBA8lBHHFt+oJKNNXhaxaEwljBCm08xwlm7tt78
        0RTotjBEAGezhYi65jopDbFDcT3sOhikZC04vRy68PxKwbFmSM8/CiPmE0/PN2pr6EiTjbMMjtI6H
        1LylQvgw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jaadE-0003JR-86; Mon, 18 May 2020 07:56:16 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id DD5DC3011E8;
        Mon, 18 May 2020 09:56:07 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C5E152B3CDC70; Mon, 18 May 2020 09:56:07 +0200 (CEST)
Date:   Mon, 18 May 2020 09:56:07 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Borislav Petkov <bp@alien8.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: Re: [for-linus][PATCH 1/3] x86/ftrace: Have ftrace trampolines turn
 read-only at the end of system boot up
Message-ID: <20200518075607.GH2940@hirez.programming.kicks-ass.net>
References: <20200514125817.850882486@goodmis.org>
 <20200514125842.392454557@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514125842.392454557@goodmis.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 14, 2020 at 08:58:18AM -0400, Steven Rostedt wrote:
> +			start_offset = (unsigned long)ftrace_caller;
> +			end_offset = (unsigned long)ftrace_epilogue;


---
Subject: x86/ftrace: Fix compile error

When building x86-64 kernels, my compiler is sad about a missing symbol.

Fixes: 59566b0b622e ("x86/ftrace: Have ftrace trampolines turn read-only at the end of system boot up")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/kernel/ftrace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index f8917a6f25b7..1cf7d69402e2 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -286,6 +286,7 @@ extern void ftrace_regs_caller_ret(void);
 extern void ftrace_caller_end(void);
 extern void ftrace_caller_op_ptr(void);
 extern void ftrace_regs_caller_op_ptr(void);
+extern void ftrace_epilogue(void);
 
 /* movq function_trace_op(%rip), %rdx */
 /* 0x48 0x8b 0x15 <offset-to-ftrace_trace_op (4 bytes)> */
