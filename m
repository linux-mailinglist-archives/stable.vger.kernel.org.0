Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489943CDD3A
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238828AbhGSO4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:56:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242863AbhGSOzT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:55:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82E4C611F2;
        Mon, 19 Jul 2021 15:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708817;
        bh=kfrq/JJTPbowBqby2tXHGQ3fw5W6T7zznB46WK2j1Tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o8HQGjvnmFtKZ9eeBfkWIBx9fiOQJnErvGwHu6wPRP0SMKa4fb4r29JHFvJUz5nrN
         ZE95cyEbMa1uH8ioWenYi8GuX6lJeGY5B3zqX+v7HllymoZQNlyrqN+bnoh9tnHWe8
         4glvT7As+HCVuXuyPmFopsLclGFrW1T3/Bca7Hds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhu Yanjun <zyjzyj2000@gmail.com>,
        Bob Pearson <rpearsonhpe@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 140/421] RDMA/rxe: Fix qp reference counting for atomic ops
Date:   Mon, 19 Jul 2021 16:49:11 +0200
Message-Id: <20210719144951.348758303@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit 15ae1375ea91ae2dee6f12d71a79d8c0a10a30bf ]

Currently the rdma_rxe driver attempts to protect atomic responder
resources by taking a reference to the qp which is only freed when the
resource is recycled for a new read or atomic operation. This means that
in normal circumstances there is almost always an extra qp reference once
an atomic operation has been executed which prevents cleaning up the qp
and associated pd and cqs when the qp is destroyed.

This patch removes the call to rxe_add_ref() in send_atomic_ack() and the
call to rxe_drop_ref() in free_rd_atomic_resource(). If the qp is
destroyed while a peer is retrying an atomic op it will cause the
operation to fail which is acceptable.

Link: https://lore.kernel.org/r/20210604230558.4812-1-rpearsonhpe@gmail.com
Reported-by: Zhu Yanjun <zyjzyj2000@gmail.com>
Fixes: 86af61764151 ("IB/rxe: remove unnecessary skb_clone")
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_qp.c   | 1 -
 drivers/infiniband/sw/rxe/rxe_resp.c | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 41c9ede98c26..4798b718b085 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -151,7 +151,6 @@ static void free_rd_atomic_resources(struct rxe_qp *qp)
 void free_rd_atomic_resource(struct rxe_qp *qp, struct resp_res *res)
 {
 	if (res->type == RXE_ATOMIC_MASK) {
-		rxe_drop_ref(qp);
 		kfree_skb(res->atomic.skb);
 	} else if (res->type == RXE_READ_MASK) {
 		if (res->read.mr)
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 9078cfd3b8bd..b36d364f0fb5 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -999,8 +999,6 @@ static int send_atomic_ack(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
 		goto out;
 	}
 
-	rxe_add_ref(qp);
-
 	res = &qp->resp.resources[qp->resp.res_head];
 	free_rd_atomic_resource(qp, res);
 	rxe_advance_resp_resource(qp);
-- 
2.30.2



