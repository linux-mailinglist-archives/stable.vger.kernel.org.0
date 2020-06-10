Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D4E1F5729
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 16:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgFJO7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 10:59:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726417AbgFJO7D (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jun 2020 10:59:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2F142072F;
        Wed, 10 Jun 2020 14:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591801141;
        bh=DRAX7dZY+3rrjcvGnB5ubpqYxgmX9PBwwAzimv9gLTA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xlOVgWzFgsWsnbv75ebTDCD/cWC3mId0ZJAxNytwS6EwARFIFNcO8bw8SEj7u+kPS
         uEG62wcIIAKYBCQsuONklLx3OXofOTwHahqjsIz96CgvCaFJ6/oeR1qsoLhwIlrCqD
         MZzUoPDhBBR7j0aUShq4J0qqj/aghZw3ChDlvnn0=
Date:   Wed, 10 Jun 2020 16:58:55 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH 4.19 24/25] uprobes: ensure that uprobe->offset and
 ->ref_ctr_offset are properly aligned
Message-ID: <20200610145855.GA2102398@kroah.com>
References: <20200609174048.576094775@linuxfoundation.org>
 <20200609174051.488794266@linuxfoundation.org>
 <CA+G9fYukN5V1z3g6Qwe9K5xnnXEuFafWdqGfDA1Wj2iVstoxfw@mail.gmail.com>
 <20200609190321.GA1046130@kroah.com>
 <20200610145305.GA3254@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200610145305.GA3254@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 10, 2020 at 04:53:06PM +0200, Oleg Nesterov wrote:
> On 06/09, Greg Kroah-Hartman wrote:
> >
> > On Wed, Jun 10, 2020 at 12:25:56AM +0530, Naresh Kamboju wrote:
> > > > @@ -911,6 +907,15 @@ static int __uprobe_register(struct inod
> > > >         if (offset > i_size_read(inode))
> > > >                 return -EINVAL;
> > > >
> > > > +       /*
> > > > +        * This ensures that copy_from_page(), copy_to_page() and
> > > > +        * __update_ref_ctr() can't cross page boundary.
> > > > +        */
> > > > +       if (!IS_ALIGNED(offset, UPROBE_SWBP_INSN_SIZE))
> > > > +               return -EINVAL;
> > > > +       if (!IS_ALIGNED(ref_ctr_offset, sizeof(short)))
> > >
> > > stable-rc 4.19 build failure for x86_64, i386 and arm.
> > > make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=x86 HOSTCC=gcc
> > > CC="sccache gcc" O=build
> > >
> > > 75 #
> > > 76 In file included from ../kernel/events/uprobes.c:25:
> > > 77 ../kernel/events/uprobes.c: In function ‘__uprobe_register’:
> > > 78 ../kernel/events/uprobes.c:916:18: error: ‘ref_ctr_offset’
> > > undeclared (first use in this function); did you mean
> > > ‘per_cpu_offset’?
> > > 79  916 | if (!IS_ALIGNED(ref_ctr_offset, sizeof(short)))
> > > 80  | ^~~~~~~~~~~~~~
> > > 81 ../include/linux/kernel.h:62:30: note: in definition of macro ‘IS_ALIGNED’
> > > 82  62 | #define IS_ALIGNED(x, a) (((x) & ((typeof(x))(a) - 1)) == 0)
> > > 83  | ^
> > > 84 ../kernel/events/uprobes.c:916:18: note: each undeclared identifier
> > > is reported only once for each function it appears in
> > > 85  916 | if (!IS_ALIGNED(ref_ctr_offset, sizeof(short)))
> > > 86  | ^~~~~~~~~~~~~~
> > > 87 ../include/linux/kernel.h:62:30: note: in definition of macro ‘IS_ALIGNED’
> > > 88  62 | #define IS_ALIGNED(x, a) (((x) & ((typeof(x))(a) - 1)) == 0)
> > > 89  | ^
> > > 90 make[3]: *** [../scripts/Makefile.build:304: kernel/events/uprobes.o] Error 1
> > >
> > > --
> > > Linaro LKFT
> > > https://lkft.linaro.org
> >
> > Good catch, my builders just caught it too :(
> >
> > 4.19, 4.14, 4.9, and 4.4 are all broken, I have a fix will test it and
> > push out -rc2 for all of those with it in a bit, thanks.
> 
> Yes, SDT markers were added by 1cc33161a83d20b5462b1e93f95d3ce6388079ee in v4.20.
> 
> See the patch for v4.4 below. It changes uprobe_register(), not __uprobe_register()
> to check IS_ALIGNED(offset, UPROBE_SWBP_INSN_SIZE) only.
> 
> Greg, please let me know if you want me to send the patches for 4.9/4.14/4.19.

Please do.  I tried to backport it to those trees, and it seems to
build/boot/run, but I would like verification I didn't mess anything up
:)

Your 4.4 version below matched my version, so I think I'm ok...

thanks,

greg k-h
