Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0F913F829
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437582AbgAPTQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:16:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:41392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730960AbgAPQzq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:55:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44E542051A;
        Thu, 16 Jan 2020 16:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193745;
        bh=z+L7J1b81PD8q0LsBdYiD30Fdaao3OMlu+10Bo8WG2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MbVTYfmDPJJsjVOtBBzx1kxk+onkx9NwLNthObnGxtvdlhMwuNKaIY10H4mpVJQDk
         +iSD0sbdviXIlAADli26QxAGf+LXw9IXwZTsl7TZPR2zNuW3dlijjTZnIrZr/SEUn7
         mfONFuVBL4vcCwb/LWALVoizX1rWNxdQI5WbejXg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 036/671] RDMA/bnxt_re: Add missing spin lock initialization
Date:   Thu, 16 Jan 2020 11:44:27 -0500
Message-Id: <20200116165502.8838-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index bc2b9e038439..bea8318e7007 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2664,6 +2664,7 @@ struct ib_cq *bnxt_re_create_cq(struct ib_device *ibdev,
 	nq->budget++;
 
 	atomic_inc(&rdev->cq_count);
+	spin_lock_init(&cq->cq_lock);
 
 	if (context) {
 		struct bnxt_re_cq_resp resp;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index 249efa0a6aba..c828c715d3cf 100644
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

