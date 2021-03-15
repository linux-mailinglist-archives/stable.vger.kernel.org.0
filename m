Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F5633B850
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbhCOOCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:02:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230461AbhCOOAD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 582DD64F46;
        Mon, 15 Mar 2021 13:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816785;
        bh=10TdnBz7JZZgIa+Dp25ke8JEZ0GUMn2KI4svKs7vyW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ImdRq0h7ckcNI/Mb0Ap5fDX0VOeWKFzbqU8ja46KY/M+DlenEf9zod1hnLsKr9X+Y
         Jhq1xHx1o5Uvx5eAqQpq0xeZWyKNnvSTagqPrMMGPdWV/0bGNWJVntjuXnriwJgC6B
         J8GFs/bFnteUsvvV8wCfh4IaeEkqNa+F0emVOAGQ=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Christian Eggers <ceggers@arri.de>
Subject: [PATCH 5.10 113/290] net: dsa: implement a central TX reallocation procedure
Date:   Mon, 15 Mar 2021 14:53:26 +0100
Message-Id: <20210315135545.737069480@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit a3b0b6479700a5b0af2c631cb2ec0fb7a0d978f2 ]

At the moment, taggers are left with the task of ensuring that the skb
headers are writable (which they aren't, if the frames were cloned for
TX timestamping, for flooding by the bridge, etc), and that there is
enough space in the skb data area for the DSA tag to be pushed.

Moreover, the life of tail taggers is even harder, because they need to
ensure that short frames have enough padding, a problem that normal
taggers don't have.

The principle of the DSA framework is that everything except for the
most intimate hardware specifics (like in this case, the actual packing
of the DSA tag bits) should be done inside the core, to avoid having
code paths that are very rarely tested.

So provide a TX reallocation procedure that should cover the known needs
of DSA today.

Note that this patch also gives the network stack a good hint about the
headroom/tailroom it's going to need. Up till now it wasn't doing that.
So the reallocation procedure should really be there only for the
exceptional cases, and for cloned packets which need to be unshared.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Christian Eggers <ceggers@arri.de> # For tail taggers only
Tested-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/slave.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 3bc5ca40c9fb..c6806eef906f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -548,6 +548,30 @@ netdev_tx_t dsa_enqueue_skb(struct sk_buff *skb, struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(dsa_enqueue_skb);
 
+static int dsa_realloc_skb(struct sk_buff *skb, struct net_device *dev)
+{
+	int needed_headroom = dev->needed_headroom;
+	int needed_tailroom = dev->needed_tailroom;
+
+	/* For tail taggers, we need to pad short frames ourselves, to ensure
+	 * that the tail tag does not fail at its role of being at the end of
+	 * the packet, once the master interface pads the frame. Account for
+	 * that pad length here, and pad later.
+	 */
+	if (unlikely(needed_tailroom && skb->len < ETH_ZLEN))
+		needed_tailroom += ETH_ZLEN - skb->len;
+	/* skb_headroom() returns unsigned int... */
+	needed_headroom = max_t(int, needed_headroom - skb_headroom(skb), 0);
+	needed_tailroom = max_t(int, needed_tailroom - skb_tailroom(skb), 0);
+
+	if (likely(!needed_headroom && !needed_tailroom && !skb_cloned(skb)))
+		/* No reallocation needed, yay! */
+		return 0;
+
+	return pskb_expand_head(skb, needed_headroom, needed_tailroom,
+				GFP_ATOMIC);
+}
+
 static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dsa_slave_priv *p = netdev_priv(dev);
@@ -567,6 +591,17 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
 	 */
 	dsa_skb_tx_timestamp(p, skb);
 
+	if (dsa_realloc_skb(skb, dev)) {
+		dev_kfree_skb_any(skb);
+		return NETDEV_TX_OK;
+	}
+
+	/* needed_tailroom should still be 'warm' in the cache line from
+	 * dsa_realloc_skb(), which has also ensured that padding is safe.
+	 */
+	if (dev->needed_tailroom)
+		eth_skb_pad(skb);
+
 	/* Transmit function may have to reallocate the original SKB,
 	 * in which case it must have freed it. Only free it here on error.
 	 */
@@ -1791,6 +1826,16 @@ int dsa_slave_create(struct dsa_port *port)
 	slave_dev->netdev_ops = &dsa_slave_netdev_ops;
 	if (ds->ops->port_max_mtu)
 		slave_dev->max_mtu = ds->ops->port_max_mtu(ds, port->index);
+	if (cpu_dp->tag_ops->tail_tag)
+		slave_dev->needed_tailroom = cpu_dp->tag_ops->overhead;
+	else
+		slave_dev->needed_headroom = cpu_dp->tag_ops->overhead;
+	/* Try to save one extra realloc later in the TX path (in the master)
+	 * by also inheriting the master's needed headroom and tailroom.
+	 * The 8021q driver also does this.
+	 */
+	slave_dev->needed_headroom += master->needed_headroom;
+	slave_dev->needed_tailroom += master->needed_tailroom;
 	SET_NETDEV_DEVTYPE(slave_dev, &dsa_type);
 
 	netdev_for_each_tx_queue(slave_dev, dsa_slave_set_lockdep_class_one,
-- 
2.30.1



