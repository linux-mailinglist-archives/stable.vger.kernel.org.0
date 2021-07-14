Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1633C8555
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 15:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbhGNNeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 09:34:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231730AbhGNNeF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 09:34:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB528613B6;
        Wed, 14 Jul 2021 13:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626269473;
        bh=SV7sJSRe1aFUuLtQS99fMd9oF2zB7ZWYui7q+JCwgGw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oJJk6+vhc0jI0ZhF90jb+S2WC44p+xmjzWq750MC+U1z4wy5PlOTAE+orcawuB47O
         6sHjj6Pdcx12bmXz9PCnNOhNZAuZF9qQOIXIEQyVXrc9fbyviBaViafC3PIsphCVfm
         +isQaI3wvOnCU91hqKF1Rnwig1/0hWaKFMRcEVQQ=
Date:   Wed, 14 Jul 2021 15:31:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Holger Kiehl <Holger.Kiehl@dwd.de>
Cc:     Jan Kara <jack@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 000/800] 5.13.2-rc1 review
Message-ID: <YO7nHhW2t4wEiI9G@kroah.com>
References: <20210712060912.995381202@linuxfoundation.org>
 <68b6051-09c-9dc8-4b52-c4e766fee5@praktifix.dwd.de>
 <YO56HTE3k95JLeje@kroah.com>
 <50fb4713-6b5d-b5e0-786a-6ece57896d2f@praktifix.dwd.de>
 <df63b875-f140-606a-862a-73b102345cd@praktifix.dwd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df63b875-f140-606a-862a-73b102345cd@praktifix.dwd.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 14, 2021 at 01:26:26PM +0000, Holger Kiehl wrote:
> On Wed, 14 Jul 2021, Holger Kiehl wrote:
> 
> > On Wed, 14 Jul 2021, Greg Kroah-Hartman wrote:
> > 
> > > On Wed, Jul 14, 2021 at 05:39:43AM +0000, Holger Kiehl wrote:
> > > > Hello,
> > > > 
> > > > On Mon, 12 Jul 2021, Greg Kroah-Hartman wrote:
> > > > 
> > > > > This is the start of the stable review cycle for the 5.13.2 release.
> > > > > There are 800 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > > 
> > > > > Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> > > > > Anything received after that time might be too late.
> > > > > 
> > > > With this my system no longer boots:
> > > > 
> > > >    [  OK  ] Reached target Swap.
> > > >    [   75.213852] NMI watchdog: Watchdog detected hard LOCKUP on cpu 0
> > > >    [   75.213926] NMI watchdog: Watchdog detected hard LOCKUP on cpu 2
> > > >    [   75.213962] NMI watchdog: Watchdog detected hard LOCKUP on cpu 4
> > > >    [FAILED] Failed to start Wait for udev To Complete Device Initialization.
> > > >    See 'systemctl status systemd-udev-settle.service' for details.
> > > >             Starting Activation of DM RAID sets...
> > > >    [      ] (1 of 2) A start job is running for Activation of DM RAID sets (..min ..s / no limit)
> > > >    [      ] (2 of 2) A start job is running for Monitoring of LVM2 mirrors, snapshots etc. using dmeventd or progress polling (..min ..s / no limit)
> > > > 
> > > > System is a Fedora 34 with all updates applied. Two other similar
> > > > systems with AMD CPUs (Ryzen 4750G + 3400G) this does not happen
> > > > and boots fine. The system where it does not boot has an Intel
> > > > Xeon E3-1285L v4 CPU. All of them use a dm_crypt root filesystem.
> > > > 
> > > > Any idea which patch I should drop to see if it boots again. I already
> > > > dropped
> > > > 
> > > >    [PATCH 5.13 743/800] ASoC: Intel: sof_sdw: add quirk support for Brya and BT-offload
> > > > 
> > > > and I just see that this one should also be dropped:
> > > > 
> > > >    [PATCH 5.13 768/800] hugetlb: address ref count racing in prep_compound_gigantic_page
> > > > 
> > > > Will still need to test this.
> > > 
> > > Can you run 'git bisect' to see what commit causes the problem?
> > > 
> > Yes, will try to do that. I think it will take some time ...
> > 
> With the help of Pavel Machek and Jiri Slaby I was able 'git bisect'
> this to:
> 
>    yoda:/usr/src/kernels/linux-5.13.y# git bisect good
>    a483f513670541227e6a31ac7141826b8c785842 is the first bad commit
>    commit a483f513670541227e6a31ac7141826b8c785842
>    Author: Jan Kara <jack@suse.cz>
>    Date:   Wed Jun 23 11:36:33 2021 +0200
> 
>        bfq: Remove merged request already in bfq_requests_merged()
> 
>        [ Upstream commit a921c655f2033dd1ce1379128efe881dda23ea37 ]
> 
>        Currently, bfq does very little in bfq_requests_merged() and handles all
>        the request cleanup in bfq_finish_requeue_request() called from
>        blk_mq_free_request(). That is currently safe only because
>        blk_mq_free_request() is called shortly after bfq_requests_merged()
>        while bfqd->lock is still held. However to fix a lock inversion between
>        bfqd->lock and ioc->lock, we need to call blk_mq_free_request() after
>        dropping bfqd->lock. That would mean that already merged request could
>        be seen by other processes inside bfq queues and possibly dispatched to
>        the device which is wrong. So move cleanup of the request from
>        bfq_finish_requeue_request() to bfq_requests_merged().
> 
>        Acked-by: Paolo Valente <paolo.valente@linaro.org>
>        Signed-off-by: Jan Kara <jack@suse.cz>
>        Link: https://lore.kernel.org/r/20210623093634.27879-2-jack@suse.cz
>        Signed-off-by: Jens Axboe <axboe@kernel.dk>
>        Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
>     block/bfq-iosched.c | 41 +++++++++++++----------------------------
>     1 file changed, 13 insertions(+), 28 deletions(-)
> 
> Holger

Wonderful!

So if you drop that, all works well?  I'll go drop that from the queues
now.

thanks,

greg k-h
