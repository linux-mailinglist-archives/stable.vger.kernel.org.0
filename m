Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 727E46451C3
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 03:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiLGCJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 21:09:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiLGCJV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 21:09:21 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92E030F72;
        Tue,  6 Dec 2022 18:09:19 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NRgh83Bwsz4x1H;
        Wed,  7 Dec 2022 13:09:12 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1670378955;
        bh=qPerjcvxj//99SC+VDDOAu42pbFJqpbWCha/nmMfhU8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=QM4X/72HsNwe9GIAqJf/W3dEcno9m5vWla3jduhaunahlWgrN0o87ypohobZgUo1N
         fS4lotKKdSDs+mOGFhr3eZVjpmaQL+/MiGsdQ2KYY3cqfO0MvebGoPkGBOgTBUvsRg
         JMoblaoJN2VUJN6fRJM1AIXRINgrtOg+PFxdz0OauFEcZ86hpdKlu3S7Z/q75tE1sy
         mmQmlOeB5mJpRnbBgD+1q9wpmXKbIwCVE3GfHUhFrTK0FJ0aQLkHAJHV8hn1HXgEDh
         83k4E+aVSgLCyC85MHSO0IWj2s53AdYldwOlVuHc4E0ioytSnBeAtTo7GViPhSLSOl
         Nb6WZk9SolZZg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
Subject: Re: [PATCH] powerpc/ftrace: fix syscall tracing on PPC64_ELF_ABI_V1
In-Reply-To: <484763aa-e77b-b599-4786-ef4cdf16d7bd@efficios.com>
References: <20221201161442.2127231-1-mjeanson@efficios.com>
 <87pmcys9ae.fsf@mpe.ellerman.id.au>
 <d5dd1491-5d59-7987-9b5b-83f5fb1b29ee@efficios.com>
 <219580de-7473-f142-5ef2-1ed40e41d13d@csgroup.eu>
 <323f83c7-38fe-8a12-d77a-0a7249aad316@efficios.com>
 <dfe0b9ba-828d-e1a5-f9a3-416c6b5b1cf3@efficios.com>
 <87mt81sbxb.fsf@mpe.ellerman.id.au>
 <484763aa-e77b-b599-4786-ef4cdf16d7bd@efficios.com>
Date:   Wed, 07 Dec 2022 13:09:05 +1100
Message-ID: <87cz8wrmm6.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:
> On 2022-12-05 17:50, Michael Ellerman wrote:
>> Michael Jeanson <mjeanson@efficios.com> writes:
>>> On 2022-12-05 15:11, Michael Jeanson wrote:
>>>>>>> Michael Jeanson <mjeanson@efficios.com> writes:
>>>>>>>> In v5.7 the powerpc syscall entry/exit logic was rewritten in C, on
>>>>>>>> PPC64_ELF_ABI_V1 this resulted in the symbols in the syscall table
>>>>>>>> changing from their dot prefixed variant to the non-prefixed ones.
>>>>>>>>
>>>>>>>> Since ftrace prefixes a dot to the syscall names when matching them to
>>>>>>>> build its syscall event list, this resulted in no syscall events being
>>>>>>>> available.
>>>>>>>>
>>>>>>>> Remove the PPC64_ELF_ABI_V1 specific version of
>>>>>>>> arch_syscall_match_sym_name to have the same behavior across all powerpc
>>>>>>>> variants.
>>>>>>>
>>>>>>> This doesn't seem to work for me.
>>>>>>>
>>>>>>> Event with it applied I still don't see anything in
>>>>>>> /sys/kernel/debug/tracing/events/syscalls
>>>>>>>
>>>>>>> Did we break it in some other way recently?
>>>>>>>
>>>>>>> cheers
>>>
>>> I did some further testing, my config also enabled KALLSYMS_ALL, when I remove
>>> it there is indeed no syscall events.
>> 
>> Aha, OK that explains it I guess.
>> 
>> I was using ppc64_guest_defconfig which has ABI_V1 and FTRACE_SYSCALLS,
>> but does not have KALLSYMS_ALL. So I guess there's some other bug
>> lurking in there.
>
> I don't have the setup handy to validate it, but I suspect it is caused 
> by the way scripts/kallsyms.c:symbol_valid() checks whether a symbol 
> entry needs to be integrated into the assembler output when 
> --all-symbols is not specified. It only keeps symbols which addresses 
> are in the text range. On PPC64_ELF_ABI_V1, this means only the 
> dot-prefixed symbols will be kept (those point to the function begin), 
> leaving out the non-dot-prefixed symbols (those point to the function 
> descriptors).

OK. So I guess it never worked without KALLSYMS_ALL.

It seems like most distros enable KALLSYMS_ALL, so I guess that's why
we've never noticed.

> So I see two possible solutions there: either we ensure that 
> FTRACE_SYSCALLS selects KALLSYMS_ALL on PPC64_ELF_ABI_V1, or we modify 
> scripts/kallsyms.c:symbol_valid() to also include function descriptor 
> symbols. This would mean accepting symbols pointing into the .opd ELF 
> section.

My only worry is that will cause some other breakage, because .opd
symbols are not really "text" in the normal sense, ie. you can't execute
them directly.

On the other hand the help for KALLSYMS_ALL says:

  "Normally kallsyms only contains the symbols of functions"

But without .opd included that's not really true. In practice it
probably doesn't really matter, because eg. backtraces will point to dot
symbols which can be resolved.

> IMHO the second option would be better because it does not increase the 
> kernel image size as much as KALLSYMS_ALL.

Yes I agree.

Even if that did break something, any breakage would be limited to
arches which uses function descriptors, which are now all rare.

Relatedly we have a patch in next to optionally use ABIv2 for 64-bit big
endian builds.

cheers
