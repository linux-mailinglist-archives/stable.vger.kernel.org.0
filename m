Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F981EA85A
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 19:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgFARVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 13:21:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgFARVi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:21:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C57F3206A4;
        Mon,  1 Jun 2020 17:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591032097;
        bh=CJlRt5rX0756QP4W9I6gjOiHoKWUKI4ZMwWMpisdbpw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SAc1iV/gljyi7dYwp+Xn2BuBB1byEw9vfquMStEZLyVNAaeVdVYn++bzPw36/EzYQ
         7OG9OFYjGOL234gijufITFZqqW4TJtgzvcuTRjh6nX2EllGGB0oqQRAo0d3ovcRt6C
         bwphCdXRKLyDlUcB4kTxm9zY1URdddb8+cqhFnUM=
Date:   Mon, 1 Jun 2020 19:21:35 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Subject: Re: stable-rc 4.9: arm: arch/arm/vfp/vfphw.S:158: Error: bad
 instruction `ldcleq p11,cr0,[r10],#32*4'
Message-ID: <20200601172135.GA1236358@kroah.com>
References: <CA+G9fYuwMbm2NUmSLohbUs+KzKcyY9rC0dc4kh9AD9hJi6+ePw@mail.gmail.com>
 <20200601170248.GA1105493@kroah.com>
 <20200601170751.GO1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601170751.GO1551@shell.armlinux.org.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 01, 2020 at 06:07:51PM +0100, Russell King - ARM Linux admin wrote:
> On Mon, Jun 01, 2020 at 07:02:48PM +0200, Greg Kroah-Hartman wrote:
> > On Mon, Jun 01, 2020 at 09:18:34PM +0530, Naresh Kamboju wrote:
> > > stable-rc 4.9 arm architecture build failed due to
> > > following errors,
> > > 
> > > # make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=arm
> > > CROSS_COMPILE=arm-linux-gnueabihf- HOSTCC=gcc CC="sccache
> > > arm-linux-gnueabihf-gcc" O=build zImage
> > > #
> > > ../arch/arm/vfp/vfphw.S: Assembler messages:
> > > ../arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],#32*4'
> > > ../arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#32*4'
> > > make[2]: *** [../scripts/Makefile.build:404: arch/arm/vfp/vfphw.o] Error 1
> > > make[2]: Target '__build' not remade because of errors.
> > > make[1]: *** [/linux/Makefile:1040: arch/arm/vfp] Error 2
> > > ../arch/arm/lib/changebit.S: Assembler messages:
> > > ../arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'
> 
> It looks like Naresh's toolchain doesn't like the new format
> instructions.  Which toolchain (and versions of the individual
> tools) are you (Naresh) using?
> 
> > Odd, I'll drop it from 4.9, but it's also in the 4.14 and 4.19 queues as
> > well, is it causing issues there too?
> 
> What if it turns out that Naresh is using an ancient toolchain
> that isn't supported by these kernels?  Does that still count as
> a reason to drop the patch?

Depends on if anyone actually wants to use the newer toolchain on the
really-old 4.9 release :)

thanks,

greg k-h
