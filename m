Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75E79F7E2B
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbfKKSsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:48:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:41150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729395AbfKKSsI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:48:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9831620674;
        Mon, 11 Nov 2019 18:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498087;
        bh=cfOwdWDLTKNCONnjilnmJE7mx2diQahMlXAy85Yx6X8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WnrA3DB26vmSQ8kOPwJEcRhUwHr5PQ04iXxUeZ745FnVxeVpIKc969QPiLNE1/XeV
         e4sjCloQI7ZfHsfjjcvPCe2Lz1RJljRgYZ5d+3QWrbX5KfEvUz2gdbrHlaBAp1CfkQ
         gUa8E8/j4LVtZRMT+tpR8apJhYUe6eE+b+0Spnzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, lipeng <lipeng321@huawei.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marc Zyngier <maz@kernel.org>,
        Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH 5.3 019/193] net: hns: Fix the stray netpoll locks causing deadlock in NAPI path
Date:   Mon, 11 Nov 2019 19:26:41 +0100
Message-Id: <20191111181501.582573002@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Salil Mehta <salil.mehta@huawei.com>

[ Upstream commit bf5a6b4c474c589244dc25ee1af2c3c829228ef8 ]

This patch fixes the problem of the spin locks, originally
meant for the netpoll path of hns driver, causing deadlock in
the normal NAPI poll path. The issue happened due to the presence
of the stray leftover spin lock code related to the netpoll,
whose support was earlier removed from the HNS[1], got activated
due to enabling of NET_POLL_CONTROLLER switch.

Earlier background:
The netpoll handling code originally had this bug(as identified
by Marc Zyngier[2]) of wrong spin lock API being used which did
not disable the interrupts and hence could cause locking issues.
i.e. if the lock were first acquired in context to thread like
'ip' util and this lock if ever got later acquired again in
context to the interrupt context like TX/RX (Interrupts could
always pre-empt the lock holding task and acquire the lock again)
and hence could cause deadlock.

Proposed Solution:
1. If the netpoll was enabled in the HNS driver, which is not
   right now, we could have simply used spin_[un]lock_irqsave()
2. But as netpoll is disabled, therefore, it is best to get rid
   of the existing locks and stray code for now. This should
   solve the problem reported by Marc.

[1] https://git.kernel.org/torvalds/c/4bd2c03be7
[2] https://patchwork.ozlabs.org/patch/1189139/

Fixes: 4bd2c03be707 ("net: hns: remove ndo_poll_controller")
Cc: lipeng <lipeng321@huawei.com>
Cc: Yisen Zhuang <yisen.zhuang@huawei.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: David S. Miller <davem@davemloft.net>
Reported-by: Marc Zyngier <maz@kernel.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Tested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns/hnae.c     |    1 -
 drivers/net/ethernet/hisilicon/hns/hnae.h     |    3 ---
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |   22 +---------------------
 3 files changed, 1 insertion(+), 25 deletions(-)

--- a/drivers/net/ethernet/hisilicon/hns/hnae.c
+++ b/drivers/net/ethernet/hisilicon/hns/hnae.c
@@ -199,7 +199,6 @@ hnae_init_ring(struct hnae_queue *q, str
 
 	ring->q = q;
 	ring->flags = flags;
-	spin_lock_init(&ring->lock);
 	ring->coal_param = q->handle->coal_param;
 	assert(!ring->desc && !ring->desc_cb && !ring->desc_dma_addr);
 
--- a/drivers/net/ethernet/hisilicon/hns/hnae.h
+++ b/drivers/net/ethernet/hisilicon/hns/hnae.h
@@ -274,9 +274,6 @@ struct hnae_ring {
 	/* statistic */
 	struct ring_stats stats;
 
-	/* ring lock for poll one */
-	spinlock_t lock;
-
 	dma_addr_t desc_dma_addr;
 	u32 buf_size;       /* size for hnae_desc->addr, preset by AE */
 	u16 desc_num;       /* total number of desc */
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -943,15 +943,6 @@ static int is_valid_clean_head(struct hn
 	return u > c ? (h > c && h <= u) : (h > c || h <= u);
 }
 
-/* netif_tx_lock will turn down the performance, set only when necessary */
-#ifdef CONFIG_NET_POLL_CONTROLLER
-#define NETIF_TX_LOCK(ring) spin_lock(&(ring)->lock)
-#define NETIF_TX_UNLOCK(ring) spin_unlock(&(ring)->lock)
-#else
-#define NETIF_TX_LOCK(ring)
-#define NETIF_TX_UNLOCK(ring)
-#endif
-
 /* reclaim all desc in one budget
  * return error or number of desc left
  */
@@ -965,21 +956,16 @@ static int hns_nic_tx_poll_one(struct hn
 	int head;
 	int bytes, pkts;
 
-	NETIF_TX_LOCK(ring);
-
 	head = readl_relaxed(ring->io_base + RCB_REG_HEAD);
 	rmb(); /* make sure head is ready before touch any data */
 
-	if (is_ring_empty(ring) || head == ring->next_to_clean) {
-		NETIF_TX_UNLOCK(ring);
+	if (is_ring_empty(ring) || head == ring->next_to_clean)
 		return 0; /* no data to poll */
-	}
 
 	if (!is_valid_clean_head(ring, head)) {
 		netdev_err(ndev, "wrong head (%d, %d-%d)\n", head,
 			   ring->next_to_use, ring->next_to_clean);
 		ring->stats.io_err_cnt++;
-		NETIF_TX_UNLOCK(ring);
 		return -EIO;
 	}
 
@@ -994,8 +980,6 @@ static int hns_nic_tx_poll_one(struct hn
 	ring->stats.tx_pkts += pkts;
 	ring->stats.tx_bytes += bytes;
 
-	NETIF_TX_UNLOCK(ring);
-
 	dev_queue = netdev_get_tx_queue(ndev, ring_data->queue_index);
 	netdev_tx_completed_queue(dev_queue, pkts, bytes);
 
@@ -1055,16 +1039,12 @@ static void hns_nic_tx_clr_all_bufs(stru
 	int head;
 	int bytes, pkts;
 
-	NETIF_TX_LOCK(ring);
-
 	head = ring->next_to_use; /* ntu :soft setted ring position*/
 	bytes = 0;
 	pkts = 0;
 	while (head != ring->next_to_clean)
 		hns_nic_reclaim_one_desc(ring, &bytes, &pkts);
 
-	NETIF_TX_UNLOCK(ring);
-
 	dev_queue = netdev_get_tx_queue(ndev, ring_data->queue_index);
 	netdev_tx_reset_queue(dev_queue);
 }


