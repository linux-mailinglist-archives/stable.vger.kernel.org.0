Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 901CCCD70B
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbfJFRvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:51:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728061AbfJFRu5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:50:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDF5D222C5;
        Sun,  6 Oct 2019 17:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383949;
        bh=k4xrTvtY0yDO2J2oqihcwC3dwQtRmjTOVkEiQCp45xw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jIcqrWbnnlXCBK9Jusz9ABzjfNiHDCadDlLvCaDxiJBzAcEjsO58zWcdiB+BD5/RB
         DWgcNbWpnHBjegwrmeHXC2x+4ayt+IbIJHWLN1s9ktmV4zpWtBv26k1XIPD29NOxct
         I2P+Ze6jGCGXddb+Lmg/a6Z3uUcYQPpZA5+fxuy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 155/166] net: socionext: netsec: always grab descriptor lock
Date:   Sun,  6 Oct 2019 19:22:01 +0200
Message-Id: <20191006171225.936955929@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 55131dec2b1c7417d216f861ea7a29dc7c4d2d20 ]

Always acquire tx descriptor spinlock even if a xdp program is not loaded
on the netsec device since ndo_xdp_xmit can run concurrently with
netsec_netdev_start_xmit and netsec_clean_tx_dring. This can happen
loading a xdp program on a different device (e.g virtio-net) and
xdp_do_redirect_map/xdp_do_redirect_slow can redirect to netsec even if
we do not have a xdp program on it.

Fixes: ba2b232108d3 ("net: netsec: add XDP support")
Tested-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/socionext/netsec.c |   30 +++++++-----------------------
 1 file changed, 7 insertions(+), 23 deletions(-)

--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -282,7 +282,6 @@ struct netsec_desc_ring {
 	void *vaddr;
 	u16 head, tail;
 	u16 xdp_xmit; /* netsec_xdp_xmit packets */
-	bool is_xdp;
 	struct page_pool *page_pool;
 	struct xdp_rxq_info xdp_rxq;
 	spinlock_t lock; /* XDP tx queue locking */
@@ -634,8 +633,7 @@ static bool netsec_clean_tx_dring(struct
 	unsigned int bytes;
 	int cnt = 0;
 
-	if (dring->is_xdp)
-		spin_lock(&dring->lock);
+	spin_lock(&dring->lock);
 
 	bytes = 0;
 	entry = dring->vaddr + DESC_SZ * tail;
@@ -682,8 +680,8 @@ next:
 		entry = dring->vaddr + DESC_SZ * tail;
 		cnt++;
 	}
-	if (dring->is_xdp)
-		spin_unlock(&dring->lock);
+
+	spin_unlock(&dring->lock);
 
 	if (!cnt)
 		return false;
@@ -799,9 +797,6 @@ static void netsec_set_tx_de(struct nets
 	de->data_buf_addr_lw = lower_32_bits(desc->dma_addr);
 	de->buf_len_info = (tx_ctrl->tcp_seg_len << 16) | desc->len;
 	de->attr = attr;
-	/* under spin_lock if using XDP */
-	if (!dring->is_xdp)
-		dma_wmb();
 
 	dring->desc[idx] = *desc;
 	if (desc->buf_type == TYPE_NETSEC_SKB)
@@ -1123,12 +1118,10 @@ static netdev_tx_t netsec_netdev_start_x
 	u16 tso_seg_len = 0;
 	int filled;
 
-	if (dring->is_xdp)
-		spin_lock_bh(&dring->lock);
+	spin_lock_bh(&dring->lock);
 	filled = netsec_desc_used(dring);
 	if (netsec_check_stop_tx(priv, filled)) {
-		if (dring->is_xdp)
-			spin_unlock_bh(&dring->lock);
+		spin_unlock_bh(&dring->lock);
 		net_warn_ratelimited("%s %s Tx queue full\n",
 				     dev_name(priv->dev), ndev->name);
 		return NETDEV_TX_BUSY;
@@ -1161,8 +1154,7 @@ static netdev_tx_t netsec_netdev_start_x
 	tx_desc.dma_addr = dma_map_single(priv->dev, skb->data,
 					  skb_headlen(skb), DMA_TO_DEVICE);
 	if (dma_mapping_error(priv->dev, tx_desc.dma_addr)) {
-		if (dring->is_xdp)
-			spin_unlock_bh(&dring->lock);
+		spin_unlock_bh(&dring->lock);
 		netif_err(priv, drv, priv->ndev,
 			  "%s: DMA mapping failed\n", __func__);
 		ndev->stats.tx_dropped++;
@@ -1177,8 +1169,7 @@ static netdev_tx_t netsec_netdev_start_x
 	netdev_sent_queue(priv->ndev, skb->len);
 
 	netsec_set_tx_de(priv, dring, &tx_ctrl, &tx_desc, skb);
-	if (dring->is_xdp)
-		spin_unlock_bh(&dring->lock);
+	spin_unlock_bh(&dring->lock);
 	netsec_write(priv, NETSEC_REG_NRM_TX_PKTCNT, 1); /* submit another tx */
 
 	return NETDEV_TX_OK;
@@ -1262,7 +1253,6 @@ err:
 static void netsec_setup_tx_dring(struct netsec_priv *priv)
 {
 	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_TX];
-	struct bpf_prog *xdp_prog = READ_ONCE(priv->xdp_prog);
 	int i;
 
 	for (i = 0; i < DESC_NUM; i++) {
@@ -1275,12 +1265,6 @@ static void netsec_setup_tx_dring(struct
 		 */
 		de->attr = 1U << NETSEC_TX_SHIFT_OWN_FIELD;
 	}
-
-	if (xdp_prog)
-		dring->is_xdp = true;
-	else
-		dring->is_xdp = false;
-
 }
 
 static int netsec_setup_rx_dring(struct netsec_priv *priv)


