Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC098395360
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 01:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbhE3Xnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 19:43:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229677AbhE3Xnc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 30 May 2021 19:43:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37937610C9;
        Sun, 30 May 2021 23:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622418113;
        bh=hKoMFEu7nm4lPHswlxsyqD3nwFMUCvwVQO6cpzQGMBA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=sZ2VbeKrAP4mENBydSUsFCeIjMPjJsTzwR7tFbimJyohkzMBAJvFM32F3ZOLL6uk5
         TvvUUn3ui5KlWNSQHNlddGtCxGQk47L0D5D3q0FMfFeXJ7+RdM2ZMV/BwhPtkZ2d9E
         YK3PE8BKNj7NblRGqxXY57cRUSArM7c1Vywu9sEQmUKIzrfRFbSGEdpSQlG0yyyS3l
         WNYuvOP0tsyydk/RDQR89nWQBr6crwYyntjlrxZUmLE0NBbGnwVI/Xew1NhfdzWIgq
         qJFP3wcEVdVijWuC2XUYVDRd20WK/4IhSxwYwB2LQiap3514ib1MZNpn7grdA4C13w
         +T7KNXBwy3oPA==
Subject: Re: [RFC v2 1/2] x86/fpu: Fix state corruption in
 __fpu__restore_sig()
To:     Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Cc:     Dave Hansen <dave.hansen@intel.com>, stable@vger.kernel.org,
        syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com
References: <cover.1622351443.git.luto@kernel.org>
 <b69df1e42d1235996682178013f61d4120b3b361.1622351443.git.luto@kernel.org>
 <87a6ob6ft2.ffs@nanos.tec.linutronix.de>
From:   Andy Lutomirski <luto@kernel.org>
Message-ID: <27deedb9-1e80-fe62-e072-1cc4904f20d5@kernel.org>
Date:   Sun, 30 May 2021 16:41:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87a6ob6ft2.ffs@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/30/21 3:02 PM, Thomas Gleixner wrote:
> Andy,
> 
> On Sat, May 29 2021 at 22:12, Andy Lutomirski wrote:
>>
>> Cc: stable@vger.kernel.org
>> Fixes: b860eb8dce59 ("x86/fpu/xstate: Define new functions for clearing fpregs and xstates")
>> Reported-by: syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com
> 
> Debugged-by ...
> 
>> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> 
> ...
> 
>>  /*
>> - * Clear the FPU state back to init state.
>> - *
>> - * Called by sys_execve(), by the signal handler code and by various
>> - * error paths.
>> + * Reset current's user FPU states to the init states.  The caller promises
>> + * that current's supervisor states (in memory or CPU regs as appropriate)
>> + * as well as the XSAVE header in memory are intact.

^^^ The caller promises this

>>   */
>> -static void fpu__clear(struct fpu *fpu, bool user_only)
>> +void fpu__clear_user_states(struct fpu *fpu)
>>  {
>>  	WARN_ON_FPU(fpu != &current->thread.fpu);
>>  

...

>> +	/*
>> +	 * Reset user states in registers.
>> +	 */
>> +	copy_init_fpstate_to_fpregs(xfeatures_mask_user());
>> +
>> +	/*
>> +	 * Now all FPU registers have their desired values.  Inform the
>> +	 * FPU state machine that current's FPU registers are in the
>> +	 * hardware registers.
>> +	 */
>>  	fpregs_mark_activate();
>> +
>>  	fpregs_unlock();
> 
> This is as wrong as before. The corrupted task->fpu.state still
> survives.

See above.  This function is not intended to fix the header.

> 
> For f*cks sake, I gave you a reproducer and a working patch and I
> explained it in great length what's broken and what needs to be fixed.

This patch fixes your reproducer and my (to-be-sent) reproducer.  I
tested it on a machine that physically has the XRSTORS instruction but I
disabled it using virt.  Are you still seeing failures with this patch
applied?  I can try to test on a different CPU.

> 
> And of course you kept the bug which was in the offending commit,
> i.e. not wiping the task->fpu.state corruption which causes the next
> XRSTOR to fail:
> 
> [   34.095020] Bad FPU state detected at copy_kernel_to_fpregs+0x28/0x40, reinitializing FPU registers.
> [   34.095052] WARNING: CPU: 0 PID: 1364 at arch/x86/mm/extable.c:65 ex_handler_fprestore+0x5f/0x70
> ...
> [   34.153472]  switch_fpu_return+0x40/0xb0
> [   34.154196]  exit_to_user_mode_prepare+0x8f/0x180
> [   34.155060]  syscall_exit_to_user_mode+0x23/0x50
> [   34.155912]  do_syscall_64+0x4d/0xb0

I don't think that the code path that calls fpu__clear_user_states() is
subject to header corruption.  If it is, then both your patch and my
patch have issues -- trying to fish the supervisor state out of a
corrupt XSTATE buffer is asking for trouble.

> 
> IOW, this is exactly the same shit as we had before. So what is decent
> about this? Define decent...
> 
> Why the heck do you think I wasted a couple of days to:
> 
>  - Analyze the root cause
> 
>  - Destill a trivial C reproducer
> 
>  - Come up with a fully working and completely correct fix
> 
> Just because, right?
> 
> I'm fine with splitting up clear_all() and clear_user(), but what you
> provided is as much of a clusterfuck as the commit it pretends to fix.
> 
> Your's seriously grumpy
> 
>        Thomas
> 

