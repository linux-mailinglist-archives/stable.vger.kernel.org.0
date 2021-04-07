Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A93356B09
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 13:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234024AbhDGLW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 07:22:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231138AbhDGLW4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 07:22:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA3B961363;
        Wed,  7 Apr 2021 11:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617794565;
        bh=HR/CgHMltIkIf6LYPeEio6BsB0RbZRGx7aLluoffiyo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y5K/Aemp5j7kyq/OIzWtqEQV6Aw92P/HlTKx6lcr4z4lkJac7ZeeP5gvtTjrh/Df6
         2NNM4PZzqoWHSsJL8ObEzCObH1tXCiUXQ3OsGZw6uKfza5J2y0tkpzuL8JRE9di5Gp
         ZJ4wqYzZTx6YcvLzDOmdovBaAAMUmBqdchETKtsQ=
Date:   Wed, 7 Apr 2021 13:22:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.4 00/74] 5.4.110-rc1 review
Message-ID: <YG2WAmvr6OUpG6A4@kroah.com>
References: <20210405085024.703004126@linuxfoundation.org>
 <9d26603c91264ce4921639affafb16ab@HQMAIL105.nvidia.com>
 <fbf7fc89-8a74-3a92-63be-6cb429360b13@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbf7fc89-8a74-3a92-63be-6cb429360b13@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 07, 2021 at 09:27:37AM +0100, Jon Hunter wrote:
