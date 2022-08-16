Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABA6F59575E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 12:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbiHPJ76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 05:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234199AbiHPJ7Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 05:59:24 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494BC7FFA4;
        Tue, 16 Aug 2022 02:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=N3rr8Ih/OydanFv1CV/YUpYdg2xo/RO8uoYUBb7azUE=; b=NeI5iJNKMM5exB1dec5OXgnxuR
        IjrRsj1TQ/c1iNcZdivLGlMbNMXyssN41VvmWeI8YNYt2AfMpXSs1ldnjmoL/hXXGcAwZf6Pj4Sgy
        QvR/TF/nsr9wYQYgSoW2PFLeHhWHEVxK5xQWhiJD3jjysvXRm+NNUbup2wNjDfv2yVlhNTZvGogAq
        yKlKCb7gAeHrxfvs+Qto/Uzjnad3oKmifKdSBvhSV4TP7dHUa+1MmhPkOH7SAdtMfv3pKJjbeTN6f
        1k/fIwntE3/ao9NgFoXj+HuJM5xlV2xaof+6kEv4TKRKF+LSb1Mx685frlfLVJGzhq6f+8HB4bbGn
        IlMHL/ww==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oNsUL-002uhh-D6; Tue, 16 Aug 2022 09:03:55 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8A763980163; Tue, 16 Aug 2022 11:03:52 +0200 (CEST)
Date:   Tue, 16 Aug 2022 11:03:52 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/entry: fix entry_INT80_compat for Xen PV guests
Message-ID: <YvtdeNYtBdSsNqWV@worktop.programming.kicks-ass.net>
References: <20220816071137.4893-1-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816071137.4893-1-jgross@suse.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 09:11:37AM +0200, Juergen Gross wrote:
> Commit c89191ce67ef ("x86/entry: Convert SWAPGS to swapgs and remove
> the definition of SWAPGS") missed one use case of SWAPGS in
> entry_INT80_compat. Removing of the SWAPGS macro led to asm just
> using "swapgs", as it is accepting instructions in capital letters,
> too.
> 
> This in turn leads to splats in Xen PV guests like:
> 
> [   36.145223] general protection fault, maybe for address 0x2d: 0000 [#1] PREEMPT SMP NOPTI
> [   36.145794] CPU: 2 PID: 1847 Comm: ld-linux.so.2 Not tainted 5.19.1-1-default #1 openSUSE Tumbleweed f3b44bfb672cdb9f235aff53b57724eba8b9411b
> [   36.146608] Hardware name: HP ProLiant ML350p Gen8, BIOS P72 11/14/2013
> [   36.148126] RIP: e030:entry_INT80_compat+0x3/0xa3
> 
> Fix that by open coding this single instance of the SWAPGS macro.
> 
> Cc: <stable@vger.kernel.org> # 5.19
> Fixes: c89191ce67ef ("x86/entry: Convert SWAPGS to swapgs and remove the definition of SWAPGS")
> Signed-off-by: Juergen Gross <jgross@suse.com>

It's a little unfortunate int80 is different from the other compat entry
points, but that's life I suppose.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

> ---
>  arch/x86/entry/entry_64_compat.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/entry/entry_64_compat.S b/arch/x86/entry/entry_64_compat.S
> index 682338e7e2a3..4dd19819053a 100644
> --- a/arch/x86/entry/entry_64_compat.S
> +++ b/arch/x86/entry/entry_64_compat.S
> @@ -311,7 +311,7 @@ SYM_CODE_START(entry_INT80_compat)
>  	 * Interrupts are off on entry.
>  	 */
>  	ASM_CLAC			/* Do this early to minimize exposure */
> -	SWAPGS
> +	ALTERNATIVE "swapgs", "", X86_FEATURE_XENPV
>  
>  	/*
>  	 * User tracing code (ptrace or signal handlers) might assume that
> -- 
> 2.35.3
> 
