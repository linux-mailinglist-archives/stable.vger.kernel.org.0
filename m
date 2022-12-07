Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22572645D79
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 16:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiLGPSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 10:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiLGPR7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 10:17:59 -0500
X-Greylist: delayed 88796 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 07 Dec 2022 07:17:55 PST
Received: from smtpout.efficios.com (unknown [IPv6:2607:5300:203:b2ee::31e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2F531377;
        Wed,  7 Dec 2022 07:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1670426274;
        bh=onhkbVgBkjqH4ScJ4IkB5Y+MP8n6mVP+AHCElM43xdY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=rYAPyx+3ucHq99LJmeqE0zjmk/D/hYr0Vo7W8O98l69XGRlqAf1oXlXzVgK+ACawp
         QYe23xxchnBdv83eUSmzk7AhI0VZCgP6dGz3A5F8pEv9U+PsDMzgksw7Nq6l5mxMsq
         tEYZLL6CCZqlT+dLXjjgOBdBk+1MfHmKWA39hjI8mdaQZifxnxJjURhp4pDYg0KAnB
         OpJzbW+8QKyLPhe4TOSLINm+F711kIVTp9/a2ZQJgc/CMCNaRaHIazFAxTrQcjlXZr
         kniYqOW8aUs4TJhUheLm1KzgqZ3+FyoMhQeySENS+n8hrm1M0850TXI2xITjYGWESc
         wTtM8qS0QKcLQ==
Received: from [172.16.0.118] (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4NS1BB1Z7gzb3F;
        Wed,  7 Dec 2022 10:17:54 -0500 (EST)
Message-ID: <6db50470-ac37-0328-37a2-760665668b5f@efficios.com>
Date:   Wed, 7 Dec 2022 10:18:13 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] powerpc/ftrace: fix syscall tracing on PPC64_ELF_ABI_V1
Content-Language: en-US
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Michael Jeanson <mjeanson@efficios.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michal Suchanek <msuchanek@suse.de>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20221201161442.2127231-1-mjeanson@efficios.com>
 <87pmcys9ae.fsf@mpe.ellerman.id.au>
 <d5dd1491-5d59-7987-9b5b-83f5fb1b29ee@efficios.com>
 <219580de-7473-f142-5ef2-1ed40e41d13d@csgroup.eu>
 <323f83c7-38fe-8a12-d77a-0a7249aad316@efficios.com>
 <dfe0b9ba-828d-e1a5-f9a3-416c6b5b1cf3@efficios.com>
 <87mt81sbxb.fsf@mpe.ellerman.id.au>
 <484763aa-e77b-b599-4786-ef4cdf16d7bd@efficios.com>
 <87cz8wrmm6.fsf@mpe.ellerman.id.au>
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <87cz8wrmm6.fsf@mpe.ellerman.id.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RDNS_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-12-06 21:09, Michael Ellerman wrote:
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:
>> On 2022-12-05 17:50, Michael Ellerman wrote:
>>> Michael Jeanson <mjeanson@efficios.com> writes:
>>>> On 2022-12-05 15:11, Michael Jeanson wrote:
>>>>>>>> Michael Jeanson <mjeanson@efficios.com> writes:
>>>>>>>>> In v5.7 the powerpc syscall entry/exit logic was rewritten in C, on
>>>>>>>>> PPC64_ELF_ABI_V1 this resulted in the symbols in the syscall table
>>>>>>>>> changing from their dot prefixed variant to the non-prefixed ones.
>>>>>>>>>
>>>>>>>>> Since ftrace prefixes a dot to the syscall names when matching them to
>>>>>>>>> build its syscall event list, this resulted in no syscall events being
>>>>>>>>> available.
>>>>>>>>>
>>>>>>>>> Remove the PPC64_ELF_ABI_V1 specific version of
>>>>>>>>> arch_syscall_match_sym_name to have the same behavior across all powerpc
>>>>>>>>> variants.
>>>>>>>>
>>>>>>>> This doesn't seem to work for me.
>>>>>>>>
>>>>>>>> Event with it applied I still don't see anything in
>>>>>>>> /sys/kernel/debug/tracing/events/syscalls
>>>>>>>>
>>>>>>>> Did we break it in some other way recently?
>>>>>>>>
>>>>>>>> cheers
>>>>
>>>> I did some further testing, my config also enabled KALLSYMS_ALL, when I remove
>>>> it there is indeed no syscall events.
>>>
>>> Aha, OK that explains it I guess.
>>>
>>> I was using ppc64_guest_defconfig which has ABI_V1 and FTRACE_SYSCALLS,
>>> but does not have KALLSYMS_ALL. So I guess there's some other bug
>>> lurking in there.
>>
>> I don't have the setup handy to validate it, but I suspect it is caused
>> by the way scripts/kallsyms.c:symbol_valid() checks whether a symbol
>> entry needs to be integrated into the assembler output when
>> --all-symbols is not specified. It only keeps symbols which addresses
>> are in the text range. On PPC64_ELF_ABI_V1, this means only the
>> dot-prefixed symbols will be kept (those point to the function begin),
>> leaving out the non-dot-prefixed symbols (those point to the function
>> descriptors).
> 
> OK. So I guess it never worked without KALLSYMS_ALL.

I suspect it worked prior to kernel v5.7, because back then the PPC64 
ABIv1 system call table contained pointers to the text section 
(beginning of functions) rather than function descriptors.

So changing this system call table to point to C functions introduced 
the dot-prefix match issue for syscall tracing as well as a dependency 
on KALLSYMS_ALL.

> 
> It seems like most distros enable KALLSYMS_ALL, so I guess that's why
> we've never noticed.

Or very few people run recent PPC64 ABIv1 kernels :)

> 
>> So I see two possible solutions there: either we ensure that
>> FTRACE_SYSCALLS selects KALLSYMS_ALL on PPC64_ELF_ABI_V1, or we modify
>> scripts/kallsyms.c:symbol_valid() to also include function descriptor
>> symbols. This would mean accepting symbols pointing into the .opd ELF
>> section.
> 
> My only worry is that will cause some other breakage, because .opd
> symbols are not really "text" in the normal sense, ie. you can't execute
> them directly.

AFAIU adding the .opd section to scripts/kallsyms.c text_ranges will 
only affect the result of symbol_valid(), which decides which symbols 
get pulled into a KALLSYMS=n/KALLSYMS_ALL=n kernel build. Considering 
that a KALLSYMS_ALL=y build pulls those function descriptor symbols into 
  the image without breaking anything, I don't see why adding the .opd 
section to this script text_ranges would have any ill side-effect.

> 
> On the other hand the help for KALLSYMS_ALL says:
> 
>    "Normally kallsyms only contains the symbols of functions"
> 
> But without .opd included that's not really true. In practice it
> probably doesn't really matter, because eg. backtraces will point to dot
> symbols which can be resolved.

Indeed, I don't see this affecting backtraces, but as soon as a lookup 
depends on comparing the C function pointer to a function descriptor, 
the .opd symbols are needed. Not having those function descriptor 
symbols in KALLSYMS_ALL=n builds seems rather error-prone.

> 
>> IMHO the second option would be better because it does not increase the
>> kernel image size as much as KALLSYMS_ALL.
> 
> Yes I agree.
> 
> Even if that did break something, any breakage would be limited to
> arches which uses function descriptors, which are now all rare.

Yes, it would only impact those arches using function descriptors, which 
are broken today with respect to system call tracing. Are you aware of 
other architectures other than PPC64 ELF ABI v1 supported by the Linux 
kernel that use function descriptors ?

> 
> Relatedly we have a patch in next to optionally use ABIv2 for 64-bit big
> endian builds.

Interesting. Does it require a matching user-space ? (built with PPC64 
ABIv2 ?) Does it handle legacy PPC32 executables ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

