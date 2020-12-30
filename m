Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB222E75B0
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 03:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgL3Cdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Dec 2020 21:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgL3Cdu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Dec 2020 21:33:50 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D53C06179C;
        Tue, 29 Dec 2020 18:33:10 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id c12so8966254pfo.10;
        Tue, 29 Dec 2020 18:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=PfIl0EjmWMxnSF+EOk80ZAbjAPzwaEf3qyLecMl/XRc=;
        b=nDaFL5lxYCUZxEPCVotfMjioI5BLNIhicG92GYRl+bW9o7TrWxGxPe0PqDXDUdvxGL
         ovvYBF0bISGn/Zpzf1pyHYOdLFAxrz3UfAR1lXz51N/K03KuWE71VFegfMD1DDIP/drp
         KUhqJ9Fn3WcSfrmIuDfPZ/QOnNSC22L/Z/ORAmWhZN1D2xASIe52OucM/qXVfSayaGAT
         57fbAo1T7kYgyhJGZ9Evd5nqFiAIc1edFYHuzkkIxctQBFyOJMPSHfXVdoKBjZA9clIV
         kEZ8gdlTRJigmHZJrUOZzCZPE80ijU9zMl4P4nZYuEkJlMxEzvQaP8bXxzoxR5aFvcz5
         +Drg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=PfIl0EjmWMxnSF+EOk80ZAbjAPzwaEf3qyLecMl/XRc=;
        b=R6NiuCYK4Ut9dRe3OD4qgs8HrMmZEUHke/1bbzKnnsGMJ20knc4qNRR4hPm5K/Wsad
         2zc2F16BJ533Q0I4JJr/xLNLAAnjlrmWYOqA3kZcwQ4wdKLKY99WVUilz8XOZAgAWt8I
         P04aQ6HaTkn/i686C/eHr977CKP2EqUXveXjXa6MNkzgdfrLaCQxKJ8yY3X7s8r5zx+i
         m5Oirx2CQD7Rr48DOCH7705mJs0C/PsY1loSHUyjTWJBEL6yv1XKqNVuo+FBMfR6wshM
         Q5C4vsHM4bzRG5pEamm7dPwEBqWoPlWKRly71qY5qzkAsTiJi1HV+jz/tmIJKZb3jcxB
         wWbQ==
X-Gm-Message-State: AOAM532bt8w44ndQjX0cW6qCfB8jp3FwC+PXlkTaHlfhlYuF8Jp0cj9I
        a6zdbSEuYn8rN4buCSpDLbs=
X-Google-Smtp-Source: ABdhPJxrOi9/gzDcjAgCtPx6FdiSP/JyedYlzSeHtVs/umobQsm2fE2URPOa8A0aW0Z8ZJFEkl2N/w==
X-Received: by 2002:a63:c04b:: with SMTP id z11mr50606521pgi.74.1609295589813;
        Tue, 29 Dec 2020 18:33:09 -0800 (PST)
Received: from localhost (193-116-97-30.tpgi.com.au. [193.116.97.30])
        by smtp.gmail.com with ESMTPSA id 6sm39988438pfj.216.2020.12.29.18.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Dec 2020 18:33:08 -0800 (PST)
Date:   Wed, 30 Dec 2020 12:33:02 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [RFC please help] membarrier: Rewrite sync_core_before_usermode()
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jann Horn <jannh@google.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Andy Lutomirski <luto@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        paulmck <paulmck@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        stable <stable@vger.kernel.org>, Will Deacon <will@kernel.org>,
        x86 <x86@kernel.org>
