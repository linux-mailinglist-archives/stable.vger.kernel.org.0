Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A3D2E7850
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 12:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgL3L6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 06:58:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbgL3L6J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Dec 2020 06:58:09 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0546C061799;
        Wed, 30 Dec 2020 03:57:28 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id be12so8591573plb.4;
        Wed, 30 Dec 2020 03:57:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=lyZez/TPJWN6sWd8vUs5LfzoEmRCXqZhMj6jVw0JL/c=;
        b=czOilpTrKnk++/HN6biw+tuZpOy1CyqfQe54Cv9eZOXtvBnV3GFIsusJj7FMJAiZgk
         BZbhSTF2fbeQgX2WSdVpy4HVUMDm0Z1KQNXuSEu+wvoe2y/FRgn77wTZeb/6AQxQlYiX
         myUHZXI9K3wvIzmnUlNDx4j9ejPFW1HeLbMexhxxCZ8/vYk4Wmt7ugM5YyZ2/yi4GqTw
         hMQSd+CPkMS+R14fOSpiExEzTlybi3a2UpaOgvFKQMnp5iD6L/0OqOwfmKxLKZX2TEhD
         5UkwfGUDdf9R4ZaltSXJyDnclPg2xX2XIwS4nUrHCDw8Mo8HgPpyO/bsbLYRNL7oQjba
         2wGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=lyZez/TPJWN6sWd8vUs5LfzoEmRCXqZhMj6jVw0JL/c=;
        b=W9nTHTu3bn5/+Y7cNL2pQZ/a2zKOHd64q8T8qnTbFCTNt9Zj4rijHdXhUFE8IPzIY/
         1cY8ZakR7/rgbIyRrwB/gEfoDhsJrIOyucYgGm/cC1aV3ch83KjaeHRjg/Eu26x5B+PT
         XiwYG7yQYr1Bq+icHeASA6MD4RtZVLaZRpCpeWJpmqyWjiupHTXpJzKAe88Mp4JCTw7k
         FMck1LK5bWhBUO8eea1QDFlNI7NGkLoBxC7tFD8uvrWxo4Junne1V8s8179gcp3p2ZSg
         XSzGkNC/WtYaauJ7UX5yGTkdrE8jiatrcIKLen3034LcHSyRknPaOktE2A8eypXUTa/W
         +ZrA==
X-Gm-Message-State: AOAM530+PPzjt6OiookMD3C1NmJfdkQRbF43xq7ub57aJigdhwWdKQTY
        nlWT+9CrPGoXVyawko9orbpsM4brAPA=
X-Google-Smtp-Source: ABdhPJze2Hr5s+OaI6p57qfWIefx8fVHgwpydEG8SuiTXCiXqCHXJZ8R8YLZ5fwL2VWdQJCmb2R3lQ==
X-Received: by 2002:a17:90a:1b66:: with SMTP id q93mr8219927pjq.133.1609329448436;
        Wed, 30 Dec 2020 03:57:28 -0800 (PST)
Received: from localhost (193-116-97-30.tpgi.com.au. [193.116.97.30])
        by smtp.gmail.com with ESMTPSA id e13sm44423131pfj.63.2020.12.30.03.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Dec 2020 03:57:27 -0800 (PST)
Date:   Wed, 30 Dec 2020 21:57:21 +1000
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
References: <20201228190852.GI1551@shell.armlinux.org.uk>
        <CALCETrVpvrBufrJgXNY=ogtZQLo7zgxQmD7k9eVCFjcdcvarmA@mail.gmail.com>
        <1086654515.3607.1609187556216.JavaMail.zimbra@efficios.com>
        <CALCETrXx3Xe+4Y6WM-mp0cTUU=r3bW6PV2b25yA8bm1Gvak6wQ@mail.gmail.com>
        <1609200902.me5niwm2t6.astroid@bobo.none>
        <CALCETrX6MOqmN5_jhyO1jJB7M3_T+hbomjxPYZLJmLVNmXAVzA@mail.gmail.com>
        <1609210162.4d8dqilke6.astroid@bobo.none>
        <20201229104456.GK1551@shell.armlinux.org.uk>
        <1609290821.wrfh89v23a.astroid@bobo.none>
        <20201230100028.GP1551@shell.armlinux.org.uk>
        <20201230105847.GQ1551@shell.armlinux.org.uk>
In-Reply-To: <20201230105847.GQ1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Message-Id: <1609327110.c18a3h158t.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Excerpts from Russell King - ARM Linux admin's message of December 30, 2020=
 8:58 pm:
