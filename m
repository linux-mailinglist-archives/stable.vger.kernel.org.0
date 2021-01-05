Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 496152EAFE5
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 17:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbhAEQVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 11:21:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbhAEQVd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 11:21:33 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032B5C061793
        for <stable@vger.kernel.org>; Tue,  5 Jan 2021 08:20:53 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id z21so164627pgj.4
        for <stable@vger.kernel.org>; Tue, 05 Jan 2021 08:20:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=YY+00AIRRtxJBsSmjelg+ZTD3PBDsqcfuNjtpAy6QDo=;
        b=B4eaIy0X/gcJ+6Vfog9DvYrA5lzlSG1wkFyLGirBvNF++rcgXb/U/8jhqrKJZpN6Ff
         0c8/ST4Y+qwjFXVzERQhJpi6yTRl3MeWGI52OW0gJiRDmDyMS9lrtLx5MMYGnO6m9nDj
         sJO8YD5Q0cHMp9+vJ7cFvE/kzbIMKBbVsXltojydDYvFaFlO4AT7V7PpJ8O7vDfqxTNv
         pX5bMba8hKh/rsPyD87PZAOoUfCCsdQzHoHE+jnjagNvEPIoUjiM2GyEikkEjDoZMdhr
         +I8KLgCyCzMrGsrIpyqBQr2zTMwcxmWNZzNXEWomxCEFyBeKPYoBx7R8MHsoobR+fvSI
         x3MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=YY+00AIRRtxJBsSmjelg+ZTD3PBDsqcfuNjtpAy6QDo=;
        b=lBDGvJXtR3mOXNumjrE6msA1wAQZnAmSV5FWM8TXxTkeYbkmjdvnW2z7e0erb3tWbL
         PbTON6JJBiu8kbYdDq2WT8ignZ19Ql0IgLtglYs80GnaMHtrFVHOu1J1pIOPSO3AGDDW
         latGRdeq/tkBVLk2mqO6OujF/h6rNkyr+hWxNqfgRw6iNyd00p/6dYTFDMBho8WXfT6v
         DzxKSKStgIb4Wrm7kIeGK/3QBmUxp2nSvlD+HKZ554bjgQWCEnOuMLNbypCS0vwBxuN0
         lvZDU6XXSF+idwWuxasqcGKZYaHNxHhY8IN09fXl1AxUU9tuN/qzLL+2GezuTkhU9W+w
         gV1g==
X-Gm-Message-State: AOAM531++Ju9AmdJqo82I/CPVTjcO3420IB5SWdbYg9m4t/MVWhGwSoc
        XtwK/sFAFV49y90hfrBM8IOsXw==
X-Google-Smtp-Source: ABdhPJxa5mdRi43w+JAj2QFqGTiJMOhmPhoSZTCD5EpNlZP1Ra7Be1Mha7b3xYN6GHbxzVuUSGXQhg==
X-Received: by 2002:aa7:954b:0:b029:19e:cb57:f3c with SMTP id w11-20020aa7954b0000b029019ecb570f3cmr253102pfq.51.1609863653323;
        Tue, 05 Jan 2021 08:20:53 -0800 (PST)
Received: from ?IPv6:2601:646:c200:1ef2:1960:9abe:3fe9:fd99? ([2601:646:c200:1ef2:1960:9abe:3fe9:fd99])
        by smtp.gmail.com with ESMTPSA id y27sm131408pfr.78.2021.01.05.08.20.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jan 2021 08:20:52 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC please help] membarrier: Rewrite sync_core_before_usermode()
Date:   Tue, 5 Jan 2021 08:20:51 -0800
Message-Id: <7BFAB97C-1949-46A3-A1E2-DFE108DC7D5E@amacapital.net>
References: <20210105132623.GB11108@willie-the-truck>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        X86 ML <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        stable <stable@vger.kernel.org>
In-Reply-To: <20210105132623.GB11108@willie-the-truck>
To:     Will Deacon <will@kernel.org>
X-Mailer: iPhone Mail (18B121)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Jan 5, 2021, at 5:26 AM, Will Deacon <will@kernel.org> wrote:
>=20
> =EF=BB=BFHi Andy,
>=20
> Sorry for the slow reply, I was socially distanced from my keyboard.
>=20
>> On Mon, Dec 28, 2020 at 04:36:11PM -0800, Andy Lutomirski wrote:
>> On Mon, Dec 28, 2020 at 4:11 PM Nicholas Piggin <npiggin@gmail.com> wrote=
:
>>>> +static inline void membarrier_sync_core_before_usermode(void)
>>>> +{
>>>> +     /*
>>>> +      * XXX: I know basically nothing about powerpc cache management.
>>>> +      * Is this correct?
>>>> +      */
>>>> +     isync();
>>>=20
>>> This is not about memory ordering or cache management, it's about
>>> pipeline management. Powerpc's return to user mode serializes the
>>> CPU (aka the hardware thread, _not_ the core; another wrongness of
>>> the name, but AFAIKS the HW thread is what is required for
>>> membarrier). So this is wrong, powerpc needs nothing here.
>>=20
>> Fair enough.  I'm happy to defer to you on the powerpc details.  In
>> any case, this just illustrates that we need feedback from a person
>> who knows more about ARM64 than I do.
>=20
> I think we're in a very similar boat to PowerPC, fwiw. Roughly speaking:
>=20
>  1. SYNC_CORE does _not_ perform any cache management; that is the
>     responsibility of userspace, either by executing the relevant
>     maintenance instructions (arm64) or a system call (arm32). Crucially,
>     the hardware will ensure that this cache maintenance is broadcast
>     to all other CPUs.

Is this guaranteed regardless of any aliases?  That is, if I flush from one C=
PU at one VA and then execute the same physical address from another CPU at a=
 different VA, does this still work?

>=20
>  2. Even with all the cache maintenance in the world, a CPU could have
>     speculatively fetched stale instructions into its "pipeline" ahead of
>     time, and these are _not_ flushed by the broadcast maintenance instruc=
tions
>     in (1). SYNC_CORE provides a means for userspace to discard these stal=
e
>     instructions.
>=20
>  3. The context synchronization event on exception entry/exit is
>     sufficient here. The Arm ARM isn't very good at describing what it
>     does, because it's in denial about the existence of a pipeline, but
>     it does have snippets such as:
>=20
>    (s/PE/CPU/)
>       | For all types of memory:
>       | The PE might have fetched the instructions from memory at any time=

>       | since the last Context synchronization event on that PE.
>=20
>     Interestingly, the architecture recently added a control bit to remove=

>     this synchronisation from exception return, so if we set that then we'=
d
>     have a problem with SYNC_CORE and adding an ISB would be necessary (an=
d
>     we could probable then make kernel->kernel returns cheaper, but I
>     suspect we're relying on this implicit synchronisation in other places=

>     too).
>=20

Is ISB just a context synchronization event or does it do more?

On x86, it=E2=80=99s very hard to tell that MFENCE does any more than LOCK, b=
ut it=E2=80=99s much slower.  And we have LFENCE, which, as documented, does=
n=E2=80=99t appear to have any semantics at all.  (Or at least it didn=E2=80=
=99t before Spectre.)

> Are you seeing a problem in practice, or did this come up while trying to
> decipher the semantics of SYNC_CORE?

It came up while trying to understand the code and work through various bugs=
 in it.  The code was written using something approximating x86 terminology,=
 but it was definitely wrong on x86 (at least if you believe the SDM, and I h=
aven=E2=80=99t convinced any architects to say otherwise).

Thanks!

>=20
> Will
