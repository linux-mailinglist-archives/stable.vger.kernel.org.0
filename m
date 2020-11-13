Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14CC62B2914
	for <lists+stable@lfdr.de>; Sat, 14 Nov 2020 00:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgKMXT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Nov 2020 18:19:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:45080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgKMXT4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Nov 2020 18:19:56 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3194B22256;
        Fri, 13 Nov 2020 23:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605309595;
        bh=d1+vwm7q5zqxJz8uUnUUrY8tcJifIeZAylikIYeQdb8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tR0c5z8/xo7blosIiFBRvtCwJ2fs0gGY+AWvbzQLUVqKAFOsuLiOib9im6VB3JCEE
         r+c4fHFYTtFXld55i6+WwsKCqvOaPFiiINqG4aATdr0l/SmhFSenNx4CoGh1IV1anc
         ID1Eo08x7LkjSjQiPE3RvNw0rHipvcB5gmJKvPmg=
Date:   Sat, 14 Nov 2020 00:20:51 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        NeilBrown <neil@brown.name>, stable@vger.kernel.org
Subject: Re: [PATCH] staging: mt7621-pci: avoid to request pci bus resources
Message-ID: <X68U0wyL0QHLfFbY@kroah.com>
References: <20201102202515.19073-1-sergio.paracuellos@gmail.com>
 <CAMhs-H9DRT6G0GQg-gpDT=q_BniDf3EbE3Qq2YbHCXZSK7nPqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMhs-H9DRT6G0GQg-gpDT=q_BniDf3EbE3Qq2YbHCXZSK7nPqw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 13, 2020 at 04:26:08PM +0100, Sergio Paracuellos wrote:
> Hi Greg,
> 
> On Mon, Nov 2, 2020 at 9:25 PM Sergio Paracuellos
> <sergio.paracuellos@gmail.com> wrote:
> >
> > After upgrading kernel to version 5.9.x the driver was not
> > working anymore showing the following kernel trace:
> >
> > ...
> > mt7621-pci 1e140000.pcie: resource collision:
> > [mem 0x60000000-0x6fffffff] conflicts with pcie@1e140000 [mem 0x60000000-0x6fffffff]
> > ------------[ cut here ]------------
> > WARNING: CPU: 2 PID: 73 at kernel/resource.c:1400
> > devm_request_resource+0xfc/0x10c
> > Modules linked in:
> > CPU: 2 PID: 73 Comm: kworker/2:1 Not tainted 5.9.2 #0
> > Workqueue: events deferred_probe_work_func
> > Stack : 00000000 81590000 807d0a1c 808a0000 8fd49080
> >         807d0000 00000009 808ac820
> >         00000001 808338d0 7fff0001 800839dc 00000049
> >         00000001 8fe51b00 367204ab
> >         00000000 00000000 807d0a1c 807c0000 00000001
> >         80082358 8fe50000 00559000
> >         00000000 8fe519f1 ffffffff 00000005 00000000
> >         00000001 00000000 807d0000
> >         00000009 808ac820 00000001 808338d0 00000001
> >         803bf1b0 00000008 81390008
> >
> > Call Trace:
> > [<8000d018>] show_stack+0x30/0x100
> > [<8032e66c>] dump_stack+0xa4/0xd4
> > [<8002db1c>] __warn+0xc0/0x134
> > [<8002dbec>] warn_slowpath_fmt+0x5c/0xac
> > [<80033b34>] devm_request_resource+0xfc/0x10c
> > [<80365ff8>] devm_request_pci_bus_resources+0x58/0xdc
> > [<8048e13c>] mt7621_pci_probe+0x8dc/0xe48
> > [<803d2140>] platform_drv_probe+0x40/0x94
> > [<803cfd94>] really_probe+0x108/0x4ec
> > [<803cd958>] bus_for_each_drv+0x70/0xb0
> > [<803d0388>] __device_attach+0xec/0x164
> > [<803cec8c>] bus_probe_device+0xa4/0xc0
> > [<803cf1c4>] deferred_probe_work_func+0x80/0xc4
> > [<80048444>] process_one_work+0x260/0x510
> > [<80048a4c>] worker_thread+0x358/0x5cc
> > [<8004f7d0>] kthread+0x134/0x13c
> > [<80007478>] ret_from_kernel_thread+0x14/0x1c
> > ---[ end trace a9dd2e37537510d3 ]---
> > mt7621-pci 1e140000.pcie: Error requesting resources
> > mt7621-pci: probe of 1e140000.pcie failed with error -16
> > ...
> >
> > With commit 669cbc708122 ("PCI: Move DT resource setup into
> > devm_pci_alloc_host_bridge()"), the DT 'ranges' is parsed and populated
> > into resources when the host bridge is allocated. The resources are
> > requested as well, but that happens a 2nd time for this driver in
> > mt7621_pcie_request_resources(). Hence we should avoid this second
> > request.
> >
> > Also, the bus ranges was also populated by default, so we can remove
> > it from mt7621_pcie_request_resources() to avoid the following trace
> > if we don't avoid it:
> >
> > pci_bus 0000:00: busn_res: can not insert [bus 00-ff]
> > under domain [bus 00-ff] (conflicts with (null) [bus 00-ff])
> >
> > Function 'mt7621_pcie_request_resources' has been renamed into
> > 'mt7621_pcie_add_resources' which now is a more accurate name
> > for this function.
> >
> > Cc: stable@vger.kernel.org#5.9.x-
> > Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
> 
> This patch have to be added also for stable 5.9.x because driver is
> broken in all kernel 5.9.x releases. I noticed a new stable release
> comes three days ago (5.9.8) and this was not added. I was wondering
> if the way I marked this patch to be included is wrong.

Is this patch in Linus's tree yet?  If not, we can't add it to any
stable tree.  That has to happen first.

thanks,

greg k-h
