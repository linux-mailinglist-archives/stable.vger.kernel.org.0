Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5CCE361E1C
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 12:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238711AbhDPKlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 06:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbhDPKla (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 06:41:30 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F284AC061574;
        Fri, 16 Apr 2021 03:41:04 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FMCRd1BPDz9sVv;
        Fri, 16 Apr 2021 20:41:01 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1618569661;
        bh=SeOzQ9Fg9C2zAMuj8cY5McP+aFk25PiM311deR2n+II=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=dlrfmoa66rjbsgjm/6d63tAsvauWz+/zCQSBCnuup3KRzbygxslVoQS9YLGzEmxCp
         BlmJROc2q2TCvBVUIsPXowKqD3tb+ePzQL27V3dkPyfXbwzb78UU1jdjd137lpsvKm
         KRliFf+AabCTWYguQlPH0zI4TXJyjldAKamw26SoqGPY25rAGdtoTIaVkio+4Uf4L1
         SEAb53oUP9Z4uROoJLiyxDIETXgY4VU69wU0ZSnGCG4nWNO75litn3pAbksUGbd/82
         gAnYfZRakpES4+dl5kRnYehiwK32L5HnaGG6PdUlZ0kv9Tk4UjgZL+TxjgXEcebnmo
         67fGXanIuuK6g==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Tony Ambardar <tony.ambardar@gmail.com>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arch <linux-arch@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stable <stable@vger.kernel.org>, Rosen Penev <rosenp@gmail.com>
Subject: Re: [PATCH v3] powerpc: fix EDEADLOCK redefinition error in
 uapi/asm/errno.h
In-Reply-To: <CAPGftE-Q+Q479j7SikDBQLiM+VKbpXpRYnTeEJeAHeZrh_Ok2A@mail.gmail.com>
References: <20200917000757.1232850-1-Tony.Ambardar@gmail.com>
 <20200917135437.1238787-1-Tony.Ambardar@gmail.com>
 <CAPGftE-Q+Q479j7SikDBQLiM+VKbpXpRYnTeEJeAHeZrh_Ok2A@mail.gmail.com>
Date:   Fri, 16 Apr 2021 20:41:00 +1000
Message-ID: <87r1jaeclf.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tony Ambardar <tony.ambardar@gmail.com> writes:
> Hello Michael,
>
> The latest version of this patch addressed all feedback I'm aware of
> when submitted last September, and I've seen no further comments from
> reviewers since then.
>
> Could you please let me know where this stands and if anything further
> is needed?

Sorry, it's still sitting in my inbox :/

I was going to reply to suggest we split the tools change out. The
headers under tools are usually updated by another maintainer, I think
it might even be scripted.

Anyway I've applied your patch and done that (dropped the change to
tools/.../errno.h), which should also mean the stable backport is more
likely to work automatically.

It will hit mainline in v5.13-rc1 and then be backported to the stable
trees.

I don't think you actually need the tools version of the header updated
to fix your bug? In which case we can probably just wait for it to be
updated automatically when the tools headers are sync'ed with the kernel
versions.

cheers


> On Thu, 17 Sept 2020 at 06:54, Tony Ambardar <tony.ambardar@gmail.com> wrote:
>>
>> A few archs like powerpc have different errno.h values for macros
>> EDEADLOCK and EDEADLK. In code including both libc and linux versions of
>> errno.h, this can result in multiple definitions of EDEADLOCK in the
>> include chain. Definitions to the same value (e.g. seen with mips) do
>> not raise warnings, but on powerpc there are redefinitions changing the
>> value, which raise warnings and errors (if using "-Werror").
>>
>> Guard against these redefinitions to avoid build errors like the following,
>> first seen cross-compiling libbpf v5.8.9 for powerpc using GCC 8.4.0 with
>> musl 1.1.24:
>>
>>   In file included from ../../arch/powerpc/include/uapi/asm/errno.h:5,
>>                    from ../../include/linux/err.h:8,
>>                    from libbpf.c:29:
>>   ../../include/uapi/asm-generic/errno.h:40: error: "EDEADLOCK" redefined [-Werror]
>>    #define EDEADLOCK EDEADLK
>>
>>   In file included from toolchain-powerpc_8540_gcc-8.4.0_musl/include/errno.h:10,
>>                    from libbpf.c:26:
>>   toolchain-powerpc_8540_gcc-8.4.0_musl/include/bits/errno.h:58: note: this is the location of the previous definition
>>    #define EDEADLOCK       58
>>
>>   cc1: all warnings being treated as errors
>>
>> CC: Stable <stable@vger.kernel.org>
>> Reported-by: Rosen Penev <rosenp@gmail.com>
>> Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
>> ---
>> v1 -> v2:
>>  * clean up commit description formatting
>>
>> v2 -> v3: (per Michael Ellerman)
>>  * drop indeterminate 'Fixes' tags, request stable backports instead
>> ---
>>  arch/powerpc/include/uapi/asm/errno.h       | 1 +
>>  tools/arch/powerpc/include/uapi/asm/errno.h | 1 +
>>  2 files changed, 2 insertions(+)
>>
>> diff --git a/arch/powerpc/include/uapi/asm/errno.h b/arch/powerpc/include/uapi/asm/errno.h
>> index cc79856896a1..4ba87de32be0 100644
>> --- a/arch/powerpc/include/uapi/asm/errno.h
>> +++ b/arch/powerpc/include/uapi/asm/errno.h
>> @@ -2,6 +2,7 @@
>>  #ifndef _ASM_POWERPC_ERRNO_H
>>  #define _ASM_POWERPC_ERRNO_H
>>
>> +#undef EDEADLOCK
>>  #include <asm-generic/errno.h>
>>
>>  #undef EDEADLOCK
>> diff --git a/tools/arch/powerpc/include/uapi/asm/errno.h b/tools/arch/powerpc/include/uapi/asm/errno.h
>> index cc79856896a1..4ba87de32be0 100644
>> --- a/tools/arch/powerpc/include/uapi/asm/errno.h
>> +++ b/tools/arch/powerpc/include/uapi/asm/errno.h
>> @@ -2,6 +2,7 @@
>>  #ifndef _ASM_POWERPC_ERRNO_H
>>  #define _ASM_POWERPC_ERRNO_H
>>
>> +#undef EDEADLOCK
>>  #include <asm-generic/errno.h>
>>
>>  #undef EDEADLOCK
>> --
>> 2.25.1
>>
