Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 308DD4FCF71
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiDLG1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239706AbiDLG1D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:27:03 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6543584B;
        Mon, 11 Apr 2022 23:24:42 -0700 (PDT)
Received: from kwepemi500003.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KcwZH70KyzBsBC;
        Tue, 12 Apr 2022 14:20:23 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi500003.china.huawei.com (7.221.188.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 12 Apr 2022 14:24:40 +0800
Received: from [10.174.177.234] (10.174.177.234) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2375.24; Tue, 12 Apr 2022 14:24:40 +0800
Subject: Re: [PATCH 5.10 092/599] drivers: hamradio: 6pack: fix UAF bug caused
 by mod_timer()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Duoming Zhou <duoming@zju.edu.cn>,
        Lin Ma <linma@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>
References: <20220405070258.802373272@linuxfoundation.org>
 <20220405070301.566657774@linuxfoundation.org>
From:   "xujia (Q)" <xujia39@huawei.com>
Message-ID: <9f2fc2c5-0380-f1e0-e6d6-8702b039b45d@huawei.com>
Date:   Tue, 12 Apr 2022 14:24:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220405070301.566657774@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.234]
X-ClientProxiedBy: dggeme707-chm.china.huawei.com (10.1.199.103) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi.

Maybe there are some errors  in LTS.  The follow test is UAF in 5.10.

https://lore.kernel.org/all/20151217213400.GA15130@linux-mips.org/T/

These two patches which showed up in v5.16-rc1 can solve this problem.

The first is 0b9111922b1f ("hamradio: defer 6pack kfree after 
unregister_netdev").
The second is 81b1d548d00b ("hamradio: remove needs_free_netdev to avoid 
UAF").

These patches make unregister_netdev() not call free_netdev() and then 
call it after
free all 6pack frame buffers.

I'll send these patches soon to fix 5.10 for reference.

在 2022/4/5 15:26, Greg Kroah-Hartman 写道:
> From: Duoming Zhou <duoming@zju.edu.cn>
>
> commit efe4186e6a1b54bf38b9e05450d43b0da1fd7739 upstream.
>
> When a 6pack device is detaching, the sixpack_close() will act to cleanup
> necessary resources. Although del_timer_sync() in sixpack_close()
> won't return if there is an active timer, one could use mod_timer() in
> sp_xmit_on_air() to wake up timer again by calling userspace syscall such
> as ax25_sendmsg(), ax25_connect() and ax25_ioctl().
>
> This unexpected waked handler, sp_xmit_on_air(), realizes nothing about
> the undergoing cleanup and may still call pty_write() to use driver layer
> resources that have already been released.
>
> One of the possible race conditions is shown below:
>
>        (USE)                      |      (FREE)
> ax25_sendmsg()                   |
>   ax25_queue_xmit()               |
>    ...                            |
>    sp_xmit()                      |
>     sp_encaps()                   | sixpack_close()
>      sp_xmit_on_air()             |  del_timer_sync(&sp->tx_t)
>       mod_timer(&sp->tx_t,...)    |  ...
>                                   |  unregister_netdev()
>                                   |  ...
>       (wait a while)              | tty_release()
>                                   |  tty_release_struct()
>                                   |   release_tty()
>      sp_xmit_on_air()             |    tty_kref_put(tty_struct) //FREE
>       pty_write(tty_struct) //USE |    ...
>
> The corresponding fail log is shown below:
> ===============================================================
> BUG: KASAN: use-after-free in __run_timers.part.0+0x170/0x470
> Write of size 8 at addr ffff88800a652ab8 by task swapper/2/0
> ...
> Call Trace:
>    ...
>    queue_work_on+0x3f/0x50
>    pty_write+0xcd/0xe0pty_write+0xcd/0xe0
>    sp_xmit_on_air+0xb2/0x1f0
>    call_timer_fn+0x28/0x150
>    __run_timers.part.0+0x3c2/0x470
>    run_timer_softirq+0x3b/0x80
>    __do_softirq+0xf1/0x380
>    ...
>
> This patch reorders the del_timer_sync() after the unregister_netdev()
> to avoid UAF bugs. Because the unregister_netdev() is well synchronized,
> it flushs out any pending queues, waits the refcount of net_device
> decreases to zero and removes net_device from kernel. There is not any
> running routines after executing unregister_netdev(). Therefore, we could
> not arouse timer from userspace again.
>
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> Reviewed-by: Lin Ma <linma@zju.edu.cn>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/net/hamradio/6pack.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> --- a/drivers/net/hamradio/6pack.c
> +++ b/drivers/net/hamradio/6pack.c
> @@ -674,14 +674,14 @@ static void sixpack_close(struct tty_str
>   	 */
>   	netif_stop_queue(sp->dev);
>   
> +	unregister_netdev(sp->dev);
> +
>   	del_timer_sync(&sp->tx_t);
>   	del_timer_sync(&sp->resync_t);
>   
>   	/* Free all 6pack frame buffers. */
>   	kfree(sp->rbuff);
>   	kfree(sp->xbuff);
> -
> -	unregister_netdev(sp->dev);
>   }
>   
>   /* Perform I/O control on an active 6pack channel. */
>
>
> .
