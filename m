Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09FAC2B7351
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 01:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgKRApa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 19:45:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:35792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgKRApa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 19:45:30 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E94324181;
        Wed, 18 Nov 2020 00:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605660329;
        bh=WQtSwGawLcx5cNeiXXUE0xzq9xL1NO7N+lP3KuaOZck=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LRWj38G++Gq39Byx9+ahpj6HYYOiiqlHK/cjkQcThMQuKvT3gDUOLAS3DFMvyFilt
         c7pg4ZmmfqQ+YNHbYd1ibSNCS0Vkc8aVj1aYZGfi3fbSPvRdQc0M2HLs7igyBr0K7N
         +KezrqksYdcU0xVCnc66s86vfiHoWW5I2HJMMlsI=
Date:   Tue, 17 Nov 2020 19:45:28 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Kamal Mostafa <kamal@canonical.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: Re: Same problem for 4.14.y and a concern: Re: [PATCH 4.19 056/191]
 powerpc: select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
Message-ID: <20201118004528.GA629656@sasha-vm>
References: <20201103203232.656475008@linuxfoundation.org>
 <20201103203239.940977599@linuxfoundation.org>
 <87361qug5a.fsf@mpe.ellerman.id.au>
 <CAEO-eVMZ-qjZfdum=NQCq-hur=KkHvFgJO1maHw7C1S4NFbczw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAEO-eVMZ-qjZfdum=NQCq-hur=KkHvFgJO1maHw7C1S4NFbczw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 17, 2020 at 10:51:16AM -0800, Kamal Mostafa wrote:
>On Tue, Nov 3, 2020 at 4:22 PM Michael Ellerman <mpe@ellerman.id.au> wrote:
>
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>> > From: Nicholas Piggin <npiggin@gmail.com>
>> >
>> > [ Upstream commit 66acd46080bd9e5ad2be4b0eb1d498d5145d058e ]
>> >
>> > powerpc uses IPIs in some situations to switch a kernel thread away
>> > from a lazy tlb mm, which is subject to the TLB flushing race
>> > described in the changelog introducing ARCH_WANT_IRQS_OFF_ACTIVATE_MM.
>> >
>> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> > Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>> > Link:
>> https://lore.kernel.org/r/20200914045219.3736466-3-npiggin@gmail.com
>> > Signed-off-by: Sasha Levin <sashal@kernel.org>
>> > ---
>> >  arch/powerpc/Kconfig                   | 1 +
>> >  arch/powerpc/include/asm/mmu_context.h | 2 +-
>> >  2 files changed, 2 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
>> > index f38d153d25861..0bc53f0e37c0f 100644
>> > --- a/arch/powerpc/Kconfig
>> > +++ b/arch/powerpc/Kconfig
>> > @@ -152,6 +152,7 @@ config PPC
>> >       select ARCH_USE_BUILTIN_BSWAP
>> >       select ARCH_USE_CMPXCHG_LOCKREF         if PPC64
>> >       select ARCH_WANT_IPC_PARSE_VERSION
>> > +     select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
>>
>> This depends on upstream commit:
>>
>>   d53c3dfb23c4 ("mm: fix exec activate_mm vs TLB shootdown and lazy tlb
>> switching race")
>>
>>
>> Which I don't see in 4.19 stable, or in the email thread here.
>>
>> So this shouldn't be backported to 4.19 unless that commit is also
>> backported.
>>
>> cheers
>>
>
>Hi-
>
>This glitch has made its way into 4.14.y ...
>    [4.14.y] c2bca8712a19 powerpc: select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
>But 4.14.y does not carry the prereq that introduces that config.

I'll queue up the 4.19 backport for 4.14 too, thanks!

-- 
Thanks,
Sasha
