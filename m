Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2FDC3A76D6
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 08:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhFOGH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 02:07:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229493AbhFOGH4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 02:07:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45A5261403;
        Tue, 15 Jun 2021 06:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623737152;
        bh=Sy29Y3LT3i5EaFLnNZYEUnT/LCJHTOdlUMaNhuACiNs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B5601PbOXwYO+bP/NreNlZnZh+spkPaKvsCeHjhUktkv2tNUpYWxNKSorlLaWjfPL
         max8kLu7bJe3f8P7kHZXszLVfG9JZZ8e+ZycMbkDfmKkUBgOGLEzPIAUOYJ5sVKZwA
         I4ii0mVDqpwOHrSBkAiNw/LX/oT6GTusiMFptHW0=
Date:   Tue, 15 Jun 2021 08:05:50 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-usb@vger.kernel.org,
        Peter Chen <peter.chen@kernel.org>,
        Jack Pham <jackp@codeaurora.org>,
        Felipe Balbi <balbi@kernel.org>
Subject: Re: [PATCH 5.10 000/130] 5.10.44-rc2 review
Message-ID: <YMhDPjbfTFpUtTs3@kroah.com>
References: <20210614161424.091266895@linuxfoundation.org>
 <CA+G9fYsfvtr7NNcb0bvEZpYYotdY7Uf+wMY22iLhr0weZ8Om3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsfvtr7NNcb0bvEZpYYotdY7Uf+wMY22iLhr0weZ8Om3g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 15, 2021 at 09:41:26AM +0530, Naresh Kamboju wrote:
> Hi Greg,
> 
> On Mon, 14 Jun 2021 at 21:45, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.44 release.
> > There are 130 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 16 Jun 2021 16:13:59 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.44-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> The following kernel crash reported on stable rc 5.10.44-rc2 arm64 db845c board.
> 
> [    5.127966] dwc3-qcom a6f8800.usb: failed to get usb-ddr path: -517
> [    5.145567] Unable to handle kernel NULL pointer dereference at
> virtual address 0000000000000002
> [    5.154451] Mem abort info:
> [    5.157296]   ESR = 0x96000004
> [    5.160401]   EC = 0x25: DABT (current EL), IL = 32 bits
> [    5.165771]   SET = 0, FnV = 0
> [    5.168873]   EA = 0, S1PTW = 0
> [    5.172064] Data abort info:
> [    5.174980]   ISV = 0, ISS = 0x00000004
> [    5.178860]   CM = 0, WnR = 0
> [    5.181872] [0000000000000002] user address but active_mm is swapper
> [    5.188293] Internal error: Oops: 96000004 [#1] PREEMPT SMP
> [    5.193922] Modules linked in:
> [    5.197022] CPU: 4 PID: 57 Comm: kworker/4:3 Not tainted 5.10.44-rc2 #1
> [    5.203697] Hardware name: Thundercomm Dragonboard 845c (DT)
> [    5.204022] ufshcd-qcom 1d84000.ufshc: ufshcd_print_pwr_info:[RX,
> TX]: gear=[3, 3], lane[2, 2], pwr[FAST MODE, FAST MODE], rate = 2
> [    5.209434] Workqueue: events deferred_probe_work_func
> [    5.221786] ufshcd-qcom 1d84000.ufshc:
> ufshcd_find_max_sup_active_icc_level: Regulator capability was not
> set, actvIccLevel=0
> [    5.226541] pstate: 60c00005 (nZCv daif +PAN +UAO -TCO BTYPE=--)
> [    5.226551] pc : inode_permission+0x2c/0x178
> [    5.226559] lr : lookup_one_len_common+0xac/0x100
> 
> ref:
> https://lkft.validation.linaro.org/scheduler/job/2899138#L2873
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> There is a crash like this reported and discussed on the mailing thread.
> https://lore.kernel.org/linux-usb/20210608105656.10795-1-peter.chen@kernel.org/

Is this crash just on shutdown?  That's what that commit was fixing, but
it is resolving an error that should not be in the 5.10.y tree.

thanks,

greg k-h
