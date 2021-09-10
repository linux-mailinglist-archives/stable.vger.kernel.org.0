Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB1A406766
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 08:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbhIJGvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 02:51:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231223AbhIJGvs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 02:51:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC13F60F9C;
        Fri, 10 Sep 2021 06:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631256637;
        bh=JmXKbuN8Nd1iPptW4uq9nfAmi+t1fzNup71N0W0sBqQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xjMEyol4EaF4x1VFpGpXgcJGDP9E7ajSXD2gWtagaRRO6+jyKjNpPp3ep/MuxSVA6
         q0pudu9z82pv6aqR37GMvXre6TgWPIrScPeyb4pQGaSdP+uLKfR7IDae9WIoXAacLr
         8qUxKdpW6JIad0V88Xg6+61hu9uqI/jUOFhUSFHU=
Date:   Fri, 10 Sep 2021 08:50:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Yi Zhang <yi.zhang@redhat.com>,
        linux-block <linux-block@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [bug report] NULL pointer at blk_mq_put_rq_ref+0x20/0xb4
 observed with blktests on 5.13.15
Message-ID: <YTsAOtychCR8m3WA@kroah.com>
References: <CAHj4cs-noupgFn3QjB96Z20hv-BhFLHOyFZFEtrhGpESkeoRSA@mail.gmail.com>
 <CAFj5m9J4sxRwQb7+nHzYOurX9QRpEgsEMCqdx4SHA4THnsJXBA@mail.gmail.com>
 <YTnc5Ja/DKR30Euy@kroah.com>
 <YTq4QFWexPF9aQvG@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTq4QFWexPF9aQvG@T590>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 10, 2021 at 09:43:28AM +0800, Ming Lei wrote:
> On Thu, Sep 09, 2021 at 12:07:32PM +0200, Greg KH wrote:
> > On Thu, Sep 09, 2021 at 05:14:18PM +0800, Ming Lei wrote:
> > > On Thu, Sep 9, 2021 at 4:47 PM Yi Zhang <yi.zhang@redhat.com> wrote:
> > > >
> > > > Hello
> > > >
> > > > I found this issue with blktests on[1], did we miss some patch on stable?
> > > > [1]
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > > > queue/5.13
> > > >
> > > > [   68.989907] run blktests block/006 at 2021-09-09 04:34:35
> > > > [   69.085724] null_blk: module loaded
> > > > [   74.271624] Unable to handle kernel NULL pointer dereference at
> > > > virtual address 00000000000002b8
> > > > [   74.280414] Mem abort info:
> > > > [   74.283195]   ESR = 0x96000004
> > > > [   74.286245]   EC = 0x25: DABT (current EL), IL = 32 bits
> > > > [   74.291545]   SET = 0, FnV = 0
> > > > [   74.294587]   EA = 0, S1PTW = 0
> > > > [   74.297720] Data abort info:
> > > > [   74.300588]   ISV = 0, ISS = 0x00000004
> > > > [   74.304411]   CM = 0, WnR = 0
> > > > [   74.307368] user pgtable: 4k pages, 48-bit VAs, pgdp=000008004366e000
> > > > [   74.313796] [00000000000002b8] pgd=0000000000000000, p4d=0000000000000000
> > > > [   74.320577] Internal error: Oops: 96000004 [#1] SMP
> > > > [   74.325443] Modules linked in: null_blk mlx5_ib ib_uverbs ib_core
> > > > rfkill sunrpc vfat fat joydev acpi_ipmi ipmi_ssif cdc_ether usbnet mii
> > > > mlx5_core psample ipmi_devintf mlxfw tls ipmi_msghandler arm_cmn
> > > > cppc_cpufreq arm_dsu_pmu acpi_tad fuse zram ip_tables xfs ast
> > > > i2c_algo_bit drm_vram_helper drm_kms_helper crct10dif_ce syscopyarea
> > > > ghash_ce sysfillrect uas sysimgblt sbsa_gwdt fb_sys_fops cec
> > > > drm_ttm_helper ttm nvme usb_storage nvme_core drm xgene_hwmon
> > > > aes_neon_bs
> > > > [   74.366458] CPU: 31 PID: 2511 Comm: fio Not tainted 5.13.15+ #1
> > > 
> > > Looks the fixes haven't land on linux-5.13.y:
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a9ed27a764156929efe714033edb3e9023c5f321
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c2da19ed50554ce52ecbad3655c98371fe58599f
> > 
> > Now queued up.  Someone could have told us they were needed :)
> 
> Thanks for queuing it up, sorry for not Cc stable.
> 
> BTW, the following two patches are missed too in linux-5.13-y:
> 
> 364b61818f65 blk-mq: clearing flush request reference in tags->rqs[]

This one applies, but,

> bd63141d585b blk-mq: clear stale request in tags->rq[] before freeing one request pool

This one does not.

Please provide working backports for both of these if you want to see
them merged into the stable trees.  And what about 5.10 for them as
well?

thanks,

greg k-h
