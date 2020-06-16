Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640BA1FBAC2
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731716AbgFPPms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:42:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731713AbgFPPmr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:42:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4268208D5;
        Tue, 16 Jun 2020 15:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322167;
        bh=mhb/upS7xW5Wm+mXqKh4ZiLZgSvOn8qlUAf+oVbaDqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OBXUxUBgRG41k+yodnG08xSyQ9z1SqofvwgzJLjzOf+4jvFga8cWWZjRhDMdtKOhk
         s0Dq1b/WucHhvChyJru4QisMSwzcmbdWuU9revPt8TGFTupEXn84149vBaSz1JA8I9
         NRw6N70SjOeDUea36IVdb4JX0wp1KmYGJhzSkbjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameeh Jubran <sameehj@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 008/163] net: ena: xdp: update napi budget for DROP and ABORTED
Date:   Tue, 16 Jun 2020 17:33:02 +0200
Message-Id: <20200616153107.263507481@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

[ Upstream commit 3921a81c31df6057183aeb7f7d204003bf699d6f ]

This patch fixes two issues with XDP:

1. If the XDP verdict is XDP_ABORTED we break the loop, which results in
   us handling one buffer per napi cycle instead of the total budget
   (usually 64). To overcome this simply change the xdp_verdict check to
   != XDP_PASS. When the verdict is XDP_PASS, the skb is not expected to
   be NULL.

2. Update the residual budget for XDP_DROP and XDP_ABORTED, since
   packets are handled in these cases.

Fixes: 548c4940b9f1 ("net: ena: Implement XDP_TX action")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1638,11 +1638,9 @@ static int ena_clean_rx_irq(struct ena_r
 					 &next_to_clean);
 
 		if (unlikely(!skb)) {
-			if (xdp_verdict == XDP_TX) {
+			if (xdp_verdict == XDP_TX)
 				ena_free_rx_page(rx_ring,
 						 &rx_ring->rx_buffer_info[rx_ring->ena_bufs[0].req_id]);
-				res_budget--;
-			}
 			for (i = 0; i < ena_rx_ctx.descs; i++) {
 				rx_ring->free_ids[next_to_clean] =
 					rx_ring->ena_bufs[i].req_id;
@@ -1650,8 +1648,10 @@ static int ena_clean_rx_irq(struct ena_r
 					ENA_RX_RING_IDX_NEXT(next_to_clean,
 							     rx_ring->ring_size);
 			}
-			if (xdp_verdict == XDP_TX || xdp_verdict == XDP_DROP)
+			if (xdp_verdict != XDP_PASS) {
+				res_budget--;
 				continue;
+			}
 			break;
 		}
 


