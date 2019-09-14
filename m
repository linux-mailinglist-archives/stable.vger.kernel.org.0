Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4641EB29FF
	for <lists+stable@lfdr.de>; Sat, 14 Sep 2019 07:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfINFu4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Sep 2019 01:50:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726193AbfINFu4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 14 Sep 2019 01:50:56 -0400
Received: from localhost (unknown [149.255.125.221])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C49B20692;
        Sat, 14 Sep 2019 05:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568440253;
        bh=gDz5GcBMkefNQSnH9m842qIEB3JN0kGNiMfmU1mmtFU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ken7HgcBY6/mJ12GILUKKYsz8MeJ+9OocufJ1QvOJm22jSd6mxAy6PTtnk7cMhEhD
         FyY06d/6gBE/P/gRkMjaGtsPUbW3tbwCd0OcBDQrtL5qrhflm7+0b3a4u7Y3fhEgWe
         67Ba1OuPEXK7n9BGeBBKsYuFc81gaNGbfAtlxSQo=
Date:   Sat, 14 Sep 2019 06:50:50 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Stefan Lippers-Hollmann <s.l-h@gmx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH 5.2 36/37] vhost: block speculation of translated
 descriptors
Message-ID: <20190914055050.GA489003@kroah.com>
References: <20190913130510.727515099@linuxfoundation.org>
 <20190913130522.155505270@linuxfoundation.org>
 <20190914025411.3016e3d9@mir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190914025411.3016e3d9@mir>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 14, 2019 at 02:54:11AM +0200, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On 2019-09-13, Greg Kroah-Hartman wrote:
> > From: Michael S. Tsirkin <mst@redhat.com>
> >
> > commit a89db445fbd7f1f8457b03759aa7343fa530ef6b upstream.
> >
> > iovec addresses coming from vhost are assumed to be
> > pre-validated, but in fact can be speculated to a value
> > out of range.
> >
> > Userspace address are later validated with array_index_nospec so we can
> > be sure kernel info does not leak through these addresses, but vhost
> > must also not leak userspace info outside the allowed memory table to
> > guests.
> >
> > Following the defence in depth principle, make sure
> > the address is not validated out of node range.
> [...]
> 
> This fails to compile as part of 5.2.15-rc1 on i386 (amd64 is fine), using
> gcc 9.2.1. Reverting just this patch results in a successful build again.
> 
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -1965,8 +1965,10 @@ static int translate_desc(struct vhost_v
> >  		_iov = iov + ret;
> >  		size = node->size - addr + node->start;
> >  		_iov->iov_len = min((u64)len - s, size);
> > -		_iov->iov_base = (void __user *)(unsigned long)
> > -			(node->userspace_addr + addr - node->start);
> > +		_iov->iov_base = (void __user *)
> > +			((unsigned long)node->userspace_addr +
> > +			 array_index_nospec((unsigned long)(addr - node->start),
> > +					    node->size));
> >  		s += size;
> >  		addr += size;
> >  		++ret;
> >
> >
> 
>   CC [M]  drivers/vhost/vhost.o
> In file included from /build/linux-5.2/include/linux/export.h:45,
>                  from /build/linux-5.2/include/linux/linkage.h:7,
>                  from /build/linux-5.2/include/linux/kernel.h:8,
>                  from /build/linux-5.2/include/linux/list.h:9,
>                  from /build/linux-5.2/include/linux/wait.h:7,
>                  from /build/linux-5.2/include/linux/eventfd.h:13,
>                  from /build/linux-5.2/drivers/vhost/vhost.c:13:
> /build/linux-5.2/drivers/vhost/vhost.c: In function 'translate_desc':
> /build/linux-5.2/include/linux/compiler.h:345:38: error: call to '__compiletime_assert_1970' declared with attribute error: BUILD_BUG_ON failed: sizeof(_s) > sizeof(long)
>   345 |  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
>       |                                      ^
> /build/linux-5.2/include/linux/compiler.h:326:4: note: in definition of macro '__compiletime_assert'
>   326 |    prefix ## suffix();    \
>       |    ^~~~~~
> /build/linux-5.2/include/linux/compiler.h:345:2: note: in expansion of macro '_compiletime_assert'
>   345 |  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
>       |  ^~~~~~~~~~~~~~~~~~~
> /build/linux-5.2/include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
>    39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>       |                                     ^~~~~~~~~~~~~~~~~~
> /build/linux-5.2/include/linux/build_bug.h:50:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
>    50 |  BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
>       |  ^~~~~~~~~~~~~~~~
> /build/linux-5.2/include/linux/nospec.h:56:2: note: in expansion of macro 'BUILD_BUG_ON'
>    56 |  BUILD_BUG_ON(sizeof(_s) > sizeof(long));   \
>       |  ^~~~~~~~~~~~
> /build/linux-5.2/drivers/vhost/vhost.c:1970:5: note: in expansion of macro 'array_index_nospec'
>  1970 |     array_index_nospec((unsigned long)(addr - node->start),
>       |     ^~~~~~~~~~~~~~~~~~
> make[3]: *** [/build/linux-5.2/scripts/Makefile.build:285: drivers/vhost/vhost.o] Error 1
> make[2]: *** [/build/linux-5.2/scripts/Makefile.build:489: drivers/vhost] Error 2
> make[1]: *** [/build/linux-5.2/Makefile:1072: drivers] Error 2
> make: *** [/build/linux-5.2/Makefile:179: sub-make] Error 2

Do you have the same problem with Linus's tree right now?

thanks,

greg k-h
