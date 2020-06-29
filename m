Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D015D20E6E9
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404575AbgF2Vvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:51:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726646AbgF2Sfk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEDA1246DF;
        Mon, 29 Jun 2020 15:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444024;
        bh=/vwdFd68ku5X8FDTyvttuCf0a4x6PHDje4Hk3/9e3+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BvsTXjmM2aF+HgC6I4SVHbfXTQr53/injJrL7olqfL+PXa0nmgvGuEmNgVOeCt1mt
         07QaNsu6bi2Tks5qvo7a6eUFqO6oXtn7B/opodhph+UOME7ibzChluy7EV2ETHCg0w
         00jBPxP70X8pYrs4YH2TeLVpFL8/uB0+tSz2F71c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 131/265] RDMA/rvt: Fix potential memory leak caused by rvt_alloc_rq
Date:   Mon, 29 Jun 2020 11:16:04 -0400
Message-Id: <20200629151818.2493727-132-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit 90a239ee25fa3a483facec3de7c144361a3d3a51 ]

In case of failure of alloc_ud_wq_attr(), the memory allocated by
rvt_alloc_rq() is not freed. Fix it by calling rvt_free_rq() using the
existing clean-up code.

Fixes: d310c4bf8aea ("IB/{rdmavt, hfi1, qib}: Remove AH refcount for UD QPs")
Link: https://lore.kernel.org/r/20200614041148.131983-1-pakki001@umn.edu
Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Acked-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rdmavt/qp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 500a7ee04c44e..ca29954a54ac3 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1196,7 +1196,7 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 		err = alloc_ud_wq_attr(qp, rdi->dparms.node);
 		if (err) {
 			ret = (ERR_PTR(err));
-			goto bail_driver_priv;
+			goto bail_rq_rvt;
 		}
 
 		err = alloc_qpn(rdi, &rdi->qp_dev->qpn_table,
@@ -1300,9 +1300,11 @@ bail_qpn:
 	rvt_free_qpn(&rdi->qp_dev->qpn_table, qp->ibqp.qp_num);
 
 bail_rq_wq:
-	rvt_free_rq(&qp->r_rq);
 	free_ud_wq_attr(qp);
 
+bail_rq_rvt:
+	rvt_free_rq(&qp->r_rq);
+
 bail_driver_priv:
 	rdi->driver_f.qp_priv_free(rdi, qp);
 
-- 
2.25.1

