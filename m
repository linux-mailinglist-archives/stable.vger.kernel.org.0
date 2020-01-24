Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 322C9147B24
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731740AbgAXJlO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:41:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:38666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732762AbgAXJlM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:41:12 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00F45214AF;
        Fri, 24 Jan 2020 09:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858871;
        bh=p2LyabCqAEe7N8QDMp3GRGKwHKIFN3xrjSEQ+m4zd5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WvF9Ven5d3yVR7ZOpVfR1+LNv107IjVLgHBN+eG5XbTQvDXpPGCeQmfSzBefXGyzd
         ctkMg66XonJpt+CgAe7/i7d64KVeGjhc1PCqQ74eVPrrJRQO1dn366Ag7KJlBJ5PmC
         fJ1gEyiwvv/K9e1itYf7TS6n3X3c+q7jLk8BCMSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 070/102] dpaa_eth: avoid timestamp read on error paths
Date:   Fri, 24 Jan 2020 10:31:11 +0100
Message-Id: <20200124092817.165533506@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madalin Bucur <madalin.bucur@nxp.com>

[ Upstream commit 9a4f4f3a894ff4487f5597b7aabba9432b238292 ]

The dpaa_cleanup_tx_fd() function is called by the frame transmit
confirmation callback but also on several error paths. This function
is reading the transmit timestamp value. Avoid reading an invalid
timestamp value on the error paths.

Fixes: 4664856e9ca2 ("dpaa_eth: add support for hardware timestamping")
Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 54ffc9d3b0a9b..fcbe01f61aa44 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -1600,13 +1600,15 @@ static int dpaa_eth_refill_bpools(struct dpaa_priv *priv)
  * Skb freeing is not handled here.
  *
  * This function may be called on error paths in the Tx function, so guard
- * against cases when not all fd relevant fields were filled in.
+ * against cases when not all fd relevant fields were filled in. To avoid
+ * reading the invalid transmission timestamp for the error paths set ts to
+ * false.
  *
  * Return the skb backpointer, since for S/G frames the buffer containing it
  * gets freed here.
  */
 static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
-					  const struct qm_fd *fd)
+					  const struct qm_fd *fd, bool ts)
 {
 	const enum dma_data_direction dma_dir = DMA_TO_DEVICE;
 	struct device *dev = priv->net_dev->dev.parent;
@@ -1648,7 +1650,8 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 	}
 
 	/* DMA unmapping is required before accessing the HW provided info */
-	if (priv->tx_tstamp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
+	if (ts && priv->tx_tstamp &&
+	    skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
 		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
 
 		if (!fman_port_get_tstamp(priv->mac_dev->port[TX], (void *)skbh,
@@ -2116,7 +2119,7 @@ dpaa_start_xmit(struct sk_buff *skb, struct net_device *net_dev)
 	if (likely(dpaa_xmit(priv, percpu_stats, queue_mapping, &fd) == 0))
 		return NETDEV_TX_OK;
 
-	dpaa_cleanup_tx_fd(priv, &fd);
+	dpaa_cleanup_tx_fd(priv, &fd, false);
 skb_to_fd_failed:
 enomem:
 	percpu_stats->tx_errors++;
@@ -2162,7 +2165,7 @@ static void dpaa_tx_error(struct net_device *net_dev,
 
 	percpu_priv->stats.tx_errors++;
 
-	skb = dpaa_cleanup_tx_fd(priv, fd);
+	skb = dpaa_cleanup_tx_fd(priv, fd, false);
 	dev_kfree_skb(skb);
 }
 
@@ -2202,7 +2205,7 @@ static void dpaa_tx_conf(struct net_device *net_dev,
 
 	percpu_priv->tx_confirm++;
 
-	skb = dpaa_cleanup_tx_fd(priv, fd);
+	skb = dpaa_cleanup_tx_fd(priv, fd, true);
 
 	consume_skb(skb);
 }
@@ -2432,7 +2435,7 @@ static void egress_ern(struct qman_portal *portal,
 	percpu_priv->stats.tx_fifo_errors++;
 	count_ern(percpu_priv, msg);
 
-	skb = dpaa_cleanup_tx_fd(priv, fd);
+	skb = dpaa_cleanup_tx_fd(priv, fd, false);
 	dev_kfree_skb_any(skb);
 }
 
-- 
2.20.1



