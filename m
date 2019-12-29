Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3B912C86F
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732746AbfL2Ryp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:54:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:42892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732448AbfL2Ryp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:54:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC80E20718;
        Sun, 29 Dec 2019 17:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642084;
        bh=kRdKq7uCA72m1K+GKFvonx8KbbCs1gZwLyCH7jaiwDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yTyX6ULrIQMKmrKaFsF/WT/0V3aP56ewABRR68Sn6iD0wzmpVbfoKumTiiM3Caud3
         z+ZfMHY2agloMZrdQIRcP8wbNBzYkdypaq9ElGmoJrTVNBgEMJddEJOj2NbYXRRgRz
         pq3bb6iVxVrZbuvy8HBVZTrHL6iOzXWjDEIKPZRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 336/434] bnxt_en: Improve RX buffer error handling.
Date:   Sun, 29 Dec 2019 18:26:29 +0100
Message-Id: <20191229172724.286405221@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 19b3751ffa713d04290effb26fe01009010f2206 ]

When hardware reports RX buffer errors, the latest 57500 chips do not
require reset.  The packet is discarded by the hardware and the
ring will continue to operate.

Also, add an rx_buf_errors counter for this type of error.  It can help
the user to identify if the aggregation ring is too small.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 8 ++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         | 1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 2 ++
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 04ec909e06df..527e1bf93116 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1767,8 +1767,12 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 
 		rc = -EIO;
 		if (rx_err & RX_CMPL_ERRORS_BUFFER_ERROR_MASK) {
-			netdev_warn(bp->dev, "RX buffer error %x\n", rx_err);
-			bnxt_sched_reset(bp, rxr);
+			bnapi->cp_ring.rx_buf_errors++;
+			if (!(bp->flags & BNXT_FLAG_CHIP_P5)) {
+				netdev_warn(bp->dev, "RX buffer error %x\n",
+					    rx_err);
+				bnxt_sched_reset(bp, rxr);
+			}
 		}
 		goto next_rx_no_len;
 	}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index d333589811a5..5163bb848618 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -927,6 +927,7 @@ struct bnxt_cp_ring_info {
 	dma_addr_t		hw_stats_map;
 	u32			hw_stats_ctx_id;
 	u64			rx_l4_csum_errors;
+	u64			rx_buf_errors;
 	u64			missed_irqs;
 
 	struct bnxt_ring_struct	cp_ring_struct;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 51c140476717..89f95428556e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -173,6 +173,7 @@ static const char * const bnxt_ring_tpa2_stats_str[] = {
 
 static const char * const bnxt_ring_sw_stats_str[] = {
 	"rx_l4_csum_errors",
+	"rx_buf_errors",
 	"missed_irqs",
 };
 
@@ -552,6 +553,7 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 		for (k = 0; k < stat_fields; j++, k++)
 			buf[j] = le64_to_cpu(hw_stats[k]);
 		buf[j++] = cpr->rx_l4_csum_errors;
+		buf[j++] = cpr->rx_buf_errors;
 		buf[j++] = cpr->missed_irqs;
 
 		bnxt_sw_func_stats[RX_TOTAL_DISCARDS].counter +=
-- 
2.20.1



