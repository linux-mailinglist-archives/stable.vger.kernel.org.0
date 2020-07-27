Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7D522F1E7
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732135AbgG0Ofa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:35:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730623AbgG0OO6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:14:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE95922BF3;
        Mon, 27 Jul 2020 14:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859297;
        bh=dJE+l1eHpIiqSZ8hIQ0F+3RMgRXM7p2Z2ofSXFjcXQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vpIz3nWX8gtZ8nKVGC9SB8sh5UMJca/NOevOeN79EOWuD3RJyJlA0IJaQLwRug2U+
         hT2NFu8P8ga2vQg+6jqkM9PqaFP8avdVaNPdxKTZ56vu7uWDaU6NlokEuQsDNSwZ3w
         mqKSfRzFaSEUMxDPn0eTo+mSR+pPGSjODuvkRC8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/138] net: hns3: fix error handling for desc filling
Date:   Mon, 27 Jul 2020 16:04:09 +0200
Message-Id: <20200727134928.056032643@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit 8ceca59fb3ed48a693171bd571c4fcbd555b7f1f ]

The content of the TX desc is automatically cleared by the HW
when the HW has sent out the packet to the wire. When desc filling
fails in hns3_nic_net_xmit(), it will call hns3_clear_desc() to do
the error handling, which miss zeroing of the TX desc and the
checking if a unmapping is needed.

So add the zeroing and checking in hns3_clear_desc() to avoid the
above problem. Also add DESC_TYPE_UNKNOWN to indicate the info in
desc_cb is not valid, because hns3_nic_reclaim_desc() may treat
the desc_cb->type of zero as packet and add to the sent pkt
statistics accordingly.

Fixes: 76ad4f0ee747 ("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h     | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index a0998937727d8..0db835d87d09d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -77,6 +77,7 @@
 	((ring)->p = ((ring)->p - 1 + (ring)->desc_num) % (ring)->desc_num)
 
 enum hns_desc_type {
+	DESC_TYPE_UNKNOWN,
 	DESC_TYPE_SKB,
 	DESC_TYPE_PAGE,
 };
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 37537c3020806..506381224559f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1292,6 +1292,10 @@ static void hns3_clear_desc(struct hns3_enet_ring *ring, int next_to_use_orig)
 	unsigned int i;
 
 	for (i = 0; i < ring->desc_num; i++) {
+		struct hns3_desc *desc = &ring->desc[ring->next_to_use];
+
+		memset(desc, 0, sizeof(*desc));
+
 		/* check if this is where we started */
 		if (ring->next_to_use == next_to_use_orig)
 			break;
@@ -1299,6 +1303,9 @@ static void hns3_clear_desc(struct hns3_enet_ring *ring, int next_to_use_orig)
 		/* rollback one */
 		ring_ptr_move_bw(ring, next_to_use);
 
+		if (!ring->desc_cb[ring->next_to_use].dma)
+			continue;
+
 		/* unmap the descriptor dma address */
 		if (ring->desc_cb[ring->next_to_use].type == DESC_TYPE_SKB)
 			dma_unmap_single(dev,
@@ -1313,6 +1320,7 @@ static void hns3_clear_desc(struct hns3_enet_ring *ring, int next_to_use_orig)
 
 		ring->desc_cb[ring->next_to_use].length = 0;
 		ring->desc_cb[ring->next_to_use].dma = 0;
+		ring->desc_cb[ring->next_to_use].type = DESC_TYPE_UNKNOWN;
 	}
 }
 
-- 
2.25.1



