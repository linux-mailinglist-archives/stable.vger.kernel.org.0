Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7A324040F
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 11:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgHJJco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 05:32:44 -0400
Received: from elvis.franken.de ([193.175.24.41]:41814 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725984AbgHJJco (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 05:32:44 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1k54AZ-000764-00; Mon, 10 Aug 2020 11:32:39 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 12CD8C0CA2; Mon, 10 Aug 2020 11:31:59 +0200 (CEST)
Date:   Mon, 10 Aug 2020 11:31:59 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Greg KH <greg@kroah.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: VZ: Only include loongson_regs.h for CPU_LOONGSON64
Message-ID: <20200810093158.GA6026@alpha.franken.de>
References: <1596891052-24052-1-git-send-email-chenhc@lemote.com>
 <20200808153123.GC369184@kroah.com>
 <2b2937d0-eae6-a489-07bd-c40ded02ce89@flygoat.com>
 <20200809070235.GA1098081@kroah.com>
 <5ffc7bb1-8e3f-227a-7ad0-cec5fc32a96a@redhat.com>
 <20200810074417.GA1529187@kroah.com>
 <5522eef8-0da5-7f73-b2f8-2d0c19bb5819@redhat.com>
 <20200810090310.GA1837172@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810090310.GA1837172@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 11:03:10AM +0200, Greg KH wrote:
> On Mon, Aug 10, 2020 at 10:56:48AM +0200, Paolo Bonzini wrote:
> > On 10/08/20 09:44, Greg KH wrote:
> > >> There is more #ifdef CONFIG_CPU_LOONGSON64 in arch/mips/kvm/vz.c, and
> > >> more #include "loongson_regs.h" in arch/mips.  So while I agree with
> > >> Greg that this idiom is quite unusual, it seems to be the expected way
> > >> to use this header.  I queued the patch.
> > > Or you all could fix it up to work properly like all other #include
> > > lines in the kernel source tree.  There's no reason mips should be
> > > "special" here, right?
> > 
> > It's not just this #include, there's a couple dozen mach-* directories;
> > changing how they work would be up to the MIPS maintainers (CCed), and
> > it would certainly not be a patch that can be merged in stable@ kernels.
> > 
> > arch/mips/kernel/cpu-probe.c has the same
> > 
> > #ifdef CONFIG_CPU_LOONGSON64
> > #include <loongson_regs.h>
> > 
> > for example, so apparently they're good with this.  So if I don't pick
> > up the patch to fix the build it would be in all likelihood merged by
> > MIPS maintainers.  The only difference will be how long the build
> > remains broken and the fact that they need to worry about KVM despite
> > the presence of a specific maintainer.
> 
> Ok, fair enough, but in the long-run, this should probably be fixed up
> "properly" if this arch is still being maintained.

I have it on my todo list. My plan is to move stuff out of mach-* directories,
which aren't needed there. This should solve issues like the one here.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
