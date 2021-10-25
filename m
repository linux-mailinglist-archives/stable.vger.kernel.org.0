Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F08043A27A
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236019AbhJYTtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:49:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237745AbhJYTpx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:45:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCD14610A5;
        Mon, 25 Oct 2021 19:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190770;
        bh=JnaI4lkbgv/2+UqoKUFx3Vhe76YHhHmi6aXdFod3FRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ru2FbenVe0GOWC7ALKGi8hrDm7KYkILJeb2HTdV2KTQpOv35bYZDMtWO3XLjkdY/h
         tjnNo2NLe62KqtW704CDoszVHgs6Ta4G+2OfWYw07rDASr5OTcH/AIoD1DdI3im/Mj
         Z7YMKIl2kFeKBfH7wFhQirT8Wjo1MvLHxy/ICEVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 047/169] net: hns3: schedule the polling again when allocation fails
Date:   Mon, 25 Oct 2021 21:13:48 +0200
Message-Id: <20211025191023.732781976@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit 68752b24f51a71d4f350a764d890b670f59062c5 ]

Currently when there is a rx page allocation failure, it is
possible that polling may be stopped if there is no more packet
to be reveiced, which may cause queue stall problem under memory
pressure.

This patch makes sure polling is scheduled again when there is
any rx page allocation failure, and polling will try to allocate
receive buffers until it succeeds.

Now the allocation retry is added, it is unnecessary to do the rx
page allocation at the end of rx cleaning, so remove it. And reset
the unused_count to zero after calling hns3_nic_alloc_rx_buffers()
to avoid calling hns3_nic_alloc_rx_buffers() repeatedly under
memory pressure.

Fixes: 76ad4f0ee747 ("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 22 ++++++++++---------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 114692c4f797..796886b112c7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3488,7 +3488,8 @@ static int hns3_desc_unused(struct hns3_enet_ring *ring)
 	return ((ntc >= ntu) ? 0 : ring->desc_num) + ntc - ntu;
 }
 
-static void hns3_nic_alloc_rx_buffers(struct hns3_enet_ring *ring,
+/* Return true if there is any allocation failure */
+static bool hns3_nic_alloc_rx_buffers(struct hns3_enet_ring *ring,
 				      int cleand_count)
 {
 	struct hns3_desc_cb *desc_cb;
@@ -3513,7 +3514,10 @@ static void hns3_nic_alloc_rx_buffers(struct hns3_enet_ring *ring,
 				hns3_rl_err(ring_to_netdev(ring),
 					    "alloc rx buffer failed: %d\n",
 					    ret);
-				break;
+
+				writel(i, ring->tqp->io_base +
+				       HNS3_RING_RX_RING_HEAD_REG);
+				return true;
 			}
 			hns3_replace_buffer(ring, ring->next_to_use, &res_cbs);
 
@@ -3526,6 +3530,7 @@ static void hns3_nic_alloc_rx_buffers(struct hns3_enet_ring *ring,
 	}
 
 	writel(i, ring->tqp->io_base + HNS3_RING_RX_RING_HEAD_REG);
+	return false;
 }
 
 static bool hns3_can_reuse_page(struct hns3_desc_cb *cb)
@@ -4159,6 +4164,7 @@ int hns3_clean_rx_ring(struct hns3_enet_ring *ring, int budget,
 {
 #define RCB_NOF_ALLOC_RX_BUFF_ONCE 16
 	int unused_count = hns3_desc_unused(ring);
+	bool failure = false;
 	int recv_pkts = 0;
 	int err;
 
@@ -4167,9 +4173,9 @@ int hns3_clean_rx_ring(struct hns3_enet_ring *ring, int budget,
 	while (recv_pkts < budget) {
 		/* Reuse or realloc buffers */
 		if (unused_count >= RCB_NOF_ALLOC_RX_BUFF_ONCE) {
-			hns3_nic_alloc_rx_buffers(ring, unused_count);
-			unused_count = hns3_desc_unused(ring) -
-					ring->pending_buf;
+			failure = failure ||
+				hns3_nic_alloc_rx_buffers(ring, unused_count);
+			unused_count = 0;
 		}
 
 		/* Poll one pkt */
@@ -4188,11 +4194,7 @@ int hns3_clean_rx_ring(struct hns3_enet_ring *ring, int budget,
 	}
 
 out:
-	/* Make all data has been write before submit */
-	if (unused_count > 0)
-		hns3_nic_alloc_rx_buffers(ring, unused_count);
-
-	return recv_pkts;
+	return failure ? budget : recv_pkts;
 }
 
 static void hns3_update_rx_int_coalesce(struct hns3_enet_tqp_vector *tqp_vector)
-- 
2.33.0