References: <20201228102537.GG1551@shell.armlinux.org.uk>
        <CALCETrWQx0qwthBc5pJBxs2PWAQo-roAz-6g=7HOs+dsiokVsg@mail.gmail.com>
        <CAG48ez0YZ_iy6qZpdGUj38wqeg_NzLHHhU-mBCBf5hcopYGVPg@mail.gmail.com>
        <20201228190852.GI1551@shell.armlinux.org.uk>
        <CALCETrVpvrBufrJgXNY=ogtZQLo7zgxQmD7k9eVCFjcdcvarmA@mail.gmail.com>
        <1086654515.3607.1609187556216.JavaMail.zimbra@efficios.com>
        <CALCETrXx3Xe+4Y6WM-mp0cTUU=r3bW6PV2b25yA8bm1Gvak6wQ@mail.gmail.com>
        <1609200902.me5niwm2t6.astroid@bobo.none>
        <CALCETrX6MOqmN5_jhyO1jJB7M3_T+hbomjxPYZLJmLVNmXAVzA@mail.gmail.com>
        <1609210162.4d8dqilke6.astroid@bobo.none>
        <20201229104456.GK1551@shell.armlinux.org.uk>
In-Reply-To: <20201229104456.GK1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Message-Id: <1609290821.wrfh89v23a.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Excerpts from Russell King - ARM Linux admin's message of December 29, 2020=
 8:44 pm:
> On Tue, Dec 29, 2020 at 01:09:12PM +1000, Nicholas Piggin wrote:
>> I think it should certainly be documented in terms of what guarantees
>> it provides to application, _not_ the kinds of instructions it may or
>> may not induce the core to execute. And if existing API can't be
>> re-documented sanely, then deprecatd and new ones added that DTRT.
>> Possibly under a new system call, if arch's like ARM want a range
>> flush and we don't want to expand the multiplexing behaviour of
>> membarrier even more (sigh).
>=20
> The 32-bit ARM sys_cacheflush() is there only to support self-modifying
> code, and takes whatever actions are necessary to support that.
> Exactly what actions it takes are cache implementation specific, and
> should be of no concern to the caller, but the underlying thing is...
> it's to support self-modifying code.

   Caveat
       cacheflush()  should  not  be used in programs intended to be portab=
le.
       On Linux, this call first appeared on the MIPS architecture, but  no=
wa=E2=80=90
       days, Linux provides a cacheflush() system call on some other archit=
ec=E2=80=90
       tures, but with different arguments.

What a disaster. Another badly designed interface, although it didn't=20
originate in Linux it sounds like we weren't to be outdone so
we messed it up even worse.

flushing caches is neither necessary nor sufficient for code modification
on many processors. Maybe some old MIPS specific private thing was fine,
but certainly before it grew to other architectures, somebody should=20
have thought for more than 2 minutes about it. Sigh.

>=20
> Sadly, because it's existed for 20+ years, and it has historically been
> sufficient for other purposes too, it has seen quite a bit of abuse
> despite its design purpose not changing - it's been used by graphics
> drivers for example. They quickly learnt the error of their ways with
> ARMv6+, since it does not do sufficient for their purposes given the
> cache architectures found there.
>=20
> Let's not go around redesigning this after twenty odd years, requiring
> a hell of a lot of pain to users. This interface is called by code
> generated by GCC, so to change it you're looking at patching GCC as
> well as the kernel, and you basically will make new programs
> incompatible with older kernels - very bad news for users.

For something to be redesigned it had to have been designed in the first=20
place, so there is no danger of that don't worry... But no I never=20
suggested making incompatible changes to any existing system call, I=20
said "re-documented". And yes I said deprecated but in Linux that really=20
means kept indefinitely.

If ARM, MIPS, 68k etc programs and toolchains keep using what they are=20
using it'll keep working no problem.

The point is we're growing new interfaces, and making the same mistakes.=20
It's not portable (ARCH_HAS_MEMBARRIER_SYNC_CORE), it's also specified=20
in terms of low level processor operations rather than higher level=20
intent, and also is not sufficient for self-modifying code (without=20
additional cache flush on some processors).

The application wants a call that says something like "memory modified=20
before the call will be visible as instructions (including illegal=20
instructions) by all threads in the program after the system call=20
returns, and no threads will be subject to any effects of executing the=20
previous contents of that memory.

So I think the basics are simple (although should confirm with some JIT=20
and debugger etc developers, and not just Android mind you). There are=20
some complications in details, address ranges, virtual/physical, thread=20
local vs process vs different process or system-wide, memory ordering=20
and propagation of i and d sides, etc. But that can be worked through,=20
erring on the side of sanity rather than pointless micro-optmisations.

Thanks,
Nick
