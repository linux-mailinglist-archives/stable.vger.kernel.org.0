Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD7A49904B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359332AbiAXT7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:59:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41656 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347076AbiAXTyT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:54:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DF6AB81239;
        Mon, 24 Jan 2022 19:54:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F2AC340E5;
        Mon, 24 Jan 2022 19:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054056;
        bh=kQeVpgjXMWBkDkt3qPRgjWIZf9hgcZyZSnVYNAKMg0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N2ClNA0/MBMVsoksSHrWeCDzauK+90quhQU53DSnmEf2xikH/KOPN9rc7nMyKXdqn
         tlEozhIaNYUsINy8tUhFcvMBXMrxSKSIFn7n/zFWLSd9YzfBEGa0VLFlINwZGClz8i
         w/6vfNRZHsTTh+xRtMRSEqD19O8JUBrlE6tP2eVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        =?UTF-8?q?Michal=20Kalderon=C2=A0?= <michal.kalderon@marvell.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 265/563] RDMA/qedr: Fix reporting max_{send/recv}_wr attrs
Date:   Mon, 24 Jan 2022 19:40:30 +0100
Message-Id: <20220124184033.600036014@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Heib <kamalheib1@gmail.com>

[ Upstream commit b1a4da64bfc189510e08df1ccb1c589e667dc7a3 ]

Fix the wrongly reported max_send_wr and max_recv_wr attributes for user
QP by making sure to save their valuse on QP creation, so when query QP is
called the attributes will be reported correctly.

Fixes: cecbcddf6461 ("qedr: Add support for QP verbs")
Link: https://lore.kernel.org/r/20211206201314.124947-1-kamalheib1@gmail.com
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
Acked-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 16d5283651894..eeb87f31cd252 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -1918,6 +1918,7 @@ static int qedr_create_user_qp(struct qedr_dev *dev,
 	/* db offset was calculated in copy_qp_uresp, now set in the user q */
 	if (qedr_qp_has_sq(qp)) {
 		qp->usq.db_addr = ctx->dpi_addr + uresp.sq_db_offset;
+		qp->sq.max_wr = attrs->cap.max_send_wr;
 		rc = qedr_db_recovery_add(dev, qp->usq.db_addr,
 					  &qp->usq.db_rec_data->db_data,
 					  DB_REC_WIDTH_32B,
@@ -1928,6 +1929,7 @@ static int qedr_create_user_qp(struct qedr_dev *dev,
 
 	if (qedr_qp_has_rq(qp)) {
 		qp->urq.db_addr = ctx->dpi_addr + uresp.rq_db_offset;
+		qp->rq.max_wr = attrs->cap.max_recv_wr;
 		rc = qedr_db_recovery_add(dev, qp->urq.db_addr,
 					  &qp->urq.db_rec_data->db_data,
 					  DB_REC_WIDTH_32B,
-- 
2.34.1



