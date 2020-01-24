Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C33411484A7
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388226AbgAXLn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:43:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:34850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387775AbgAXLBr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:01:47 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 246C32075D;
        Fri, 24 Jan 2020 11:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863706;
        bh=R42p8EilbRbVFkTD4UNRS3mWkYYHpNPIw5FbffRX+gQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xCURA0MPHLuT8IT8TY1Goj7Y2itYBfpKN8nUV6P65tVs20VNdmPNjApAHizeB59ik
         fT/nnChQRoSGgQyZCs9QNXH3HmjtPq3ziFwOPhaTADlBELqFA1R6LBc8aGP051Lzjz
         K2BXPqN5A0ug3colISHLA640yfatc7Yws87GQIY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 053/639] RDMA/bnxt_re: Add missing spin lock initialization
Date:   Fri, 24 Jan 2020 10:23:43 +0100
Message-Id: <20200124093054.050445323@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 5a23e0b1dd51fe0efae666b03fdb15e1301f437a ]

Add the missing initalization of the cq_lock and qplib.flush_lock.

Fixes: 942c9b6ca8de ("RDMA/bnxt_re: Avoid Hard lockup during error CQE processing")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 1 +
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index a69632f1fab0b..c9af2d139f5cb 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2664,6 +2664,7 @@ struct ib_cq *bnxt_re_create_cq(struct ib_device *ibdev,
 	nq->budget++;
 
 	atomic_inc(&rdev->cq_count);
+	spin_lock_init(&cq->cq_lock);
 
 	if (context) {
 		struct bnxt_re_cq_resp resp;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index c15335dc8f614..60f2fb7e7dbfe 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -1970,6 +1970,7 @@ int bnxt_qplib_create_cq(struct bnxt_qplib_res *res, struct bnxt_qplib_cq *cq)
 	INIT_LIST_HEAD(&cq->sqf_head);
 	INIT_LIST_HEAD(&cq->rqf_head);
 	spin_lock_init(&cq->compl_lock);
+	spin_lock_init(&cq->flush_lock);
 
 	bnxt_qplib_arm_cq_enable(cq);
 	return 0;
-- 
2.20.1



