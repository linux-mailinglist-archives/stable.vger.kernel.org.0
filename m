Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1107E397CA3
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 00:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235119AbhFAWqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 18:46:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235080AbhFAWqa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Jun 2021 18:46:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2090B61159;
        Tue,  1 Jun 2021 22:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622587488;
        bh=5YWIoR/62ZiC9vpjF23LwbbgopCgG7MqnaA+B88qxMo=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=hjeQTgPNQ2ZanDBGw0G213Y7P3nWdzFAFzf7x8g3rYAHu8vmOo7q0StJ49mvyTrG2
         7zwlfiZNSOd4s0NsUhYonKVExJs2+xvApTIVRT1LzrBoPhQ8GMcy7XmAZDRVIoY3HB
         axppEUz82kXdFxtdL+ZKHcA5W1T2837EvqBm3bw46YVmyMo9fNccMlq2eaB259vjiw
         6kJOp6EB4h5HbMNojFiTEW+JWgSo/oU26+XSeeMby0k1vjPeYA8j4X/4bej/nlwrkC
         7QfqtDk2KwstoSp3phsNbBSmO/qh0hffI3zGIvyAf3YF2TxOzWLcXJnYeZBrFyi/h+
         rDXYmpT/Hxk0w==
Subject: Re: [PATCH v3 3/5] x86/fpu: Clean up the fpu__clear() variants
To:     Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>
Cc:     stable@vger.kernel.org,
        syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com
References: <878s3u34iy.ffs@nanos.tec.linutronix.de>
 <603011b5-9479-3aac-78ee-74b9b5a5ef7c@kernel.org>
 <aef37213-8bf1-ff89-9b41-417dcdfbe713@intel.com>
 <f3448b39-ebd5-42a7-ac01-7fdf84bacbe9@www.fastmail.com>
 <eb91d5a2-879f-a5c5-8f0d-c10f84536667@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Message-ID: <2669d4ff-ae0f-b9d7-9a34-31bc32a75721@kernel.org>
Date:   Tue, 1 Jun 2021 15:44:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <eb91d5a2-879f-a5c5-8f0d-c10f84536667@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/1/21 11:35 AM, Dave Hansen wrote:
> On 6/1/21 11:14 AM, Andy Lutomirski wrote:
>>> Nit: Could we move the detailed comments about TIF_NEED_FPU_LOAD
>>> right next to the fpu__initialize() call?  It would make it
>>> painfully obvious which call is responsible.  The naming isn't
>>> super helpful here.
>>>
>> Hmm. I was actually thinking of open-coding it all.
>> fpu__initialize() and fpu__drop() have very few callers, and I’m not
>> even convinced that the other callers are calling them for a valid
>> reason.
> 
> Fine by me.  We all know what the TIF flag does, but its connection to
> this code is totally opaque.  It's a place where removing the
> abstraction might actually make sense.
> 

After mulling this over for a while, I think the TIF flag's existence is
fine, but the APIs are all awful.  I think we should give the states in
the little FPU state machine explicit names:

ACTIVE: If the current CPU's FPU regs are ACTIVE, then those regs are
the current task's registers and current->fpu does not necessarily
contain the current task's registers.  (This is !TIF_NEED_FPU_LOAD.)

INACTIVE: If the current CPU's FPU regs are INACTIVE, then those regs
belong to the kernel and do not belong to any particular task.  The
current task's FPU registers are in current->fpu.

PRESERVED: If the current CPU's FPU regs are PRESERVED for a given task,
then they are guaranteed to match that task's task->fpu.  It is possible
to tell whether a given task's FPU regs are PRESERVED on a given CPU,
but it is not possible to tell whether a given CPU's regs are PRESERVED
or INACTIVE, as it is possible that fpu_fpregs_owner_ctx points to
memory that has been reused for a different purpose, so dereferencing
->last_fpu is not safe.


If a non-current task is running, then its FPU state may not be accessed
(obviously).  Similarly, in interrupt context, neither FPU regs nor
current->fpu may be accessed, as interrupts can nest inside
fpregs_lock()ed regions and the state may be indeterminate.

If a non-current task is *stopped*, then its FPU registers may be read.
If its FPU registers are invalidated, then they may also be written.
fpu__prepare_read() and fpu__prepare_write() may be used for these
purposes.  (But fpu__prepare_read() should be rewritten.  It currently
copies the regs to memory but leaves the state ACTIVE, which is just
silly, especially the absurd way it manages the FSAVE clobber
workaround.  It should just do switch_fpu_prepare().)



And we add some APIs that have locking assertions:

fpu__current_regs_active(): returns true if the current task's regs are
ACTIVE.  This replaces most checks for TIF_NEED_FPU_LOAD.  Asserts
!preemptible().

and more to come, but not today.
