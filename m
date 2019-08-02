Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 300AF7EE28
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 09:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390580AbfHBH5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 03:57:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728268AbfHBH5s (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 03:57:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7164420449;
        Fri,  2 Aug 2019 07:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564732667;
        bh=IIi+crYPKCJNVS372QYWXk3lsDIqeTJGHnU5i0PSoCU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kzySmlyiI9BnzS87TcDSD9/hn7oqFaFfxPRU+Mj9dH7NiFCtK7BdJESYT+k9eioU0
         lS+wNSbPuS1lbt9kKqwuKKhsHVPutNrrI10F4BngRW7Y1dmiZIvCyOOXujO31RlCa3
         e7ksgVRHuHS6FqrHHJxTyBS1FMh3kw4eS2zjcTG0=
Date:   Fri, 2 Aug 2019 09:57:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rolf Eike Beer <eb@emlix.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Matthias Kaehlcke <mka@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: Building arm64 EFI stub with -fpie breaks build of 4.9.x
 (undefined reference to `__efistub__GLOBAL_OFFSET_TABLE_')
Message-ID: <20190802075745.GI26174@kroah.com>
References: <779905244.a0lJJiZRjM@devpool35>
 <CAKwvOdnegLvkAa+-2uc-GM63HLcucWZtN5OoFvocLs50iLNJLg@mail.gmail.com>
 <CAKwvOdn9g2Z=G_qz84S5xmn2GBNK7T-MWOGYT5C52sP0R=M_-Q@mail.gmail.com>
 <2102708.6BiaULqomI@devpool35>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2102708.6BiaULqomI@devpool35>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 06, 2019 at 09:11:00AM +0200, Rolf Eike Beer wrote:
> Nick Desaulniers wrote:
> > On Wed, Jun 5, 2019 at 10:27 AM Nick Desaulniers
> > 
> > <ndesaulniers@google.com> wrote:
> > > On Wed, Jun 5, 2019 at 9:26 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > On Wed, Jun 05, 2019 at 05:19:40PM +0200, Rolf Eike Beer wrote:
> > > > > I decided to dig out a toy project which uses a DragonBoard 410c. This
> > > > > has
> > > > > been "running" with kernel 4.9, which I would keep this way for
> > > > > unrelated
> > > > > reasons. The vanilla 4.9 kernel wasn't bootable back then, but it was
> > > > > buildable, which was good enough.
> > > > > 
> > > > > Upgrading the kernel to 4.9.180 caused the boot to suddenly fail:
> > > > > 
> > > > > aarch64-unknown-linux-gnueabi-ld:
> > > > > ./drivers/firmware/efi/libstub/lib.a(arm64- stub.stub.o): in function
> > > > > `handle_kernel_image':
> > > > > /tmp/e2/build/linux-4.9.139/drivers/firmware/efi/libstub/arm64-stub.c:
> > > > > 63:
> > > > > undefined reference to `__efistub__GLOBAL_OFFSET_TABLE_'
> > > > > aarch64-unknown-linux-gnueabi-ld:
> > > > > ./drivers/firmware/efi/libstub/lib.a(arm64- stub.stub.o): relocation
> > > > > R_AARCH64_ADR_PREL_PG_HI21 against symbol
> > > > > `__efistub__GLOBAL_OFFSET_TABLE_' which may bind externally can not
> > > > > be used when making a shared object; recompile with -fPIC
> > > > > /tmp/e2/build/linux-4.9.139/drivers/firmware/efi/libstub/arm64-stub.c:
> > > > > 63:
> > > > > (.init.text+0xc): dangerous relocation: unsupported relocation
> > > > > /tmp/e2/build/linux-4.9.139/Makefile:1001: recipe for target 'vmlinux'
> > > > > failed -make[1]: *** [vmlinux] Error 1
> > > > > 
> > > > > This is caused by commit 27b5ebf61818749b3568354c64a8ec2d9cd5ecca from
> > > > > linux-4.9.y (which is 91ee5b21ee026c49e4e7483de69b55b8b47042be),
> > > > > reverting
> > > > > this commit fixes the build.
> > > > > 
> > > > > This happens with vanilla binutils 2.32 and gcc 8.3.0 as well as
> > > > > 9.1.0. See
> > > > > the attached .config for reference.
> > > > > 
> > > > > If you have questions or patches just ping me.
> > > > 
> > > > Does Linus's latest tree also fail for you (or 5.1)?
> > > > 
> > > > Nick, do we need to add another fix that is in mainline for this to work
> > > > properly?
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > 
> > > Doesn't immediately ring any bells for me.
> > 
> > Upstream commits:
> > dd6846d77469 ("arm64: drop linker script hack to hide __efistub_ symbols")
> > 1212f7a16af4 ("scripts/kallsyms: filter arm64's __efistub_ symbols")
> > 
> > Look related to __efistub__ prefixes on symbols and aren't in stable
> > 4.9 (maybe Rolf can try cherry picks of those).
> 
> I now have cherry-picked these commits:
> 
> dd6846d77469
> fdfb69a72522e97f9105a6d39a5be0a465951ed8
> 1212f7a16af4
> 56067812d5b0e737ac2063e94a50f76b810d6ca3
> 
> The 2 additional ones were needed as dependencies of the others. Nothing of 
> this has helped.

Did this ever get resolved, or is it still an issue?

thanks,

greg k-h
