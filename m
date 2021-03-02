Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C68E32AEDB
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236093AbhCCAGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:06:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:38180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381518AbhCBIBn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 03:01:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80E4361477;
        Tue,  2 Mar 2021 08:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614672038;
        bh=2MKbjDbFlD8ZDCokwNa6L9NbWF3Mgk7IBiot+AdPD5Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OUwPtiSpX6oOcWj9FvrlQ4Wb5XfpmjSU0/WHf2kGWmB/eYiuU+ltGLWGMfTdssO6w
         GdlPrr9bLHpRIq/g7G2ixcTuBOBWdVYSgs7fxw9n0k+Al5RnVVmodUNa+DriBktHcP
         ENh1Y7AP4GTXt+uX9M4hZ2T3hRyf8pfwKPFm9Mlc=
Date:   Tue, 2 Mar 2021 09:00:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sahaj Sarup <sahaj.sarup@linaro.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Subject: Re: sparc: icmpv6.h:70:2: error: implicit declaration of function
 '__icmpv6_send'; did you mean 'icmpv6_send'?
 [-Werror=implicit-function-declaration]
Message-ID: <YD3wo+etw0HQaAK2@kroah.com>
References: <CA+G9fYvxM8ECmog5rGSesSUmw3NsmXYZfdg957-37B_BDm=R9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvxM8ECmog5rGSesSUmw3NsmXYZfdg957-37B_BDm=R9Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 10:42:34PM +0530, Naresh Kamboju wrote:
> On stable rc 5.11 sparc allnoconfig and tinyconfig failed with gcc-8,
> gcc-9 and gcc-10.
> 
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=sparc
> CROSS_COMPILE=sparc64-linux-gnu- 'CC=sccache sparc64-linux-gnu-gcc'
> 'HOSTCC=sccache gcc'
> <stdin>:1335:2: warning: #warning syscall rseq not implemented [-Wcpp]
> In file included from include/net/ndisc.h:50,
>                  from include/net/ipv6.h:21,
>                  from include/linux/sunrpc/clnt.h:28,
>                  from include/linux/nfs_fs.h:32,
>                  from init/do_mounts.c:22:
> include/linux/icmpv6.h: In function 'icmpv6_ndo_send':
> include/linux/icmpv6.h:70:2: error: implicit declaration of function
> '__icmpv6_send'; did you mean 'icmpv6_send'?
> [-Werror=implicit-function-declaration]
>    70 |  __icmpv6_send(skb_in, type, code, info, &parm);
>       |  ^~~~~~~~~~~~~
>       |  icmpv6_send
> cc1: some warnings being treated as errors
> make[2]: *** [scripts/Makefile.build:304: init/do_mounts.o] Error 1
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> 
> Ref:
> https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1064179275#L62

Ok, I can duplicate this on 4.19.y, but not 5.11.y, let me see how to
resolve it...

thanks,

greg k-h
