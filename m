Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6B8441AD0
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 12:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbhKALp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 07:45:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231485AbhKALp2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 07:45:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB1D560FC4;
        Mon,  1 Nov 2021 11:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635766974;
        bh=/IEoUasZBcpACWaVwBqW47l/RunrnLYmaUrKY1DxaKk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G5lD2Tpnad8cYev91j1+lnNp72lgdBsOuhdPsPc1CCRSxDrcGmzrvXTsyzXv0J8TR
         thSxI28SZK7ndqGV1bpJP76NLb1zkQ95VaapQdjUrlF1rNS3tmZpLPu4LxV+uhaUES
         mUvKGarMToM7aYHWhqyXxJnI8/wZafe+1IqMj9A8=
Date:   Mon, 1 Nov 2021 12:42:48 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Subject: Re: [PATCH 5.4 00/51] 5.4.157-rc1 review
Message-ID: <YX/SuKCd2N68dByP@kroah.com>
References: <20211101082500.203657870@linuxfoundation.org>
 <CA+G9fYs6FbiP=o=4ACyQ6Lp9YgUpOr9Xtn+ZhHdZm2Z+rhBJZw@mail.gmail.com>
 <9091c526-1a9c-2648-1b6b-146d2b911b5b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9091c526-1a9c-2648-1b6b-146d2b911b5b@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 01, 2021 at 11:11:58AM +0000, Jon Hunter wrote:
> 
> On 01/11/2021 11:09, Naresh Kamboju wrote:
> > On Mon, 1 Nov 2021 at 14:53, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > 
> > > This is the start of the stable review cycle for the 5.4.157 release.
> > > There are 51 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 03 Nov 2021 08:24:20 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >          https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.157-rc1.gz
> > > or in the git tree and branch at:
> > >          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > 
> > Regression found on arm and arm64 builds
> > Following build warnings / errors reported on stable-rc 5.4.
> > 
> > > Haibo Chen <haibo.chen@nxp.com>
> > >      mmc: sdhci-esdhc-imx: clear the buffer_read_ready to reset standard tuning circuit
> > 
> > 
> > build error :
> > --------------
> > drivers/mmc/host/sdhci-esdhc-imx.c: In function 'esdhc_reset_tuning':
> > drivers/mmc/host/sdhci-esdhc-imx.c:1041:10: error: implicit
> > declaration of function 'readl_poll_timeout'; did you mean
> > 'key_set_timeout'? [-Werror=implicit-function-declaration]
> >       ret = readl_poll_timeout(host->ioaddr + SDHCI_AUTO_CMD_STATUS,
> >             ^~~~~~~~~~~~~~~~~~
> >             key_set_timeoutcc1: some warnings being treated as errors
> 
> 
> I am seeing the same. I am also seeing this on v4.14 and v4.19 branches as
> well.

THanks, let me go add an #include and push out -rc2 versions of all 3
branches.

greg k-h
