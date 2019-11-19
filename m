Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75935101A7F
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 08:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfKSHtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 02:49:49 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.167]:19404 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfKSHts (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 02:49:48 -0500
X-Greylist: delayed 358 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Nov 2019 02:49:47 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1574149786;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=Xr2GSIGT6PAYO7fLO801aLSNVXlX7d5ZM8pV1OAozA0=;
        b=H5inGi1q+hs2D+kXbUesB5CNT+Ea6sec2PmQOyc49cXKCtWFydA7RHhiI2K0cPvgKv
        ZN47/05e4b/WSM7/R2+1jr0qzwUvOx4EWsm9JrHu5dk15g5c3sN01Ft7nxmCvrYDXjWH
        N/Na58p3lXurLHJG0dzVY1oPqily9utVpBz05RlwyMmTjitUw44Qg3PnIYbiugrm3uGZ
        9y5smbxd7hhqgr1Pto8hwMC8s3atlE6ZicnABLyhCjJlZ2XNZjfx71Y8m4U91b8nmxs8
        K25YjE+K+ZoXn/kjBQ7Sa/epj92/oTmijgmp9TJNBbA6wSfUf79qAYnLFpMpadJbj2Ig
        lz9A==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJVch5l0xf"
X-RZG-CLASS-ID: mo00
Received: from [192.168.1.177]
        by smtp.strato.de (RZmta 44.29.0 DYNA|AUTH)
        with ESMTPSA id C03a03vAJ7hk2Al
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Tue, 19 Nov 2019 08:43:46 +0100 (CET)
Subject: Re: [PATCH 5.3 09/48] slip: Fix memory leak in slip_open error path
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Jouni Hogander <jouni.hogander@unikie.com>
References: <20191119050946.745015350@linuxfoundation.org>
 <20191119050955.380296035@linuxfoundation.org>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <eb6fcac2-abdd-cb83-0942-09878b5e4751@hartkopp.net>
Date:   Tue, 19 Nov 2019 08:43:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191119050955.380296035@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

thanks for taking care of the slip.c patches.

The original issue was reported by Jouni for "slcan.c" which is also 
referenced in this commit message. But it was probably overlooked at 
upstream time that it should go into stable too.

The slcan.c fix is here:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ed50e1600b4483c049ce76e6bd3b665a6a9300ed

Best regards,
Oliver

On 19/11/2019 06.19, Greg Kroah-Hartman wrote:
> From: Jouni Hogander <jouni.hogander@unikie.com>
> 
> [ Upstream commit 3b5a39979dafea9d0cd69c7ae06088f7a84cdafa ]
> 
> Driver/net/can/slcan.c is derived from slip.c. Memory leak was detected
> by Syzkaller in slcan. Same issue exists in slip.c and this patch is
> addressing the leak in slip.c.
> 
> Here is the slcan memory leak trace reported by Syzkaller:
> 
> BUG: memory leak unreferenced object 0xffff888067f65500 (size 4096):
>    comm "syz-executor043", pid 454, jiffies 4294759719 (age 11.930s)
>    hex dump (first 32 bytes):
>      73 6c 63 61 6e 30 00 00 00 00 00 00 00 00 00 00 slcan0..........
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
>    backtrace:
>      [<00000000a06eec0d>] __kmalloc+0x18b/0x2c0
>      [<0000000083306e66>] kvmalloc_node+0x3a/0xc0
>      [<000000006ac27f87>] alloc_netdev_mqs+0x17a/0x1080
>      [<0000000061a996c9>] slcan_open+0x3ae/0x9a0
>      [<000000001226f0f9>] tty_ldisc_open.isra.1+0x76/0xc0
>      [<0000000019289631>] tty_set_ldisc+0x28c/0x5f0
>      [<000000004de5a617>] tty_ioctl+0x48d/0x1590
>      [<00000000daef496f>] do_vfs_ioctl+0x1c7/0x1510
>      [<0000000059068dbc>] ksys_ioctl+0x99/0xb0
>      [<000000009a6eb334>] __x64_sys_ioctl+0x78/0xb0
>      [<0000000053d0332e>] do_syscall_64+0x16f/0x580
>      [<0000000021b83b99>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>      [<000000008ea75434>] 0xfffffffffffffff
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Oliver Hartkopp <socketcan@hartkopp.net>
> Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/net/slip/slip.c |    1 +
>   1 file changed, 1 insertion(+)
> 
> --- a/drivers/net/slip/slip.c
> +++ b/drivers/net/slip/slip.c
> @@ -855,6 +855,7 @@ err_free_chan:
>   	sl->tty = NULL;
>   	tty->disc_data = NULL;
>   	clear_bit(SLF_INUSE, &sl->flags);
> +	free_netdev(sl->dev);
>   
>   err_exit:
>   	rtnl_unlock();
> 
> 
