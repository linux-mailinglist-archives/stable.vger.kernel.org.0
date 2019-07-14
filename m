Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C90667D94
	for <lists+stable@lfdr.de>; Sun, 14 Jul 2019 07:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbfGNFyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jul 2019 01:54:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbfGNFyh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Jul 2019 01:54:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1036020838;
        Sun, 14 Jul 2019 05:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563083676;
        bh=lCATJxLCIl0waEr1Vq9Lc4u46c1a2350/LFLTXbTgXs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=guFfydS1kJCH4tg0h6fdcpna/zRAbHCwYxU08SmdfU6VfqO3oVrDIh+VBLHghingw
         JtZIfLwL1fN5oOl9E348P4MlIWVMbcf4QYbukxMWGeLvac/N/+zt+pR9aqAdy9CxG/
         58656HLvbJ2/B4sA491044IngulrT1wIaQtPwD5I=
Date:   Sun, 14 Jul 2019 07:54:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     kbuild test robot <lkp@intel.com>, Sasha Levin <sashal@kernel.org>,
        kbuild@01.org, Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com, stable@vger.kernel.org
Subject: Re: [linux-stable-rc:linux-4.14.y 9981/9999]
 arch/x86/kernel/ptrace.c:659:22: warning: ISO C90 forbids mixing
 declarations and code
Message-ID: <20190714055433.GA8005@kroah.com>
References: <201907140611.AydIXYEe%lkp@intel.com>
 <20190714034125.GA90669@archlinux-threadripper>
 <20190714034554.GD90669@archlinux-threadripper>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190714034554.GD90669@archlinux-threadripper>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 13, 2019 at 08:45:54PM -0700, Nathan Chancellor wrote:
> On Sat, Jul 13, 2019 at 08:41:25PM -0700, Nathan Chancellor wrote:
> > On Sun, Jul 14, 2019 at 06:55:15AM +0800, kbuild test robot wrote:
> > > CC: kbuild-all@01.org
> > > TO: Dianzhang Chen <dianzhangchen0@gmail.com>
> > > CC: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> > > CC: Thomas Gleixner <tglx@linutronix.de>
> > > 
> > > tree:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> > > head:   728f3eef5bdde0f9516277b4c4519fa5436e7e5d
> > > commit: 55ac552ebd34f9687cc1bdcb07006bf7f104dc99 [9981/9999] x86/ptrace: Fix possible spectre-v1 in ptrace_get_debugreg()
> > > config: x86_64-rhel-7.2 (attached as .config)
> > > compiler: clang version 9.0.0 (git://gitmirror/llvm_project 87856e739c8e55f3b4e0f37baaf93308ec2dbd47)
> > > reproduce:
> > >         git checkout 55ac552ebd34f9687cc1bdcb07006bf7f104dc99
> > >         # save the attached .config to linux build tree
> > >         make ARCH=x86_64 
> > > 
> > > If you fix the issue, kindly add following tag
> > > Reported-by: kbuild test robot <lkp@intel.com>
> > > 
> > > All warnings (new ones prefixed by >>):
> > > 
> > > >> arch/x86/kernel/ptrace.c:659:22: warning: ISO C90 forbids mixing declarations and code [-Wdeclaration-after-statement]
> > >                    struct perf_event *bp = thread->ptrace_bps[index];
> > >                                       ^
> > >    1 warning generated.
> > > 
> > > vim +659 arch/x86/kernel/ptrace.c
> > > 
> > > ---
> > > 0-DAY kernel test infrastructure                Open Source Technology Center
> > > https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> > 
> > Hi Greg and Sasha,
> > 
> > I was going to reply to this on the GCC version of the thread but I
> > don't really see a way to get the original message or the message ID
> > from the web archive since I'm not subscribed to that list :(
> > 
> > https://lists.01.org/pipermail/kbuild-all/2019-July/062379.html
> > 
> > This is not an issue in Linus' tree because he fixed it manually during
> > the merge:
> > 
> > https://lore.kernel.org/lkml/CAHk-=whhq5RQYNKzHOLqC+gzSjmcEGNJjbC=Psc_vQaCx4TCKg@mail.gmail.com/
> > 
> > I would say that it isn't unreasonable to fold that fixup into the
> > original patch, with a note that it came from Linus' merge upstream:
> > 
> > 223cea6a4f05 ("Merge branch 'x86-pti-for-linus' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip").
> > 
> > Cheers,
> > Nathan
> 
> Re-adding our list, which I messed up when adding stable. Sorry for the
> noise :(

Ah, didn't realize it was fixed during the merge, will do the same thing
here and tweak the original patch.

thanks,

greg k-h
