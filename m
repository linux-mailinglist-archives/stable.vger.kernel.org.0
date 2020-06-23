Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB2A205680
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 17:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732957AbgFWP7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 11:59:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731616AbgFWP7G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 11:59:06 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 665982073E;
        Tue, 23 Jun 2020 15:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592927945;
        bh=x+7UD1OgiiJsxoi7UkFb+a3YArvi+7IwVdYJ2e1iMT8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XOwyqgz/FnnO4oLI1Q5EYP2/80wMh1et7dtpvBFFg6zYQ2x/BR2aPnaoqoyueMvmj
         R+1hQIFvCu9c0mzUPw/gX+QNGNVIFKfrWgaeXwyK4f8iarS16ht/5LAcuRe+0i7F1A
         sv2+7KvSP6xChkI19pd5i5vlWhzeiddti1iAvh5s=
Date:   Tue, 23 Jun 2020 16:59:01 +0100
From:   Will Deacon <will@kernel.org>
To:     Paul Gortmaker <paul.gortmaker@windriver.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>, mark.rutland@arm.com
Subject: Re: [PATCH] arm64: don't preempt_disable in do_debug_exception
Message-ID: <20200623155900.GA4777@willie-the-truck>
References: <1592501369-27645-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1592501369-27645-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 18, 2020 at 01:29:29PM -0400, Paul Gortmaker wrote:
> In commit d8bb6718c4db ("arm64: Make debug exception handlers visible
> from RCU") debug_exception_enter and exit were added to deal with better
> tracking of RCU state - however, in addition to that, but not mentioned
> in the commit log, a preempt_disable/enable pair were also added.
> 
> Based on the comment (being removed here) it would seem that the pair
> were not added to address a specific problem, but just as a proactive,
> preventative measure - as in "seemed like a good idea at the time".
> 
> The problem is that do_debug_exception() eventually calls out to
> generic kernel code like do_force_sig_info() which takes non-raw locks
> and on -rt enabled kernels, results in things looking like the following,
> since on -rt kernels, it is noticed that preemption is still disabled.
> 
>  BUG: sleeping function called from invalid context at kernel/locking/rtmutex.c:975
>  in_atomic(): 1, irqs_disabled(): 0, pid: 35658, name: gdbtest
>  Preemption disabled at:
>  [<ffff000010081578>] do_debug_exception+0x38/0x1a4
>  Call trace:
>  dump_backtrace+0x0/0x138
>  show_stack+0x24/0x30
>  dump_stack+0x94/0xbc
>  ___might_sleep+0x13c/0x168
>  rt_spin_lock+0x40/0x80
>  do_force_sig_info+0x30/0xe0
>  force_sig_fault+0x64/0x90
>  arm64_force_sig_fault+0x50/0x80
>  send_user_sigtrap+0x50/0x80
>  brk_handler+0x98/0xc8
>  do_debug_exception+0x70/0x1a4
>  el0_dbg+0x18/0x20
> 
> The reproducer was basically an automated gdb test that set a breakpoint
> on a simple "hello world" program and then quit gdb once the breakpoint
> was hit - i.e. "(gdb) A debugging session is active.  Quit anyway? "

Hmm, the debug exception handler path was definitely written with the
expectation that preemption is disabled, so this is unfortunate. For
exceptions from kernelspace, we need to keep that guarantee as we implement
things like BUG() using this path. For exceptions from userspace, it's
plausible that we could re-enable preemption, but then we should also
re-enable interrupts and debug exceptions too because we don't
context-switch pstate in switch_to() and we would end up with holes in our
kernel debug coverage (and these might be fatal if e.g. single step doesn't
work in a kprobe OOL buffer). However, that then means that any common code
when handling user and kernel debug exceptions needs to be re-entrant,
which it probably isn't at the moment (I haven't checked).

So although I'm alright with this idea for user debug exceptions, I think
it needs more work.

Will
