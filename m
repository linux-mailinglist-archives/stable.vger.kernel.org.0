Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7445C10C45C
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 08:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfK1Hh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 02:37:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:58196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727142AbfK1Hh4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Nov 2019 02:37:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29A932168B;
        Thu, 28 Nov 2019 07:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574926675;
        bh=/x6FQ3ngN2ChmVvaEh2WWu7L67kYDuJUqi8t3X4tz3Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a6D/MqZWmGb27EcZreH5VhTEhVHsS2C2DZ0OYVyWi5fEuzxbYp4wVGnnLtYbFFZQn
         C8O477RVTieVdOXAVdWSCUS+spGC5U4mBKiXljr0qlNtmTE0yJFb058jXywRjQIq6a
         yRsGOH86bDZK6PuOBUAbRkb6C/V1kbMbTpVS3HFY=
Date:   Thu, 28 Nov 2019 08:35:31 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Jouni Hogander <jouni.hogander@unikie.com>
Subject: Re: [PATCH 4.19 282/306] net-sysfs: Fix reference count leak in
 rx|netdev_queue_add_kobject
Message-ID: <20191128073531.GD3317872@kroah.com>
References: <20191127203114.766709977@linuxfoundation.org>
 <20191127203135.382666831@linuxfoundation.org>
 <20191128033302.riq5c55kt7mre3vw@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191128033302.riq5c55kt7mre3vw@toshiba.co.jp>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 28, 2019 at 12:33:02PM +0900, Nobuhiro Iwamatsu wrote:
> Hi,
> 
> On Wed, Nov 27, 2019 at 09:32:12PM +0100, Greg Kroah-Hartman wrote:
> > From: Jouni Hogander <jouni.hogander@unikie.com>
> > 
> > commit b8eb718348b8fb30b5a7d0a8fce26fb3f4ac741b upstream.
> > 
> > kobject_init_and_add takes reference even when it fails. This has
> > to be given up by the caller in error handling. Otherwise memory
> > allocated by kobject_init_and_add is never freed. Originally found
> > by Syzkaller:
> > 
> > BUG: memory leak
> > unreferenced object 0xffff8880679f8b08 (size 8):
> >   comm "netdev_register", pid 269, jiffies 4294693094 (age 12.132s)
> >   hex dump (first 8 bytes):
> >     72 78 2d 30 00 36 20 d4                          rx-0.6 .
> >   backtrace:
> >     [<000000008c93818e>] __kmalloc_track_caller+0x16e/0x290
> >     [<000000001f2e4e49>] kvasprintf+0xb1/0x140
> >     [<000000007f313394>] kvasprintf_const+0x56/0x160
> >     [<00000000aeca11c8>] kobject_set_name_vargs+0x5b/0x140
> >     [<0000000073a0367c>] kobject_init_and_add+0xd8/0x170
> >     [<0000000088838e4b>] net_rx_queue_update_kobjects+0x152/0x560
> >     [<000000006be5f104>] netdev_register_kobject+0x210/0x380
> >     [<00000000e31dab9d>] register_netdevice+0xa1b/0xf00
> >     [<00000000f68b2465>] __tun_chr_ioctl+0x20d5/0x3dd0
> >     [<000000004c50599f>] tun_chr_ioctl+0x2f/0x40
> >     [<00000000bbd4c317>] do_vfs_ioctl+0x1c7/0x1510
> >     [<00000000d4c59e8f>] ksys_ioctl+0x99/0xb0
> >     [<00000000946aea81>] __x64_sys_ioctl+0x78/0xb0
> >     [<0000000038d946e5>] do_syscall_64+0x16f/0x580
> >     [<00000000e0aa5d8f>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >     [<00000000285b3d1a>] 0xffffffffffffffff
> > 
> > Cc: David Miller <davem@davemloft.net>
> > Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> > Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> 
> We also need the following commits to fix this issue:
> 
> commit 48a322b6f9965b2f1e4ce81af972f0e287b07ed0
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Wed Nov 20 19:19:07 2019 -0800
> 
>     net-sysfs: fix netdev_queue_add_kobject() breakage
> 
>     kobject_put() should only be called in error path.
> 
>     Fixes: b8eb718348b8 ("net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject")
>     Signed-off-by: Eric Dumazet <edumazet@google.com>
>     Cc: Jouni Hogander <jouni.hogander@unikie.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> And this should also apply to 4.14.y and 5.3.y.
> Please apply this commnit to 4.14.y, 4.19.y and 5.3.y

Thanks for the report, will go queue it up now.

greg k-h
