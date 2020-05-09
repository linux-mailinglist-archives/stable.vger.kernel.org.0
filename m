Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29B61CBE30
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 08:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbgEIGw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 May 2020 02:52:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728471AbgEIGw1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 May 2020 02:52:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF91724955;
        Sat,  9 May 2020 06:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589007148;
        bh=mot9OEs7o6VxCWFYE7Of6R11++mJqcPB9EroHDqPSdA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZPlWQAPWVvo5rEQA7ax+HrLD3yM5ATXGBL/7OFfBZxLlR/0voAfvqTyHp9ugj0kpL
         NdWX6aazjY0HnIzmWQaQ2Q3SQVVlUmELfWN32BGI2iM8SzObkzmxfNvSAM7aA98YbG
         eMgayX/ryQVq8MesXb6UnOjwRoLnsFP93TiiCJgs=
Date:   Sat, 9 May 2020 08:52:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/308] 4.4.223-rc2 review
Message-ID: <20200509065226.GA1765287@kroah.com>
References: <20200508142854.087405740@linuxfoundation.org>
 <ada628d9-fd10-acd4-94fe-cdcf1caf43fc@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada628d9-fd10-acd4-94fe-cdcf1caf43fc@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 08, 2020 at 02:10:40PM -0700, Guenter Roeck wrote:
> On 5/8/20 7:32 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.223 release.
> > There are 308 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 10 May 2020 14:26:28 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 169 pass: 156 fail: 13
> Failed builds:
> 	<all mips>
> Qemu test results:
> 	total: 332 pass: 272 fail: 60
> Failed tests:
> 	arm:mcimx6ul-evk:imx_v6_v7_defconfig:nodrm:mem256:imx6ul-14x14-evk:initrd
> 	arm:mcimx6ul-evk:imx_v6_v7_defconfig:nodrm:sd:mem256:imx6ul-14x14-evk:rootfs
> 	arm:mcimx6ul-evk:imx_v6_v7_defconfig:nodrm:usb1:mem256:imx6ul-14x14-evk:rootfs
> 	<all mips>
> 
> Bisecting the arm boot failure points to commit 9b86858f37d682 ("regulator:
> Try to resolve regulators supplies on registration"). Reverting this commit fixes
> the problem.
> 
> The mips build failure is caused by commit d0e89dd815b712 ("MIPS: math-emu:
> Fix m{add,sub}.s shifts"). It removes the define of SPXSRSXn, but that define
> is still used in v4.4.y. Reverting the offending patch fixes the problem.

Thank you for saving me having to do the bisection.

I've dropped both of these and now pushed out a -rc3.

thanks again,

greg k-h
