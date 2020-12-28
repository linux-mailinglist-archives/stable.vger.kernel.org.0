Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693602E427F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440928AbgL1PXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:23:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:34012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407931AbgL1OAS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:00:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE41E20791;
        Mon, 28 Dec 2020 13:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163978;
        bh=Q6hybbWsGBwwnhjLmmlGK0Kt0ZUf3abeoZZx17T3GIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1xwu+qVr8tpFMRCy2thXoFtjpDCvh2SczGFu9md1cYAVHrsdwFzmkn8i0SLcoD45m
         b7OEky5W+RNwVnH9sfKmdh5kqTkJPqL5WNJb6MTKXOZSlTihdru306MrRIXAlFvbS0
         x5IQoVewKQokfraGCkgf0ZFjEUdapK0BChYixgoc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Devesh Sharma <devesh.sharma@broadcom.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 018/717] RDMA/bnxt_re: Fix entry size during SRQ create
Date:   Mon, 28 Dec 2020 13:40:16 +0100
Message-Id: <20201228125021.857284942@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit b898d5c50cab1f985e77d053eb5c4d2c4a7694ae ]

Only static WQE is supported for SRQ. So always use the max supported SGEs
while calculating SRQ entry size.

Fixes: 2bb3c32c5c5f ("RDMA/bnxt_re: Change wr posting logic to accommodate variable wqes")
Link: https://lore.kernel.org/r/1602569752-12745-1-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Devesh Sharma <devesh.sharma@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index f9c999d5ba28e..266de55f57192 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1657,8 +1657,8 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
 	srq->qplib_srq.max_wqe = entries;
 
 	srq->qplib_srq.max_sge = srq_init_attr->attr.max_sge;
-	srq->qplib_srq.wqe_size =
-			bnxt_re_get_rwqe_size(srq->qplib_srq.max_sge);
+	 /* 128 byte wqe size for SRQ . So use max sges */
+	srq->qplib_srq.wqe_size = bnxt_re_get_rwqe_size(dev_attr->max_srq_sges);
 	srq->qplib_srq.threshold = srq_init_attr->attr.srq_limit;
 	srq->srq_limit = srq_init_attr->attr.srq_limit;
 	srq->qplib_srq.eventq_hw_ring_id = rdev->nq[0].ring_id;
-- 
2.27.0



