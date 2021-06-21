Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F323AF544
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 20:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhFUSoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 14:44:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:38452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231194AbhFUSoQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 14:44:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8BE260FF1;
        Mon, 21 Jun 2021 18:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624300922;
        bh=u1hkaHhINKZ8Vpvi/ri0BwgYIF+3BcBhkkskryx2Yt4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=j/+ZnqYBf48aM57aLoudYI3SHrxa7Vodj8uOZNpNnVkC0XbVukISdAxRSJD0QuYuE
         D0ekP/i1AlvysoJx0g+oVkq+4fr5lx46lZYrz5uHQn5Lc/MabVRWuw07HX1W+3DB6w
         LxSPkQpTZ7qv/PHA57sLB8SDHzPvXbRW62H5S36Y3P004B0p8606mcy7ZWkrOxUDG6
         WoTkKiWZ9cvms25ocH857V/tuim91xdo5aAs3RyO09W8oK5wx+J8nasuEvdttMlYzN
         P7NERq0IIVPpgCi/TudV4lQsZqXoqgck0RKpivEonjC22WoblOmGdwBfviScuwhi5/
         ZAPRl0WYGK2Og==
Subject: Re: FAILED: patch "[PATCH] x86/fpu: Invalidate FPU state after a
 failed XRSTOR from a" failed to apply to 5.4-stable tree
To:     Borislav Petkov <bp@suse.de>, gregkh@linuxfoundation.org
Cc:     dave.hansen@linux.intel.com, riel@surriel.com, tglx@linutronix.de,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <162427270623162@kroah.com> <YNCiQRPD9iox9g/v@zn.tnic>
From:   Andy Lutomirski <luto@kernel.org>
Message-ID: <5c9dc791-f34e-e26e-9d34-7f5280d3990f@kernel.org>
Date:   Mon, 21 Jun 2021 11:42:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YNCiQRPD9iox9g/v@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/21/21 7:29 AM, Borislav Petkov wrote:
> On Mon, Jun 21, 2021 at 12:51:46PM +0200, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 5.4-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>>
>> thanks,
>>
>> greg k-h
>>
>> ------------------ original commit in Linus's tree ------------------
>>
>> From d8778e393afa421f1f117471144f8ce6deb6953a Mon Sep 17 00:00:00 2001
>> From: Andy Lutomirski <luto@kernel.org>
>> Date: Tue, 8 Jun 2021 16:36:19 +0200
>> Subject: [PATCH] x86/fpu: Invalidate FPU state after a failed XRSTOR from a
>>  user buffer
>>
>> Both Intel and AMD consider it to be architecturally valid for XRSTOR to
>> fail with #PF but nonetheless change the register state.  The actual
>> conditions under which this might occur are unclear [1], but it seems
>> plausible that this might be triggered if one sibling thread unmaps a page
>> and invalidates the shared TLB while another sibling thread is executing
>> XRSTOR on the page in question.
>>
>> __fpu__restore_sig() can execute XRSTOR while the hardware registers
>> are preserved on behalf of a different victim task (using the
>> fpu_fpregs_owner_ctx mechanism), and, in theory, XRSTOR could fail but
>> modify the registers.
>>
>> If this happens, then there is a window in which __fpu__restore_sig()
>> could schedule out and the victim task could schedule back in without
>> reloading its own FPU registers. This would result in part of the FPU
>> state that __fpu__restore_sig() was attempting to load leaking into the
>> victim task's user-visible state.
>>
>> Invalidate preserved FPU registers on XRSTOR failure to prevent this
>> situation from corrupting any state.
>>
>> [1] Frequent readers of the errata lists might imagine "complex
>>     microarchitectural conditions".
>>
>> Fixes: 1d731e731c4c ("x86/fpu: Add a fastpath to __fpu__restore_sig()")
>> Signed-off-by: Andy Lutomirski <luto@kernel.org>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> Signed-off-by: Borislav Petkov <bp@suse.de>
>> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
>> Acked-by: Rik van Riel <riel@surriel.com>
>> Cc: stable@vger.kernel.org
>> Link: https://lkml.kernel.org/r/20210608144345.758116583@linutronix.de
>>
>> diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
>> index d5bc96a536c2..4ab9aeb9a963 100644
>> --- a/arch/x86/kernel/fpu/signal.c
>> +++ b/arch/x86/kernel/fpu/signal.c
>> @@ -369,6 +369,25 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
>>  			fpregs_unlock();
>>  			return 0;
>>  		}
>> +
>> +		/*
>> +		 * The above did an FPU restore operation, restricted to
>> +		 * the user portion of the registers, and failed, but the
>> +		 * microcode might have modified the FPU registers
>> +		 * nevertheless.
>> +		 *
>> +		 * If the FPU registers do not belong to current, then
>> +		 * invalidate the FPU register state otherwise the task might
>> +		 * preempt current and return to user space with corrupted
>> +		 * FPU registers.
>> +		 *
>> +		 * In case current owns the FPU registers then no further
>> +		 * action is required. The fixup below will handle it
>> +		 * correctly.
>> +		 */
>> +		if (test_thread_flag(TIF_NEED_FPU_LOAD))
>> +			__cpu_invalidate_fpregs_state();
>> +
>>  		fpregs_unlock();
>>  	} else {
> 
> So I'm looking at this and 5.4.127 has:
> 
>                 if (!ret) {
>                         fpregs_mark_activate();
>                         fpregs_unlock();
>                         return 0;
>                 }
>                 fpregs_deactivate(fpu);		<---
>                 fpregs_unlock();
> 
> i.e., an unconditional fpu invalidation there. Which got removed by:
> 
> 98265c17efa9 ("x86/fpu/xstate: Preserve supervisor states for the slow path in __fpu__restore_sig()")
> 
> in 5.7.
> 
> so that Fixes: commit above which points to a 5.1 kernel is probably wrong-ish.
> 
> amluto?
> 

I agree.  The fixes line is indeed wrong, and the (horribly misnamed)
fpu_deactivate() call did the right thing.
