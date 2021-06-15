Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B083A7BAB
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 12:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhFOKYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 06:24:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231187AbhFOKYg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 06:24:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A96B461410;
        Tue, 15 Jun 2021 10:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623752551;
        bh=T40//mmj0tAIzHIBrS3UZt6u2zL0uOi2QoB1mc8CpX4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wYl3BOq5+IEHsdF5xlm5EK7XErwGOjQN7PBm4fXpP2hp4HXMg6+PNN2ymW/2og4JE
         SCTkpK1FPhkU7EIQH0EJ/KsYeUqv/fo+rXkMFamySep9sxlm+qvOJezdz5jopEWDft
         P3nRpnGo5yPD+DEYaaDZmKp+YpddF2jFHewwK+0M=
Date:   Tue, 15 Jun 2021 12:22:28 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jack Pham <jackp@codeaurora.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-usb@vger.kernel.org,
        Peter Chen <peter.chen@kernel.org>,
        Felipe Balbi <balbi@kernel.org>
Subject: Re: [PATCH 5.10 000/130] 5.10.44-rc2 review
Message-ID: <YMh/ZNyeC8BuxHzO@kroah.com>
References: <20210614161424.091266895@linuxfoundation.org>
 <CA+G9fYsfvtr7NNcb0bvEZpYYotdY7Uf+wMY22iLhr0weZ8Om3g@mail.gmail.com>
 <YMhDPjbfTFpUtTs3@kroah.com>
 <20210615070747.GB31646@jackp-linux.qualcomm.com>
 <YMhStNjyczSNkfkm@kroah.com>
 <20210615081618.GB10432@jackp-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615081618.GB10432@jackp-linux.qualcomm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 15, 2021 at 01:16:18AM -0700, Jack Pham wrote:
