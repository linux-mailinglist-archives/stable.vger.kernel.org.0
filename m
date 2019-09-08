Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6B8DACE67
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730648AbfIHMrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:47:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730611AbfIHMrT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:47:19 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCAD6218AC;
        Sun,  8 Sep 2019 12:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946839;
        bh=qUm4Hz3UlfFJcoxfNGwaaABMr5AHGadsYX+6XAWtEKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yrLQ7IotFCX6xr8AHmA8JeB12CDEbv/OgSdfRlSXxaNm1ybfIZeIHAZRe6pcnoEz/
         3IVqYU8X6cXMkt3Rz7p8hfMk+haTehSE1qfDcknZzyqcqESayQqcK58kdN50v77OBh
         7gXwjvwKW2iqodKQ6HPxMDco4upZ99xuBUwTTCms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Feng Sun <loyou85@gmail.com>,
        Xiaojun Zhao <xiaojunzhao141@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 02/57] net: fix skb use after free in netpoll
Date:   Sun,  8 Sep 2019 13:41:26 +0100
Message-Id: <20190908121127.158072530@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121125.608195329@linuxfoundation.org>
References: <20190908121125.608195329@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Feng Sun <loyou85@gmail.com>

[ Upstream commit 2c1644cf6d46a8267d79ed95cb9b563839346562 ]

After commit baeababb5b85d5c4e6c917efe2a1504179438d3b
("tun: return NET_XMIT_DROP for dropped packets"),
when tun_net_xmit drop packets, it will free skb and return NET_XMIT_DROP,
netpoll_send_skb_on_dev will run into following use after free cases:
1. retry netpoll_start_xmit with freed skb;
2. queue freed skb in npinfo->txq.
queue_process will also run into use after free case.

hit netpoll_send_skb_on_dev first case with following kernel log:

[  117.864773] kernel BUG at mm/slub.c:306!
[  117.864773] invalid opcode: 0000 [#1] SMP PTI
[  117.864774] CPU: 3 PID: 2627 Comm: loop_printmsg Kdump: loaded Tainted: P           OE     5.3.0-050300rc5-generic #201908182231
[  117.864775] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[  117.864775] RIP: 0010:kmem_cache_free+0x28d/0x2b0
[  117.864781] Call Trace:
[  117.864781]  ? tun_net_xmit+0x21c/0x460
[  117.864781]  kfree_skbmem+0x4e/0x60
[  117.864782]  kfree_skb+0x3a/0xa0
[  117.864782]  tun_net_xmit+0x21c/0x460
[  117.864782]  netpoll_start_xmit+0x11d/0x1b0
[  117.864788]  netpoll_send_skb_on_dev+0x1b8/0x200
[  117.864789]  __br_forward+0x1b9/0x1e0 [bridge]
[  117.864789]  ? skb_clone+0x53/0xd0
[  117.864790]  ? __skb_clone+0x2e/0x120
[  117.864790]  deliver_clone+0x37/0x50 [bridge]
[  117.864790]  maybe_deliver+0x89/0xc0 [bridge]
[  117.864791]  br_flood+0x6c/0x130 [bridge]
[  117.864791]  br_dev_xmit+0x315/0x3c0 [bridge]
[  117.864792]  netpoll_start_xmit+0x11d/0x1b0
[  117.864792]  netpoll_send_skb_on_dev+0x1b8/0x200
[  117.864792]  netpoll_send_udp+0x2c6/0x3e8
[  117.864793]  write_msg+0xd9/0xf0 [netconsole]
[  117.864793]  console_unlock+0x386/0x4e0
[  117.864793]  vprintk_emit+0x17e/0x280
[  117.864794]  vprintk_default+0x29/0x50
[  117.864794]  vprintk_func+0x4c/0xbc
[  117.864794]  printk+0x58/0x6f
[  117.864795]  loop_fun+0x24/0x41 [printmsg_loop]
[  117.864795]  kthread+0x104/0x140
[  117.864795]  ? 0xffffffffc05b1000
[  117.864796]  ? kthread_park+0x80/0x80
[  117.864796]  ret_from_fork+0x35/0x40

Signed-off-by: Feng Sun <loyou85@gmail.com>
Signed-off-by: Xiaojun Zhao <xiaojunzhao141@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/netpoll.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -122,7 +122,7 @@ static void queue_process(struct work_st
 		txq = netdev_get_tx_queue(dev, q_index);
 		HARD_TX_LOCK(dev, txq, smp_processor_id());
 		if (netif_xmit_frozen_or_stopped(txq) ||
-		    netpoll_start_xmit(skb, dev, txq) != NETDEV_TX_OK) {
+		    !dev_xmit_complete(netpoll_start_xmit(skb, dev, txq))) {
 			skb_queue_head(&npinfo->txq, skb);
 			HARD_TX_UNLOCK(dev, txq);
 			local_irq_restore(flags);
@@ -335,7 +335,7 @@ void netpoll_send_skb_on_dev(struct netp
 
 				HARD_TX_UNLOCK(dev, txq);
 
-				if (status == NETDEV_TX_OK)
+				if (dev_xmit_complete(status))
 					break;
 
 			}
@@ -352,7 +352,7 @@ void netpoll_send_skb_on_dev(struct netp
 
 	}
 
-	if (status != NETDEV_TX_OK) {
+	if (!dev_xmit_complete(status)) {
 		skb_queue_tail(&npinfo->txq, skb);
 		schedule_delayed_work(&npinfo->tx_work,0);
 	}


