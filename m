Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD6671CB0AE
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgEHNoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:44:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbgEHNoL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 09:44:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38EC020708;
        Fri,  8 May 2020 13:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588945450;
        bh=Qsyz2CrbR4xCc8ca/uokwedAFc+9rG0zKRD2WnexmDI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jybO2y7NJJxik42jn2wBwKs2Ej1oDrkWaPIH1Jf5b5LICDmeLJ65X/VwAB3y/8c6E
         UhtBVYUK5xUjIMC+VJimvwIdF0RaANl+cVQ8BoVzE+zoN28v/e4C/DFBVW9phyRGRS
         wniBc1VrBM2VuwCGI+OLBTbdTWetVbSHJTRYIpX0=
Date:   Fri, 8 May 2020 15:44:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/312] 4.4.223-rc1 review
Message-ID: <20200508134408.GA196344@kroah.com>
References: <20200508123124.574959822@linuxfoundation.org>
 <fe060262-1712-9205-b1cd-cd209d0ed395@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe060262-1712-9205-b1cd-cd209d0ed395@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 08, 2020 at 06:37:56AM -0700, Guenter Roeck wrote:
> On 5/8/20 5:29 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.223 release.
> > There are 312 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 10 May 2020 12:29:44 +0000.
> > Anything received after that time might be too late.
> > 
> 
> This is not a complete list of errors.

Yeah, I knew this was going to be a rough one.  I was hoping the "early
warning" messages from Linaro would have caught most of these, oh well
:(

> 
> arm64:allmodconfig
> 
> drivers/spi/spi-rockchip.c: In function 'rockchip_spi_prepare_dma':
> drivers/spi/spi-rockchip.c:461:19: error: 'struct dma_slave_caps' has no member named 'max_burst'

Now fixed.

> arm:allmodconfig
> 
> drivers/mtd/nand/pxa3xx_nand.c: In function 'alloc_nand_resource':
> drivers/mtd/nand/pxa3xx_nand.c:1753:7: error: 'np' undeclared

Now fixed.

> mips:defconfig
> 
> Lots of
> 
> In file included from ./arch/mips/include/asm/fpu.h:24,
>                  from arch/mips/kernel/branch.c:16:
> ./arch/mips/include/asm/msa.h: In function 'read_msa_ir':
> ./arch/mips/include/asm/msa.h:204:2: error: expected ':' or ')' before '_ASM_INSN_IF_MIPS'
> 
> and similar errors.
> 
> arch/mips/mm/tlbex.c: In function 'config_htw_params':
> arch/mips/mm/tlbex.c:2334:13: error: 'MIPS_PWSIZE_PS_MASK' undeclared
> 
> All mips builds are badly broken.

Odd, I thought I had tested mips locally, I guess I got it completly
wrong...  Let me go through those again...

I'll push out a -rc2 after digging into the mips mess...

greg k-h