> On Tue, Jun 15, 2021 at 09:11:48AM +0200, Greg Kroah-Hartman wrote:
> > On Tue, Jun 15, 2021 at 12:07:47AM -0700, Jack Pham wrote:
> > > Hi Greg,
> > > 
> > > On Tue, Jun 15, 2021 at 08:05:50AM +0200, Greg Kroah-Hartman wrote:
> > > > On Tue, Jun 15, 2021 at 09:41:26AM +0530, Naresh Kamboju wrote:
> > > > > On Mon, 14 Jun 2021 at 21:45, Greg Kroah-Hartman
> > > > > <gregkh@linuxfoundation.org> wrote:
> > > > > >
> > > > > > This is the start of the stable review cycle for the 5.10.44 release.
> > > > > > There are 130 patches in this series, all will be posted as a response
> > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > let me know.
> > > > > >
> > > > > > Responses should be made by Wed, 16 Jun 2021 16:13:59 +0000.
> > > > > > Anything received after that time might be too late.
> > > > > >
> > > > > > The whole patch series can be found in one patch at:
> > > > > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.44-rc2.gz
> > > > > > or in the git tree and branch at:
> > > > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > > > > > and the diffstat can be found below.
> > > > > >
> > > > > > thanks,
> > > > > >
> > > > > > greg k-h
> > > > > 
> > > > > The following kernel crash reported on stable rc 5.10.44-rc2 arm64 db845c board.
> > > > > 
> > > > > [    5.127966] dwc3-qcom a6f8800.usb: failed to get usb-ddr path: -517
> > > 
> > > Looks like -EPROBE_DEFER happened here due to a not-yet-probed
> > > dependency (interconnect driver).  This leads to dwc3_qcom_probe()
> > > unwinding and calling of_platform_depopulate() which triggers the
> > > "child" dwc3's driver remove callback dwc3_remove()...
> > > 
> > > > > [    5.145567] Unable to handle kernel NULL pointer dereference at
> > > > > virtual address 0000000000000002
> > > > > [    5.154451] Mem abort info:
> > > > > [    5.157296]   ESR = 0x96000004
> > > > > [    5.160401]   EC = 0x25: DABT (current EL), IL = 32 bits
> > > > > [    5.165771]   SET = 0, FnV = 0
> > > > > [    5.168873]   EA = 0, S1PTW = 0
> > > > > [    5.172064] Data abort info:
> > > > > [    5.174980]   ISV = 0, ISS = 0x00000004
> > > > > [    5.178860]   CM = 0, WnR = 0
> > > > > [    5.181872] [0000000000000002] user address but active_mm is swapper
> > > > > [    5.188293] Internal error: Oops: 96000004 [#1] PREEMPT SMP
> > > > > [    5.193922] Modules linked in:
> > > > > [    5.197022] CPU: 4 PID: 57 Comm: kworker/4:3 Not tainted 5.10.44-rc2 #1
> > > > > [    5.203697] Hardware name: Thundercomm Dragonboard 845c (DT)
> > > > > [    5.204022] ufshcd-qcom 1d84000.ufshc: ufshcd_print_pwr_info:[RX,
> > > > > TX]: gear=[3, 3], lane[2, 2], pwr[FAST MODE, FAST MODE], rate = 2
> > > > > [    5.209434] Workqueue: events deferred_probe_work_func
> > > > > [    5.221786] ufshcd-qcom 1d84000.ufshc:
> > > > > ufshcd_find_max_sup_active_icc_level: Regulator capability was not
> > > > > set, actvIccLevel=0
> > > > > [    5.226541] pstate: 60c00005 (nZCv daif +PAN +UAO -TCO BTYPE=--)
> > > > > [    5.226551] pc : inode_permission+0x2c/0x178
> > > > > [    5.226559] lr : lookup_one_len_common+0xac/0x100
> > > > > 
> > > > > ref:
> > > > > https://lkft.validation.linaro.org/scheduler/job/2899138#L2873
> > > > > 
> > > > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > > > > 
> > > > > There is a crash like this reported and discussed on the mailing thread.
> > > > > https://lore.kernel.org/linux-usb/20210608105656.10795-1-peter.chen@kernel.org/
> > > > 
> > > > Is this crash just on shutdown?  That's what that commit was fixing, but
> > > > it is resolving an error that should not be in the 5.10.y tree.
> > > 
> > > Peter reported and fixed it based on reproducing the crash from shutting
> > > down but in my manual testing I found that it could be triggered any
> > > time dwc3_remove() is called, though I surmised it would be a rare
> > > occurence.  In this particular case however Naresh is reporting it is
> > > triggered even during bootup since dwc3-qcom would add its
> > > dwc3 child, but because it encounters a probe deferral it has to
> > > subsequently trigger the dwc3 driver remove callback right after it was
> > > just probed.
> > > 
> > > So I think it would be good if Peter's follow-up change
> > > (2a042767814b in your usb-next branch) can please go into stable as well
> > > as it should help not only for the shutdown/reboot case.  Otherwise,
> > > my change "usb: dwc3: debugfs: Add and remove endpoint dirs
> > > dynamically" could be simply be dropped until they can go in together.
> > 
> > That will all have to wait until 5.14-rc1 as these patches are not
> > queued up to hit Linus's tree until then.  I was not aware that this
> > problem was showing up anywhere except in linux-next.
> > 
> > If we need a fix in 5.13-final before then, please let me know and
> > submit it so that I can take it in my tree and get it to Linus quickly.
> 
> Sure. I just responded to one of your auto-replies about Peter's patch
> "usb: dwc3: core: fix kernel panic when do reboot" getting accepted for
> usb-next and asked if you can take it for usb-linus for 5.13-final asap
> as well. Or did you mean I should submit a new separate patch?
> 
> As for this failure in $subject on 5.10.44-rc2, I think the prudent
> thing would be to drop my patch "usb: dwc3: debugfs: Add and remove
> endpoint dirs dynamically" from the stable queue altogether and revisit
> it later (when it can go in along with Peter's fix).  I hope it's not
> too late to NAK it (at least for now) on stable?
> 
> Sorry for the mess.

Ick, yeah, that's a mess, we had this commit in two different branches,
and that's what happens when this gets out of sync...

Anyway, I've cherry-picked this commit now to my branch for 5.13-final,
fixed up the "Fixes:" line, and will get it to Linus soon.

I'll also go drop this "dwc3: debugfs:" patch from the stable queue as
it will cause problems for people, and not add it back until I can get
this fix into Linus's tree as well.

thanks,

greg k-h
