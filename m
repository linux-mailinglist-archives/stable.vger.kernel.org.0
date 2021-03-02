Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1E832AFC5
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238942AbhCCA2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:28:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:50816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380804AbhCBMcs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:32:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8B2264F19;
        Tue,  2 Mar 2021 12:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614687705;
        bh=SfCVXrPmgvAc8W68+2TZfGwdJwz3XZw8DdWBjXq6eFE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=goCqcINBsmmP/iQSxiST6M9n7sYvp1xlUCc0hDt0pw0/TJiczXGNfGIuSz9ErOAT8
         FI5zaoomcwoa8iAcLhUKoQCJSPGHNjNg8WTTydc6jVASgEYwRDXOS3AjvVoAXZFkNV
         amtevWlxS2pojNvOy/2DtwL9oqI57BxYtJPaB7Po=
Date:   Tue, 2 Mar 2021 13:21:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>,
        Sahaj Sarup <sahaj.sarup@linaro.org>
Subject: Re: sparc: icmpv6.h:70:2: error: implicit declaration of function
 '__icmpv6_send'; did you mean 'icmpv6_send'?
 [-Werror=implicit-function-declaration]
Message-ID: <YD4t1sYqQ0i5SGKI@kroah.com>
References: <CA+G9fYvxM8ECmog5rGSesSUmw3NsmXYZfdg957-37B_BDm=R9Q@mail.gmail.com>
 <YD06+unUAIh8ufOl@kroah.com>
 <CAEUSe780_-ynip=3z=CtMai+ZSL7Hjt8kuHs0AGPX5XUSbUxZA@mail.gmail.com>
 <YD1E2jmIl8n2bclQ@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YD1E2jmIl8n2bclQ@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 08:47:38PM +0100, Greg Kroah-Hartman wrote:
> On Mon, Mar 01, 2021 at 01:41:20PM -0600, Daniel Díaz wrote:
> > )Hello!
> > 
> > On Mon, 1 Mar 2021 at 13:15, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Mon, Mar 01, 2021 at 10:42:34PM +0530, Naresh Kamboju wrote:
> > > > On stable rc 5.11 sparc allnoconfig and tinyconfig failed with gcc-8,
> > > > gcc-9 and gcc-10.
> > > >
> > > > make --silent --keep-going --jobs=8
> > > > O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=sparc
> > > > CROSS_COMPILE=sparc64-linux-gnu- 'CC=sccache sparc64-linux-gnu-gcc'
> > > > 'HOSTCC=sccache gcc'
> > > > <stdin>:1335:2: warning: #warning syscall rseq not implemented [-Wcpp]
> > > > In file included from include/net/ndisc.h:50,
> > > >                  from include/net/ipv6.h:21,
> > > >                  from include/linux/sunrpc/clnt.h:28,
> > > >                  from include/linux/nfs_fs.h:32,
> > > >                  from init/do_mounts.c:22:
> > > > include/linux/icmpv6.h: In function 'icmpv6_ndo_send':
> > > > include/linux/icmpv6.h:70:2: error: implicit declaration of function
> > > > '__icmpv6_send'; did you mean 'icmpv6_send'?
> > > > [-Werror=implicit-function-declaration]
> > > >    70 |  __icmpv6_send(skb_in, type, code, info, &parm);
> > > >       |  ^~~~~~~~~~~~~
> > > >       |  icmpv6_send
> > > > cc1: some warnings being treated as errors
> > > > make[2]: *** [scripts/Makefile.build:304: init/do_mounts.o] Error 1
> > > >
> > > > Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> > >
> > > What is the odds that Linus's tree also fails with this configuration
> > > and arch right now?
> > 
> > We don't see this kind of failure (or any failure whatsoever) on
> > mainline (Linux 5.12-rc1) at the moment.
> 
> Odd, ok, let me dig into this in the morning, I might have missed
> something that needed to be backported here...

Found it, needed one more patch backported.  Now passes my local tests,
will push out new -rcs now...

thanks,

greg k-h
