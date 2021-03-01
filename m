Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42CB33282A3
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 16:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237315AbhCAPhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 10:37:41 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:59960 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237243AbhCAPhd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 10:37:33 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1614613001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qKx7JwT/dd3v06LiZPRPHxdr3Mvak0GPNra5VoMoP1o=;
        b=nK+Ok5k0MzH/QI6D7htimuCzXA0alrKJWT8+Do3p+0XYuoyqfczSMozW3q7pxLrvoqEoQG
        oPMTvaQ335ix5FKGXv++7rUZ4aVJ6F7VMOnGN4yrMZzl2f1FpgrAeIWHr6p9NlZRkTny3C
        mfyauLVxT+Q3OgBC3zcg7KjMex2oaw3NzCRrusUY0dx1/IqU7V4MsxRLGZV5kWXk9MlrMV
        wEHyxfGS9F24lyJG44eWDWkGw/UUKuuSK4YEEkprmtMx8L6sOyW5Sou/QG0jpLUUuRwAcJ
        RtksL22s2Aoghop2gfxmOKrLD+2+HdorpWpCy3XJ8Hdm4/73xtrFZPMIIKRAJw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1614613001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qKx7JwT/dd3v06LiZPRPHxdr3Mvak0GPNra5VoMoP1o=;
        b=gygiVZKWsDAhRTr3SxO2Ecx5unMNBPIV7lNOYhJIMVyr4SRI5yLWsQlhx0G1nESn4BdQC1
        xdWjjxdFYk354aCg==
To:     Andy Lutomirski <luto@kernel.org>, x86@kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/3] x86/entry: Fix entry/exit mismatch on failed fast 32-bit syscalls
In-Reply-To: <04713c6be5ab45357e3406c42d382536f52a64c6.1614104065.git.luto@kernel.org>
References: <cover.1614104065.git.luto@kernel.org> <04713c6be5ab45357e3406c42d382536f52a64c6.1614104065.git.luto@kernel.org>
Date:   Mon, 01 Mar 2021 16:36:40 +0100
Message-ID: <87h7luubqv.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 23 2021 at 10:15, Andy Lutomirski wrote:
> On a 32-bit fast syscall that fails to read its arguments from user
> memory, the kernel currently does syscall exit work but not
> syscall entry work.  This confuses audit and ptrace.  For example:
>
>     $ ./tools/testing/selftests/x86/syscall_arg_fault_32
>     ...
>     strace: pid 264258: entering, ptrace_syscall_info.op == 2
>     ...
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

That's still the same as the previous version. The right function (while
the name is misleading) to invoke here is irqentry_exit_to_user_mode()
because that invokes exit_to_user_mode_prepare() before
exit_to_user_mode(). We can rename that function afterwards.

Thanks,

        tglx