> Hi Greg,
> 
> On 07/04/2021 09:21, Jon Hunter wrote:
> > On Mon, 05 Apr 2021 10:53:24 +0200, Greg Kroah-Hartman wrote:
> >> This is the start of the stable review cycle for the 5.4.110 release.
> >> There are 74 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, please
> >> let me know.
> >>
> >> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> >> Anything received after that time might be too late.
> >>
> >> The whole patch series can be found in one patch at:
> >> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.110-rc1.gz
> >> or in the git tree and branch at:
> >> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> >> and the diffstat can be found below.
> >>
> >> thanks,
> >>
> >> greg k-h
> > 
> > Failures detected for Tegra ...
> > 
> > Test results for stable-v5.4:
> >     12 builds:	12 pass, 0 fail
> >     26 boots:	26 pass, 0 fail
> >     59 tests:	58 pass, 1 fail
> > 
> > Linux version:	5.4.110-rc1-gc6f7c5a01d5a
> > Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
> >                 tegra194-p2972-0000, tegra20-ventana,
> >                 tegra210-p2371-2180, tegra210-p3450-0000,
> >                 tegra30-cardhu-a04
> > 
> > Test failures:	tegra194-p2972-0000: boot.py
> 
> 
> The following change ...
> 
> Thierry Reding <treding@nvidia.com>
>     drm/tegra: sor: Grab runtime PM reference across reset
> 
> 
> ... is causing this error ...
> 
> boot: logs: [      16.166043] WARNING KERN ------------[ cut here ]------------
> boot: logs: [      16.166061] WARNING KERN reset bpmp (ID: 89) is not acquired
> boot: logs: [      16.166132] WARNING KERN WARNING: CPU: 2 PID: 90 at /dvs/git/dirty/git-master_l4t-upstream/kernel/drivers/reset/core.c:379 reset_control_assert+0x174/0x1a8
> boot: logs: [      16.166136] WARNING KERN Modules linked in: tegra_drm(+) drm_kms_helper drm snd_hda_codec_hdmi snd_hda_tegra snd_hda_codec host1x crct10dif_ce pwm_tegra snd_hda_core pwm_fan pcie_tegra194(+) lm90 phy_tegra194_p2u tegra_bpmp_thermal ip_tables x_tables ipv6
> boot: logs: [      16.166216] WARNING KERN CPU: 2 PID: 90 Comm: kworker/2:1 Not tainted 5.4.110-rc1-gc6f7c5a01d5a #1
> boot: logs: [      16.166220] WARNING KERN Hardware name: NVIDIA Jetson AGX Xavier Developer Kit (DT)
> boot: logs: [      16.166233] WARNING KERN Workqueue: pm pm_runtime_work
> boot: logs: [      16.166242] WARNING KERN pstate: 40c00009 (nZcv daif +PAN +UAO)
> boot: logs: [      16.166248] WARNING KERN pc : reset_control_assert+0x174/0x1a8
> boot: logs: [      16.166252] WARNING KERN lr : reset_control_assert+0x174/0x1a8
> boot: logs: [      16.166256] WARNING KERN sp : ffff800011bc3ba0
> boot: logs: [      16.166265] WARNING KERN x29: ffff800011bc3ba0 x28: 0000000000000000
> boot: logs: [      16.166288] WARNING KERN x27: 0000000000000008 x26: ffff8000114d9000
> boot: logs: [      16.166303] WARNING KERN x25: 000000032b5183e0 x24: ffff0003e3443800
> boot: logs: [      16.166317] WARNING KERN x23: 0000000000000000 x22: ffff800010710638
> boot: logs: [      16.166332] WARNING KERN x21: ffff0003eb967410 x20: ffff0003eb84a360
> boot: logs: [      16.166347] WARNING KERN x19: ffff0003e12fd080 x18: ffffffffffffffff
> boot: logs: [      16.166361] WARNING KERN x17: 0000000000000000 x16: 0000000000000000
> boot: logs: [      16.166375] WARNING KERN x15: ffff8000114d98c8 x14: 00000000fffffff0
> boot: logs: [      16.166416] WARNING KERN x13: ffff8000116b9fa8 x12: ffff8000114f25e8
> boot: logs: [      16.166424] WARNING KERN x11: ffff8000114f2000 x10: 0000000000000000
> boot: logs: [      16.166430] WARNING KERN x9 : 000000000000017a x8 : 0000000000000004
> boot: logs: [      16.166436] WARNING KERN x7 : 000000000000017a x6 : ffff0003ee17c180
> boot: logs: [      16.166442] WARNING KERN x5 : 0000000000000007 x4 : ffff0003ee17c180
> boot: logs: [      16.166449] WARNING KERN x3 : 0000000000000006 x2 : 0000000000000007
> boot: logs: [      16.166460] WARNING KERN x1 : aa01989c70ddbd00 x0 : 0000000000000000
> boot: logs: [      16.166467] WARNING KERN Call trace:
> boot: logs: [      16.166474] WARNING KERN  reset_control_assert+0x174/0x1a8
> boot: logs: [      16.166516] WARNING KERN  tegra_sor_suspend+0x24/0x88 [tegra_drm]
> boot: logs: [      16.166526] WARNING KERN  pm_generic_runtime_suspend+0x28/0x40
> boot: logs: [      16.166534] WARNING KERN  genpd_runtime_suspend+0x90/0x240
> boot: logs: [      16.166541] WARNING KERN  __rpm_callback+0xd8/0x150
> boot: logs: [      16.166546] WARNING KERN  rpm_callback+0x24/0x98
> boot: logs: [      16.166551] WARNING KERN  rpm_suspend+0xe0/0x480
> boot: logs: [      16.166556] WARNING KERN  rpm_idle+0x124/0x140
> boot: logs: [      16.166561] WARNING KERN  pm_runtime_work+0xa0/0xb8
> boot: logs: [      16.166569] WARNING KERN  process_one_work+0x1c8/0x358
> boot: logs: [      16.166575] WARNING KERN  worker_thread+0x48/0x460
> boot: logs: [      16.166580] WARNING KERN  kthread+0x120/0x150
> boot: logs: [      16.166587] WARNING KERN  ret_from_fork+0x10/0x18
> boot: logs: [      16.166592] WARNING KERN ---[ end trace ec6031475f7a0830 ]---
> boot: logs: [      16.166670] ERR KERN tegra-sor 15b80000.sor: failed to assert reset: -1
> 
> 
> Sorry we should have checked which kernels to back port
> this fix for. Can we drop this for v5.4? Appears to be
> fine for v5.10+.

Thanks, I've now dropped this for 5.4.

greg k-h
