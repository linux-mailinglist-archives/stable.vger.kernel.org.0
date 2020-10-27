Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB7C29B994
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802617AbgJ0Pub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801402AbgJ0PlF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:41:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5911F222E9;
        Tue, 27 Oct 2020 15:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813265;
        bh=pae6MpBY6fkN36hxYx/zJM3YYcTZGXK1kDgCLE5i/uU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BFXW1EW65cwEGseUWofNBran9+ukh103P01P/xMlr9JrHrsvy67ThT0GxyQA25InI
         ZfgfsjyHG5tGD0iTiGj1GeGTPi6HWAhibFtaLVRFuQuCx0Nzrenu6ddWPO37QzF/+F
         +nEqHJD60cROxMpcmEO4aK2Su37Y/Im1zqThkRRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Pearson <rpearson@hpe.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 493/757] RDMA/rxe: Fix skb lifetime in rxe_rcv_mcast_pkt()
Date:   Tue, 27 Oct 2020 14:52:23 +0100
Message-Id: <20201027135513.597462804@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit e7ec96fc7932f48a6d6cdd05bf82004a1a04285b ]

The changes referenced below replaced sbk_clone)_ by taking additional
references, passing the skb along and then freeing the skb. This
deleted the packets before they could be processed and additionally
passed bad data in each packet. Since pkt is stored in skb->cb
changing pkt->qp changed it for all the packets.

Replace skb_get() by sbk_clone() in rxe_rcv_mcast_pkt() for cases where
multiple QPs are receiving multicast packets on the same address.

Delete kfree_skb() because the packets need to live until they have been
processed by each QP. They are freed later.

Fixes: 86af61764151 ("IB/rxe: remove unnecessary skb_clone")
Fixes: fe896ceb5772 ("IB/rxe: replace refcount_inc with skb_get")
Link: https://lore.kernel.org/r/20201008203651.256958-1-rpearson@hpe.com
Signed-off-by: Bob Pearson <rpearson@hpe.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_recv.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_recv.c b/drivers/infiniband/sw/rxe/rxe_recv.c
index 7e123d3c4d09b..967ee8e1699cd 100644
--- a/drivers/infiniband/sw/rxe/rxe_recv.c
+++ b/drivers/infiniband/sw/rxe/rxe_recv.c
@@ -260,6 +260,8 @@ static void rxe_rcv_mcast_pkt(struct rxe_dev *rxe, struct sk_buff *skb)
 	struct rxe_mc_elem *mce;
 	struct rxe_qp *qp;
 	union ib_gid dgid;
+	struct sk_buff *per_qp_skb;
+	struct rxe_pkt_info *per_qp_pkt;
 	int err;
 
 	if (skb->protocol == htons(ETH_P_IP))
@@ -288,21 +290,26 @@ static void rxe_rcv_mcast_pkt(struct rxe_dev *rxe, struct sk_buff *skb)
 		if (err)
 			continue;
 
-		/* if *not* the last qp in the list
-		 * increase the users of the skb then post to the next qp
+		/* for all but the last qp create a new clone of the
+		 * skb and pass to the qp.
 		 */
 		if (mce->qp_list.next != &mcg->qp_list)
-			skb_get(skb);
+			per_qp_skb = skb_clone(skb, GFP_ATOMIC);
+		else
+			per_qp_skb = skb;
 
-		pkt->qp = qp;
+		per_qp_pkt = SKB_TO_PKT(per_qp_skb);
+		per_qp_pkt->qp = qp;
 		rxe_add_ref(qp);
-		rxe_rcv_pkt(pkt, skb);
+		rxe_rcv_pkt(per_qp_pkt, per_qp_skb);
 	}
 
 	spin_unlock_bh(&mcg->mcg_lock);
 
 	rxe_drop_ref(mcg);	/* drop ref from rxe_pool_get_key. */
 
+	return;
+
 err1:
 	kfree_skb(skb);
 }
-- 
2.25.1



