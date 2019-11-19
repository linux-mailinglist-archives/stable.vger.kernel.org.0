Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55794101556
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729566AbfKSFnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:43:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:37886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727586AbfKSFnG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:43:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F701208C3;
        Tue, 19 Nov 2019 05:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142185;
        bh=rUWE+gCpVtyvviHYp6lEwaLES4+niP2PfE8w5mXRyp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gy4r+Npb4fLwaHjaE71bIetUoxDJ0z7gfIjN/U3Qpw9QBgvMlaLKyVy78iME494K9
         1L+NtQ5IbMFu6lgaysdTECDg0cziud+0+DSIk+TJMqPgLm6rJ1UDQSlwVwu+iA81D2
         fGHo4rdbWsIGP0BRKUceGMZ3zICJW9uOPJkwHvKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Israel Rukshin <israelr@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 418/422] IB/iser: Fix possible NULL deref at iser_inv_desc()
Date:   Tue, 19 Nov 2019 06:20:15 +0100
Message-Id: <20191119051426.281452901@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Israel Rukshin <israelr@mellanox.com>

[ Upstream commit 65f07f5a09dacf3b60619f196f096ea3671a5eda ]

In case target remote invalidates bogus rkey and signature is not used,
pi_ctx is NULL deref.

The commit also fails the connection on bogus remote invalidation.

Fixes: 59caaed7a72a ("IB/iser: Support the remote invalidation exception")
Signed-off-by: Israel Rukshin <israelr@mellanox.com>
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/iser/iser_initiator.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 2f6388596f886..96af06cfe0afd 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -589,13 +589,19 @@ void iser_login_rsp(struct ib_cq *cq, struct ib_wc *wc)
 	ib_conn->post_recv_buf_count--;
 }
 
-static inline void
+static inline int
 iser_inv_desc(struct iser_fr_desc *desc, u32 rkey)
 {
-	if (likely(rkey == desc->rsc.mr->rkey))
+	if (likely(rkey == desc->rsc.mr->rkey)) {
 		desc->rsc.mr_valid = 0;
-	else if (likely(rkey == desc->pi_ctx->sig_mr->rkey))
+	} else if (likely(desc->pi_ctx && rkey == desc->pi_ctx->sig_mr->rkey)) {
 		desc->pi_ctx->sig_mr_valid = 0;
+	} else {
+		iser_err("Bogus remote invalidation for rkey %#x\n", rkey);
+		return -EINVAL;
+	}
+
+	return 0;
 }
 
 static int
@@ -623,12 +629,14 @@ iser_check_remote_inv(struct iser_conn *iser_conn,
 
 			if (iser_task->dir[ISER_DIR_IN]) {
 				desc = iser_task->rdma_reg[ISER_DIR_IN].mem_h;
-				iser_inv_desc(desc, rkey);
+				if (unlikely(iser_inv_desc(desc, rkey)))
+					return -EINVAL;
 			}
 
 			if (iser_task->dir[ISER_DIR_OUT]) {
 				desc = iser_task->rdma_reg[ISER_DIR_OUT].mem_h;
-				iser_inv_desc(desc, rkey);
+				if (unlikely(iser_inv_desc(desc, rkey)))
+					return -EINVAL;
 			}
 		} else {
 			iser_err("failed to get task for itt=%d\n", hdr->itt);
-- 
2.20.1



