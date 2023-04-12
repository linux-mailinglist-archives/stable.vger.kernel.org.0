Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2732C6DEEA3
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbjDLIoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbjDLInx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:43:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318F77A82
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:43:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D2226308B
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:42:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D98C433D2;
        Wed, 12 Apr 2023 08:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288961;
        bh=Yh1fMWrHRNHokVHYSfw/szZwhr2A8AcHPgen2jXsQlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1zOZSb/BiROE3shRZbIuTuHJhq7GguznTENy83hcrXwm5Ov+B06IcQPukL0KUfvlL
         Y79uKYvZWw6PgKlNz14IyUV1Xq3rsej3QkeGTa5m1NRhQkpqp43UVHYp6AsxrM00Oj
         axBiGdKdUiPjVaWknFLbo/jXKlELEh18Le5ZxUEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shailend Chand <shailend@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/164] gve: Secure enough bytes in the first TX desc for all TCP pkts
Date:   Wed, 12 Apr 2023 10:32:55 +0200
Message-Id: <20230412082839.084338516@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shailend Chand <shailend@google.com>

[ Upstream commit 3ce9345580974863c060fa32971537996a7b2d57 ]

Non-GSO TCP packets whose SKBs' linear portion did not include the
entire TCP header were not populating the first Tx descriptor with
as many bytes as the vNIC expected. This change ensures that all
TCP packets populate the first descriptor with the correct number of
bytes.

Fixes: 893ce44df565 ("gve: Add basic driver framework for Compute Engine Virtual NIC")
Signed-off-by: Shailend Chand <shailend@google.com>
Link: https://lore.kernel.org/r/20230403172809.2939306-1-shailend@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve.h    |  2 ++
 drivers/net/ethernet/google/gve/gve_tx.c | 12 +++++-------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 160735484465a..458149a77ebe6 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -47,6 +47,8 @@
 
 #define GVE_RX_BUFFER_SIZE_DQO 2048
 
+#define GVE_GQ_TX_MIN_PKT_DESC_BYTES 182
+
 /* Each slot in the desc ring has a 1:1 mapping to a slot in the data ring */
 struct gve_rx_desc_queue {
 	struct gve_rx_desc *desc_ring; /* the descriptor ring */
diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index 4888bf05fbedb..5e11b82367545 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -284,8 +284,8 @@ static inline int gve_skb_fifo_bytes_required(struct gve_tx_ring *tx,
 	int bytes;
 	int hlen;
 
-	hlen = skb_is_gso(skb) ? skb_checksum_start_offset(skb) +
-				 tcp_hdrlen(skb) : skb_headlen(skb);
+	hlen = skb_is_gso(skb) ? skb_checksum_start_offset(skb) + tcp_hdrlen(skb) :
+				 min_t(int, GVE_GQ_TX_MIN_PKT_DESC_BYTES, skb->len);
 
 	pad_bytes = gve_tx_fifo_pad_alloc_one_frag(&tx->tx_fifo,
 						   hlen);
@@ -454,13 +454,11 @@ static int gve_tx_add_skb_copy(struct gve_priv *priv, struct gve_tx_ring *tx, st
 	pkt_desc = &tx->desc[idx];
 
 	l4_hdr_offset = skb_checksum_start_offset(skb);
-	/* If the skb is gso, then we want the tcp header in the first segment
-	 * otherwise we want the linear portion of the skb (which will contain
-	 * the checksum because skb->csum_start and skb->csum_offset are given
-	 * relative to skb->head) in the first segment.
+	/* If the skb is gso, then we want the tcp header alone in the first segment
+	 * otherwise we want the minimum required by the gVNIC spec.
 	 */
 	hlen = is_gso ? l4_hdr_offset + tcp_hdrlen(skb) :
-			skb_headlen(skb);
+			min_t(int, GVE_GQ_TX_MIN_PKT_DESC_BYTES, skb->len);
 
 	info->skb =  skb;
 	/* We don't want to split the header, so if necessary, pad to the end
-- 
2.39.2



