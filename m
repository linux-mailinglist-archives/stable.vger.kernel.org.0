Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18B68FF385
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbfKPPl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:41:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:45354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728060AbfKPPl6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:58 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82519207FA;
        Sat, 16 Nov 2019 15:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918916;
        bh=exWk14fngb1BXqFLHVNg9jbsZqzBTXvvlD/nSx7Ny2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iz9PEi7qdmdwtuwhN0lZ+WHlQTyuqPmOa++f+/qyhAaaavri2V9ZuQolue7uT57gD
         2rTnepnwz5dDKSNunsMVcOMMiYJ+WfyPAJ9RFZRaNTxvWOgJwX+QryLH4yFvK2RRGe
         ZLh0PR0NF2OaYAgTCiPvRqFBXzrWCIXe0ssA4dkA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 040/237] RDMA/bnxt_re: Avoid resource leak in case the NQ registration fails
Date:   Sat, 16 Nov 2019 10:37:55 -0500
Message-Id: <20191116154113.7417-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 5df950994934814a8b91f0cf9f653842d2ba082d ]

In case the NQ alloc/enable fails, free up the already allocated/enabled
NQ before reporting failure. Also, track the alloc/enable using proper
state checking.

Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/bnxt_re.h |  2 ++
 drivers/infiniband/hw/bnxt_re/main.c    | 31 ++++++++++++++++++-------
 2 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
index 96f76896488da..802942adea8e8 100644
--- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
+++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
@@ -120,6 +120,8 @@ struct bnxt_re_dev {
 #define BNXT_RE_FLAG_HAVE_L2_REF		3
 #define BNXT_RE_FLAG_RCFW_CHANNEL_EN		4
 #define BNXT_RE_FLAG_QOS_WORK_REG		5
+#define BNXT_RE_FLAG_RESOURCES_ALLOCATED	7
+#define BNXT_RE_FLAG_RESOURCES_INITIALIZED	8
 #define BNXT_RE_FLAG_ISSUE_ROCE_STATS          29
 	struct net_device		*netdev;
 	unsigned int			version, major, minor;
diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 7ffad368c5fa1..589b0d4677d52 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -864,10 +864,8 @@ static void bnxt_re_cleanup_res(struct bnxt_re_dev *rdev)
 {
 	int i;
 
-	if (rdev->nq[0].hwq.max_elements) {
-		for (i = 1; i < rdev->num_msix; i++)
-			bnxt_qplib_disable_nq(&rdev->nq[i - 1]);
-	}
+	for (i = 1; i < rdev->num_msix; i++)
+		bnxt_qplib_disable_nq(&rdev->nq[i - 1]);
 
 	if (rdev->qplib_res.rcfw)
 		bnxt_qplib_cleanup_res(&rdev->qplib_res);
@@ -876,6 +874,7 @@ static void bnxt_re_cleanup_res(struct bnxt_re_dev *rdev)
 static int bnxt_re_init_res(struct bnxt_re_dev *rdev)
 {
 	int rc = 0, i;
+	int num_vec_enabled = 0;
 
 	bnxt_qplib_init_res(&rdev->qplib_res);
 
@@ -891,9 +890,13 @@ static int bnxt_re_init_res(struct bnxt_re_dev *rdev)
 				"Failed to enable NQ with rc = 0x%x", rc);
 			goto fail;
 		}
+		num_vec_enabled++;
 	}
 	return 0;
 fail:
+	for (i = num_vec_enabled; i >= 0; i--)
+		bnxt_qplib_disable_nq(&rdev->nq[i]);
+
 	return rc;
 }
 
@@ -925,6 +928,7 @@ static void bnxt_re_free_res(struct bnxt_re_dev *rdev)
 static int bnxt_re_alloc_res(struct bnxt_re_dev *rdev)
 {
 	int rc = 0, i;
+	int num_vec_created = 0;
 
 	/* Configure and allocate resources for qplib */
 	rdev->qplib_res.rcfw = &rdev->rcfw;
@@ -951,7 +955,7 @@ static int bnxt_re_alloc_res(struct bnxt_re_dev *rdev)
 		if (rc) {
 			dev_err(rdev_to_dev(rdev), "Alloc Failed NQ%d rc:%#x",
 				i, rc);
-			goto dealloc_dpi;
+			goto free_nq;
 		}
 		rc = bnxt_re_net_ring_alloc
 			(rdev, rdev->nq[i].hwq.pbl[PBL_LVL_0].pg_map_arr,
@@ -964,14 +968,17 @@ static int bnxt_re_alloc_res(struct bnxt_re_dev *rdev)
 			dev_err(rdev_to_dev(rdev),
 				"Failed to allocate NQ fw id with rc = 0x%x",
 				rc);
+			bnxt_qplib_free_nq(&rdev->nq[i]);
 			goto free_nq;
 		}
+		num_vec_created++;
 	}
 	return 0;
 free_nq:
-	for (i = 0; i < rdev->num_msix - 1; i++)
+	for (i = num_vec_created; i >= 0; i--) {
+		bnxt_re_net_ring_free(rdev, rdev->nq[i].ring_id);
 		bnxt_qplib_free_nq(&rdev->nq[i]);
-dealloc_dpi:
+	}
 	bnxt_qplib_dealloc_dpi(&rdev->qplib_res,
 			       &rdev->qplib_res.dpi_tbl,
 			       &rdev->dpi_privileged);
@@ -1206,8 +1213,11 @@ static void bnxt_re_ib_unreg(struct bnxt_re_dev *rdev)
 	if (test_and_clear_bit(BNXT_RE_FLAG_QOS_WORK_REG, &rdev->flags))
 		cancel_delayed_work(&rdev->worker);
 
-	bnxt_re_cleanup_res(rdev);
-	bnxt_re_free_res(rdev);
+	if (test_and_clear_bit(BNXT_RE_FLAG_RESOURCES_INITIALIZED,
+			       &rdev->flags))
+		bnxt_re_cleanup_res(rdev);
+	if (test_and_clear_bit(BNXT_RE_FLAG_RESOURCES_ALLOCATED, &rdev->flags))
+		bnxt_re_free_res(rdev);
 
 	if (test_and_clear_bit(BNXT_RE_FLAG_RCFW_CHANNEL_EN, &rdev->flags)) {
 		rc = bnxt_qplib_deinit_rcfw(&rdev->rcfw);
@@ -1337,12 +1347,15 @@ static int bnxt_re_ib_reg(struct bnxt_re_dev *rdev)
 		pr_err("Failed to allocate resources: %#x\n", rc);
 		goto fail;
 	}
+	set_bit(BNXT_RE_FLAG_RESOURCES_ALLOCATED, &rdev->flags);
 	rc = bnxt_re_init_res(rdev);
 	if (rc) {
 		pr_err("Failed to initialize resources: %#x\n", rc);
 		goto fail;
 	}
 
+	set_bit(BNXT_RE_FLAG_RESOURCES_INITIALIZED, &rdev->flags);
+
 	if (!rdev->is_virtfn) {
 		rc = bnxt_re_setup_qos(rdev);
 		if (rc)
-- 
2.20.1

