Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA5673074BF
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 12:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbhA1L0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 06:26:38 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:55337 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbhA1LZo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 06:25:44 -0500
Date:   Thu, 28 Jan 2021 11:24:47 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tmb.nu;
        s=protonmail; t=1611833091;
        bh=nMo99p1zsBQ7qgU/WQffiE/LABS3uMEgG5nQn6ZvKR8=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=HTsblzOMyfn21uBXlL1657KKVZp+HuHAvwKKVKQRrZwOw//+pZhZaaFgRjcySTXf4
         qNbd3NzrUcRgzdPkqwsCBEbJ+jWiato5y2Mgbl5qSf+iOtYdOnwTRfvHRIQZUTHtAx
         gLYmJjBPePEq7u4goxKmgSCewDbAgimiN2VyCAno=
To:     Chris Clayton <chris2553@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Thomas Backlund <tmb@tmb.nu>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Reply-To: Thomas Backlund <tmb@tmb.nu>
Subject: Re: linux-5.10.11 build failure
Message-ID: <8b3e9d93-1381-b415-9ece-a10fb098b896@tmb.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Den 28.1.2021 kl. 12:05, skrev Chris Clayton:
>=20
> On 28/01/2021 09:34, Greg Kroah-Hartman wrote:
>> On Thu, Jan 28, 2021 at 09:17:10AM +0000, Chris Clayton wrote:
>>> Hi,
>>>
>>> Building 5.10.11 fails on my (x86-64) laptop thusly:
>>>
>>> ..
>>>
>>>   AS      arch/x86/entry/thunk_64.o
>>>    CC      arch/x86/entry/vsyscall/vsyscall_64.o
>>>    AS      arch/x86/realmode/rm/header.o
>>>    CC      arch/x86/mm/pat/set_memory.o
>>>    CC      arch/x86/events/amd/core.o
>>>    CC      arch/x86/kernel/fpu/init.o
>>>    CC      arch/x86/entry/vdso/vma.o
>>>    CC      kernel/sched/core.o
>>> arch/x86/entry/thunk_64.o: warning: objtool: missing symbol for insn at=
 offset 0x3e
>>>
>>>    AS      arch/x86/realmode/rm/trampoline_64.o
>>> make[2]: *** [scripts/Makefile.build:360: arch/x86/entry/thunk_64.o] Er=
ror 255
>>> make[2]: *** Deleting file 'arch/x86/entry/thunk_64.o'
>>> make[2]: *** Waiting for unfinished jobs....
>>>
>>> ..
>>>
>>> Compiler is latest snapshot of gcc-10.
>>>
>>> Happy to test the fix but please cc me as I'm not subscribed
>>
>> Can you do 'git bisect' to track down the offending commit?
>>
>=20
> Sure, but I'll hold that request for a while. I updated to binutils-2.36 =
on Monday and I'm pretty sure that is a feature
> of this build fail. I've reverted binutils to 2.35.1, and the build succe=
eds. Updated to 2.36 again and, surprise,
> surprise, the kernel build fails again.
>=20
> I've had a glance at the binutils ML and there are all sorts of issues be=
ing reported, but it's beyond my knowledge to
> assess if this build error is related to any of them.
>=20
> I'll stick with binutils-2.35.1 for the time being.
>=20
>> And what exact gcc version are you using?
>>
>=20
>   It's built from the 10-20210123 snapshot tarball.
>=20
> I can report this to the binutils folks, but might it be better if the ob=
jtool maintainer looks at it first? The
> binutils change might just have opened the gate to a bug in objtool.
>=20
>> thanks,
>>
>> greg k-h
>>
>=20


AFAIK you need this in stable trees:

 From 1d489151e9f9d1647110277ff77282fe4d96d09b Mon Sep 17 00:00:00 2001
From: Josh Poimboeuf <jpoimboe@redhat.com>
Date: Thu, 14 Jan 2021 16:14:01 -0600
Subject: [PATCH] objtool: Don't fail on missing symbol table


--
Thomas