> On Wed, Dec 30, 2020 at 10:00:28AM +0000, Russell King - ARM Linux admin =
wrote:
>> On Wed, Dec 30, 2020 at 12:33:02PM +1000, Nicholas Piggin wrote:
>> > Excerpts from Russell King - ARM Linux admin's message of December 29,=
 2020 8:44 pm:
>> > > On Tue, Dec 29, 2020 at 01:09:12PM +1000, Nicholas Piggin wrote:
>> > >> I think it should certainly be documented in terms of what guarante=
es
>> > >> it provides to application, _not_ the kinds of instructions it may =
or
>> > >> may not induce the core to execute. And if existing API can't be
>> > >> re-documented sanely, then deprecatd and new ones added that DTRT.
>> > >> Possibly under a new system call, if arch's like ARM want a range
>> > >> flush and we don't want to expand the multiplexing behaviour of
>> > >> membarrier even more (sigh).
>> > >=20
>> > > The 32-bit ARM sys_cacheflush() is there only to support self-modify=
ing
>> > > code, and takes whatever actions are necessary to support that.
>> > > Exactly what actions it takes are cache implementation specific, and
>> > > should be of no concern to the caller, but the underlying thing is..=
.
>> > > it's to support self-modifying code.
>> >=20
>> >    Caveat
>> >        cacheflush()  should  not  be used in programs intended to be p=
ortable.
>> >        On Linux, this call first appeared on the MIPS architecture, bu=
t  nowa=E2=80=90
>> >        days, Linux provides a cacheflush() system call on some other a=
rchitec=E2=80=90
>> >        tures, but with different arguments.
>> >=20
>> > What a disaster. Another badly designed interface, although it didn't=20
>> > originate in Linux it sounds like we weren't to be outdone so
>> > we messed it up even worse.
>> >=20
>> > flushing caches is neither necessary nor sufficient for code modificat=
ion
>> > on many processors. Maybe some old MIPS specific private thing was fin=
e,
>> > but certainly before it grew to other architectures, somebody should=20
>> > have thought for more than 2 minutes about it. Sigh.
>>=20
>> WARNING: You are bordering on being objectionable and offensive with
>> that comment.
>>=20
>> The ARM interface was designed by me back in the very early days of
>> Linux, probably while you were still in dypers, based on what was
>> known at the time.  Back in the early 2000s, ideas such as relaxed
>> memory ordering were not known.  All there was was one level of
>> harvard cache.

I wasn't talking about memory ordering at all, and I assumed it
came earlier and was brought to Linux for portability reasons -

CONFORMING TO
       Historically, this system call was available on all MIPS UNIX  varia=
nts
       including RISC/os, IRIX, Ultrix, NetBSD, OpenBSD, and FreeBSD (and a=
lso
       on some non-UNIX MIPS operating systems), so that the existence of t=
his
       call in MIPS operating systems is a de-facto standard.

I don't think the call was totally unreasonable for incoherent virtual=20
caches or incoherent i/d caches etc. Although early unix system call interf=
ace
demonstrates that people understood how to define good interfaces that deal=
t
with intent at an abstract level rather than implementation -- munmap=20
doesn't specify anywhere that a TLB flush instruction must be executed,=20
for example. So "cacheflush" was obviously never a well designed interface=20
but rather the typical hardware-centric hack to get their stuff working
(which was fine for its purpose I'm sure).

>=20
> Sorry, I got that slightly wrong. Its origins on ARM were from 12 Dec
> 1998:
>=20
> http://www.armlinux.org.uk/developer/patches/viewpatch.php?id=3D88/1
>=20
> by Philip Blundell, and first appeared in the ARM
> pre-patch-2.1.131-19981214-1.gz. It was subsequently documented in the
> kernel sources by me in July 2001 in ARM patch-2.4.6-rmk2.gz. It has
> a slightly different signature: the third argument on ARM is a flags
> argument, whereas the MIPS code, it is some undocumented "cache"
> parameter.
>=20
> Whether the ARM version pre or post dates the MIPS code, I couldn't say.
> Whether it was ultimately taken from the MIPS implementation, again, I
> couldn't say.

I can, it was in MIPS in late 1.3 kernels at least. I would guess it
came from IRIX.

> However, please stop insulting your fellow developers ability to think.

Sorry, I was being melodramatic. Everyone makes mistakes or decisions
which with hindsight could have been better or were under some=20
constraint that isn't apparent. I shouldn't have suggested it indicated=20
thoughtlessness.

Thanks,
Nick
