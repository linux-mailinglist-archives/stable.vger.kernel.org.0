Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04DE8307A38
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 17:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbhA1QBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 11:01:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40549 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231637AbhA1QBw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 11:01:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611849626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PxuJh50+g/cku2d0UPfXOTSyCQOYqdgJFNW+IzFd4fc=;
        b=IFx4jA9aMomtdMVlag6S75/FPNSkTVhgrcTomQ39emWRQdBKprTxp1VfCvqjMHShYEGFTX
        nT6zgpwL6TjonSO+KONvXnj3/B9+G8Jfw5adXKuE5QlgxRMMdM1PYZ9YrhKshRgSqSd/Fg
        AsUpl0A1ekVGnC3YzLilw6Ocw5/LrJ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-beUSGt48MliPEebyqsePnQ-1; Thu, 28 Jan 2021 11:00:22 -0500
X-MC-Unique: beUSGt48MliPEebyqsePnQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 549E5107ACF9;
        Thu, 28 Jan 2021 16:00:18 +0000 (UTC)
Received: from treble (ovpn-120-118.rdu2.redhat.com [10.10.120.118])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 892BB5D9EF;
        Thu, 28 Jan 2021 16:00:17 +0000 (UTC)
Date:   Thu, 28 Jan 2021 10:00:15 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Chris Clayton <chris2553@googlemail.com>
Cc:     Thomas Backlund <tmb@tmb.nu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        torvic9@mailbox.org
Subject: Re: linux-5.10.11 build failure
Message-ID: <20210128160015.phaovyou2m2fgcpi@treble>
References: <8b3e9d93-1381-b415-9ece-a10fb098b896@tmb.nu>
 <9617db49-cf67-3b48-1b31-3bcd34cf3e1a@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9617db49-cf67-3b48-1b31-3bcd34cf3e1a@googlemail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 28, 2021 at 01:38:25PM +0000, Chris Clayton wrote:
> Thanks, Thomas.
> 
> On 28/01/2021 11:24, Thomas Backlund wrote:
> > Den 28.1.2021 kl. 12:05, skrev Chris Clayton:
> >>
> >> On 28/01/2021 09:34, Greg Kroah-Hartman wrote:
> >>> On Thu, Jan 28, 2021 at 09:17:10AM +0000, Chris Clayton wrote:
> >>>> Hi,
> >>>>
> >>>> Building 5.10.11 fails on my (x86-64) laptop thusly:
> >>>>
> >>>> ..
> >>>>
> >>>>   AS      arch/x86/entry/thunk_64.o
> >>>>    CC      arch/x86/entry/vsyscall/vsyscall_64.o
> >>>>    AS      arch/x86/realmode/rm/header.o
> >>>>    CC      arch/x86/mm/pat/set_memory.o
> >>>>    CC      arch/x86/events/amd/core.o
> >>>>    CC      arch/x86/kernel/fpu/init.o
> >>>>    CC      arch/x86/entry/vdso/vma.o
> >>>>    CC      kernel/sched/core.o
> >>>> arch/x86/entry/thunk_64.o: warning: objtool: missing symbol for insn at offset 0x3e
> >>>>
> >>>>    AS      arch/x86/realmode/rm/trampoline_64.o
> >>>> make[2]: *** [scripts/Makefile.build:360: arch/x86/entry/thunk_64.o] Error 255
> >>>> make[2]: *** Deleting file 'arch/x86/entry/thunk_64.o'
> >>>> make[2]: *** Waiting for unfinished jobs....
> >>>>
> >>>> ..
> >>>>
> >>>> Compiler is latest snapshot of gcc-10.
> >>>>
> >>>> Happy to test the fix but please cc me as I'm not subscribed
> >>>
> >>> Can you do 'git bisect' to track down the offending commit?
> >>>
> >>
> >> Sure, but I'll hold that request for a while. I updated to binutils-2.36 on Monday and I'm pretty sure that is a feature
> >> of this build fail. I've reverted binutils to 2.35.1, and the build succeeds. Updated to 2.36 again and, surprise,
> >> surprise, the kernel build fails again.
> >>
> >> I've had a glance at the binutils ML and there are all sorts of issues being reported, but it's beyond my knowledge to
> >> assess if this build error is related to any of them.
> >>
> >> I'll stick with binutils-2.35.1 for the time being.
> >>
> >>> And what exact gcc version are you using?
> >>>
> >>
> >>   It's built from the 10-20210123 snapshot tarball.
> >>
> >> I can report this to the binutils folks, but might it be better if the objtool maintainer looks at it first? The
> >> binutils change might just have opened the gate to a bug in objtool.
> >>
> >>> thanks,
> >>>
> >>> greg k-h
> >>>
> >>
> > 
> > 
> > AFAIK you need this in stable trees:
> > 
> >  From 1d489151e9f9d1647110277ff77282fe4d96d09b Mon Sep 17 00:00:00 2001
> > From: Josh Poimboeuf <jpoimboe@redhat.com>
> > Date: Thu, 14 Jan 2021 16:14:01 -0600
> > Subject: [PATCH] objtool: Don't fail on missing symbol table
> > 
> > 
> 
> That may be the caae, but it doesn't fix the build failure I've reported in this thread. However, as suggested by Tor,
> https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/patch/?id=5e6dca82bcaa49348f9e5fcb48df4881f6d6c4ae does fix it.
> 
> That hasn't made Linus' tree yet and I don't see a pull request, but it is in linux-next so I guess it could make it in
> -rc6.

I mistakenly thought this was already in Linus' tree and submitted this
patch to stable a few days ago.

I talked to Boris (-tip maintainer), he's going to submit a pull request
to Linus this weekend.

-- 
Josh

