Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8947F45C6A3
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354648AbhKXOKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:10:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:57142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354597AbhKXOI0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:08:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39B1B613AD;
        Wed, 24 Nov 2021 13:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759713;
        bh=drosgPC9YmQkwX7TqquI1QNkbudQ1d9rfHOJEZiUvaY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jDh6HFSxb741/RwnoMfiahC9mi57pXU3CRpia2kjPj5dxUA2Jh798e/RPoEQ0mUxc
         DtwomeiKsK7LCxrpz9Pxrw0iUQdg1xmQHVwUhy9QhCQZpzDCbjNJurwkQm5OYC9nxK
         qw4M8AIH4OYi4k4JdlH6U6dhmgvlVOIPcu+EF3j8=
Date:   Wed, 24 Nov 2021 14:15:10 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+e4df4e1389e28972e955@syzkaller.appspotmail.com,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.14 181/251] net: vlan: fix a UAF in vlan_dev_real_dev()
Message-ID: <YZ463j6mlk/UUwar@kroah.com>
References: <20211124115710.214900256@linuxfoundation.org>
 <20211124115716.547727004@linuxfoundation.org>
 <20211124125018.GG4670@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124125018.GG4670@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 08:50:18AM -0400, Jason Gunthorpe wrote:
> On Wed, Nov 24, 2021 at 12:57:03PM +0100, Greg Kroah-Hartman wrote:
> > From: Ziyang Xuan <william.xuanziyang@huawei.com>
> > 
> > [ Upstream commit 563bcbae3ba233c275c244bfce2efe12938f5363 ]
> > 
> > The real_dev of a vlan net_device may be freed after
> > unregister_vlan_dev(). Access the real_dev continually by
> > vlan_dev_real_dev() will trigger the UAF problem for the
> > real_dev like following:
> > 
> > ==================================================================
> > BUG: KASAN: use-after-free in vlan_dev_real_dev+0xf9/0x120
> > Call Trace:
> >  kasan_report.cold+0x83/0xdf
> >  vlan_dev_real_dev+0xf9/0x120
> >  is_eth_port_of_netdev_filter.part.0+0xb1/0x2c0
> >  is_eth_port_of_netdev_filter+0x28/0x40
> >  ib_enum_roce_netdev+0x1a3/0x300
> >  ib_enum_all_roce_netdevs+0xc7/0x140
> >  netdevice_event_work_handler+0x9d/0x210
> > ...
> > 
> > Freed by task 9288:
> >  kasan_save_stack+0x1b/0x40
> >  kasan_set_track+0x1c/0x30
> >  kasan_set_free_info+0x20/0x30
> >  __kasan_slab_free+0xfc/0x130
> >  slab_free_freelist_hook+0xdd/0x240
> >  kfree+0xe4/0x690
> >  kvfree+0x42/0x50
> >  device_release+0x9f/0x240
> >  kobject_put+0x1c8/0x530
> >  put_device+0x1b/0x30
> >  free_netdev+0x370/0x540
> >  ppp_destroy_interface+0x313/0x3d0
> > ...
> > 
> > Move the put_device(real_dev) to vlan_dev_free(). Ensure
> > real_dev not be freed before vlan_dev unregistered.
> > 
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Reported-by: syzbot+e4df4e1389e28972e955@syzkaller.appspotmail.com
> > Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  net/8021q/vlan.c     | 3 ---
> >  net/8021q/vlan_dev.c | 3 +++
> >  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> This patch is known to be broken, it should not be backported

It is already in a bunch of branches :(

What is the upstream revert of this commit in Linus's tree?

thanks,

greg k-h
