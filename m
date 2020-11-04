Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2EB2A5BC9
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 02:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730292AbgKDBTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 20:19:48 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:42465 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729246AbgKDBTs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 20:19:48 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CQpjG2wKPz9sTK;
        Wed,  4 Nov 2020 12:19:46 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1604452786;
        bh=Pnxsopz9uW6zKe3C5IY9MA7QaAelW0hEbYa9LsvaFoc=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=BvlYY1ddLg/HgYELt5uLxAYE9rqFlO4BWVf1RSRRsdXCPf5PBsrw1XniMtXFxgejg
         r3urJGMGuOAeP20m+8T6ZvNKu2gvdJ1wXE07xkfWWAVJ5KEzKOOG9Bg4FOxVN5rgPw
         NA0eo5TlYEl3swtjwD8RsWQ9u3kwep1VXcklwkpqjVtbIfZPltXPwQcBZGpJfyY1oj
         6Ll0E/m6o0Vor396c4uS7bK9P74QBfUAsCwR4kuN6gaLLTJ+Jror/l3Fiv8jRLNVfH
         Me6MSmjU3+gTzjBKe5yvzmBnQdikl7LSKiMj3WysoKn99VoqHkGdkVcKHfF+Vv0Pte
         soulluRH5vtXA==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 056/191] powerpc: select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
In-Reply-To: <87361qug5a.fsf@mpe.ellerman.id.au>
References: <20201103203232.656475008@linuxfoundation.org> <20201103203239.940977599@linuxfoundation.org> <87361qug5a.fsf@mpe.ellerman.id.au>
Date:   Wed, 04 Nov 2020 12:19:45 +1100
Message-ID: <87zh3xude6.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Michael Ellerman <mpe@ellerman.id.au> writes:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>> From: Nicholas Piggin <npiggin@gmail.com>
>>
>> [ Upstream commit 66acd46080bd9e5ad2be4b0eb1d498d5145d058e ]
>>
>> powerpc uses IPIs in some situations to switch a kernel thread away
>> from a lazy tlb mm, which is subject to the TLB flushing race
>> described in the changelog introducing ARCH_WANT_IRQS_OFF_ACTIVATE_MM.
>>
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>> Link: https://lore.kernel.org/r/20200914045219.3736466-3-npiggin@gmail.com
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  arch/powerpc/Kconfig                   | 1 +
>>  arch/powerpc/include/asm/mmu_context.h | 2 +-
>>  2 files changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
>> index f38d153d25861..0bc53f0e37c0f 100644
>> --- a/arch/powerpc/Kconfig
>> +++ b/arch/powerpc/Kconfig
>> @@ -152,6 +152,7 @@ config PPC
>>  	select ARCH_USE_BUILTIN_BSWAP
>>  	select ARCH_USE_CMPXCHG_LOCKREF		if PPC64
>>  	select ARCH_WANT_IPC_PARSE_VERSION
>> +	select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
>
> This depends on upstream commit:
>
>   d53c3dfb23c4 ("mm: fix exec activate_mm vs TLB shootdown and lazy tlb switching race")
>
>
> Which I don't see in 4.19 stable, or in the email thread here.
>
> So this shouldn't be backported to 4.19 unless that commit is also
> backported.

I just sent you a backport of d53c3dfb23c4 for 4.19.

cheers
