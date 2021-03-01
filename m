Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17C6329020
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242670AbhCAUDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:03:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:58662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241922AbhCATw3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:52:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C704F650EC;
        Mon,  1 Mar 2021 17:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621166;
        bh=+ZbRol78FT9g7t81/wKTuFrObdBVUN4AlGkqVNKLG+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J6vlg4dnwfXmUfquI3D0gBHzezycrysxG5TZBJ350JTy4vlQ0J08L7bBfaDUEzNWX
         WeCvompz3LgfzKuOBSlqvHdGvOTURGq9u6bJJyeo4cLaDDd02f9/TUgPbVYB6X+kae
         MtdwVoumF2mRQ7eTkUk69V9RKqy10T+tPNGRGR1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Pearson <rpearson@hpe.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 417/775] RDMA/rxe: Fix coding error in rxe_rcv_mcast_pkt
Date:   Mon,  1 Mar 2021 17:09:45 +0100
Message-Id: <20210301161222.188946074@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit 8fc1b7027fc162738d5a85c82410e501a371a404 ]

rxe_rcv_mcast_pkt() in rxe_recv.c can leak SKBs in error path code. The
loop over the QPs attached to a multicast group creates new cloned SKBs
for all but the last QP in the list and passes the SKB and its clones to
rxe_rcv_pkt() for further processing. Any QPs that do not pass some checks
are skipped.  If the last QP in the list fails the tests the SKB is
leaked.  This patch checks if the SKB for the last QP was used and if not
frees it. Also removes a redundant loop invariant assignment.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Fixes: 71abf20b28ff ("RDMA/rxe: Handle skb_clone() failure in rxe_recv.c")
Link: https://lore.kernel.org/r/20210128174752.16128-1-rpearson@hpe.com
Signed-off-by: Bob Pearson <rpearson@hpe.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_recv.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_recv.c b/drivers/infiniband/sw/rxe/rxe_recv.c
index db0ee5c3962e4..cb69a125e2806 100644
--- a/drivers/infiniband/sw/rxe/rxe_recv.c
+++ b/drivers/infiniband/sw/rxe/rxe_recv.c
@@ -257,7 +257,6 @@ static void rxe_rcv_mcast_pkt(struct rxe_dev *rxe, struct sk_buff *skb)
 
 	list_for_each_entry(mce, &mcg->qp_list, qp_list) {
 		qp = mce->qp;
-		pkt = SKB_TO_PKT(skb);
 
 		/* validate qp for incoming packet */
 		err = check_type_state(rxe, pkt, qp);
@@ -269,12 +268,18 @@ static void rxe_rcv_mcast_pkt(struct rxe_dev *rxe, struct sk_buff *skb)
 			continue;
 
 		/* for all but the last qp create a new clone of the
-		 * skb and pass to the qp.
+		 * skb and pass to the qp. If an error occurs in the
+		 * checks for the last qp in the list we need to
+		 * free the skb since it hasn't been passed on to
+		 * rxe_rcv_pkt() which would free it later.
 		 */
-		if (mce->qp_list.next != &mcg->qp_list)
+		if (mce->qp_list.next != &mcg->qp_list) {
 			per_qp_skb = skb_clone(skb, GFP_ATOMIC);
-		else
+		} else {
 			per_qp_skb = skb;
+			/* show we have consumed the skb */
+			skb = NULL;
+		}
 
 		if (unlikely(!per_qp_skb))
 			continue;
@@ -289,9 +294,8 @@ static void rxe_rcv_mcast_pkt(struct rxe_dev *rxe, struct sk_buff *skb)
 
 	rxe_drop_ref(mcg);	/* drop ref from rxe_pool_get_key. */
 
-	return;
-
 err1:
+	/* free skb if not consumed */
 	kfree_skb(skb);
 }
 
-- 
2.27.0



