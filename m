Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47C52E6BBB
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 00:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730597AbgL1Wzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 17:55:51 -0500
Received: from mail.efficios.com ([167.114.26.124]:48196 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729509AbgL1V1Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 16:27:24 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id DD2AF276346;
        Mon, 28 Dec 2020 16:26:42 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id bbvVjxmkCU_s; Mon, 28 Dec 2020 16:26:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 680D4276524;
        Mon, 28 Dec 2020 16:26:42 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 680D4276524
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1609190802;
        bh=z5SadIcR2lzpMzQSq0MlMGX6w4abtftg0yLn7xs5uL0=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=APaKQfS/4RtIWzaWOaHYIx5R3o6+lMdlIwnwMvuRpQPipj9Vp5blrwND39rR+isBS
         si6sR5LIrYQxIyVChB8SzsIXIJhMANi1S1teS4XeCjz7xEY1a/JyedylDqgsP4pQjR
         NVMmTbwC4A7eYN3McEdVHyAjaancpxsGQFXHYaJlOm/t4D0jIkO9hm+CJVECVz12AJ
         F4K2OUbbRpRsgnd2ALM5tqH11Nd6ye1S7LIH8C3PnR4reveNmvnbnvNTLaK1WasdWp
         nT6sVspVjGFMUSzI/+326EQCOivv6yCkn0Tda/qm3O/aASJ47v7WebROPCfSbx+mlR
         dECQokSZCgHOw==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6zlFCT90YhfK; Mon, 28 Dec 2020 16:26:42 -0500 (EST)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 53B23276602;
        Mon, 28 Dec 2020 16:26:42 -0500 (EST)
Date:   Mon, 28 Dec 2020 16:26:42 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     paulmck <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Russell King, ARM Linux" <linux@armlinux.org.uk>,
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
Message-ID: <1378834482.3699.1609190802236.JavaMail.zimbra@efficios.com>
In-Reply-To: <CALCETrXx3Xe+4Y6WM-mp0cTUU=r3bW6PV2b25yA8bm1Gvak6wQ@mail.gmail.com>
References: <bf59ecb5487171a852bcc8cdd553ec797aedc485.1609093476.git.luto@kernel.org> <20201228102537.GG1551@shell.armlinux.org.uk> <CALCETrWQx0qwthBc5pJBxs2PWAQo-roAz-6g=7HOs+dsiokVsg@mail.gmail.com> <CAG48ez0YZ_iy6qZpdGUj38wqeg_NzLHHhU-mBCBf5hcopYGVPg@mail.gmail.com> <20201228190852.GI1551@shell.armlinux.org.uk> <CALCETrVpvrBufrJgXNY=ogtZQLo7zgxQmD7k9eVCFjcdcvarmA@mail.gmail.com> <1086654515.3607.1609187556216.JavaMail.zimbra@efficios.com> <CALCETrXx3Xe+4Y6WM-mp0cTUU=r3bW6PV2b25yA8bm1Gvak6wQ@mail.gmail.com>
Subject: Re: [RFC please help] membarrier: Rewrite
 sync_core_before_usermode()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3991 (ZimbraWebClient - FF84 (Linux)/8.8.15_GA_3980)
Thread-Topic: membarrier: Rewrite sync_core_before_usermode()
Thread-Index: tIlQLlu+op3Kl5YqWG9aEqEFkV0nuQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- On Dec 28, 2020, at 4:06 PM, Andy Lutomirski luto@kernel.org wrote:

> On Mon, Dec 28, 2020 at 12:32 PM Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
>>
>> ----- On Dec 28, 2020, at 2:44 PM, Andy Lutomirski luto@kernel.org wrote:
>>
>> > On Mon, Dec 28, 2020 at 11:09 AM Russell King - ARM Linux admin
>> > <linux@armlinux.org.uk> wrote:
>> >>
>> >> On Mon, Dec 28, 2020 at 07:29:34PM +0100, Jann Horn wrote:
>> >> > After chatting with rmk about this (but without claiming that any of
>> >> > this is his opinion), based on the manpage, I think membarrier()
>> >> > currently doesn't really claim to be synchronizing caches? It just
>> >> > serializes cores. So arguably if userspace wants to use membarrier()
>> >> > to synchronize code changes, userspace should first do the code
>> >> > change, then flush icache as appropriate for the architecture, and
>> >> > then do the membarrier() to ensure that the old code is unused?
>>
>> ^ exactly, yes.
>>
>> >> >
>> >> > For 32-bit arm, rmk pointed out that that would be the cacheflush()
>> >> > syscall. That might cause you to end up with two IPIs instead of one
>> >> > in total, but we probably don't care _that_ much about extra IPIs on
>> >> > 32-bit arm?
>>
>> This was the original thinking, yes. The cacheflush IPI will flush specific
>> regions of code, and the membarrier IPI issues context synchronizing
>> instructions.
>>
>> Architectures with coherent i/d caches don't need the cacheflush step.
> 
> There are different levels of coherency -- VIVT architectures may have
> differing requirements compared to PIPT, etc.
> 
> In any case, I feel like the approach taken by the documentation is
> fundamentally confusing.  Architectures don't all speak the same
> language

Agreed.

> How about something like:

I dislike the wording "barrier" and the association between "write" and
"instruction fetch" done in the descriptions below. It leads to think that
this behaves like a memory barrier, when in fact my understanding of
a context synchronizing instruction is that it simply flushes internal
CPU state, which would cause coherency issues if the CPU observes both the
old and then the new code without having this state flushed.

[ Sorry if I take more time to reply and if my replies are a bit more
  concise than usual. I'm currently on parental leave, so I have
  non-maskable interrupts to attend to. ;-) ]

Thanks,

Mathieu

> 
> The SYNC_CORE operation causes all threads in the caller's address
> space (including the caller) to execute an architecture-defined
> barrier operation.  membarrier() will ensure that this barrier is
> executed at a time such that all data writes done by the calling
> thread before membarrier() are made visible by the barrier.
> Additional architecture-dependent cache management operations may be
> required to use this for JIT code.
> 
> x86: SYNC_CORE executes a barrier that will cause subsequent
> instruction fetches to observe prior writes.  Currently this will be a
> "serializing" instruction, but, if future improved CPU documentation
> becomes available and relaxes this requirement, the barrier may
> change.  The kernel guarantees that writing new or modified
> instructions to normal memory (and issuing SFENCE if the writes were
> non-temporal) then doing a membarrier SYNC_CORE operation is
> sufficient to cause all threads in the caller's address space to
> execute the new or modified instructions.  This is true regardless of
> whether or not those instructions are written at the same virtual
> address from which they are subsequently executed.  No additional
> cache management is required on x86.
> 
> arm: Something about the cache management syscalls.
> 
> arm64: Ditto
> 
> powerpc: I have no idea.

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
