Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206AE2E6CC0
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 01:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgL2AMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 19:12:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727527AbgL2AME (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 19:12:04 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30ACAC0613D6;
        Mon, 28 Dec 2020 16:11:24 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id d2so7120517pfq.5;
        Mon, 28 Dec 2020 16:11:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=+x0jg3kgtAnVsZSiLJVqeiqq/kBhePK5zrv50jFdLuw=;
        b=IRcovKNGSDtnXPhGzyqD7eyJ8xFOY06mgqPAH+dIQcl1Q2qBdd1KfvZaTUAaCWSouR
         OF7dcFcaTAAMkiQ4Hc9JLvPgOFnEetNx9BpimyxpCVgv5ifpx10XC+yZKl/JOtC2OMn5
         M7kgyvd1BUR1+0S8aDjsWCCD6Jk6pPEHO9a3j4oayoVYcGXLLAEd/4eyc0h/83/pqHG4
         j55aC4Z20m1D1cMPUX8l+BkAtcB7XVS5+AAW/HS7DDlCE+UJYC6/HCTjzt0dkdDs7Qql
         j4eXnCP8ybnbZ0qK8O+2WMlivBPVkLMSTzR3m+dS3hyeR5ZLkae8RJawpTHjti7+jC68
         zytg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=+x0jg3kgtAnVsZSiLJVqeiqq/kBhePK5zrv50jFdLuw=;
        b=IaykZzuJpx/3kpfPLaLAwB6esqo3Sr/2x0uH3abmRagU+PQv5WF/qSDYjgRKAg/W2b
         8Rq5iXZoW3QXTn1gOL7FPVWOtY/fUL/MGnAaTJeVJU5h+7xAhDX1wrmtaNnD5t9/2Gbi
         YWBGsICKTpx9K8Z9W08aHM9umXLSdaFxyOJNhVcnLStBHredDmjjDhNOsI134vg0Keo9
         eDCVlX0Rl1s/oXLQv0n4CTtGopXOadswsC/myf6pd0uERamj59rdryb65ZG7tzDsjuJb
         DOezVaTeLuXm8O0CbPoFIsm2C8ygK9ecrCPRHBEh2g5VhH5gh3xpSe5A1helLEi6UphJ
         KJEQ==
X-Gm-Message-State: AOAM5336z05zchd1EinDGZDjdAHQ43SJ6KpTGpNFXIJu9SkEPSi/RaUN
        IMsmDZr1Cx0AD71hQgysor5vZodKvkE=
X-Google-Smtp-Source: ABdhPJziWQaDuQ55fGtxjE6fQbAeK72BPSalCM5Tcc9+bonmCukOTiRZskRtE1A/1ZjpqIusBtl70w==
X-Received: by 2002:a62:63c5:0:b029:1a9:3a46:7d32 with SMTP id x188-20020a6263c50000b02901a93a467d32mr43109410pfb.39.1609200683417;
        Mon, 28 Dec 2020 16:11:23 -0800 (PST)
Received: from localhost (193-116-97-30.tpgi.com.au. [193.116.97.30])
        by smtp.gmail.com with ESMTPSA id 92sm589278pjv.15.2020.12.28.16.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 16:11:22 -0800 (PST)
Date:   Tue, 29 Dec 2020 10:11:16 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [RFC please help] membarrier: Rewrite sync_core_before_usermode()
To:     Andy Lutomirski <luto@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        x86@kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>, stable@vger.kernel.org,
        Will Deacon <will@kernel.org>
References: <bf59ecb5487171a852bcc8cdd553ec797aedc485.1609093476.git.luto@kernel.org>
In-Reply-To: <bf59ecb5487171a852bcc8cdd553ec797aedc485.1609093476.git.luto@kernel.org>
MIME-Version: 1.0
Message-Id: <1609199804.yrsu9vagzk.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Excerpts from Andy Lutomirski's message of December 28, 2020 4:28 am:
> The old sync_core_before_usermode() comments said that a non-icache-synci=
ng
> return-to-usermode instruction is x86-specific and that all other
> architectures automatically notice cross-modified code on return to
> userspace.  Based on my general understanding of how CPUs work and based =
on
> my atttempt to read the ARM manual, this is not true at all.  In fact, x8=
6
> seems to be a bit of an anomaly in the other direction: x86's IRET is
> unusually heavyweight for a return-to-usermode instruction.

"sync_core_before_usermode" as I've said says nothing to arch, or to the=20
scheduler, or to membarrier. It's badly named to start with so if=20
renaming it it should be something else. exit_lazy_tlb() at least says
something quite precise to scheudler and arch code that implements
the membarrier.

But I don't mind the idea of just making it x86 specific if as you say the
arch code can detect lazy mm switches more precisely than generic and=20
you want to do that.

> So let's drop any pretense that we can have a generic way implementation
> behind membarrier's SYNC_CORE flush and require all architectures that op=
t
> in to supply their own.  This means x86, arm64, and powerpc for now.  Let=
's
> also rename the function from sync_core_before_usermode() to
> membarrier_sync_core_before_usermode() because the precise flushing detai=
ls
> may very well be specific to membarrier, and even the concept of
> "sync_core" in the kernel is mostly an x86-ism.

The concept of "sync_core" (x86: serializing instruction, powerpc: context
synchronizing instruction, etc) is not an x86-ism at all. x86 just wanted
to add a serializing instruction to generic code so it grew this nasty API,
but the concept applies broadly.

>=20
> I admit that I'm rather surprised that the code worked at all on arm64,
> and I'm suspicious that it has never been very well tested.  My apologies
> for not reviewing this more carefully in the first place.


>=20
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: x86@kernel.org
> Cc: stable@vger.kernel.org
> Fixes: 70216e18e519 ("membarrier: Provide core serializing command, *_SYN=
C_CORE")
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
>=20
> Hi arm64 and powerpc people-
>=20
> This is part of a series here:
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/log/?h=3Dx=
86/fixes
>=20
> Before I send out the whole series, I'm hoping that some arm64 and powerp=
c
> people can help me verify that I did this patch right.  Once I get
> some feedback on this patch, I'll send out the whole pile.  And once
> *that's* done, I'll start giving the mm lazy stuff some serious thought.
>=20
> The x86 part is already fixed in Linus' tree.
>=20
> Thanks,
> Andy
>=20
>  arch/arm64/include/asm/sync_core.h   | 21 +++++++++++++++++++++
>  arch/powerpc/include/asm/sync_core.h | 20 ++++++++++++++++++++
>  arch/x86/Kconfig                     |  1 -
>  arch/x86/include/asm/sync_core.h     |  7 +++----
>  include/linux/sched/mm.h             |  1 -
>  include/linux/sync_core.h            | 21 ---------------------
>  init/Kconfig                         |  3 ---
>  kernel/sched/membarrier.c            | 15 +++++++++++----
>  8 files changed, 55 insertions(+), 34 deletions(-)
>  create mode 100644 arch/arm64/include/asm/sync_core.h
>  create mode 100644 arch/powerpc/include/asm/sync_core.h
>  delete mode 100644 include/linux/sync_core.h
>=20
> diff --git a/arch/arm64/include/asm/sync_core.h b/arch/arm64/include/asm/=
sync_core.h
> new file mode 100644
> index 000000000000..5be4531caabd
> --- /dev/null
> +++ b/arch/arm64/include/asm/sync_core.h
> @@ -0,0 +1,21 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_ARM64_SYNC_CORE_H
> +#define _ASM_ARM64_SYNC_CORE_H
> +
> +#include <asm/barrier.h>
> +
> +/*
> + * Ensure that the CPU notices any instruction changes before the next t=
ime
> + * it returns to usermode.
> + */
> +static inline void membarrier_sync_core_before_usermode(void)
> +{
> +	/*
> +	 * XXX: is this enough or do we need a DMB first to make sure that
> +	 * writes from other CPUs become visible to this CPU?  We have an
> +	 * smp_mb() already, but that's not quite the same thing.
> +	 */
> +	isb();
> +}
> +
> +#endif /* _ASM_ARM64_SYNC_CORE_H */
> diff --git a/arch/powerpc/include/asm/sync_core.h b/arch/powerpc/include/=
asm/sync_core.h
> new file mode 100644
> index 000000000000..71dfbe7794e5
> --- /dev/null
> +++ b/arch/powerpc/include/asm/sync_core.h
> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_POWERPC_SYNC_CORE_H
> +#define _ASM_POWERPC_SYNC_CORE_H
> +
> +#include <asm/barrier.h>
> +
> +/*
> + * Ensure that the CPU notices any instruction changes before the next t=
ime
> + * it returns to usermode.
> + */
> +static inline void membarrier_sync_core_before_usermode(void)
> +{
> +	/*
> +	 * XXX: I know basically nothing about powerpc cache management.
> +	 * Is this correct?
> +	 */
> +	isync();

This is not about memory ordering or cache management, it's about=20
pipeline management. Powerpc's return to user mode serializes the
CPU (aka the hardware thread, _not_ the core; another wrongness of
the name, but AFAIKS the HW thread is what is required for
membarrier). So this is wrong, powerpc needs nothing here.

Thanks,
Nick

