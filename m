Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 643E74CE515
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 14:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiCENzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 08:55:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiCENy7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 08:54:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04BD1CABC5
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 05:54:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5970D612BB
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 13:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454AAC004E1;
        Sat,  5 Mar 2022 13:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646488448;
        bh=/I5JlV1PMbp5hlvxRrEszK0/5nfsedfo0enrFBJk0nw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o49IPgTXsAdI6no4fITCEZMD/IjHno8JefZhbKg4J9o/Wd1zpymNTPeOtMxKW5plB
         QGf/3+OVCxaf/eKQUflv0Uc+cXhLUqzON1RZcPiaDcPUS/sw8hhriGVI5mkeksV7wQ
         9lWmDs6ee9hLjY+VL4JSptqslfBiyTp6Fl70s17k=
Date:   Sat, 5 Mar 2022 14:54:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marek =?iso-8859-1?Q?Marczykowski-G=F3recki?= 
        <marmarek@invisiblethingslab.com>
Cc:     stable@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.4,4.19] xen/netfront: destroy queues before
 real_num_tx_queues is zeroed
Message-ID: <YiNrfMMDu04IMv76@kroah.com>
References: <20220305132616.3464066-1-marmarek@invisiblethingslab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220305132616.3464066-1-marmarek@invisiblethingslab.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 05, 2022 at 02:26:17PM +0100, Marek Marczykowski-Górecki wrote:
> commit dcf4ff7a48e7598e6b10126cc02177abb8ae4f3f upstream.
> 
> xennet_destroy_queues() relies on info->netdev->real_num_tx_queues to
> delete queues. Since d7dac083414eb5bb99a6d2ed53dc2c1b405224e5
> ("net-sysfs: update the queue counts in the unregistration path"),
> unregister_netdev() indirectly sets real_num_tx_queues to 0. Those two
> facts together means, that xennet_destroy_queues() called from
> xennet_remove() cannot do its job, because it's called after
> unregister_netdev(). This results in kfree-ing queues that are still
> linked in napi, which ultimately crashes:
> 
>     BUG: kernel NULL pointer dereference, address: 0000000000000000
>     #PF: supervisor read access in kernel mode
>     #PF: error_code(0x0000) - not-present page
>     PGD 0 P4D 0
>     Oops: 0000 [#1] PREEMPT SMP PTI
>     CPU: 1 PID: 52 Comm: xenwatch Tainted: G        W         5.16.10-1.32.fc32.qubes.x86_64+ #226
>     RIP: 0010:free_netdev+0xa3/0x1a0
>     Code: ff 48 89 df e8 2e e9 00 00 48 8b 43 50 48 8b 08 48 8d b8 a0 fe ff ff 48 8d a9 a0 fe ff ff 49 39 c4 75 26 eb 47 e8 ed c1 66 ff <48> 8b 85 60 01 00 00 48 8d 95 60 01 00 00 48 89 ef 48 2d 60 01 00
>     RSP: 0000:ffffc90000bcfd00 EFLAGS: 00010286
>     RAX: 0000000000000000 RBX: ffff88800edad000 RCX: 0000000000000000
>     RDX: 0000000000000001 RSI: ffffc90000bcfc30 RDI: 00000000ffffffff
>     RBP: fffffffffffffea0 R08: 0000000000000000 R09: 0000000000000000
>     R10: 0000000000000000 R11: 0000000000000001 R12: ffff88800edad050
>     R13: ffff8880065f8f88 R14: 0000000000000000 R15: ffff8880066c6680
>     FS:  0000000000000000(0000) GS:ffff8880f3300000(0000) knlGS:0000000000000000
>     CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>     CR2: 0000000000000000 CR3: 00000000e998c006 CR4: 00000000003706e0
>     Call Trace:
>      <TASK>
>      xennet_remove+0x13d/0x300 [xen_netfront]
>      xenbus_dev_remove+0x6d/0xf0
>      __device_release_driver+0x17a/0x240
>      device_release_driver+0x24/0x30
>      bus_remove_device+0xd8/0x140
>      device_del+0x18b/0x410
>      ? _raw_spin_unlock+0x16/0x30
>      ? klist_iter_exit+0x14/0x20
>      ? xenbus_dev_request_and_reply+0x80/0x80
>      device_unregister+0x13/0x60
>      xenbus_dev_changed+0x18e/0x1f0
>      xenwatch_thread+0xc0/0x1a0
>      ? do_wait_intr_irq+0xa0/0xa0
>      kthread+0x16b/0x190
>      ? set_kthread_struct+0x40/0x40
>      ret_from_fork+0x22/0x30
>      </TASK>
> 
> Fix this by calling xennet_destroy_queues() from xennet_uninit(),
> when real_num_tx_queues is still available. This ensures that queues are
> destroyed when real_num_tx_queues is set to 0, regardless of how
> unregister_netdev() was called.
> 
> Originally reported at
> https://github.com/QubesOS/qubes-issues/issues/7257
> 
> Fixes: d7dac083414eb5bb9 ("net-sysfs: update the queue counts in the unregistration path")
> Cc: stable@vger.kernel.org
> Signed-off-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  drivers/net/xen-netfront.c | 39 ++++++++++++++++++++++----------------
>  1 file changed, 23 insertions(+), 16 deletions(-)

Now queued up, thanks.

greg k-h
