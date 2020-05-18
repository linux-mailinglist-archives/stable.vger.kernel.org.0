Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05821D8484
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732787AbgERSE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:04:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:51464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732335AbgERSE2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:04:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81378207D3;
        Mon, 18 May 2020 18:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825068;
        bh=ez2yiaLPZoIhBALY+D2vaAgcAuhJq9y6IBu3Sg2n3zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EUgxiOaJL6R4J/Clo0C2rf4btvpMb3XM8HT5WLNlj3hA+VkhU8sYN3xilt1u0RFBu
         tw14MZiJd86ddnV9grnHNf06OWYnM+k9bKxmEXbSOXf5GHhLtrcJ4iJaaFP5VHn580
         zqcRXmAnhqMlta58x+EU71HmJyx0hg89vXu3JrJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 115/194] RDMA/iw_cxgb4: Fix incorrect function parameters
Date:   Mon, 18 May 2020 19:36:45 +0200
Message-Id: <20200518173541.287296912@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Potnuri Bharat Teja <bharat@chelsio.com>

[ Upstream commit c8b1f340e54158662acfa41d6dee274846370282 ]

While reading the TCB field in t4_tcb_get_field32() the wrong mask is
passed as a parameter which leads the driver eventually to a kernel
panic/app segfault from access to an illegal SRQ index while flushing the
SRQ completions during connection teardown.

Fixes: 11a27e2121a5 ("iw_cxgb4: complete the cached SRQ buffers")
Link: https://lore.kernel.org/r/20200511185608.5202-1-bharat@chelsio.com
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index d69dece3b1d54..30e08bcc9afb5 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2891,8 +2891,7 @@ static int peer_abort(struct c4iw_dev *dev, struct sk_buff *skb)
 			srqidx = ABORT_RSS_SRQIDX_G(
 					be32_to_cpu(req->srqidx_status));
 			if (srqidx) {
-				complete_cached_srq_buffers(ep,
-							    req->srqidx_status);
+				complete_cached_srq_buffers(ep, srqidx);
 			} else {
 				/* Hold ep ref until finish_peer_abort() */
 				c4iw_get_ep(&ep->com);
@@ -3878,8 +3877,8 @@ static int read_tcb_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 		return 0;
 	}
 
-	ep->srqe_idx = t4_tcb_get_field32(tcb, TCB_RQ_START_W, TCB_RQ_START_W,
-			TCB_RQ_START_S);
+	ep->srqe_idx = t4_tcb_get_field32(tcb, TCB_RQ_START_W, TCB_RQ_START_M,
+					  TCB_RQ_START_S);
 cleanup:
 	pr_debug("ep %p tid %u %016x\n", ep, ep->hwtid, ep->srqe_idx);
 
-- 
2.20.1



