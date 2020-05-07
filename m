Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8311C8FE8
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbgEGOfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:35:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728111AbgEGO2d (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:28:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DAF6215A4;
        Thu,  7 May 2020 14:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861713;
        bh=+ppmzA/tbeWOkSA9YhL6/xoA42hURX7gCULa5gfiHRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q91niJX0zmSX1BnZ/ByYQhGbUjc7jAxiknKSusQdYqWqqPq9XHYsr03w2FcJKm621
         V3bWlTHeJqcf43fyn/pSJ75o7EGKn+/XCmJeKG2aMYT6iZBwOwr3dDyGBz4EoRCJhw
         yh1eP1MhmxYesdWthaCbD0zLZIHAqJ9US99NbowU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/35] RDMA/siw: Fix potential siw_mem refcnt leak in siw_fastreg_mr()
Date:   Thu,  7 May 2020 10:27:56 -0400
Message-Id: <20200507142830.26239-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142830.26239-1-sashal@kernel.org>
References: <20200507142830.26239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

[ Upstream commit 6e051971b0e2eeb0ce7ec65d3cc8180450512d36 ]

siw_fastreg_mr() invokes siw_mem_id2obj(), which returns a local reference
of the siw_mem object to "mem" with increased refcnt.  When
siw_fastreg_mr() returns, "mem" becomes invalid, so the refcount should be
decreased to keep refcount balanced.

The issue happens in one error path of siw_fastreg_mr(). When "base_mr"
equals to NULL but "mem" is not NULL, the function forgets to decrease the
refcnt increased by siw_mem_id2obj() and causes a refcnt leak.

Reorganize the flow so that the goto unwind can be used as expected.

Fixes: b9be6f18cf9e ("rdma/siw: transmit path")
Link: https://lore.kernel.org/r/1586939949-69856-1-git-send-email-xiyuyang19@fudan.edu.cn
Reported-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_qp_tx.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
index 5d97bba0ce6d4..e7cd04eda04ac 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -920,20 +920,27 @@ static int siw_fastreg_mr(struct ib_pd *pd, struct siw_sqe *sqe)
 {
 	struct ib_mr *base_mr = (struct ib_mr *)(uintptr_t)sqe->base_mr;
 	struct siw_device *sdev = to_siw_dev(pd->device);
-	struct siw_mem *mem = siw_mem_id2obj(sdev, sqe->rkey  >> 8);
+	struct siw_mem *mem;
 	int rv = 0;
 
 	siw_dbg_pd(pd, "STag 0x%08x\n", sqe->rkey);
 
-	if (unlikely(!mem || !base_mr)) {
+	if (unlikely(!base_mr)) {
 		pr_warn("siw: fastreg: STag 0x%08x unknown\n", sqe->rkey);
 		return -EINVAL;
 	}
+
 	if (unlikely(base_mr->rkey >> 8 != sqe->rkey  >> 8)) {
 		pr_warn("siw: fastreg: STag 0x%08x: bad MR\n", sqe->rkey);
-		rv = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
+
+	mem = siw_mem_id2obj(sdev, sqe->rkey  >> 8);
+	if (unlikely(!mem)) {
+		pr_warn("siw: fastreg: STag 0x%08x unknown\n", sqe->rkey);
+		return -EINVAL;
+	}
+
 	if (unlikely(mem->pd != pd)) {
 		pr_warn("siw: fastreg: PD mismatch\n");
 		rv = -EINVAL;
-- 
2.20.1

