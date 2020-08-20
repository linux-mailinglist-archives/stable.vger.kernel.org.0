Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6D024C3B4
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 18:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729701AbgHTQxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 12:53:11 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:40547 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729766AbgHTQxJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 12:53:09 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 07KGq4Qu021721;
        Thu, 20 Aug 2020 18:52:04 +0200
Date:   Thu, 20 Aug 2020 18:52:04 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 4.4 000/149] 4.4.233-rc1 review
Message-ID: <20200820165204.GA21717@1wt.eu>
References: <20200820092125.688850368@linuxfoundation.org>
 <CA+G9fYsxQEnACmjP+CUtBq9P+0nWU_19oG62tpCbKtdcGAStfA@mail.gmail.com>
 <20200820150848.GA1565072@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820150848.GA1565072@kroah.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 05:08:48PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Aug 20, 2020 at 07:49:06PM +0530, Naresh Kamboju wrote:
> > On Thu, 20 Aug 2020 at 15:47, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 4.4.233 release.
> > > There are 149 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sat, 22 Aug 2020 09:21:01 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.233-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > i386 build failed on stable-rc 4.4 branch
> > 
> > make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=i386 HOSTCC=gcc
> > CC="sccache gcc" O=build
> > #
> > In file included from ../samples/seccomp/bpf-direct.c:19:
> > /usr/include/linux/types.h:5:10: fatal error: asm/types.h: No such
> > file or directory
> >     5 | #include <asm/types.h>
> >       |          ^~~~~~~~~~~~~
> > compilation terminated.
> > In file included from /usr/include/linux/filter.h:10,
> >                  from ../samples/seccomp/bpf-fancy.c:12:
> > /usr/include/linux/types.h:5:10: fatal error: asm/types.h: No such
> > file or directory
> >     5 | #include <asm/types.h>
> >       |          ^~~~~~~~~~~~~
> > compilation terminated.
> > make[3]: *** [scripts/Makefile.host:108: samples/seccomp/bpf-direct.o] Error 1
> > make[3]: *** [scripts/Makefile.host:108: samples/seccomp/bpf-fancy.o] Error 1
> > In file included from /usr/include/bits/errno.h:26,
> >                  from /usr/include/errno.h:28,
> >                  from ../samples/seccomp/dropper.c:17:
> > /usr/include/linux/errno.h:1:10: fatal error: asm/errno.h: No such
> > file or directory
> >     1 | #include <asm/errno.h>
> >       |          ^~~~~~~~~~~~~
> > compilation terminated.
> > make[3]: *** [scripts/Makefile.host:108: samples/seccomp/dropper.o] Error 1
> > In file included from ../samples/seccomp/bpf-helper.c:16:
> > ../samples/seccomp/bpf-helper.h:17:10: fatal error: asm/bitsperlong.h:
> > No such file or directory
> >    17 | #include <asm/bitsperlong.h> /* for __BITS_PER_LONG */
> >       |          ^~~~~~~~~~~~~~~~~~~
> 
> Any pointers to the commit that caused this?  I'll place odds on one of
> the random.h changes :(

It's very possible, but we never touched these files, so it looks like
there is something else if these ones cannot even be found :

> > /usr/include/linux/types.h:5:10: fatal error: asm/types.h: No such
> > file or directory
> >     5 | #include <asm/types.h>
> >       |          ^~~~~~~~~~~~~

Also I don't know what this "sccache" wrapper is, maybe it needs to be
cleaned before trying again ?

That's a bit confusing :-/

Willy
