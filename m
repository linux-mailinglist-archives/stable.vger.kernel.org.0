Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B96F26B5B5
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727214AbgIOXtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:49:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727098AbgIOOcm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:32:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57C5D23BDE;
        Tue, 15 Sep 2020 14:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179876;
        bh=hHoLGgiAwXMFD63PG6tBBvyhsmsxBoSwKp4NhTY052A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K6EPVtI9vhfO4gKJ1z6SOLFOnWaZ+pWPTtC1BLmmcU1yVco2MTBxEa60xfZdHmPjL
         Rv0U5pYqQEIGDhzfis8NF1kRDB1Glg9P2dXpcDCh76BamfYxImQmbDoDELXi5J8Nba
         nMvjPGR8jqNHCPy5L8zIeVL/nJXe41XDDMCHuB4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 020/177] RDMA/bnxt_re: Static NQ depth allocation
Date:   Tue, 15 Sep 2020 16:11:31 +0200
Message-Id: <20200915140654.616022769@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>

[ Upstream commit f86b31c6a28f06eed3f6d9dc958079853b0792f1 ]

At first, driver allocates memory for NQ based on qplib_ctx->cq_count and
qplib_ctx->srqc_count.  Later when creating ring, it uses a static value
of 128K -1.

Fixing this with a static value for now.

Fixes: b08fe048a69d ("RDMA/bnxt_re: Refactor net ring allocation function")
Link: https://lore.kernel.org/r/1598292876-26529-5-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 5c41e13496a02..882c4f49d3a87 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -1027,8 +1027,7 @@ static int bnxt_re_alloc_res(struct bnxt_re_dev *rdev)
 		struct bnxt_qplib_nq *nq;
 
 		nq = &rdev->nq[i];
-		nq->hwq.max_elements = (qplib_ctx->cq_count +
-					qplib_ctx->srqc_count + 2);
+		nq->hwq.max_elements = BNXT_QPLIB_NQE_MAX_CNT;
 		rc = bnxt_qplib_alloc_nq(&rdev->qplib_res, &rdev->nq[i]);
 		if (rc) {
 			ibdev_err(&rdev->ibdev, "Alloc Failed NQ%d rc:%#x",
-- 
2.25.1



