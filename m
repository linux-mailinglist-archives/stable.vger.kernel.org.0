Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB5E3C5405
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349420AbhGLH4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351630AbhGLHv7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 020F460FF1;
        Mon, 12 Jul 2021 07:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076151;
        bh=poVeK7EhLVcgvfNqEIIt69ZyXMeYgV+XWonfX+8FZEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hvHkdB6EVM3p0Q1xRwPxD49CR0ZDfE6OTs2qHbd0k7beH261lUK05Im3255MK/KL2
         8uEBEdFI8xMDH+sQFj0OM0PHa261hBbVXVnayF0QIJh/nSngyB6l/my2Xhs424crBp
         h3SFPZUbR41+VRft3sBR8HaWGSWREVKL2LoQNSoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhu Yanjun <zyjzyj2000@gmail.com>,
        Bob Pearson <rpearsonhpe@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 477/800] RDMA/rxe: Fix qp reference counting for atomic ops
Date:   Mon, 12 Jul 2021 08:08:20 +0200
Message-Id: <20210712061017.924060338@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index 2b220659bddb..39dc39be586e 100644
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



