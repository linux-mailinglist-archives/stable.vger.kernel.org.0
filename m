Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0628D2E6BAA
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 00:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730579AbgL1Wzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 17:55:50 -0500
Received: from mail.efficios.com ([167.114.26.124]:40400 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729494AbgL1VKV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 16:10:21 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 063922761C7;
        Mon, 28 Dec 2020 16:09:40 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id Xl2HNlqr6BSs; Mon, 28 Dec 2020 16:09:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 8512E2761C5;
        Mon, 28 Dec 2020 16:09:39 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 8512E2761C5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1609189779;
        bh=A+A/Blx9QD1hoONN5Jxqqa59/BnSFAuRhzOnDZD8md8=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=p/szlAxKXnb8sMCXgDpGdE6is/o1rjODbnzdRovA9owiEjuUPlM3+dte9oFxY/+Hd
         pvcRHGvBLx8S5o5ANGCMKBwMqzBmFMfuacgLtZuDT1vBtUVUSIdSFMD3lwBW0Mm8Sq
         XkulYMWharVGPEE76YIKlwesiZMP7dKhpXj/gToE1q4CiEAv+QDgP6f1MTue34+EDL
         yC7abPFDn6sQU4EVRsjnLUgN48sbY+nRlQq9VYRasErERk2As+18wk5Q0JRbIc/lci
         ltQp4+4byni+b6Qb7IBjB/By21MOffNXi7Ev/3OOnq+SzZHcRZHXttXzb3ZGlGI4S3
         +WkZTiCC1H5Hw==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id BWu1pC_47JoY; Mon, 28 Dec 2020 16:09:39 -0500 (EST)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 725FE27640E;
        Mon, 28 Dec 2020 16:09:39 -0500 (EST)
Date:   Mon, 28 Dec 2020 16:09:39 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Andy Lutomirski <luto@kernel.org>, paulmck <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     "Russell King, ARM Linux" <linux@armlinux.org.uk>,
        x86 <x86@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        stable <stable@vger.kernel.org>
Message-ID: <1670059472.3671.1609189779376.JavaMail.zimbra@efficios.com>
In-Reply-To: <CALCETrVdcn2r2Jvd1=-bM=FQ8KbX4aH-v4ytdojL7r7Nb6k8YQ@mail.gmail.com>
References: <bf59ecb5487171a852bcc8cdd553ec797aedc485.1609093476.git.luto@kernel.org> <1836294649.3345.1609100294833.JavaMail.zimbra@efficios.com> <CALCETrVdcn2r2Jvd1=-bM=FQ8KbX4aH-v4ytdojL7r7Nb6k8YQ@mail.gmail.com>
Subject: Re: [RFC please help] membarrier: Rewrite
 sync_core_before_usermode()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3991 (ZimbraWebClient - FF84 (Linux)/8.8.15_GA_3980)
Thread-Topic: membarrier: Rewrite sync_core_before_usermode()
Thread-Index: UfUbgHPNYlsGbr5X+VxS/QBaGieq4w==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- On Dec 27, 2020, at 4:36 PM, Andy Lutomirski luto@kernel.org wrote:

[...]

>> You seem to have noticed odd cases on arm64 where this guarantee does not
>> match reality. Where exactly can we find this in the code, and which part
>> of the architecture manual can you point us to which supports your concern ?
>>
>> Based on the notes I have, use of `eret` on aarch64 guarantees a context
>> synchronizing
>> instruction when returning to user-space.
> 
> Based on my reading of the manual, ERET on ARM doesn't synchronize
> anything at all.  I can't find any evidence that it synchronizes data
> or instructions, and I've seen reports that the CPU will happily
> speculate right past it.

Reading [1] there appears to be 3 kind of context synchronization events:

- Taking an exception,
- Returning from an exception,
- ISB.

This other source [2] adds (search for Context synchronization operation):

- Exit from Debug state
- Executing a DCPS instruction
- Executing a DRPS instruction

"ERET" falls into the second kind of events, and AFAIU should be context
synchronizing. That was confirmed to me by Will Deacon when membarrier
sync-core was implemented for aarch64. If the architecture reference manuals
are wrong, is there an errata ?

As for the algorithm to use on ARMv8 to update instructions, see [2]
B2.3.4  Implication of caches for the application programmer
"Synchronization and coherency issues between data and instruction accesses"

Membarrier only takes care of making sure the "ISB" part of the algorithm can be
done easily and efficiently on multiprocessor systems.

Thanks,

Mathieu

[1] https://developer.arm.com/documentation/den0024/a/Memory-Ordering/Barriers/ISB-in-more-detail
[2] https://montcs.bloomu.edu/Information/ARMv8/ARMv8-A_Architecture_Reference_Manual_(Issue_A.a).pdf

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
