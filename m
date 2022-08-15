Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19E25592A95
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 10:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbiHOH3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 03:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiHOH3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 03:29:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8C51834D;
        Mon, 15 Aug 2022 00:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WLetqZztJRGpEs+QGrVdxJPRivEZitIYqQS4z+3w0us=; b=Z1LAkm9Z/Jk1kEPqfMnOx2pfGs
        AnaD2SHDCwOs0LXfFbNIFQrNP2QO02HSNSWUIqBeUevxDPjX0ygn/rbmIi86BZWpaYoq5jLyLRt7m
        Nm6vombiB3LD1gMSc+w+AWOtOKWAIljTD2uDfOXWakmdC5EpWeDRa6TFjtLUsVvRaul5x8X+gqsUP
        V8yvn0ln24bpfiHr2fRGGkl6JkvDjlaK4eyr14cB1EHHpMg+Xg/HvrMpRK7svhXehIRiLVmkPXgCL
        ZjQdKAHVoe+b1HJflXz0EL4Px9xAnn0zlhe2kFk9JG/l8NEBGC1jszeB9hs4hnTbBKkCL1b8adgql
        LgYQqHDw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oNUXK-005WG8-Jj; Mon, 15 Aug 2022 07:29:22 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id D4BC4980264; Mon, 15 Aug 2022 09:29:20 +0200 (CEST)
Date:   Mon, 15 Aug 2022 09:29:20 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/kprobes: fix JNG/JNLE emulation
Message-ID: <Yvn10AjTCHM+ua9E@worktop.programming.kicks-ass.net>
References: <20220813225943.143767-1-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220813225943.143767-1-namit@vmware.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 13, 2022 at 03:59:43PM -0700, Nadav Amit wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> When kprobes emulates JNG/JNLE instructions on x86 it uses the wrong
> condition. For JNG (opcode: 0F 8E), according to Intel SDM, the jump is
> performed if (ZF == 1 or SF != OF). However the kernel emulation
> currently uses 'and' instead of 'or'.
> 
> As a result, setting a kprobe on JNG/JNLE might cause the kernel to
> behave incorrectly whenever the kprobe is hit.
> 
> Fix by changing the 'and' to 'or'.
> 
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: stable@vger.kernel.org
> Fixes: 6256e668b7af ("x86/kprobes: Use int3 instead of debug trap for single-step")
> Signed-off-by: Nadav Amit <namit@vmware.com>

Urgghh..

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

> ---
>  arch/x86/kernel/kprobes/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
> index 74167dc5f55e..4c3c27b6aea3 100644
> --- a/arch/x86/kernel/kprobes/core.c
> +++ b/arch/x86/kernel/kprobes/core.c
> @@ -505,7 +505,7 @@ static void kprobe_emulate_jcc(struct kprobe *p, struct pt_regs *regs)
>  		match = ((regs->flags & X86_EFLAGS_SF) >> X86_EFLAGS_SF_BIT) ^
>  			((regs->flags & X86_EFLAGS_OF) >> X86_EFLAGS_OF_BIT);
>  		if (p->ainsn.jcc.type >= 0xe)
> -			match = match && (regs->flags & X86_EFLAGS_ZF);
> +			match = match || (regs->flags & X86_EFLAGS_ZF);
>  	}
>  	__kprobe_emulate_jmp(p, regs, (match && !invert) || (!match && invert));
>  }
> -- 
> 2.25.1
> 
