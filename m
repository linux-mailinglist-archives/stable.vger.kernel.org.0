Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A18B2C9BEA
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390073AbgLAJNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:13:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:51504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390068AbgLAJNQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:13:16 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50C1521D46;
        Tue,  1 Dec 2020 09:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813954;
        bh=7dOvUqzU+NusqOwoMSbO/uOCD/1aYZSfEPeq3KK85lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F3o3Kyt4BM2UeSx/p16LE+3ih4TJhtWo98X2/oJj8RJVUI2HKaUfOvyLnKQGJ+WX4
         VMOTlBbN/qf0pFBlalnhSzxZjtmm+dlRrnca+vX5buqEvQxJ/U7gAslMUi7yaSLfft
         egG4LldSk9lxjqcCxj/0oCGovM5sAO1nSZiWKMEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lincoln Ramsay <lincoln.ramsay@opengear.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 109/152] aquantia: Remove the build_skb path
Date:   Tue,  1 Dec 2020 09:53:44 +0100
Message-Id: <20201201084726.147321605@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lincoln Ramsay <lincoln.ramsay@opengear.com>

[ Upstream commit 9bd2702d292cb7b565b09e949d30288ab7a26d51 ]

When performing IPv6 forwarding, there is an expectation that SKBs
will have some headroom. When forwarding a packet from the aquantia
driver, this does not always happen, triggering a kernel warning.

aq_ring.c has this code (edited slightly for brevity):

if (buff->is_eop && buff->len <= AQ_CFG_RX_FRAME_MAX - AQ_SKB_ALIGN) {
    skb = build_skb(aq_buf_vaddr(&buff->rxdata), AQ_CFG_RX_FRAME_MAX);
} else {
    skb = napi_alloc_skb(napi, AQ_CFG_RX_HDR_SIZE);

There is a significant difference between the SKB produced by these
2 code paths. When napi_alloc_skb creates an SKB, there is a certain
amount of headroom reserved. However, this is not done in the
build_skb codepath.

As the hardware buffer that build_skb is built around does not
handle the presence of the SKB header, this code path is being
removed and the napi_alloc_skb path will always be used. This code
path does have to copy the packet header into the SKB, but it adds
the packet data as a frag.

Fixes: 018423e90bee ("net: ethernet: aquantia: Add ring support code")
Signed-off-by: Lincoln Ramsay <lincoln.ramsay@opengear.com>
Link: https://lore.kernel.org/r/MWHPR1001MB23184F3EAFA413E0D1910EC9E8FC0@MWHPR1001MB2318.namprd10.prod.outlook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/aquantia/atlantic/aq_ring.c  | 126 ++++++++----------
 1 file changed, 52 insertions(+), 74 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 4f913658eea46..24122ccda614c 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -413,85 +413,63 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 					      buff->rxdata.pg_off,
 					      buff->len, DMA_FROM_DEVICE);
 
