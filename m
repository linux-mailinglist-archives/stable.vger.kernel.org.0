Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0377415315A
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 14:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgBENCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 08:02:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:54628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbgBENCL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 08:02:11 -0500
Received: from localhost (unknown [212.187.182.165])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF2A3217F4;
        Wed,  5 Feb 2020 13:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580907730;
        bh=3UV6Ke695Hw2GuPRAnPrXfUEyBkzretTk1OokBbR4Fo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ykDDmAwNPGoDmoYWDGHqSmWxyKrf6OS4Z2h9iZYRNZtCDD7PidKk0sfB/bPT79Z+b
         5VY/EnHdLA6LM0nmZV7ongyAQ4JExeS1bf51hCATa7h0yCM+NUSS1ZZguStb070k/z
         y1J+Af/8YaIHbLLcYV6FnqkExuFFzxyp7WbEMGDA=
Date:   Wed, 5 Feb 2020 13:02:07 +0000
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chris Paterson <Chris.Paterson2@renesas.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "ben.hutchings@codethink.co.uk" <ben.hutchings@codethink.co.uk>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "cip-dev@lists.cip-project.org" <cip-dev@lists.cip-project.org>
Subject: Re: [PATCH 4.4 00/53] 4.4.213-stable review
Message-ID: <20200205130207.GA1199959@kroah.com>
References: <20200203161902.714326084@linuxfoundation.org>
 <TYAPR01MB2285D96DC944217E7A22F8C6B7030@TYAPR01MB2285.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYAPR01MB2285D96DC944217E7A22F8C6B7030@TYAPR01MB2285.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 04, 2020 at 09:50:56AM +0000, Chris Paterson wrote:
> Hi Greg,
> 
> > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> > Behalf Of Greg Kroah-Hartman
> > Sent: 03 February 2020 16:19
> > 
> > This is the start of the stable review cycle for the 4.4.213 release.
> > There are 53 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
> > Anything received after that time might be too late.
> 
> We're seeing an issue with 4.4.213-rc1 (36670370c48b) and 4.4.213-rc2 (758a39807529) with our 4 am335x configurations [0]:
> 
>    AS      arch/arm/kernel/hyp-stub.o
>  arch/arm/kernel/hyp-stub.S:   CC      arch/arm/mach-omap2/sram.o
>  Assembler messages:
>    AS      arch/arm/kernel/smccc-call.o
>  arch/arm/kernel/hyp-stub.S:147: Error: selected processor does not support `ubfx r7,r7,#16,#4' in ARM mode
>  scripts/Makefile.build:375: recipe for target 'arch/arm/kernel/hyp-stub.o' failed
>  make[1]: *** [arch/arm/kernel/hyp-stub.o] Error 1
> 
> The culprit seems to be: 15163bcee7b5 ("ARM: 8955/1: virt: Relax arch timer version check during early boot")
> Reverting the same resolves the build issue.
> 
> Latest pipeline: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/pipelines/114683657
> 
> [0] https://gitlab.com/cip-project/cip-kernel/cip-kernel-config/-/blob/master/4.4.y-cip/arm/
> siemens_am335x-axm2_defconfig, siemens_am335x-draco_defconfig, siemens_am335x-dxr2_defconfig, siemens_am335x-etamin_defconfig

Thanks, I'll go drop that patch from 4.4 and 4.9 trees.

greg k-h
