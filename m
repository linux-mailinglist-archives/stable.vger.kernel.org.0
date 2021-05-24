Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6EA038EE53
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234165AbhEXPsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:48:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234276AbhEXPq3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:46:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 795E261476;
        Mon, 24 May 2021 15:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870601;
        bh=PDp0/U3qKwYq3omsYJ3iKxZ9x4fs5OC9Obq63S0Ywt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qOZ+oCBlSh+5QA8YYHB7GMwHsDcI11HBgz1S+tz2ssOTPUXp9wwIg2WAbYcc9MAPq
         wyhJyn9HBU5HppRG9rensSzLijixE9J9VUcWnBtPMZkZNi2nPW5TKuWLLRnZTfWc2J
         K4ZdCBz49ji1fsfCNnzcKhufdKPMijQMDnCAxd5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/71] RDMA/siw: Properly check send and receive CQ pointers
Date:   Mon, 24 May 2021 17:25:09 +0200
Message-Id: <20210524152326.562771396@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152326.447759938@linuxfoundation.org>
References: <20210524152326.447759938@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit a568814a55a0e82bbc7c7b51333d0c38e8fb5520 ]

The check for the NULL of pointer received from container_of() is
incorrect by definition as it points to some offset from NULL.

Change such check with proper NULL check of SIW QP attributes.

Fixes: 303ae1cdfdf7 ("rdma/siw: application interface")
Link: https://lore.kernel.org/r/a7535a82925f6f4c1f062abaa294f3ae6e54bdd2.1620560310.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_verbs.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index 2c3704f0f10f..daa71469269e 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -314,7 +314,6 @@ struct ib_qp *siw_create_qp(struct ib_pd *pd,
 	struct siw_ucontext *uctx =
 		rdma_udata_to_drv_context(udata, struct siw_ucontext,
 					  base_ucontext);
-	struct siw_cq *scq = NULL, *rcq = NULL;
 	unsigned long flags;
 	int num_sqe, num_rqe, rv = 0;
 
@@ -353,10 +352,8 @@ struct ib_qp *siw_create_qp(struct ib_pd *pd,
 		rv = -EINVAL;
 		goto err_out;
 	}
-	scq = to_siw_cq(attrs->send_cq);
-	rcq = to_siw_cq(attrs->recv_cq);
 
-	if (!scq || (!rcq && !attrs->srq)) {
+	if (!attrs->send_cq || (!attrs->recv_cq && !attrs->srq)) {
 		siw_dbg(base_dev, "send CQ or receive CQ invalid\n");
 		rv = -EINVAL;
 		goto err_out;
@@ -423,8 +420,8 @@ struct ib_qp *siw_create_qp(struct ib_pd *pd,
 		}
 	}
 	qp->pd = pd;
-	qp->scq = scq;
-	qp->rcq = rcq;
+	qp->scq = to_siw_cq(attrs->send_cq);
+	qp->rcq = to_siw_cq(attrs->recv_cq);
 
 	if (attrs->srq) {
 		/*
-- 
2.30.2



