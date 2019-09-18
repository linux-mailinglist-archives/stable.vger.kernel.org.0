Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7137EB5CDC
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbfIRGZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:25:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730152AbfIRGZg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:25:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E004521925;
        Wed, 18 Sep 2019 06:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787935;
        bh=U9DpG53GL6w9YrFfEY8N076J1h21axkip3hX3GgBUDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TbrMWmBv1Vkw1YdQ80SNx5A92qAp/XNi6QALGm3o+wfEfQvWRFN88egPFDPG8kjIU
         EHMeUtyAkQhqOLjAXXbiX1gGPGN6l+VzXXfUT2PW9usCPI7iO91VP/laCcJO6ZoKGz
         xPb14jzgvOqP8NQvmgmwgEEV6eesJlwhqSAuHMDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Maximets <i.maximets@samsung.com>,
        William Tu <u9012063@gmail.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 5.2 37/85] ixgbe: fix double clean of Tx descriptors with xdp
Date:   Wed, 18 Sep 2019 08:18:55 +0200
Message-Id: <20190918061235.318662150@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Maximets <i.maximets@samsung.com>

commit bf280c0387ebbf8eebad1036fca8f7b85ebfde32 upstream.

Tx code doesn't clear the descriptors' status after cleaning.
So, if the budget is larger than number of used elems in a ring, some
descriptors will be accounted twice and xsk_umem_complete_tx will move
prod_tail far beyond the prod_head breaking the completion queue ring.

Fix that by limiting the number of descriptors to clean by the number
of used descriptors in the Tx ring.

'ixgbe_clean_xdp_tx_irq()' function refactored to look more like
'ixgbe_xsk_clean_tx_ring()' since we're allowed to directly use
'next_to_clean' and 'next_to_use' indexes.

CC: stable@vger.kernel.org
Fixes: 8221c5eba8c1 ("ixgbe: add AF_XDP zero-copy Tx support")
Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
Tested-by: William Tu <u9012063@gmail.com>
Tested-by: Eelco Chaudron <echaudro@redhat.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c |   29 ++++++++++-----------------
 1 file changed, 11 insertions(+), 18 deletions(-)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -679,19 +679,17 @@ static void ixgbe_clean_xdp_tx_buffer(st
 bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
 			    struct ixgbe_ring *tx_ring, int napi_budget)
 {
+	u16 ntc = tx_ring->next_to_clean, ntu = tx_ring->next_to_use;
 	unsigned int total_packets = 0, total_bytes = 0;
-	u32 i = tx_ring->next_to_clean, xsk_frames = 0;
-	unsigned int budget = q_vector->tx.work_limit;
 	struct xdp_umem *umem = tx_ring->xsk_umem;
 	union ixgbe_adv_tx_desc *tx_desc;
 	struct ixgbe_tx_buffer *tx_bi;
-	bool xmit_done;
+	u32 xsk_frames = 0;
 
-	tx_bi = &tx_ring->tx_buffer_info[i];
-	tx_desc = IXGBE_TX_DESC(tx_ring, i);
-	i -= tx_ring->count;
+	tx_bi = &tx_ring->tx_buffer_info[ntc];
+	tx_desc = IXGBE_TX_DESC(tx_ring, ntc);
 
-	do {
+	while (ntc != ntu) {
 		if (!(tx_desc->wb.status & cpu_to_le32(IXGBE_TXD_STAT_DD)))
 			break;
 
@@ -708,22 +706,18 @@ bool ixgbe_clean_xdp_tx_irq(struct ixgbe
 
 		tx_bi++;
 		tx_desc++;
-		i++;
-		if (unlikely(!i)) {
-			i -= tx_ring->count;
+		ntc++;
+		if (unlikely(ntc == tx_ring->count)) {
+			ntc = 0;
 			tx_bi = tx_ring->tx_buffer_info;
 			tx_desc = IXGBE_TX_DESC(tx_ring, 0);
 		}
 
 		/* issue prefetch for next Tx descriptor */
 		prefetch(tx_desc);
+	}
 
-		/* update budget accounting */
-		budget--;
-	} while (likely(budget));
-
-	i += tx_ring->count;
-	tx_ring->next_to_clean = i;
+	tx_ring->next_to_clean = ntc;
 
 	u64_stats_update_begin(&tx_ring->syncp);
 	tx_ring->stats.bytes += total_bytes;
@@ -735,8 +729,7 @@ bool ixgbe_clean_xdp_tx_irq(struct ixgbe
 	if (xsk_frames)
 		xsk_umem_complete_tx(umem, xsk_frames);
 
-	xmit_done = ixgbe_xmit_zc(tx_ring, q_vector->tx.work_limit);
-	return budget > 0 && xmit_done;
+	return ixgbe_xmit_zc(tx_ring, q_vector->tx.work_limit);
 }
 
 int ixgbe_xsk_async_xmit(struct net_device *dev, u32 qid)


