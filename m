Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69E332297E
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 12:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbhBWL3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 06:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbhBWL3h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 06:29:37 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B92DC061574;
        Tue, 23 Feb 2021 03:28:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0jAXGKPxMIw4NpPHuTLsuiFVbiCmr9mViG5BBKJjnuw=; b=VfLZRreiIw1aK3M14fs1IjsWSW
        ziHle4k1KUsZNqtv23FlrOySa06y3drpyBuCxvN5+5RxPOOVhCIOgZPNs3jW6XOaCYGHLUF0bcax7
        YTEOQ+la/CUpnckkcu7ToozwSJk0SgSCNn1w1pCiUduubJnqysWmZIaDgn2uuhi1fzbir9N5X8RMX
        4xidvj/60SIwnBBEQqUjK6093P8x9XFZ6wfjIopPMIkNLPrnrcbTJ0AumeTalXiv9n1AI/Hjt9teI
        eN9QsQTOkuihnoW2vUwsn0zJT+Bamd/ec4l8zzhxsk68peVuQBu+tdqlLANQKRYGzIBF1d5aRWoK9
        I+Olr4Iw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lEVs1-007tF7-T4; Tue, 23 Feb 2021 11:28:51 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 8334930477A;
        Tue, 23 Feb 2021 12:28:49 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 6A88B2013B7C2; Tue, 23 Feb 2021 12:28:49 +0100 (CET)
Date:   Tue, 23 Feb 2021 12:28:49 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/3] x86/entry: Fix entry/exit mismatch on failed fast
 32-bit syscalls
Message-ID: <YDTm8Q/cvBcfzhPn@hirez.programming.kicks-ass.net>
References: <cover.1614059335.git.luto@kernel.org>
 <a0025117242488a30621fb9858918802532f9ee9.1614059335.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0025117242488a30621fb9858918802532f9ee9.1614059335.git.luto@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 09:50:28PM -0800, Andy Lutomirski wrote:
> On a 32-bit fast syscall that fails to read its arguments from user
> memory, the kernel currently does syscall exit work but not
> syscall exit work.  This would confuse audit and ptrace.
> 
> This is a minimal fix intended for ease of backporting.  A more
> complete cleanup is coming.
> 
> Cc: stable@vger.kernel.org
> Fixes: 0b085e68f407 ("x86/entry: Consolidate 32/64 bit syscall entry")
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
>  arch/x86/entry/common.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
> index 0904f5676e4d..cf4dcf346ca8 100644
> --- a/arch/x86/entry/common.c
> +++ b/arch/x86/entry/common.c
> @@ -128,7 +128,8 @@ static noinstr bool __do_fast_syscall_32(struct pt_regs *regs)
>  		regs->ax = -EFAULT;
>  
>  		instrumentation_end();
> -		syscall_exit_to_user_mode(regs);
> +		local_irq_disable();
> +		exit_to_user_mode();
>  		return false;
>  	}

I'm confused, twice. Once by your Changelog, and second by the actual
patch. Shouldn't every return to userspace pass through
exit_to_user_mode_prepare() ? We shouldn't ignore NEED_RESCHED or
NOTIFY_RESUME, both of which can be set I think, even if the SYSCALL
didn't actually do anything.
