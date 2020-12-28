Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9BCD2E6BF3
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 00:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730528AbgL1Wzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 17:55:49 -0500
Received: from mail.efficios.com ([167.114.26.124]:52552 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729425AbgL1UdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 15:33:19 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 24A90275DE1;
        Mon, 28 Dec 2020 15:32:37 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id jW0t28t_x-DE; Mon, 28 Dec 2020 15:32:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 7BEC1275EB9;
        Mon, 28 Dec 2020 15:32:36 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 7BEC1275EB9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1609187556;
        bh=AKY5Enr3DlUeN+b9dnxNzb7PN699ojwjquviv9CqJRI=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=T0zhQM6Ke4mxofKZimPJWDRHtnizyFX8oRLDkBCW9wtYMMP9yFiyskEM0di0EVLkb
         6zCF0bjsxhXwFJNvepOSQV98Mn2EpzYtz/mJrhvZHFWRTOttKVohBEvc32jQf7nz/j
         WVktAsDGPgUoAx0KIYFsIqNVDcX/7s9G/dHxlkVUU+fjmS2YiZA9M6r4wADXZmJV7/
         IdS8TPQwbZlfRUYN2peKZTMFH2boyO8tktYbazqKngGOHjl0Bz+RA+TG+mSLE7CCFD
         BYrGS9RLzho7ssoPJS75F7/79nZP6itxFY9e7caVEQApNi1mbhkG7MtLQgR3Up71vB
         l05ZSkBjeEz9A==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id i8O4-r9lLZyl; Mon, 28 Dec 2020 15:32:36 -0500 (EST)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 5214F275F9F;
        Mon, 28 Dec 2020 15:32:36 -0500 (EST)
Date:   Mon, 28 Dec 2020 15:32:36 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Andy Lutomirski <luto@kernel.org>, paulmck <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     "Russell King, ARM Linux" <linux@armlinux.org.uk>,
        Jann Horn <jannh@google.com>, Will Deacon <will@kernel.org>,
        x86 <x86@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        stable <stable@vger.kernel.org>
Message-ID: <1086654515.3607.1609187556216.JavaMail.zimbra@efficios.com>
In-Reply-To: <CALCETrVpvrBufrJgXNY=ogtZQLo7zgxQmD7k9eVCFjcdcvarmA@mail.gmail.com>
References: <bf59ecb5487171a852bcc8cdd553ec797aedc485.1609093476.git.luto@kernel.org> <1836294649.3345.1609100294833.JavaMail.zimbra@efficios.com> <CALCETrVdcn2r2Jvd1=-bM=FQ8KbX4aH-v4ytdojL7r7Nb6k8YQ@mail.gmail.com> <20201228102537.GG1551@shell.armlinux.org.uk> <CALCETrWQx0qwthBc5pJBxs2PWAQo-roAz-6g=7HOs+dsiokVsg@mail.gmail.com> <CAG48ez0YZ_iy6qZpdGUj38wqeg_NzLHHhU-mBCBf5hcopYGVPg@mail.gmail.com> <20201228190852.GI1551@shell.armlinux.org.uk> <CALCETrVpvrBufrJgXNY=ogtZQLo7zgxQmD7k9eVCFjcdcvarmA@mail.gmail.com>
Subject: Re: [RFC please help] membarrier: Rewrite
 sync_core_before_usermode()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3991 (ZimbraWebClient - FF84 (Linux)/8.8.15_GA_3980)
Thread-Topic: membarrier: Rewrite sync_core_before_usermode()
Thread-Index: +s6nbevyhmTVOSvju28y1ZNMIc+UYg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- On Dec 28, 2020, at 2:44 PM, Andy Lutomirski luto@kernel.org wrote:

> On Mon, Dec 28, 2020 at 11:09 AM Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
>>
>> On Mon, Dec 28, 2020 at 07:29:34PM +0100, Jann Horn wrote:
>> > After chatting with rmk about this (but without claiming that any of
>> > this is his opinion), based on the manpage, I think membarrier()
>> > currently doesn't really claim to be synchronizing caches? It just
>> > serializes cores. So arguably if userspace wants to use membarrier()
>> > to synchronize code changes, userspace should first do the code
>> > change, then flush icache as appropriate for the architecture, and
>> > then do the membarrier() to ensure that the old code is unused?

^ exactly, yes.

>> >
>> > For 32-bit arm, rmk pointed out that that would be the cacheflush()
>> > syscall. That might cause you to end up with two IPIs instead of one
>> > in total, but we probably don't care _that_ much about extra IPIs on
>> > 32-bit arm?

This was the original thinking, yes. The cacheflush IPI will flush specific
regions of code, and the membarrier IPI issues context synchronizing
instructions.

Architectures with coherent i/d caches don't need the cacheflush step.

>> >
>> > For arm64, I believe userspace can flush icache across the entire
>> > system with some instructions from userspace - "DC CVAU" followed by
>> > "DSB ISH", or something like that, I think? (See e.g.
>> > compat_arm_syscall(), the arm64 compat code that implements the 32-bit
>> > arm cacheflush() syscall.)
>>
>> Note that the ARM cacheflush syscall calls flush_icache_user_range()
>> over the range of addresses that userspace has passed - it's intention
>> since day one is to support cases where userspace wants to change
>> executable code.
>>
>> It will issue the appropriate write-backs to the data cache (DCCMVAU),
>> the invalidates to the instruction cache (ICIMVAU), invalidate the
>> branch target buffer (BPIALLIS or BPIALL as appropriate), and issue
>> the appropriate barriers (DSB ISHST, ISB).
>>
>> Note that neither flush_icache_user_range() nor flush_icache_range()
>> result in IPIs; cache operations are broadcast across all CPUs (which
>> is one of the minimums we require for SMP systems.)

But the ISB AFAIU is not a broadcast. Based on
https://developer.arm.com/documentation/ddi0406/c/Appendices/Barrier-Litmus-Tests/Cache-and-TLB-maintenance-operations-and-barriers/Instruction-cache-maintenance-operations

"Ensuring the visibility of updates to instructions for a multiprocessor"

the ISB needs to be issued on each processor in a multiprocessor system.
This is where membarrier sync-core comes handy.

>>
>> Now, that all said, I think the question that has to be asked is...
>>
>>         What is the basic purpose of membarrier?

For basic membarrier (not sync-core), the purpose is to provide memory
barriers across a given set of threads.

For sync-core membarrier, the purpose is to guarantee context synchronizing
instructions on all threads belonging to the same mm.

>>
>> Is the purpose of it to provide memory barriers, or is it to provide
>> memory coherence?

The purpose has never been to provide any kind of memory coherence, as
this would duplicate what is already achieved by other architecture-specific
system calls.

>>
>> If it's the former and not the latter, then cache flushes are out of
>> scope, and expecting memory written to be visible to the instruction
>> stream is totally out of scope of the membarrier interface, whether
>> or not the writes happen on the same or a different CPU to the one
>> executing the rewritten code.
>>
>> The documentation in the kernel does not seem to describe what it's
>> supposed to be doing - the only thing I could find is this:
>> Documentation/features/sched/membarrier-sync-core/arch-support.txt
>> which describes it as "arch supports core serializing membarrier"
>> whatever that means.

It's described in include/uapi/linux/membarrier.h.

>>
>> Seems to be the standard and usual case of utterly poor to non-existent
>> documentation within the kernel tree, or even a pointer to where any
>> useful documentation can be found.
>>
>> Reading the membarrier(2) man page, I find nothing in there that talks
>> about any kind of cache coherency for self-modifying code - it only
>> seems to be about _barriers_ and nothing more, and barriers alone do
>> precisely nothing to save you from non-coherent Harvard caches.

There is no mention of cache coherency because membarrier does not
do anything wrt cache coherency. We should perhaps explicitly point
it out though.

>>
>> So, either Andy has a misunderstanding, or the man page is wrong, or
>> my rudimentary understanding of what membarrier is supposed to be
>> doing is wrong...
> 
> Look at the latest man page:
> 
> https://man7.org/linux/man-pages/man2/membarrier.2.html
> 
> for MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE.  The result may not be
> all that enlightening.

As described in the membarrier(2) man page and in include/uapi/linux/membarrier.h,
membarrier MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE guarantees core serializing
instructions in addition to the memory ordering guaranteed by MEMBARRIER_CMD_PRIVATE_EXPEDITED.

It does not guarantee anything wrt i/d cache coherency. I initially considered
adding such guarantees when we introduced membarrier sync-core, but decided
against it because it would basically replicate what architectures already
expose to user-space, e.g. flush_icache_user_range on arm32.

So between code modification and allowing other threads to jump to that code,
it should be expected that architectures without coherent i/d cache will need
to flush caches to ensure coherency *and* to issue membarrier to make sure
core serializing instructions will be issued by every thread acting on the
same mm either immediately by means of the IPI, or before they return to
user-space if they do not happen to be currently running when the membarrier
system call is invoked.

Hoping this clarifies things. I suspect we will need to clarify documentation
about what membarrier *does not* guarantee, given that you mistakenly expected
membarrier to take care of cache flushing.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
