Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2827F24E946
	for <lists+stable@lfdr.de>; Sat, 22 Aug 2020 20:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbgHVSbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Aug 2020 14:31:34 -0400
Received: from orcam.me.uk ([81.187.245.177]:32992 "EHLO orcam.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727893AbgHVSbe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Aug 2020 14:31:34 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Aug 2020 14:31:33 EDT
Received: from bugs.linux-mips.org (eddie.linux-mips.org [IPv6:2a01:4f8:201:92aa::3])
        by orcam.me.uk (Postfix) with ESMTPS id CC3F02BE086;
        Sat, 22 Aug 2020 19:24:49 +0100 (BST)
Date:   Sat, 22 Aug 2020 19:24:47 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@linux-mips.org>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
cc:     Greg KH <greg@kroah.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: VZ: Only include loongson_regs.h for
 CPU_LOONGSON64
In-Reply-To: <20200810093158.GA6026@alpha.franken.de>
Message-ID: <alpine.LFD.2.21.2008221913550.3460685@eddie.linux-mips.org>
References: <1596891052-24052-1-git-send-email-chenhc@lemote.com> <20200808153123.GC369184@kroah.com> <2b2937d0-eae6-a489-07bd-c40ded02ce89@flygoat.com> <20200809070235.GA1098081@kroah.com> <5ffc7bb1-8e3f-227a-7ad0-cec5fc32a96a@redhat.com>
 <20200810074417.GA1529187@kroah.com> <5522eef8-0da5-7f73-b2f8-2d0c19bb5819@redhat.com> <20200810090310.GA1837172@kroah.com> <20200810093158.GA6026@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 Aug 2020, Thomas Bogendoerfer wrote:

> > > It's not just this #include, there's a couple dozen mach-* directories;
> > > changing how they work would be up to the MIPS maintainers (CCed), and
> > > it would certainly not be a patch that can be merged in stable@ kernels.
> > > 
> > > arch/mips/kernel/cpu-probe.c has the same
> > > 
> > > #ifdef CONFIG_CPU_LOONGSON64
> > > #include <loongson_regs.h>
> > > 
> > > for example, so apparently they're good with this.  So if I don't pick
> > > up the patch to fix the build it would be in all likelihood merged by
> > > MIPS maintainers.  The only difference will be how long the build
> > > remains broken and the fact that they need to worry about KVM despite
> > > the presence of a specific maintainer.
> > 
> > Ok, fair enough, but in the long-run, this should probably be fixed up
> > "properly" if this arch is still being maintained.
> 
> I have it on my todo list. My plan is to move stuff out of mach-* directories,
> which aren't needed there. This should solve issues like the one here.

 Correct, it looks like another maintainer's oversight.

 The asm/mach-<platform>/ directories are there for platform variants of 
generic stuff found in asm/mach-generic/.  So if something is not there in 
asm/mach-generic/, then it must not be in any other asm/mach-<plaftorm>/ 
subdirectory either.

 Regular platform headers need to go under asm/<plaftorm>/.  Compare 
asm/mach-dec/ vs asm/dec/, or asm/mach-sibyte/ vs asm/sibyte/, and so on.  
So this `loongson_regs.h' piece belongs to asm/loongson64/ rather than 
asm/mach-loongson64/.

  Maciej
