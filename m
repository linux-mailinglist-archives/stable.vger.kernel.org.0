Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96ADA29B8EB
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802096AbgJ0Ppf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801064AbgJ0PiY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:38:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07A412225E;
        Tue, 27 Oct 2020 15:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813103;
        bh=a9FoLFY3a0YLls1nteY7k/q1l1cCoVANCrzHmI05bkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R2RQPR7qSd5JAwVGvCNezdse8WYyKixDfdqQ9yCX+TY/43Co5tnYgQDalSbwu7MDi
         1hDDXrWyB1aCO3WByfLtGM6q/RulllxIl3t/Q5g2TLycPpZcnFvEOoBA7Mlii2o42N
         GprfHsM6OqBFP/6QgeMcaKHatkf4AQpqnhFNqpH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 437/757] RDMA/qedr: Fix return code if accept is called on a destroyed qp
Date:   Tue, 27 Oct 2020 14:51:27 +0100
Message-Id: <20201027135511.038888049@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>

[ Upstream commit 8a5a10a1a74465065c75d9de1aa6685e1f1aa117 ]

In iWARP, accept could be called after a QP is already destroyed.  In this
case an error should be returned and not success.

Fixes: 82af6d19d8d9 ("RDMA/qedr: Fix synchronization methods and memory leaks in qedr")
Link: https://lore.kernel.org/r/20200902165741.8355-5-michal.kalderon@marvell.com
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/qedr_iw_cm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/qedr_iw_cm.c b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
index 97fc7dd353b04..c7169d2c69e5b 100644
--- a/drivers/infiniband/hw/qedr/qedr_iw_cm.c
+++ b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
@@ -736,7 +736,7 @@ int qedr_iw_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	struct qedr_dev *dev = ep->dev;
 	struct qedr_qp *qp;
 	struct qed_iwarp_accept_in params;
-	int rc = 0;
+	int rc;
 
 	DP_DEBUG(dev, QEDR_MSG_IWARP, "Accept on qpid=%d\n", conn_param->qpn);
 
@@ -759,8 +759,10 @@ int qedr_iw_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	params.ord = conn_param->ord;
 
 	if (test_and_set_bit(QEDR_IWARP_CM_WAIT_FOR_CONNECT,
-			     &qp->iwarp_cm_flags))
+			     &qp->iwarp_cm_flags)) {
+		rc = -EINVAL;
 		goto err; /* QP already destroyed */
+	}
 
 	rc = dev->ops->iwarp_accept(dev->rdma_ctx, &params);
 	if (rc) {
-- 
2.25.1



