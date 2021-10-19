Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC9343324F
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 11:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234887AbhJSJhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 05:37:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234817AbhJSJhD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Oct 2021 05:37:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FC1861177;
        Tue, 19 Oct 2021 09:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634636091;
        bh=/GWakFsYwXkSWJEyHHuny34u7KmSCHMduRF5sRRPRuI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X0JGkzCfrlgYOn8YH9zUNzkMSOGCMbfN48dpARvc0/1GRFUKJ04VoETkYk77tK7of
         UnzSC7lKB4bSjlm4Zn4PVvzer36LKgetthPXC0NUq9I+CdEf+vbjcFM1Lls95jQCOi
         EgHjnkyjLIpyTkXrCiPYCbo/1trF/ac7cS0j8iSo=
Date:   Tue, 19 Oct 2021 11:34:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudeep Holla <sudeep.holla@arm.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Jens Wiklander <jens.wiklander@linaro.org>
Subject: Re: [PATCH 5.14 000/151] 5.14.14-rc1 review
Message-ID: <YW6ROCyvBy5MjOkG@kroah.com>
References: <20211018132340.682786018@linuxfoundation.org>
 <CA+G9fYtLTmosatvO8VBe-RDjEHEvY01P=Fw5mvRvwbxL31ahOA@mail.gmail.com>
 <YW5iBGg4VKP6ZL+O@kroah.com>
 <20211019091818.utbm254kec4uh6nw@bogus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211019091818.utbm254kec4uh6nw@bogus>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 19, 2021 at 10:18:18AM +0100, Sudeep Holla wrote:
> Hi Greg,
> 
> On Tue, Oct 19, 2021 at 08:13:24AM +0200, Greg Kroah-Hartman wrote:
> > On Tue, Oct 19, 2021 at 09:08:08AM +0530, Naresh Kamboju wrote:
> > > On Mon, 18 Oct 2021 at 19:08, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 5.14.14 release.
> > > > There are 151 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Wed, 20 Oct 2021 13:23:15 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.14-rc1.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > > 
> > > Following build errors noticed while building Linux stable rc 5.14
> > > with gcc-11 allmodconfig for arm64 architecture.
> > > 
> > >   - 5.14.14 gcc-11 arm64 allmodconfig FAILED
> > > 
> > > > Sudeep Holla <sudeep.holla@arm.com>
> > > >     firmware: arm_ffa: Add missing remove callback to ffa_bus_type
> > > 
> > > drivers/firmware/arm_ffa/bus.c:96:27: error: initialization of 'int
> > > (*)(struct device *)' from incompatible pointer type 'void (*)(struct
> > > device *)' [-Werror=incompatible-pointer-types]
> > >    96 |         .remove         = ffa_device_remove,
> > >       |                           ^~~~~~~~~~~~~~~~~
> > > drivers/firmware/arm_ffa/bus.c:96:27: note: (near initialization for
> > > 'ffa_bus_type.remove')
> > > cc1: some warnings being treated as errors
> 
> Sorry for that.
> 
> Commit fc7a6209d571 ("bus: Make remove callback return void") was merged
> in v5.15 I think.
> 
> Do you need me to send the patch for v5.14 or you have already fixed it ?

I've already fixed this up, so all is good, no worries!

greg k-h
