Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A853228CE
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 11:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhBWKZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 05:25:17 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:51128 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbhBWKZH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 05:25:07 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1614075864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Epderi1QkPwqwKBeAZe/Rq/ZQb3Wr4mU5fqNnb1yVro=;
        b=3STMUkFag5f3fNlRtB0YMOZ/CIaftEN2Fe5hxyoo2c1l3a5zxjknqqlOqeZbXPG2Cly7wV
        PHjU1/sFU5u1MHIK0tDwztutt6q7i+z3oVH9Cd2JQClz0kOkkWd8POkXPOO/xoGZbiDtvm
        egzD1ESpS+S61hj/u4b+HN2mXiTz/hF+pHVieM3MIhBLsFQPqOSEShDW1/sLLkQ2h/jBti
        HRInv1BArMWuONBHRDXXXNIXROt7TcDkwN541E0NDwHYccAVZCvrN/cFWxB6EN0ks2Xae/
        1iZZ8yLdWTg1Z+rWcozXRYlPCevlsyJwTHi0mwO9GbMjVYMWqh6K6o8DmNl5Kw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1614075864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Epderi1QkPwqwKBeAZe/Rq/ZQb3Wr4mU5fqNnb1yVro=;
        b=DDSQnZeYiiFnkeZZ66TOdXougGRMSdp+inqUGiDoxbBZj0e6xZV+t47CSILBrbGih/WPuK
        +xue+glqBtdMS0DA==
To:     Andy Lutomirski <luto@kernel.org>, x86@kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 2/3] x86/entry: Fix entry/exit mismatch on failed fast 32-bit syscalls
In-Reply-To: <a0025117242488a30621fb9858918802532f9ee9.1614059335.git.luto@kernel.org>
References: <cover.1614059335.git.luto@kernel.org> <a0025117242488a30621fb9858918802532f9ee9.1614059335.git.luto@kernel.org>
Date:   Tue, 23 Feb 2021 11:24:24 +0100
Message-ID: <87sg5n5bfr.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22 2021 at 21:50, Andy Lutomirski wrote:
> On a 32-bit fast syscall that fails to read its arguments from user
> memory, the kernel currently does syscall exit work but not
> syscall exit work.

and this sentence does not make any sense.

> This would confuse audit and ptrace.

Would? It does confuse it, right?

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

While I suggested this with tired brain yesterday night, it's not really
correct as it does not go through exit_to_user_mode_prepare() which it
really has to.

Thanks,

        tglx
