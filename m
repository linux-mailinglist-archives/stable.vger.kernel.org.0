Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0458E43A33B
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239614AbhJYT5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:57:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235645AbhJYTzR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:55:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63DBD6124F;
        Mon, 25 Oct 2021 19:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191140;
        bh=r7IBdyyPsS7J9WPQQCr3Gfo0le+4g1AwBZqG/tJCFSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xiKXoq38CzLIlHTyRVn16Qbo8nNOuFY0MHd46hs4KwBf0tG2Nc/GfenOaqi9P+LWX
         AQAAJXZ8Sxe/i1fv64/Hmma9d8yLW5sDHvqS3OC7EUMQFYHOW/YNx63cmHV0uGMLgd
         rUexssG9DNxzNHIoh6o8saqx0NU7FnM3xPzpIGNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 155/169] net: hns3: fix for miscalculation of rx unused desc
Date:   Mon, 25 Oct 2021 21:15:36 +0200
Message-Id: <20211025191037.071153150@linuxfoundation.org>
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

[ Upstream commit 9f9f0f19994b42b3e5e8735d41b9c5136828a76c ]

rx unused desc is the desc that need attatching new buffer
before refilling to hw to receive new packet, the number of
desc need attatching new buffer is calculated using next_to_use
and next_to_clean. when next_to_use == next_to_clean, currently
hns3 driver assumes that all the desc has the buffer attatched,
but 'next_to_use == next_to_clean' also means all the desc need
attatching new buffer if hw has comsumed all the desc and the
driver has not attatched any buffer to the desc yet.

This patch adds 'refill' in desc_cb to indicate whether a new
buffer has been refilled to a desc.

Fixes: 76ad4f0ee747 ("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 8 ++++++++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 02495ea34332..5aad7951308d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3263,6 +3263,7 @@ static void hns3_buffer_detach(struct hns3_enet_ring *ring, int i)
 {
 	hns3_unmap_buffer(ring, &ring->desc_cb[i]);
 	ring->desc[i].addr = 0;
+	ring->desc_cb[i].refill = 0;
 }
 
 static void hns3_free_buffer_detach(struct hns3_enet_ring *ring, int i,
@@ -3340,6 +3341,7 @@ static int hns3_alloc_and_attach_buffer(struct hns3_enet_ring *ring, int i)
 		return ret;
 
 	ring->desc[i].addr = cpu_to_le64(ring->desc_cb[i].dma);
+	ring->desc_cb[i].refill = 1;
 
 	return 0;
 }
@@ -3370,12 +3372,14 @@ static void hns3_replace_buffer(struct hns3_enet_ring *ring, int i,
 	hns3_unmap_buffer(ring, &ring->desc_cb[i]);
 	ring->desc_cb[i] = *res_cb;
 	ring->desc[i].addr = cpu_to_le64(ring->desc_cb[i].dma);
+	ring->desc_cb[i].refill = 1;
 	ring->desc[i].rx.bd_base_info = 0;
 }
 
 static void hns3_reuse_buffer(struct hns3_enet_ring *ring, int i)
 {
 	ring->desc_cb[i].reuse_flag = 0;
+	ring->desc_cb[i].refill = 1;
 	ring->desc[i].addr = cpu_to_le64(ring->desc_cb[i].dma +
 					 ring->desc_cb[i].page_offset);
 	ring->desc[i].rx.bd_base_info = 0;
@@ -3482,6 +3486,9 @@ static int hns3_desc_unused(struct hns3_enet_ring *ring)
 	int ntc = ring->next_to_clean;
 	int ntu = ring->next_to_use;
 
+	if (unlikely(ntc == ntu && !ring->desc_cb[ntc].refill))
+		return ring->desc_num;
+
 	return ((ntc >= ntu) ? 0 : ring->desc_num) + ntc - ntu;
 }
 
@@ -3826,6 +3833,7 @@ static void hns3_rx_ring_move_fw(struct hns3_enet_ring *ring)
 {
 	ring->desc[ring->next_to_clean].rx.bd_base_info &=
 		cpu_to_le32(~BIT(HNS3_RXD_VLD_B));
+	ring->desc_cb[ring->next_to_clean].refill = 0;
 	ring->next_to_clean += 1;
 
 	if (unlikely(ring->next_to_clean == ring->desc_num))
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 399ebeed6e7e..d146f44bfaca 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -322,6 +322,7 @@ struct hns3_desc_cb {
 	u32 length;     /* length of the buffer */
 
 	u16 reuse_flag;
+	u16 refill;
 
 	/* desc type, used by the ring user to mark the type of the priv data */
 	u16 type;
-- 
2.33.0



