Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F10B395F80
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhEaOMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:12:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231204AbhEaOKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:10:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80EB961979;
        Mon, 31 May 2021 13:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468435;
        bh=tGNc0MqiA58s6FfhMGBlsfmW7lFaGQRrO/nZmRl2Kus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cj9LQJOXPZ6N3FIPyHIrk5eFwy4gsTibPYw9WwnRp6HVRrxkKLR87h2ouaj/6kk3s
         41Ur/emgnphmpNBkcfROOOAfq/oLVZYX2Mg2I7J8HArNW/hQMuaqDxFGT2yLFCsMNK
         xyZayYJvKMI/Stvk9dPMWMy5YJNCLE4FEV2deWYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Stefan Chulski <stefanc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 242/252] net: mvpp2: add buffer header handling in RX
Date:   Mon, 31 May 2021 15:15:07 +0200
Message-Id: <20210531130706.235792525@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

[ Upstream commit 17f9c1b63cdd4439523cfcdf5683e5070b911f24 ]

If Link Partner sends frames larger than RX buffer size, MAC mark it
as oversize but still would pass it to the Packet Processor.
In this scenario, Packet Processor scatter frame between multiple buffers,
but only a single buffer would be returned to the Buffer Manager pool and
it would not refill the poll.

Patch add handling of oversize error with buffer header handling, so all
buffers would be returned to the Buffer Manager pool.

Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
Reported-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    | 22 ++++++++
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 54 +++++++++++++++----
 2 files changed, 67 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 834775843067..a1aefce55e65 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -909,6 +909,14 @@ enum mvpp22_ptp_packet_format {
 
 #define MVPP2_DESC_DMA_MASK	DMA_BIT_MASK(40)
 
+/* Buffer header info bits */
+#define MVPP2_B_HDR_INFO_MC_ID_MASK	0xfff
+#define MVPP2_B_HDR_INFO_MC_ID(info)	((info) & MVPP2_B_HDR_INFO_MC_ID_MASK)
+#define MVPP2_B_HDR_INFO_LAST_OFFS	12
+#define MVPP2_B_HDR_INFO_LAST_MASK	BIT(12)
+#define MVPP2_B_HDR_INFO_IS_LAST(info) \
+	   (((info) & MVPP2_B_HDR_INFO_LAST_MASK) >> MVPP2_B_HDR_INFO_LAST_OFFS)
+
 struct mvpp2_tai;
 
 /* Definitions */
@@ -918,6 +926,20 @@ struct mvpp2_rss_table {
 	u32 indir[MVPP22_RSS_TABLE_ENTRIES];
 };
 
+struct mvpp2_buff_hdr {
+	__le32 next_phys_addr;
+	__le32 next_dma_addr;
+	__le16 byte_count;
+	__le16 info;
+	__le16 reserved1;	/* bm_qset (for future use, BM) */
+	u8 next_phys_addr_high;
+	u8 next_dma_addr_high;
+	__le16 reserved2;
+	__le16 reserved3;
+	__le16 reserved4;
+	__le16 reserved5;
+};
+
 /* Shared Packet Processor resources */
 struct mvpp2 {
 	/* Shared registers' base addresses */
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index f5333fc27e14..6aa13c9f9fc9 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3481,6 +3481,35 @@ mvpp2_run_xdp(struct mvpp2_port *port, struct mvpp2_rx_queue *rxq,
 	return ret;
 }
 
+static void mvpp2_buff_hdr_pool_put(struct mvpp2_port *port, struct mvpp2_rx_desc *rx_desc,
+				    int pool, u32 rx_status)
+{
+	phys_addr_t phys_addr, phys_addr_next;
+	dma_addr_t dma_addr, dma_addr_next;
+	struct mvpp2_buff_hdr *buff_hdr;
+
+	phys_addr = mvpp2_rxdesc_dma_addr_get(port, rx_desc);
+	dma_addr = mvpp2_rxdesc_cookie_get(port, rx_desc);
+
+	do {
+		buff_hdr = (struct mvpp2_buff_hdr *)phys_to_virt(phys_addr);
+
+		phys_addr_next = le32_to_cpu(buff_hdr->next_phys_addr);
+		dma_addr_next = le32_to_cpu(buff_hdr->next_dma_addr);
+
+		if (port->priv->hw_version >= MVPP22) {
+			phys_addr_next |= ((u64)buff_hdr->next_phys_addr_high << 32);
+			dma_addr_next |= ((u64)buff_hdr->next_dma_addr_high << 32);
+		}
+
+		mvpp2_bm_pool_put(port, pool, dma_addr, phys_addr);
+
+		phys_addr = phys_addr_next;
+		dma_addr = dma_addr_next;
+
+	} while (!MVPP2_B_HDR_INFO_IS_LAST(le16_to_cpu(buff_hdr->info)));
+}
+
 /* Main rx processing */
 static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		    int rx_todo, struct mvpp2_rx_queue *rxq)
@@ -3527,14 +3556,6 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 			MVPP2_RXD_BM_POOL_ID_OFFS;
 		bm_pool = &port->priv->bm_pools[pool];
 
-		/* In case of an error, release the requested buffer pointer
-		 * to the Buffer Manager. This request process is controlled
-		 * by the hardware, and the information about the buffer is
-		 * comprised by the RX descriptor.
-		 */
-		if (rx_status & MVPP2_RXD_ERR_SUMMARY)
-			goto err_drop_frame;
-
 		if (port->priv->percpu_pools) {
 			pp = port->priv->page_pool[pool];
 			dma_dir = page_pool_get_dma_dir(pp);
@@ -3546,6 +3567,18 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 					rx_bytes + MVPP2_MH_SIZE,
 					dma_dir);
 
+		/* Buffer header not supported */
+		if (rx_status & MVPP2_RXD_BUF_HDR)
+			goto err_drop_frame;
+
+		/* In case of an error, release the requested buffer pointer
+		 * to the Buffer Manager. This request process is controlled
+		 * by the hardware, and the information about the buffer is
+		 * comprised by the RX descriptor.
+		 */
+		if (rx_status & MVPP2_RXD_ERR_SUMMARY)
+			goto err_drop_frame;
+
 		/* Prefetch header */
 		prefetch(data);
 
@@ -3627,7 +3660,10 @@ err_drop_frame:
 		dev->stats.rx_errors++;
 		mvpp2_rx_error(port, rx_desc);
 		/* Return the buffer to the pool */
-		mvpp2_bm_pool_put(port, pool, dma_addr, phys_addr);
+		if (rx_status & MVPP2_RXD_BUF_HDR)
+			mvpp2_buff_hdr_pool_put(port, rx_desc, pool, rx_status);
+		else
+			mvpp2_bm_pool_put(port, pool, dma_addr, phys_addr);
 	}
 
 	rcu_read_unlock();
-- 
2.30.2



