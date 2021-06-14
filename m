Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2EA3A5C5D
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 07:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhFNFVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 01:21:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229596AbhFNFVD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 01:21:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AC736124B;
        Mon, 14 Jun 2021 05:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623647925;
        bh=f3eWrlSyTQ4DWrXMK3hTWJ9WylqT014CbowNPYbUR+4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mTb7rKM8tRpf8Hog+wGWcmy2dGgeH3XqDVqJEiiqJtUem/Nn4m5vHucJX06rx2f5p
         HKUggOzZcywdX2K/wqYZp8BBujvLGicNQ9cMv8t7ajGazio06IfCsfS/7iYFqTp/Ol
         a2GEOWE/2CYi/Y7XJkncM6Qp7mKek2z1dKCaHj6U=
Date:   Mon, 14 Jun 2021 07:18:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Subject: Re: compiler.h:417:38: error: call to '__compiletime_assert_59'
 declared with attribute error: BUILD_BUG_ON failed: sizeof(_i) >
 sizeof(long)
Message-ID: <YMbmsV7JYb7e1CVO@kroah.com>
References: <CA+G9fYuBo_WgjtW1BugKLPeYnmLEe65zU7Ttt=FB2uqMzZy1eQ@mail.gmail.com>
 <YMYepbrAxKbgaXi8@kroah.com>
 <CA+G9fYsEwbLh2Tisdmsmb=yThZCmhWi4ZzqearrN_nQXStoJVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsEwbLh2Tisdmsmb=yThZCmhWi4ZzqearrN_nQXStoJVA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 14, 2021 at 10:24:23AM +0530, Naresh Kamboju wrote:
> On Sun, 13 Jun 2021 at 20:35, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Sun, Jun 13, 2021 at 08:25:19PM +0530, Naresh Kamboju wrote:
> > > The following error was noticed on stable-rc 5.12, 5.10, 5.4, 4.19,
> > > 4.14, 4.9 and 4.4
> > > for i386 and arm.
> > >
> > > make --silent --keep-going --jobs=8
> > > O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm
> > > CROSS_COMPILE=arm-linux-gnueabihf- 'CC=sccache
> > > arm-linux-gnueabihf-gcc' 'HOSTCC=sccache gcc'
> > > In file included from /builds/linux/include/linux/kernel.h:11,
> > >                  from /builds/linux/include/linux/list.h:9,
> > >                  from /builds/linux/include/linux/preempt.h:11,
> > >                  from /builds/linux/include/linux/hardirq.h:5,
> > >                  from /builds/linux/include/linux/kvm_host.h:7,
> > >                  from
> > > /builds/linux/arch/arm/kvm/../../../virt/kvm/kvm_main.c:18:
> > > In function '__gfn_to_hva_memslot',
> > >     inlined from '__gfn_to_hva_many.part.6' at
> > > /builds/linux/arch/arm/kvm/../../../virt/kvm/kvm_main.c:1446:9,
> > >     inlined from '__gfn_to_hva_many' at
> > > /builds/linux/arch/arm/kvm/../../../virt/kvm/kvm_main.c:1434:22:
> > > /builds/linux/include/linux/compiler.h:417:38: error: call to
> > > '__compiletime_assert_59' declared with attribute error: BUILD_BUG_ON
> > > failed: sizeof(_i) > sizeof(long)
> > >   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
> > >                                       ^
> > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > >
> > > ref:
> > > https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1342604370#L389
> >
> > Odd.  Does Linus's tree have this problem?
> >
> > The only arm changes was in arch/arm/include/asm/cpuidle.h in the tree
> > right now.  There are some kvm changes, but they are tiny...
> >
> > Can you bisect this?
> 
> The bisect script pointing to,
> 
> commit 1aa1b47db53e0a66899d63103b3ac1d7f54816bc
> Author: Paolo Bonzini <pbonzini@redhat.com>
> Date:   Tue Jun 8 15:31:42 2021 -0400
>     kvm: avoid speculation-based attacks from out-of-range memslot accesses
> 
>     commit da27a83fd6cc7780fea190e1f5c19e87019da65c upstream.

Ah, so is Linus's tree also broken the same way?

thanks,

greg k-h
