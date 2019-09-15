Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9ADB3045
	for <lists+stable@lfdr.de>; Sun, 15 Sep 2019 15:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731534AbfIONhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Sep 2019 09:37:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbfIONhO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Sep 2019 09:37:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 189552067B;
        Sun, 15 Sep 2019 13:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568554631;
        bh=tgGeaqAJon44Je9AhJyBt4XGowvfWwlz86wGUciRlAc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hI+TFsXzGddr19fnOYpyN9DLa39XViNNFS0nLyxoLHrPwLiDn5Hj73QchixeZ3CFD
         X8vRfZpA5XvSTAJTbs8jPhE/z78inbp6iVwstxlcqFy+XXQwh1BBzbGLLsIlKHn29p
         lbC+/+H4GvCimE/W9KVQP40Wj0OeE03JB7+Ppr7E=
Date:   Sun, 15 Sep 2019 15:37:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Thomas Backlund <tmb@mageia.org>
Cc:     Stefan Lippers-Hollmann <s.l-h@gmx.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH 5.2 36/37] vhost: block speculation of translated
 descriptors
Message-ID: <20190915133708.GA552389@kroah.com>
References: <20190913130510.727515099@linuxfoundation.org>
 <20190913130522.155505270@linuxfoundation.org>
 <20190914025411.3016e3d9@mir>
 <20190914055050.GA489003@kroah.com>
 <20190914091548.230a63de@mir>
 <20190914080836.GB522114@kroah.com>
 <368d254b-dc29-6309-062d-a2d07b5dad75@mageia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <368d254b-dc29-6309-062d-a2d07b5dad75@mageia.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 15, 2019 at 12:34:57PM +0300, Thomas Backlund wrote:
> Den 14-09-2019 kl. 11:08, skrev Greg Kroah-Hartman:
> > On Sat, Sep 14, 2019 at 09:15:48AM +0200, Stefan Lippers-Hollmann wrote:
> > > Hi
> > > 
> > > On 2019-09-14, Greg Kroah-Hartman wrote:
> > > > On Sat, Sep 14, 2019 at 02:54:11AM +0200, Stefan Lippers-Hollmann wrote:
> > > > > On 2019-09-13, Greg Kroah-Hartman wrote:
> > > > > > From: Michael S. Tsirkin <mst@redhat.com>
> > > > > > 
> > > > > > commit a89db445fbd7f1f8457b03759aa7343fa530ef6b upstream.
> > > > > > 
> > > > > > iovec addresses coming from vhost are assumed to be
> > > > > > pre-validated, but in fact can be speculated to a value
> > > > > > out of range.
> > > > > > 
> > > > > > Userspace address are later validated with array_index_nospec so we can
> > > > > > be sure kernel info does not leak through these addresses, but vhost
> > > > > > must also not leak userspace info outside the allowed memory table to
> > > > > > guests.
> > > > > > 
> > > > > > Following the defence in depth principle, make sure
> > > > > > the address is not validated out of node range.
> > > [...]
> > > > Do you have the same problem with Linus's tree right now?
> > > 
> > > Actually, yes I do (I had not tested i386 for 5.3~ within the last ~2
> > > weeks, only amd64). Very similar kernel config, same compiler versions
> > > but built in a slightly different environment (built directly on the bare
> > > iron, in a amd64 multilib userspace, rather than a pure-i386 chroot on an
> > > amd64 kernel).
> > > 
> > > $ git describe
> > > v5.3-rc8-36-ga7f89616b737
> > > 
> > > $ LANG= make ARCH=x86 -j1 bzImage modules
> > >    CALL    scripts/checksyscalls.sh
> > >    CALL    scripts/atomic/check-atomics.sh
> > >    CHK     include/generated/compile.h
> > >    CHK     kernel/kheaders_data.tar.xz
> > >    CC [M]  drivers/vhost/vhost.o
> > > In file included from ./include/linux/export.h:45,
> > >                   from ./include/linux/linkage.h:7,
> > >                   from ./include/linux/kernel.h:8,
> > >                   from ./include/linux/list.h:9,
> > >                   from ./include/linux/wait.h:7,
> > >                   from ./include/linux/eventfd.h:13,
> > >                   from drivers/vhost/vhost.c:13:
> > > drivers/vhost/vhost.c: In function 'translate_desc':
> > > ./include/linux/compiler.h:350:38: error: call to '__compiletime_assert_2076' declared with attribute error: BUILD_BUG_ON failed: sizeof(_s) > sizeof(long)
> > >    350 |  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
> > >        |                                      ^
> > > ./include/linux/compiler.h:331:4: note: in definition of macro '__compiletime_assert'
> > >    331 |    prefix ## suffix();    \
> > >        |    ^~~~~~
> > > ./include/linux/compiler.h:350:2: note: in expansion of macro '_compiletime_assert'
> > >    350 |  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
> > >        |  ^~~~~~~~~~~~~~~~~~~
> > > ./include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
> > >     39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
> > >        |                                     ^~~~~~~~~~~~~~~~~~
> > > ./include/linux/build_bug.h:50:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
> > >     50 |  BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
> > >        |  ^~~~~~~~~~~~~~~~
> > > ./include/linux/nospec.h:56:2: note: in expansion of macro 'BUILD_BUG_ON'
> > >     56 |  BUILD_BUG_ON(sizeof(_s) > sizeof(long));   \
> > >        |  ^~~~~~~~~~~~
> > > drivers/vhost/vhost.c:2076:5: note: in expansion of macro 'array_index_nospec'
> > >   2076 |     array_index_nospec((unsigned long)(addr - node->start),
> > >        |     ^~~~~~~~~~~~~~~~~~
> > > make[2]: *** [scripts/Makefile.build:281: drivers/vhost/vhost.o] Error 1
> > > make[1]: *** [scripts/Makefile.build:497: drivers/vhost] Error 2
> > > make: *** [Makefile:1083: drivers] Error 2
> > > 
> > > $ git revert a89db445fbd7f1f8457b03759aa7343fa530ef6b
> > > 
> > > $ LANG= make ARCH=x86 -j16 bzImage modules
> > >    CALL    scripts/atomic/check-atomics.sh
> > >    CALL    scripts/checksyscalls.sh
> > >    CHK     include/generated/compile.h
> > >    CHK     kernel/kheaders_data.tar.xz
> > >    Building modules, stage 2.
> > > Kernel: arch/x86/boot/bzImage is ready  (#1)
> > >    MODPOST 3464 modules
> > > 
> > > $ echo $?
> > > 0
> > > 
> > > $ find . -name vhost\\.ko
> > > ./drivers/vhost/vhost.ko
> > > 
> > > I've attached the affected kernel config for v5.3~/ i386.
> > 
> > Ok, good, we will be "bug compatible" at the very least now :)
> > 
> > When this gets fixed in Linus's tree we can backport the fix here as
> > well.  The number of users of that compiler version/configuration is
> > probably pretty low at the moment to want to hold off on this fix.
> > 
> 
> This is now reverted upstream:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0d4a3f2abbef73b9e5bb5f12213c275565473588

And now dropped from all of the stable branches.

thanks,

greg k-h
