Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6FD431785
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 13:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhJRLil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 07:38:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230346AbhJRLil (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 07:38:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF6DE60E76;
        Mon, 18 Oct 2021 11:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634556990;
        bh=z6AydGC4A6ArPdvqzYVHmE38LAxTFQx6eEXB/CS+6gY=;
        h=Subject:To:Cc:From:Date:From;
        b=f8kP509rP1Eph4khnmuE33UtiakHi+HryAX92W8JOos2RYokMl0FO+1LVv5Oo9G0O
         7f23enI9UheEn84ogtuq8xGdl+FlVrnc4NYesFnsY0vEBhDp6RMlXgbeXsq/Udr37h
         l7DPoQ4Q6NffpeLoNIu8TaKJncL2J+K2GDZxRZ7k=
Subject: FAILED: patch "[PATCH] net: dsa: felix: purge skb from TX timestamping queue if it" failed to apply to 5.14-stable tree
To:     vladimir.oltean@nxp.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 13:36:27 +0200
Message-ID: <1634556987377@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1328a883258b4507909090ed0a9ad63771f9f780 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Tue, 12 Oct 2021 14:40:42 +0300
Subject: [PATCH] net: dsa: felix: purge skb from TX timestamping queue if it
 cannot be sent

At present, when a PTP packet which requires TX timestamping gets
dropped under congestion by the switch, things go downhill very fast.
The driver keeps a clone of that skb in a queue of packets awaiting TX
timestamp interrupts, but interrupts will never be raised for the
dropped packets.

Moreover, matching timestamped packets to timestamps is done by a 2-bit
timestamp ID, and this can wrap around and we can match on the wrong skb.

Since with the default NPI-based tagging protocol, we get no notification
about packet drops, the best we can do is eventually recover from the
drop of a PTP frame: its skb will be dead memory until another skb which
was assigned the same timestamp ID happens to find it.

However, with the ocelot-8021q tagger which injects packets using the
manual register interface, it appears that we can check for more
information, such as:

- whether the input queue has reached the high watermark or not
- whether the injection group's FIFO can accept additional data or not

so we know that a PTP frame is likely to get dropped before actually
sending it, and drop it ourselves (because DSA uses NETIF_F_LLTX, so it
can't return NETDEV_TX_BUSY to ask the qdisc to requeue the packet).

But when we do that, we can also remove the skb from the timestamping
queue, because there surely won't be any timestamp that matches it.

Fixes: 0a6f17c6ae21 ("net: dsa: tag_ocelot_8021q: add support for PTP timestamping")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index f8603e068e7c..9af8f900aa56 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1074,6 +1074,33 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	return 0;
 }
 
+static void ocelot_port_purge_txtstamp_skb(struct ocelot *ocelot, int port,
+					   struct sk_buff *skb)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct sk_buff *clone = OCELOT_SKB_CB(skb)->clone;
+	struct sk_buff *skb_match = NULL, *skb_tmp;
+	unsigned long flags;
+
+	if (!clone)
+		return;
+
+	spin_lock_irqsave(&ocelot_port->tx_skbs.lock, flags);
+
+	skb_queue_walk_safe(&ocelot_port->tx_skbs, skb, skb_tmp) {
+		if (skb != clone)
+			continue;
+		__skb_unlink(skb, &ocelot_port->tx_skbs);
+		skb_match = skb;
+		break;
+	}
+
+	spin_unlock_irqrestore(&ocelot_port->tx_skbs.lock, flags);
+
+	WARN_ONCE(!skb_match,
+		  "Could not find skb clone in TX timestamping list\n");
+}
+
 #define work_to_xmit_work(w) \
 		container_of((w), struct felix_deferred_xmit_work, work)
 
@@ -1097,6 +1124,7 @@ static void felix_port_deferred_xmit(struct kthread_work *work)
 	if (!retries) {
 		dev_err(ocelot->dev, "port %d failed to inject skb\n",
 			port);
+		ocelot_port_purge_txtstamp_skb(ocelot, port, skb);
 		kfree_skb(skb);
 		return;
 	}

