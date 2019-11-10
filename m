Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9C51F643B
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbfKJC62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:58:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:47212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729444AbfKJC4s (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:56:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C62D22571;
        Sun, 10 Nov 2019 02:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354120;
        bh=gjsQgDA0Yi/U7t3UzquNBahrZVVvipDwiouj+8LHZNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1qGOsQgA5I5df/wesIIlCndt+/D3dce7Xz+MPmcWP5dZi/7Nq31Vxl77XjSqbr/uE
         RgJc5H3utOksvgH1MiI+LWA9Lfc2z6oeYw5V+8yWyywy1LcVfPUmvQs1BGoWwA4/Y8
         Hd0qjmdyQ0zW37yDZNfevYGP56/o5leqjPrD445A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Israel Rukshin <israelr@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 108/109] IB/iser: Fix possible NULL deref at iser_inv_desc()
Date:   Sat,  9 Nov 2019 21:45:40 -0500
Message-Id: <20191110024541.31567-108-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 2a07692007bdd..a126750b65a92 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -592,13 +592,19 @@ void iser_login_rsp(struct ib_cq *cq, struct ib_wc *wc)
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
@@ -626,12 +632,14 @@ iser_check_remote_inv(struct iser_conn *iser_conn,
 
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

