Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1AF6445F5
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 15:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235008AbiLFOpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 09:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234997AbiLFOpq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 09:45:46 -0500
X-Greylist: delayed 468 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 06 Dec 2022 06:45:43 PST
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5951AD90
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 06:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1670337473;
        bh=Kd0jjz1CjqcV+7piYClIjIJneBLKFwnv523KTTiO8hc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Ea1ZwCpSugdyNqlfCe26vLk7eouQGBO16z+sABZ+AEhPAoLqpWdhIDQeEtbGdLtH/
         Jv0ExQFuElzvCxZDepj4uNvxW9Ax1PjfXxqRp0FrtpysjqGqGij5zJb2PSy8LGnvjY
         K3hdxKdz9uuAiQ4hZA5eJnKOGTIl2mr/yvEUf43qdn0fsTuyKkapurJ7YEqABZS8zQ
         tH/WHgQorXsQXgz/uU8wmLA6pfZSMSKcRKDFEwI4AhewU4F91iKppX9ZjUlIOSF8yh
         7h6+nUfBIbbqWRkqBLb99QUKwzGZbzdwf5FMQoNcPy+3+ZswlGBngbsgC5T2ymC2zh
         W3F9L1UL+utyQ==
Received: from [172.16.0.118] (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4NRNLT2jlDzZx8;
        Tue,  6 Dec 2022 09:37:53 -0500 (EST)
Message-ID: <484763aa-e77b-b599-4786-ef4cdf16d7bd@efficios.com>
Date:   Tue, 6 Dec 2022 09:38:11 -0500
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
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <87mt81sbxb.fsf@mpe.ellerman.id.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-12-05 17:50, Michael Ellerman wrote:
> Michael Jeanson <mjeanson@efficios.com> writes:
>> On 2022-12-05 15:11, Michael Jeanson wrote:
>>>>>> Michael Jeanson <mjeanson@efficios.com> writes:
>>>>>>> In v5.7 the powerpc syscall entry/exit logic was rewritten in C, on
>>>>>>> PPC64_ELF_ABI_V1 this resulted in the symbols in the syscall table
>>>>>>> changing from their dot prefixed variant to the non-prefixed ones.
>>>>>>>
>>>>>>> Since ftrace prefixes a dot to the syscall names when matching them to
>>>>>>> build its syscall event list, this resulted in no syscall events being
>>>>>>> available.
>>>>>>>
>>>>>>> Remove the PPC64_ELF_ABI_V1 specific version of
>>>>>>> arch_syscall_match_sym_name to have the same behavior across all powerpc
>>>>>>> variants.
>>>>>>
>>>>>> This doesn't seem to work for me.
>>>>>>
>>>>>> Event with it applied I still don't see anything in
>>>>>> /sys/kernel/debug/tracing/events/syscalls
>>>>>>
>>>>>> Did we break it in some other way recently?
>>>>>>
>>>>>> cheers
>>
>> I did some further testing, my config also enabled KALLSYMS_ALL, when I remove
>> it there is indeed no syscall events.
> 
> Aha, OK that explains it I guess.
> 
> I was using ppc64_guest_defconfig which has ABI_V1 and FTRACE_SYSCALLS,
> but does not have KALLSYMS_ALL. So I guess there's some other bug
> lurking in there.

I don't have the setup handy to validate it, but I suspect it is caused 
by the way scripts/kallsyms.c:symbol_valid() checks whether a symbol 
entry needs to be integrated into the assembler output when 
--all-symbols is not specified. It only keeps symbols which addresses 
are in the text range. On PPC64_ELF_ABI_V1, this means only the 
dot-prefixed symbols will be kept (those point to the function begin), 
leaving out the non-dot-prefixed symbols (those point to the function 
descriptors).

So I see two possible solutions there: either we ensure that 
FTRACE_SYSCALLS selects KALLSYMS_ALL on PPC64_ELF_ABI_V1, or we modify 
scripts/kallsyms.c:symbol_valid() to also include function descriptor 
symbols. This would mean accepting symbols pointing into the .opd ELF 
section.

IMHO the second option would be better because it does not increase the 
kernel image size as much as KALLSYMS_ALL.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

