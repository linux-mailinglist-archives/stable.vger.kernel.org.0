Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7454110C2DE
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 04:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfK1DdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 22:33:17 -0500
Received: from mo-csw1515.securemx.jp ([210.130.202.154]:36624 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727228AbfK1DdQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 22:33:16 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1515) id xAS3X6ob005472; Thu, 28 Nov 2019 12:33:06 +0900
X-Iguazu-Qid: 34trMIO5KQudw3XypG
X-Iguazu-QSIG: v=2; s=0; t=1574911986; q=34trMIO5KQudw3XypG; m=TQwososeHkYd8YPQcmO3nAFvyvjdHxKubdsnV5Ex9r8=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1510) id xAS3X4IG034859;
        Thu, 28 Nov 2019 12:33:05 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id xAS3X4FH013494;
        Thu, 28 Nov 2019 12:33:04 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id xAS3X4Sr028371;
        Thu, 28 Nov 2019 12:33:04 +0900
Date:   Thu, 28 Nov 2019 12:33:02 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Jouni Hogander <jouni.hogander@unikie.com>
Subject: Re: [PATCH 4.19 282/306] net-sysfs: Fix reference count leak in
 rx|netdev_queue_add_kobject
X-TSB-HOP: ON
Message-ID: <20191128033302.riq5c55kt7mre3vw@toshiba.co.jp>
References: <20191127203114.766709977@linuxfoundation.org>
 <20191127203135.382666831@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127203135.382666831@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Wed, Nov 27, 2019 at 09:32:12PM +0100, Greg Kroah-Hartman wrote:
> From: Jouni Hogander <jouni.hogander@unikie.com>
> 
> commit b8eb718348b8fb30b5a7d0a8fce26fb3f4ac741b upstream.
> 
> kobject_init_and_add takes reference even when it fails. This has
> to be given up by the caller in error handling. Otherwise memory
> allocated by kobject_init_and_add is never freed. Originally found
> by Syzkaller:
> 
> BUG: memory leak
> unreferenced object 0xffff8880679f8b08 (size 8):
>   comm "netdev_register", pid 269, jiffies 4294693094 (age 12.132s)
>   hex dump (first 8 bytes):
>     72 78 2d 30 00 36 20 d4                          rx-0.6 .
>   backtrace:
>     [<000000008c93818e>] __kmalloc_track_caller+0x16e/0x290
>     [<000000001f2e4e49>] kvasprintf+0xb1/0x140
>     [<000000007f313394>] kvasprintf_const+0x56/0x160
>     [<00000000aeca11c8>] kobject_set_name_vargs+0x5b/0x140
>     [<0000000073a0367c>] kobject_init_and_add+0xd8/0x170
>     [<0000000088838e4b>] net_rx_queue_update_kobjects+0x152/0x560
>     [<000000006be5f104>] netdev_register_kobject+0x210/0x380
>     [<00000000e31dab9d>] register_netdevice+0xa1b/0xf00
>     [<00000000f68b2465>] __tun_chr_ioctl+0x20d5/0x3dd0
>     [<000000004c50599f>] tun_chr_ioctl+0x2f/0x40
>     [<00000000bbd4c317>] do_vfs_ioctl+0x1c7/0x1510
>     [<00000000d4c59e8f>] ksys_ioctl+0x99/0xb0
>     [<00000000946aea81>] __x64_sys_ioctl+0x78/0xb0
>     [<0000000038d946e5>] do_syscall_64+0x16f/0x580
>     [<00000000e0aa5d8f>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>     [<00000000285b3d1a>] 0xffffffffffffffff
> 
> Cc: David Miller <davem@davemloft.net>
> Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 

We also need the following commits to fix this issue:

commit 48a322b6f9965b2f1e4ce81af972f0e287b07ed0
Author: Eric Dumazet <edumazet@google.com>
Date:   Wed Nov 20 19:19:07 2019 -0800

    net-sysfs: fix netdev_queue_add_kobject() breakage

    kobject_put() should only be called in error path.

    Fixes: b8eb718348b8 ("net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject")
    Signed-off-by: Eric Dumazet <edumazet@google.com>
    Cc: Jouni Hogander <jouni.hogander@unikie.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

And this should also apply to 4.14.y and 5.3.y.
Please apply this commnit to 4.14.y, 4.19.y and 5.3.y

Best regards,
  Nobuhiro


> ---
>  net/core/net-sysfs.c |   24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
> 
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -932,21 +932,23 @@ static int rx_queue_add_kobject(struct n
>  	error = kobject_init_and_add(kobj, &rx_queue_ktype, NULL,
>  				     "rx-%u", index);
>  	if (error)
> -		return error;
> +		goto err;
>  
>  	dev_hold(queue->dev);
>  
>  	if (dev->sysfs_rx_queue_group) {
>  		error = sysfs_create_group(kobj, dev->sysfs_rx_queue_group);
> -		if (error) {
> -			kobject_put(kobj);
> -			return error;
> -		}
> +		if (error)
> +			goto err;
>  	}
>  
>  	kobject_uevent(kobj, KOBJ_ADD);
>  
>  	return error;
> +
> +err:
> +	kobject_put(kobj);
> +	return error;
>  }
>  #endif /* CONFIG_SYSFS */
>  
> @@ -1471,21 +1473,21 @@ static int netdev_queue_add_kobject(stru
>  	error = kobject_init_and_add(kobj, &netdev_queue_ktype, NULL,
>  				     "tx-%u", index);
>  	if (error)
> -		return error;
> +		goto err;
>  
>  	dev_hold(queue->dev);
>  
>  #ifdef CONFIG_BQL
>  	error = sysfs_create_group(kobj, &dql_group);
> -	if (error) {
> -		kobject_put(kobj);
> -		return error;
> -	}
> +	if (error)
> +		goto err;
>  #endif
>  
>  	kobject_uevent(kobj, KOBJ_ADD);
>  
> -	return 0;
> +err:
> +	kobject_put(kobj);
> +	return error;
>  }
>  #endif /* CONFIG_SYSFS */
>  
> 
> 
> 
