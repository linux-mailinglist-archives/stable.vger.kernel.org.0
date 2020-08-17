Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B66E2470C8
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388394AbgHQSO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:14:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731052AbgHQQGY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:06:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19D8A2063A;
        Mon, 17 Aug 2020 16:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680371;
        bh=kw06jVtb/jIPSntCZK3WXF6KXsRzue6VWinIXA0xhaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZrelS+3IGmFZm/PLrTsQm7IVasR+9s8ig51bfFJgf3OyLMsePTCuMy0Mq+P5z+bo0
         lrhVHb+H7+s3z0vj/t3PMkQyLbNbBLUajG4V3n8lcygogjDMQC2lsUDYXmAFo4xi4R
         EwC+gVC7j7ryMGpfLlImk4lZw6L7YTtZFgITdfTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhu Yanjun <yanjunz@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 130/270] RDMA/rxe: Skip dgid check in loopback mode
Date:   Mon, 17 Aug 2020 17:15:31 +0200
Message-Id: <20200817143802.262314210@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhu Yanjun <yanjunz@mellanox.com>

[ Upstream commit 5c99274be8864519328aa74bc550ba410095bc1c ]

In the loopback tests, the following call trace occurs.

 Call Trace:
  __rxe_do_task+0x1a/0x30 [rdma_rxe]
  rxe_qp_destroy+0x61/0xa0 [rdma_rxe]
  rxe_destroy_qp+0x20/0x60 [rdma_rxe]
  ib_destroy_qp_user+0xcc/0x220 [ib_core]
  uverbs_free_qp+0x3c/0xc0 [ib_uverbs]
  destroy_hw_idr_uobject+0x24/0x70 [ib_uverbs]
  uverbs_destroy_uobject+0x43/0x1b0 [ib_uverbs]
  uobj_destroy+0x41/0x70 [ib_uverbs]
  __uobj_get_destroy+0x39/0x70 [ib_uverbs]
  ib_uverbs_destroy_qp+0x88/0xc0 [ib_uverbs]
  ib_uverbs_handler_UVERBS_METHOD_INVOKE_WRITE+0xb9/0xf0 [ib_uverbs]
  ib_uverbs_cmd_verbs+0xb16/0xc30 [ib_uverbs]

The root cause is that the actual RDMA connection is not created in the
loopback tests and the rxe_match_dgid will fail randomly.

To fix this call trace which appear in the loopback tests, skip check of
the dgid.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20200630123605.446959-1-leon@kernel.org
Signed-off-by: Zhu Yanjun <yanjunz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_recv.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_recv.c b/drivers/infiniband/sw/rxe/rxe_recv.c
index 831ad578a7b29..46e111c218fd4 100644
--- a/drivers/infiniband/sw/rxe/rxe_recv.c
+++ b/drivers/infiniband/sw/rxe/rxe_recv.c
@@ -330,10 +330,14 @@ static void rxe_rcv_mcast_pkt(struct rxe_dev *rxe, struct sk_buff *skb)
 
 static int rxe_match_dgid(struct rxe_dev *rxe, struct sk_buff *skb)
 {
+	struct rxe_pkt_info *pkt = SKB_TO_PKT(skb);
 	const struct ib_gid_attr *gid_attr;
 	union ib_gid dgid;
 	union ib_gid *pdgid;
 
+	if (pkt->mask & RXE_LOOPBACK_MASK)
+		return 0;
+
 	if (skb->protocol == htons(ETH_P_IP)) {
 		ipv6_addr_set_v4mapped(ip_hdr(skb)->daddr,
 				       (struct in6_addr *)&dgid);
@@ -366,7 +370,7 @@ void rxe_rcv(struct sk_buff *skb)
 	if (unlikely(skb->len < pkt->offset + RXE_BTH_BYTES))
 		goto drop;
 
-	if (unlikely(rxe_match_dgid(rxe, skb) < 0)) {
+	if (rxe_match_dgid(rxe, skb) < 0) {
 		pr_warn_ratelimited("failed matching dgid\n");
 		goto drop;
 	}
-- 
2.25.1



