Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 086FF4F2DD4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344455AbiDEKjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242232AbiDEJg1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:36:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B807972F7;
        Tue,  5 Apr 2022 02:24:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12792B81C99;
        Tue,  5 Apr 2022 09:24:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F142C385A0;
        Tue,  5 Apr 2022 09:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150659;
        bh=fo8p2+ttd+ffwyrKTGB2OgmH97OwcdKTt3Yz9iCK+aU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rzx2Em2c0cig403k2LFOSYazTP2da+EFyPGXpZ2V1lHowK2oqsJXa0A0ENVpCCUPK
         3UHWvX+y5WC6I+OwQTH9lUaSWfNxEmkiy7MLPygw29Ige93zQu/EtEmceOFZdDvYr9
         WOi60e+GBa816SEMgQNsNahuqizVgL4nQigUzy7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        Lin Ma <linma@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 135/913] drivers: hamradio: 6pack: fix UAF bug caused by mod_timer()
Date:   Tue,  5 Apr 2022 09:19:57 +0200
Message-Id: <20220405070343.877315234@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

commit efe4186e6a1b54bf38b9e05450d43b0da1fd7739 upstream.

When a 6pack device is detaching, the sixpack_close() will act to cleanup
necessary resources. Although del_timer_sync() in sixpack_close()
won't return if there is an active timer, one could use mod_timer() in
sp_xmit_on_air() to wake up timer again by calling userspace syscall such
as ax25_sendmsg(), ax25_connect() and ax25_ioctl().

This unexpected waked handler, sp_xmit_on_air(), realizes nothing about
the undergoing cleanup and may still call pty_write() to use driver layer
resources that have already been released.

One of the possible race conditions is shown below:

      (USE)                      |      (FREE)
ax25_sendmsg()                   |
 ax25_queue_xmit()               |
  ...                            |
  sp_xmit()                      |
   sp_encaps()                   | sixpack_close()
    sp_xmit_on_air()             |  del_timer_sync(&sp->tx_t)
     mod_timer(&sp->tx_t,...)    |  ...
                                 |  unregister_netdev()
                                 |  ...
     (wait a while)              | tty_release()
                                 |  tty_release_struct()
                                 |   release_tty()
    sp_xmit_on_air()             |    tty_kref_put(tty_struct) //FREE
     pty_write(tty_struct) //USE |    ...

The corresponding fail log is shown below:
===============================================================
BUG: KASAN: use-after-free in __run_timers.part.0+0x170/0x470
Write of size 8 at addr ffff88800a652ab8 by task swapper/2/0
...
Call Trace:
  ...
  queue_work_on+0x3f/0x50
  pty_write+0xcd/0xe0pty_write+0xcd/0xe0
  sp_xmit_on_air+0xb2/0x1f0
  call_timer_fn+0x28/0x150
  __run_timers.part.0+0x3c2/0x470
  run_timer_softirq+0x3b/0x80
  __do_softirq+0xf1/0x380
  ...

This patch reorders the del_timer_sync() after the unregister_netdev()
to avoid UAF bugs. Because the unregister_netdev() is well synchronized,
it flushs out any pending queues, waits the refcount of net_device
decreases to zero and removes net_device from kernel. There is not any
running routines after executing unregister_netdev(). Therefore, we could
not arouse timer from userspace again.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Lin Ma <linma@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hamradio/6pack.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -669,14 +669,14 @@ static void sixpack_close(struct tty_str
 	 */
 	netif_stop_queue(sp->dev);
 
+	unregister_netdev(sp->dev);
+
 	del_timer_sync(&sp->tx_t);
 	del_timer_sync(&sp->resync_t);
 
 	/* Free all 6pack frame buffers. */
 	kfree(sp->rbuff);
 	kfree(sp->xbuff);
-
-	unregister_netdev(sp->dev);
 }
 
 /* Perform I/O control on an active 6pack channel. */


