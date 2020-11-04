Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638292A6659
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 15:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgKDO2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 09:28:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:41918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbgKDO2I (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Nov 2020 09:28:08 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDE85206E3;
        Wed,  4 Nov 2020 14:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604500087;
        bh=VK01esNG6Gi3qrzThiZjiJRVQlJVdU/tFUBbGdDni1s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IhZ6/JAcmdSJTOcuvSUYlWChLXI8DNAl4R8WycU8DOQhKYnb15UAi9bnopXHPOpLQ
         /sg9n135oV6vaV3Oz9E+exvrafw0jbJCWVKRS+XlyKR/uqu4obeJtmvGM29dS/muSi
         wYlhdYRX2se0IDOAPhPwkQlJ3pmoDpwd+DLH1NJ8=
Date:   Wed, 4 Nov 2020 15:28:58 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/214] 5.4.75-rc1 review
Message-ID: <20201104142858.GA2202359@kroah.com>
References: <20201103203249.448706377@linuxfoundation.org>
 <20201104140754.GA4312@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104140754.GA4312@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 04, 2020 at 06:07:54AM -0800, Guenter Roeck wrote:
> On Tue, Nov 03, 2020 at 09:34:08PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.75 release.
> > There are 214 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 05 Nov 2020 20:29:58 +0000.
> > Anything received after that time might be too late.
> > 
> 
> All sparc images fail to build.
> 
> Building sparc32:defconfig ... failed
> --------------
> Error log:
> <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
> In file included from arch/sparc/include/asm/io_32.h:14,
>                  from arch/sparc/include/asm/io.h:7,
>                  from include/linux/io.h:13,
>                  from include/linux/irq.h:20,
>                  from include/asm-generic/hardirq.h:13,
>                  from arch/sparc/include/asm/hardirq_32.h:11,
>                  from arch/sparc/include/asm/hardirq.h:7,
>                  from include/linux/hardirq.h:9,
>                  from include/linux/interrupt.h:11,
>                  from include/linux/kernel_stat.h:9,
>                  from arch/sparc/kernel/irq_32.c:15:
> include/asm-generic/io.h: In function '__pci_ioport_unmap':
> include/asm-generic/io.h:1012:2: error: implicit declaration of function 'iounmap'; did you mean 'ioremap'?

Thanks, I'll go drop f5810e5c3292 ("asm-generic/io.h: Fix
!CONFIG_GENERIC_IOMAP pci_iounmap() implementation") which seems to be
causing this.

Sasha, any reason you only added it to the 5.4 and 4.14 queues and not
5.9 and 4.19?

thanks,

greg k-h
