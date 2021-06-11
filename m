Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2183A3D19
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 09:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbhFKHad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 03:30:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231132AbhFKHac (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Jun 2021 03:30:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12DAF61364;
        Fri, 11 Jun 2021 07:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623396504;
        bh=iWBqmxR5yC0tFyrseLU0ee4luBOIWzSZZX576C3Ke7A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y4GPo/7ApXKSbKJ1HQzd/76hN5GhmUtJOJkzUBncipGXUnE5iVsP+TtvSPKT9gmsp
         0OLxVJGnryUgo+z9PL38N23i8/YVRD03rKkPFaQWSfWzXHPgYqM0jYhWrPRi4zlxyq
         Kom4f76+Kf/vTTR2Bk2y7TqMNdiSRKEU6/5SmPvU=
Date:   Fri, 11 Jun 2021 09:28:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marek Vasut <marex@denx.de>
Cc:     Pavel Machek <pavel@denx.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Fabio Estevam <festevam@gmail.com>,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        Ludwig Zenz <lzenz@dh-electronics.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH 4.19 00/58] 4.19.194-rc1 review
Message-ID: <YMMQlne6YEVm4FEb@kroah.com>
References: <20210608175932.263480586@linuxfoundation.org>
 <CA+G9fYu3URCR6_ZL+KPYFEOVL4f=8TjjyFncmvoLuYrR_YR3=A@mail.gmail.com>
 <20210608224155.GA31308@amd>
 <YMBe9/7mJ+dGiGJA@kroah.com>
 <439102f7-e05f-cb25-72ed-2de64a9a2560@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <439102f7-e05f-cb25-72ed-2de64a9a2560@denx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 10, 2021 at 01:40:14PM +0200, Marek Vasut wrote:
> On 6/9/21 8:25 AM, Greg Kroah-Hartman wrote:
> > On Wed, Jun 09, 2021 at 12:41:55AM +0200, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > > This is the start of the stable review cycle for the 4.19.194 release.
> > > > > There are 58 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > ...
> > > > > Marek Vasut <marex@denx.de>
> > > > >      ARM: dts: imx6q-dhcom: Add PU,VDD1P1,VDD2P5 regulators
> > > > 
> > > > make --silent --keep-going --jobs=8
> > > > O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm
> > > > CROSS_COMPILE=arm-linux-gnueabihf- 'CC=sccache
> > > > arm-linux-gnueabihf-gcc' 'HOSTCC=sccache gcc'
> > > > Error: /builds/linux/arch/arm/boot/dts/imx6q-dhcom-som.dtsi:414.1-12
> > > > Label or path reg_vdd1p1 not found
> > > > Error: /builds/linux/arch/arm/boot/dts/imx6q-dhcom-som.dtsi:418.1-12
> > > > Label or path reg_vdd2p5 not found
> > > > FATAL ERROR: Syntax error parsing input tree
> > > > make[2]: *** [scripts/Makefile.lib:294:
> > > > arch/arm/boot/dts/imx6q-dhcom-pdk2.dtb] Error 1
> > > 
> > > For the record, we see same build error in our testing:
> > > 
> > > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/1328869295
> > 
> > Will fix this and push out a -rc2.
> 
> I suspect for 4.19.y , you will need to pick the following as dependency. It
> looks like board DT patch, but it also adds the missing labels to
> imx6qdl.dtsi
> 
> 93385546ba36 ("ARM: dts: imx6qdl-sabresd: Assign corresponding power supply
> for LDOs")

Thanks, I've done this now.

greg k-h
