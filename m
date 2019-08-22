Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8286B99A33
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388572AbfHVRKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:10:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:59656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390730AbfHVRJU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:09:20 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 074F2233FC;
        Thu, 22 Aug 2019 17:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493759;
        bh=fJ3azQZ1DCnkjLnuIEYjspKZxSeuc1mE32jQfEX269s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bsrZzXn3UKpgojFf5/bob3yQcTq5Go20xNVcf5d/ECG4tMzUFJ6iPJWq+yDkXxCpZ
         KBdgI10zMh2kZ8Eotf9VDXFhL+QpFKBzn11rkIFRHYnZY28+AMkKSWgDh3VkoOUP/t
         aVBhN1/2CAP0u6uZwWRhxJbp/mqbXQv6W2yxkGQQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 120/135] bnxt_en: Improve RX doorbell sequence.
Date:   Thu, 22 Aug 2019 13:07:56 -0400
Message-Id: <20190822170811.13303-121-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit e8f267b063208372f7a329c6d5288d58944d873c ]

When both RX buffers and RX aggregation buffers have to be
replenished at the end of NAPI, post the RX aggregation buffers first
before RX buffers.  Otherwise, we may run into a situation where
there are only RX buffers without RX aggregation buffers for a split
second.  This will cause the hardware to abort the RX packet and
report buffer errors, which will cause unnecessary cleanup by the
driver.

Ringing the Aggregation ring doorbell first before the RX ring doorbell
will prevent some of these buffer errors.  Use the same sequence during
ring initialization as well.

Fixes: 697197e5a173 ("bnxt_en: Re-structure doorbells.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index d9eaafa93970b..36fe4f161cf1c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2015,9 +2015,9 @@ static void __bnxt_poll_work_done(struct bnxt *bp, struct bnxt_napi *bnapi)
 	if (bnapi->events & BNXT_RX_EVENT) {
 		struct bnxt_rx_ring_info *rxr = bnapi->rx_ring;
 
-		bnxt_db_write(bp, &rxr->rx_db, rxr->rx_prod);
 		if (bnapi->events & BNXT_AGG_EVENT)
 			bnxt_db_write(bp, &rxr->rx_agg_db, rxr->rx_agg_prod);
+		bnxt_db_write(bp, &rxr->rx_db, rxr->rx_prod);
 	}
 	bnapi->events = 0;
 }
@@ -5011,6 +5011,7 @@ static void bnxt_set_db(struct bnxt *bp, struct bnxt_db_info *db, u32 ring_type,
 
 static int bnxt_hwrm_ring_alloc(struct bnxt *bp)
 {
+	bool agg_rings = !!(bp->flags & BNXT_FLAG_AGG_RINGS);
 	int i, rc = 0;
 	u32 type;
 
@@ -5086,7 +5087,9 @@ static int bnxt_hwrm_ring_alloc(struct bnxt *bp)
 		if (rc)
 			goto err_out;
 		bnxt_set_db(bp, &rxr->rx_db, type, map_idx, ring->fw_ring_id);
-		bnxt_db_write(bp, &rxr->rx_db, rxr->rx_prod);
+		/* If we have agg rings, post agg buffers first. */
+		if (!agg_rings)
+			bnxt_db_write(bp, &rxr->rx_db, rxr->rx_prod);
 		bp->grp_info[map_idx].rx_fw_ring_id = ring->fw_ring_id;
 		if (bp->flags & BNXT_FLAG_CHIP_P5) {
 			struct bnxt_cp_ring_info *cpr = &bnapi->cp_ring;
@@ -5105,7 +5108,7 @@ static int bnxt_hwrm_ring_alloc(struct bnxt *bp)
 		}
 	}
 
-	if (bp->flags & BNXT_FLAG_AGG_RINGS) {
+	if (agg_rings) {
 		type = HWRM_RING_ALLOC_AGG;
 		for (i = 0; i < bp->rx_nr_rings; i++) {
 			struct bnxt_rx_ring_info *rxr = &bp->rx_ring[i];
@@ -5121,6 +5124,7 @@ static int bnxt_hwrm_ring_alloc(struct bnxt *bp)
 			bnxt_set_db(bp, &rxr->rx_agg_db, type, map_idx,
 				    ring->fw_ring_id);
 			bnxt_db_write(bp, &rxr->rx_agg_db, rxr->rx_agg_prod);
+			bnxt_db_write(bp, &rxr->rx_db, rxr->rx_prod);
 			bp->grp_info[grp_idx].agg_fw_ring_id = ring->fw_ring_id;
 		}
 	}
-- 
2.20.1

