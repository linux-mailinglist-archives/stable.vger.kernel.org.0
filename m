Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C875232E62
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbgG3IFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:05:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729124AbgG3IFR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:05:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F13F32074B;
        Thu, 30 Jul 2020 08:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096316;
        bh=kh+wE68N2kyRA2fXhaGgr74yea6YKa1fBgeKu2BPwew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=17rL/4guoMwP8HCEnFnd0I0TvGENpa7pDfN/ay26Ng4yiMHPsNmT7XDCOqGvt2hDw
         lrJvnu6KMS8YSBcaX/uK6fbXE+0icYT/irlfnSXBRUu4CcHob2SqYIns1qCU3bRzOe
         np0ivgMzjpn7KRJzSP8T6kPVXJ2GadIyq8i+vYQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Martin Schiller <ms@dev.tdt.de>,
        Xie He <xie.he.0141@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 04/20] drivers/net/wan/x25_asy: Fix to make it work
Date:   Thu, 30 Jul 2020 10:03:54 +0200
Message-Id: <20200730074420.749987528@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074420.533211699@linuxfoundation.org>
References: <20200730074420.533211699@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 8fdcabeac39824fe67480fd9508d80161c541854 ]

This driver is not working because of problems of its receiving code.
This patch fixes it to make it work.

When the driver receives an LAPB frame, it should first pass the frame
to the LAPB module to process. After processing, the LAPB module passes
the data (the packet) back to the driver, the driver should then add a
one-byte pseudo header and pass the data to upper layers.

The changes to the "x25_asy_bump" function and the
"x25_asy_data_indication" function are to correctly implement this
procedure.

Also, the "x25_asy_unesc" function ignores any frame that is shorter
than 3 bytes. However the shortest frames are 2-byte long. So we need
to change it to allow 2-byte frames to pass.

Cc: Eric Dumazet <edumazet@google.com>
Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Reviewed-by: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wan/x25_asy.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/drivers/net/wan/x25_asy.c
+++ b/drivers/net/wan/x25_asy.c
@@ -183,7 +183,7 @@ static inline void x25_asy_unlock(struct
 	netif_wake_queue(sl->dev);
 }
 
-/* Send one completely decapsulated IP datagram to the IP layer. */
+/* Send an LAPB frame to the LAPB module to process. */
 
 static void x25_asy_bump(struct x25_asy *sl)
 {
@@ -195,13 +195,12 @@ static void x25_asy_bump(struct x25_asy
 	count = sl->rcount;
 	dev->stats.rx_bytes += count;
 
-	skb = dev_alloc_skb(count+1);
+	skb = dev_alloc_skb(count);
 	if (skb == NULL) {
 		netdev_warn(sl->dev, "memory squeeze, dropping packet\n");
 		dev->stats.rx_dropped++;
 		return;
 	}
-	skb_push(skb, 1);	/* LAPB internal control */
 	skb_put_data(skb, sl->rbuff, count);
 	skb->protocol = x25_type_trans(skb, sl->dev);
 	err = lapb_data_received(skb->dev, skb);
@@ -209,7 +208,6 @@ static void x25_asy_bump(struct x25_asy
 		kfree_skb(skb);
 		printk(KERN_DEBUG "x25_asy: data received err - %d\n", err);
 	} else {
-		netif_rx(skb);
 		dev->stats.rx_packets++;
 	}
 }
@@ -356,12 +354,21 @@ static netdev_tx_t x25_asy_xmit(struct s
  */
 
 /*
- *	Called when I frame data arrives. We did the work above - throw it
- *	at the net layer.
+ *	Called when I frame data arrive. We add a pseudo header for upper
+ *	layers and pass it to upper layers.
  */
 
 static int x25_asy_data_indication(struct net_device *dev, struct sk_buff *skb)
 {
+	if (skb_cow(skb, 1)) {
+		kfree_skb(skb);
+		return NET_RX_DROP;
+	}
+	skb_push(skb, 1);
+	skb->data[0] = X25_IFACE_DATA;
+
+	skb->protocol = x25_type_trans(skb, dev);
+
 	return netif_rx(skb);
 }
 
@@ -657,7 +664,7 @@ static void x25_asy_unesc(struct x25_asy
 	switch (s) {
 	case X25_END:
 		if (!test_and_clear_bit(SLF_ERROR, &sl->flags) &&
-		    sl->rcount > 2)
+		    sl->rcount >= 2)
 			x25_asy_bump(sl);
 		clear_bit(SLF_ESCAPE, &sl->flags);
 		sl->rcount = 0;


