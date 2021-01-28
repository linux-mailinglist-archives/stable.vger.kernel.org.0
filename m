Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7646C307862
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 15:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbhA1Oml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 09:42:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:48990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231147AbhA1Omg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 09:42:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADE1064DD9;
        Thu, 28 Jan 2021 14:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611844915;
        bh=pZxcGYSKnQiztTa8HIdsqYzlFNUK3+5fl4t723SLFNo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jf2mi8vZk6PtxXGXRditcm/799lCCB4AFDd/C90LhaJ1SIopFOtTXZgqtWCdJB844
         ApBcqtgt9BWbGMA6yTUVT0whTaA2Re1RwkMqObmblyCjyozk1J7c5n2wE9rIywqNxd
         WT2NaSMCfEiYwMNtGbjC00iFLccYhhwUuawLpjJw=
Date:   Thu, 28 Jan 2021 15:41:52 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chris Clayton <chris2553@googlemail.com>
Cc:     Thomas Backlund <tmb@tmb.nu>, LKML <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, torvic9@mailbox.org
Subject: Re: linux-5.10.11 build failure
Message-ID: <YBLNMBmsrmD7HfY6@kroah.com>
References: <8b3e9d93-1381-b415-9ece-a10fb098b896@tmb.nu>
 <9617db49-cf67-3b48-1b31-3bcd34cf3e1a@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9617db49-cf67-3b48-1b31-3bcd34cf3e1a@googlemail.com>
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

Ok, thanks, so this is not a new regression for 5.10.y.

greg k-h
