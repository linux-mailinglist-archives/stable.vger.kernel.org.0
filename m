Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA9A3C4E24
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243701AbhGLHRC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:17:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242504AbhGLHQ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:16:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2582361156;
        Mon, 12 Jul 2021 07:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073977;
        bh=bevA9dOp0eJbl1TYf2u7t3Kb/T5Cr4MeAROOWHPFzB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+ez1ZicX7I6zQapIc4Dva7I5ZxiMuybXB/j/9m9nCwE+2v/o7t4WiuKibuRXDXX/
         IizxJsd7JlIsB25g95AUq2rg8ETKWB4w3BMstlJ+C0eAHQ062qpKpfVjNVPks+MdZy
         xSpudup4CCYF4w/OhrR14rGQfa1nfH8UurezT8UE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhu Yanjun <zyjzyj2000@gmail.com>,
        Bob Pearson <rpearsonhpe@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 423/700] RDMA/rxe: Fix qp reference counting for atomic ops
Date:   Mon, 12 Jul 2021 08:08:26 +0200
Message-Id: <20210712061021.391251941@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index b0f350d674fd..93a41ebda1a8 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -136,7 +136,6 @@ static void free_rd_atomic_resources(struct rxe_qp *qp)
 void free_rd_atomic_resource(struct rxe_qp *qp, struct resp_res *res)
 {
 	if (res->type == RXE_ATOMIC_MASK) {
-		rxe_drop_ref(qp);
 		kfree_skb(res->atomic.skb);
 	} else if (res->type == RXE_READ_MASK) {
 		if (res->read.mr)
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 8e237b623b31..ae97bebc0f34 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -966,8 +966,6 @@ static int send_atomic_ack(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
 		goto out;
 	}
 
-	rxe_add_ref(qp);
-
 	res = &qp->resp.resources[qp->resp.res_head];
 	free_rd_atomic_resource(qp, res);
 	rxe_advance_resp_resource(qp);
-- 
2.30.2



