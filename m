Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6DAD4D77D
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbfFTSPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:15:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729624AbfFTSPe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:15:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05A0F2082C;
        Thu, 20 Jun 2019 18:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054533;
        bh=fQMt85ABpQUQv5H4MnPX6OzQAlr02ROktdlDIMzOd6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bmGTNmgciTG330BCL8w2VhH4o4whjTDGNuGto0wJCEv+LP6P8oqNWuJ99stUeGb1H
         xNIsnvlmVXvxU4yPHsq9rryGgr5/Z1HWFVUp6vT43IPUEUHscJQyV6l+jUNj543JHE
         U8ktk+KSIpCvwB4GxJcRXjGGRSJhOEp02Fz3U6Yc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Igor Russkikh <igor.russkikh@aquantia.com>,
        Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 62/98] net: aquantia: fix LRO with FCS error
Date:   Thu, 20 Jun 2019 19:57:29 +0200
Message-Id: <20190620174352.205003505@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit eaeb3b7494ba9159323814a8ce8af06a9277d99b ]

Driver stops producing skbs on ring if a packet with FCS error
was coalesced into LRO session. Ring gets hang forever.

Thats a logical error in driver processing descriptors:
When rx_stat indicates MAC Error, next pointer and eop flags
are not filled. This confuses driver so it waits for descriptor 0
to be filled by HW.

Solution is fill next pointer and eop flag even for packets with FCS error.

Fixes: bab6de8fd180b ("net: ethernet: aquantia: Atlantic A0 and B0 specific functions.")
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
Signed-off-by: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 61 ++++++++++---------
 1 file changed, 32 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index b31dba1b1a55..ec302fdfec63 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -702,38 +702,41 @@ static int hw_atl_b0_hw_ring_rx_receive(struct aq_hw_s *self,
 		if ((rx_stat & BIT(0)) || rxd_wb->type & 0x1000U) {
 			/* MAC error or DMA error */
 			buff->is_error = 1U;
-		} else {
-			if (self->aq_nic_cfg->is_rss) {
-				/* last 4 byte */
-				u16 rss_type = rxd_wb->type & 0xFU;
-
-				if (rss_type && rss_type < 0x8U) {
-					buff->is_hash_l4 = (rss_type == 0x4 ||
-					rss_type == 0x5);
-					buff->rss_hash = rxd_wb->rss_hash;
-				}
+		}
+		if (self->aq_nic_cfg->is_rss) {
+			/* last 4 byte */
+			u16 rss_type = rxd_wb->type & 0xFU;
+
+			if (rss_type && rss_type < 0x8U) {
+				buff->is_hash_l4 = (rss_type == 0x4 ||
+				rss_type == 0x5);
+				buff->rss_hash = rxd_wb->rss_hash;
 			}
+		}
 
-			if (HW_ATL_B0_RXD_WB_STAT2_EOP & rxd_wb->status) {
-				buff->len = rxd_wb->pkt_len %
-					AQ_CFG_RX_FRAME_MAX;
-				buff->len = buff->len ?
-					buff->len : AQ_CFG_RX_FRAME_MAX;
-				buff->next = 0U;
-				buff->is_eop = 1U;
+		if (HW_ATL_B0_RXD_WB_STAT2_EOP & rxd_wb->status) {
+			buff->len = rxd_wb->pkt_len %
+				AQ_CFG_RX_FRAME_MAX;
+			buff->len = buff->len ?
+				buff->len : AQ_CFG_RX_FRAME_MAX;
+			buff->next = 0U;
+			buff->is_eop = 1U;
+		} else {
+			buff->len =
+				rxd_wb->pkt_len > AQ_CFG_RX_FRAME_MAX ?
+				AQ_CFG_RX_FRAME_MAX : rxd_wb->pkt_len;
+
+			if (HW_ATL_B0_RXD_WB_STAT2_RSCCNT &
+				rxd_wb->status) {
+				/* LRO */
+				buff->next = rxd_wb->next_desc_ptr;
+				++ring->stats.rx.lro_packets;
 			} else {
-				if (HW_ATL_B0_RXD_WB_STAT2_RSCCNT &
-					rxd_wb->status) {
-					/* LRO */
-					buff->next = rxd_wb->next_desc_ptr;
-					++ring->stats.rx.lro_packets;
-				} else {
-					/* jumbo */
-					buff->next =
-						aq_ring_next_dx(ring,
-								ring->hw_head);
-					++ring->stats.rx.jumbo_packets;
-				}
+				/* jumbo */
+				buff->next =
+					aq_ring_next_dx(ring,
+							ring->hw_head);
+				++ring->stats.rx.jumbo_packets;
 			}
 		}
 	}
-- 
2.20.1



