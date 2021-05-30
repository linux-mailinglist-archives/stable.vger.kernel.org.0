Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3E2395320
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 00:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhE3WEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 18:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbhE3WEP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 18:04:15 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAD7C061574
        for <stable@vger.kernel.org>; Sun, 30 May 2021 15:02:37 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622412154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MKd6zv7WZScEl5igo0zkykfrQym3iemdXvlO/e8+1rc=;
        b=y4fUj2muU1QyUsqBmXLAYrBvYEbbYfmUYdNwvnBO0tO3tFno4mbFHcDWG2UU9IzWo2dG3l
        kAdL4auapr7ZNcDJPhFq+A4IlZYRbctqd+82DsLswPge0H+2kYvXfz7DUSBxkYxBFooRVQ
        AkZlyAU67tOHI0YwxkV8Xm/3c4JX20vFqCszNi807wWWV8Cp7O1dpjMFrkieosL/tWD2ya
        wUjeHo0CetBf3XgHDXG2WyIGsIjUiNhCRlxgNLew/8BNTscfYfm99/zuf0fwOV5b06APKZ
        6g1+YYADkKZIqmh0LxB7nWa3eDp/Ns+HGHsG3eEuVWqnpRvwSXazZ6LbiOdu2w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622412154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MKd6zv7WZScEl5igo0zkykfrQym3iemdXvlO/e8+1rc=;
        b=4c61nGbX+RfK5f3itS8CrTHXR7liJIvT9uUKXzX5v7u/j82kvDn5jsTmukqK6fgJQzlIA2
        iX9dRZKsMbyKI5CA==
To:     Andy Lutomirski <luto@kernel.org>, x86@kernel.org
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org,
        syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com
Subject: Re: [RFC v2 1/2] x86/fpu: Fix state corruption in __fpu__restore_sig()
In-Reply-To: <b69df1e42d1235996682178013f61d4120b3b361.1622351443.git.luto@kernel.org>
References: <cover.1622351443.git.luto@kernel.org> <b69df1e42d1235996682178013f61d4120b3b361.1622351443.git.luto@kernel.org>
Date:   Mon, 31 May 2021 00:02:33 +0200
Message-ID: <87a6ob6ft2.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Andy,

On Sat, May 29 2021 at 22:12, Andy Lutomirski wrote:
>
> Cc: stable@vger.kernel.org
> Fixes: b860eb8dce59 ("x86/fpu/xstate: Define new functions for clearing fpregs and xstates")
> Reported-by: syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com

Debugged-by ...

> Signed-off-by: Andy Lutomirski <luto@kernel.org>

...

>  /*
> - * Clear the FPU state back to init state.
> - *
> - * Called by sys_execve(), by the signal handler code and by various
> - * error paths.
> + * Reset current's user FPU states to the init states.  The caller promises
> + * that current's supervisor states (in memory or CPU regs as appropriate)
> + * as well as the XSAVE header in memory are intact.
>   */
> -static void fpu__clear(struct fpu *fpu, bool user_only)
> +void fpu__clear_user_states(struct fpu *fpu)
>  {
>  	WARN_ON_FPU(fpu != &current->thread.fpu);
>  
>  	if (!static_cpu_has(X86_FEATURE_FPU)) {
> -		fpu__drop(fpu);
> -		fpu__initialize(fpu);
> +		fpu__clear_all(fpu);
>  		return;
>  	}
>  
>  	fpregs_lock();
>  
> -	if (user_only) {
> -		if (!fpregs_state_valid(fpu, smp_processor_id()) &&
> -		    xfeatures_mask_supervisor())
> -			copy_kernel_to_xregs(&fpu->state.xsave,
> -					     xfeatures_mask_supervisor());
> -		copy_init_fpstate_to_fpregs(xfeatures_mask_user());
> -	} else {
> -		copy_init_fpstate_to_fpregs(xfeatures_mask_all);
> -	}
> +	/*
> +	 * Ensure that current's supervisor states are loaded into
> +	 * their corresponding registers.
> +	 */
> +	if (!fpregs_state_valid(fpu, smp_processor_id()) &&
> +	    xfeatures_mask_supervisor())
> +		copy_kernel_to_xregs(&fpu->state.xsave,
> +				     xfeatures_mask_supervisor());
>  
> +	/*
> +	 * Reset user states in registers.
> +	 */
> +	copy_init_fpstate_to_fpregs(xfeatures_mask_user());
> +
> +	/*
> +	 * Now all FPU registers have their desired values.  Inform the
> +	 * FPU state machine that current's FPU registers are in the
> +	 * hardware registers.
> +	 */
>  	fpregs_mark_activate();
> +
>  	fpregs_unlock();

This is as wrong as before. The corrupted task->fpu.state still
survives.

For f*cks sake, I gave you a reproducer and a working patch and I
explained it in great length what's broken and what needs to be fixed.

And of course you kept the bug which was in the offending commit,
i.e. not wiping the task->fpu.state corruption which causes the next
XRSTOR to fail:

[   34.095020] Bad FPU state detected at copy_kernel_to_fpregs+0x28/0x40, reinitializing FPU registers.
[   34.095052] WARNING: CPU: 0 PID: 1364 at arch/x86/mm/extable.c:65 ex_handler_fprestore+0x5f/0x70
...
[   34.153472]  switch_fpu_return+0x40/0xb0
[   34.154196]  exit_to_user_mode_prepare+0x8f/0x180
[   34.155060]  syscall_exit_to_user_mode+0x23/0x50
[   34.155912]  do_syscall_64+0x4d/0xb0

IOW, this is exactly the same shit as we had before. So what is decent
about this? Define decent...

Why the heck do you think I wasted a couple of days to:

 - Analyze the root cause

 - Destill a trivial C reproducer

 - Come up with a fully working and completely correct fix

Just because, right?

I'm fine with splitting up clear_all() and clear_user(), but what you
provided is as much of a clusterfuck as the commit it pretends to fix.

Your's seriously grumpy

       Thomas
