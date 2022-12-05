Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA86E643866
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 23:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbiLEWu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 17:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233808AbiLEWuY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 17:50:24 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F559FF0;
        Mon,  5 Dec 2022 14:50:17 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NQzJx3NtCz4xP9;
        Tue,  6 Dec 2022 09:50:09 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1670280611;
        bh=FNsUgJ4FY4mftzXnZsxTHw8V/RkJzfvhTQjoxw+A9u8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=sBNn/PWDAk5aGDHOQQNW1NEGjnuKVmBDghLBo+OS97RfnE9Y49J4BQvAzkLvi5XE6
         UXOy6IZMJCfhCyRP9N5oFPnb4ooxy+m+MtJazKxH4va1fIFJUIeOTlNCNia4zPhQPy
         nA69eP4m0wz6AbNVR697lJK821TSPTvzorKgRkEbsp4t95knr8VPw+18W+yZjjZJcS
         ghNbSyKQqgiXnpEmoQd1NGQO+O6O4BIuoCxzJ5kopp0rnbhSDyXGM0FnZ6W1KXkkpS
         8PeAEjbeRLgZ3ltZjP5BJNCDan2h2qYAEMT1gdFg5SUlRgccqy6Xf5dA0momIcWAvY
         n/TfJUdI8GRLw==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Michael Jeanson <mjeanson@efficios.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michal Suchanek <msuchanek@suse.de>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] powerpc/ftrace: fix syscall tracing on PPC64_ELF_ABI_V1
In-Reply-To: <dfe0b9ba-828d-e1a5-f9a3-416c6b5b1cf3@efficios.com>
References: <20221201161442.2127231-1-mjeanson@efficios.com>
 <87pmcys9ae.fsf@mpe.ellerman.id.au>
 <d5dd1491-5d59-7987-9b5b-83f5fb1b29ee@efficios.com>
 <219580de-7473-f142-5ef2-1ed40e41d13d@csgroup.eu>
 <323f83c7-38fe-8a12-d77a-0a7249aad316@efficios.com>
 <dfe0b9ba-828d-e1a5-f9a3-416c6b5b1cf3@efficios.com>
Date:   Tue, 06 Dec 2022 09:50:08 +1100
Message-ID: <87mt81sbxb.fsf@mpe.ellerman.id.au>
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

Michael Jeanson <mjeanson@efficios.com> writes:
> On 2022-12-05 15:11, Michael Jeanson wrote:
>>>>> Michael Jeanson <mjeanson@efficios.com> writes:
>>>>>> In v5.7 the powerpc syscall entry/exit logic was rewritten in C, on
>>>>>> PPC64_ELF_ABI_V1 this resulted in the symbols in the syscall table
>>>>>> changing from their dot prefixed variant to the non-prefixed ones.
>>>>>>
>>>>>> Since ftrace prefixes a dot to the syscall names when matching them to
>>>>>> build its syscall event list, this resulted in no syscall events being
>>>>>> available.
>>>>>>
>>>>>> Remove the PPC64_ELF_ABI_V1 specific version of
>>>>>> arch_syscall_match_sym_name to have the same behavior across all powerpc
>>>>>> variants.
>>>>>
>>>>> This doesn't seem to work for me.
>>>>>
>>>>> Event with it applied I still don't see anything in
>>>>> /sys/kernel/debug/tracing/events/syscalls
>>>>>
>>>>> Did we break it in some other way recently?
>>>>>
>>>>> cheers
>
> I did some further testing, my config also enabled KALLSYMS_ALL, when I remove 
> it there is indeed no syscall events.

Aha, OK that explains it I guess.

I was using ppc64_guest_defconfig which has ABI_V1 and FTRACE_SYSCALLS,
but does not have KALLSYMS_ALL. So I guess there's some other bug
lurking in there.

cheers
