Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5341CB043
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgEHN1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:27:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbgEHN1k (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 09:27:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 600D4208DB;
        Fri,  8 May 2020 13:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588944459;
        bh=WoFe3YzSoDBlR/QxiETEMCC62eGbgcNbl+XND+75qcg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dEKKjcQHeJrZW2rlfo9zA+ChG/wQhnuQRVCbxZdnl1dea2zKgtVo/AeMzC0349xbn
         9FzfI9IrCWLUKPg8GEOYQug/cup1XRe2nPhrqqJLAQLCRAmIDwXgkmX77e4ne6HHtE
         3IsxaiLfNUOFDGr9x9CZT9FgqrWKIHhUsVP8pGFE=
Date:   Fri, 8 May 2020 15:27:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Christoph Hellwig <hch@lst.de>, m.szyprowski@samsung.com,
        open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.4 40/50] dma-direct: exclude dma_direct_map_resource
 from the min_low_pfn check
Message-ID: <20200508132737.GA173507@kroah.com>
References: <20200508123043.085296641@linuxfoundation.org>
 <20200508123048.730720753@linuxfoundation.org>
 <CA+G9fYvdD3dhMhGL5=nfT+7xTEdD36zUtceF2fROPF4OQQZbLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYvdD3dhMhGL5=nfT+7xTEdD36zUtceF2fROPF4OQQZbLQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 08, 2020 at 06:50:02PM +0530, Naresh Kamboju wrote:
> On Fri, 8 May 2020 at 18:23, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Christoph Hellwig <hch@lst.de>
> >
> > commit 68a33b1794665ba8a1d1ef1d3bfcc7c587d380a6 upstream.
> >
> > The valid memory address check in dma_capable only makes sense when mapping
> > normal memory, not when using dma_map_resource to map a device resource.
> > Add a new boolean argument to dma_capable to exclude that check for the
> > dma_map_resource case.
> >
> > Fixes: b12d66278dd6 ("dma-direct: check for overflows on 32 bit DMA addresses")
> > Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> <trim>
> >
> > --- a/kernel/dma/direct.c
> > +++ b/kernel/dma/direct.c
> > @@ -327,7 +327,7 @@ static inline bool dma_direct_possible(s
> >                 size_t size)
> >  {
> >         return swiotlb_force != SWIOTLB_FORCE &&
> > -               dma_capable(dev, dma_addr, size);
> > +               dma_capable(dev, dma_addr, size, true);
> 
> While building kernel Image for arm architecture the following error noticed
> on stale-rc 5.4 kernel branch.
> 
>  # make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=arm
> CROSS_COMPILE=arm-linux-gnueabihf- HOSTCC=gcc CC="sccache
> arm-linux-gnueabihf-gcc" O=build zImage
>  #
>  ../kernel/dma/direct.c: In function ‘dma_direct_possible’:
>  ../kernel/dma/direct.c:330:3: error: too many arguments to function
> ‘dma_capable’
>    330 |   dma_capable(dev, dma_addr, size, true);
>        |   ^~~~~~~~~~~
>  In file included from ../include/linux/dma-direct.h:12,
>                   from ../kernel/dma/direct.c:10:
>  ../arch/arm/include/asm/dma-direct.h:17:20: note: declared here
>     17 | static inline bool dma_capable(struct device *dev, dma_addr_t
> addr, size_t size)
>        |                    ^~~~~~~~~~~
>  In file included from ../include/linux/init.h:5,
>                   from ../include/linux/memblock.h:12,
>                   from ../kernel/dma/direct.c:7:
>  ../kernel/dma/direct.c: In function ‘dma_direct_map_resource’:
>  ../kernel/dma/direct.c:379:16: error: too many arguments to function
> ‘dma_capable’
>    379 |  if (unlikely(!dma_capable(dev, dma_addr, size, false))) {
>        |                ^~~~~~~~~~~
>  ../include/linux/compiler.h:78:42: note: in definition of macro ‘unlikely’
>     78 | # define unlikely(x) __builtin_expect(!!(x), 0)
>        |                                          ^
>  In file included from ../include/linux/dma-direct.h:12,
>                   from ../kernel/dma/direct.c:10:
>  ../arch/arm/include/asm/dma-direct.h:17:20: note: declared here
>     17 | static inline bool dma_capable(struct device *dev, dma_addr_t
> addr, size_t size)
>        |                    ^~~~~~~~~~~
>  make[3]: *** [../scripts/Makefile.build:266: kernel/dma/direct.o] Error 1
>  In file included from ../include/linux/string.h:6,
>                   from ../include/linux/dma-mapping.h:6,
>                   from ../include/linux/dma-direct.h:5,
>                   from ../kernel/dma/swiotlb.c:24:
>  ../kernel/dma/swiotlb.c: In function ‘swiotlb_map’:
>  ../kernel/dma/swiotlb.c:681:16: error: too many arguments to function
> ‘dma_capable’
>    681 |  if (unlikely(!dma_capable(dev, *dma_addr, size, true))) {
>        |                ^~~~~~~~~~~
>  ../include/linux/compiler.h:78:42: note: in definition of macro ‘unlikely’
>     78 | # define unlikely(x) __builtin_expect(!!(x), 0)
>        |                                          ^
>  In file included from ../include/linux/dma-direct.h:12,
>                   from ../kernel/dma/swiotlb.c:24:
>  ../arch/arm/include/asm/dma-direct.h:17:20: note: declared here
>     17 | static inline bool dma_capable(struct device *dev, dma_addr_t
> addr, size_t size)
>        |                    ^~~~~~~~~~

Ah crap, I think I remember trying to apply this in the past and running
into these issues.  I'll go drop it now and push out a -rc2, thanks!

greg k-h