-		/* for single fragment packets use build_skb() */
-		if (buff->is_eop &&
-		    buff->len <= AQ_CFG_RX_FRAME_MAX - AQ_SKB_ALIGN) {
-			skb = build_skb(aq_buf_vaddr(&buff->rxdata),
+		skb = napi_alloc_skb(napi, AQ_CFG_RX_HDR_SIZE);
+		if (unlikely(!skb)) {
+			u64_stats_update_begin(&self->stats.rx.syncp);
+			self->stats.rx.skb_alloc_fails++;
+			u64_stats_update_end(&self->stats.rx.syncp);
+			err = -ENOMEM;
+			goto err_exit;
+		}
+		if (is_ptp_ring)
+			buff->len -=
+				aq_ptp_extract_ts(self->aq_nic, skb,
+						  aq_buf_vaddr(&buff->rxdata),
+						  buff->len);
+
+		hdr_len = buff->len;
+		if (hdr_len > AQ_CFG_RX_HDR_SIZE)
+			hdr_len = eth_get_headlen(skb->dev,
+						  aq_buf_vaddr(&buff->rxdata),
+						  AQ_CFG_RX_HDR_SIZE);
+
+		memcpy(__skb_put(skb, hdr_len), aq_buf_vaddr(&buff->rxdata),
+		       ALIGN(hdr_len, sizeof(long)));
+
+		if (buff->len - hdr_len > 0) {
+			skb_add_rx_frag(skb, 0, buff->rxdata.page,
+					buff->rxdata.pg_off + hdr_len,
+					buff->len - hdr_len,
 					AQ_CFG_RX_FRAME_MAX);
-			if (unlikely(!skb)) {
-				u64_stats_update_begin(&self->stats.rx.syncp);
-				self->stats.rx.skb_alloc_fails++;
-				u64_stats_update_end(&self->stats.rx.syncp);
-				err = -ENOMEM;
-				goto err_exit;
-			}
-			if (is_ptp_ring)
-				buff->len -=
-					aq_ptp_extract_ts(self->aq_nic, skb,
-						aq_buf_vaddr(&buff->rxdata),
-						buff->len);
-			skb_put(skb, buff->len);
 			page_ref_inc(buff->rxdata.page);
-		} else {
-			skb = napi_alloc_skb(napi, AQ_CFG_RX_HDR_SIZE);
-			if (unlikely(!skb)) {
-				u64_stats_update_begin(&self->stats.rx.syncp);
-				self->stats.rx.skb_alloc_fails++;
-				u64_stats_update_end(&self->stats.rx.syncp);
-				err = -ENOMEM;
-				goto err_exit;
-			}
-			if (is_ptp_ring)
-				buff->len -=
-					aq_ptp_extract_ts(self->aq_nic, skb,
-						aq_buf_vaddr(&buff->rxdata),
-						buff->len);
-
-			hdr_len = buff->len;
-			if (hdr_len > AQ_CFG_RX_HDR_SIZE)
-				hdr_len = eth_get_headlen(skb->dev,
-							  aq_buf_vaddr(&buff->rxdata),
-							  AQ_CFG_RX_HDR_SIZE);
-
-			memcpy(__skb_put(skb, hdr_len), aq_buf_vaddr(&buff->rxdata),
-			       ALIGN(hdr_len, sizeof(long)));
-
-			if (buff->len - hdr_len > 0) {
-				skb_add_rx_frag(skb, 0, buff->rxdata.page,
-						buff->rxdata.pg_off + hdr_len,
-						buff->len - hdr_len,
-						AQ_CFG_RX_FRAME_MAX);
-				page_ref_inc(buff->rxdata.page);
-			}
+		}
 
-			if (!buff->is_eop) {
-				buff_ = buff;
-				i = 1U;
-				do {
-					next_ = buff_->next,
-					buff_ = &self->buff_ring[next_];
+		if (!buff->is_eop) {
+			buff_ = buff;
+			i = 1U;
+			do {
+				next_ = buff_->next;
+				buff_ = &self->buff_ring[next_];
 
-					dma_sync_single_range_for_cpu(
-							aq_nic_get_dev(self->aq_nic),
-							buff_->rxdata.daddr,
-							buff_->rxdata.pg_off,
-							buff_->len,
-							DMA_FROM_DEVICE);
-					skb_add_rx_frag(skb, i++,
-							buff_->rxdata.page,
-							buff_->rxdata.pg_off,
-							buff_->len,
-							AQ_CFG_RX_FRAME_MAX);
-					page_ref_inc(buff_->rxdata.page);
-					buff_->is_cleaned = 1;
-
-					buff->is_ip_cso &= buff_->is_ip_cso;
-					buff->is_udp_cso &= buff_->is_udp_cso;
-					buff->is_tcp_cso &= buff_->is_tcp_cso;
-					buff->is_cso_err |= buff_->is_cso_err;
+				dma_sync_single_range_for_cpu(aq_nic_get_dev(self->aq_nic),
+							      buff_->rxdata.daddr,
+							      buff_->rxdata.pg_off,
+							      buff_->len,
+							      DMA_FROM_DEVICE);
+				skb_add_rx_frag(skb, i++,
+						buff_->rxdata.page,
+						buff_->rxdata.pg_off,
+						buff_->len,
+						AQ_CFG_RX_FRAME_MAX);
+				page_ref_inc(buff_->rxdata.page);
+				buff_->is_cleaned = 1;
 
-				} while (!buff_->is_eop);
-			}
+				buff->is_ip_cso &= buff_->is_ip_cso;
+				buff->is_udp_cso &= buff_->is_udp_cso;
+				buff->is_tcp_cso &= buff_->is_tcp_cso;
+				buff->is_cso_err |= buff_->is_cso_err;
+
+			} while (!buff_->is_eop);
 		}
 
 		if (buff->is_vlan)
-- 
2.27.0



