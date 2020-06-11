Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37AA1F6BB2
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 17:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbgFKP5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 11:57:24 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:34564 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728585AbgFKP5Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 11:57:24 -0400
Received: from moto.blr.asicdesigners.com (moto.blr.asicdesigners.com [10.193.184.79] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05BFrs79005517;
        Thu, 11 Jun 2020 08:56:09 -0700
From:   Dakshaja Uppalapati <dakshaja@chelsio.com>
To:     eduard@hasenleithner.at, kbusch@kernel.org, sagi@grimberg.me,
        hch@lst.de
Cc:     stable@vger.kernel.org, nirranjan@chelsio.com, bharat@chelsio.com,
        dakshaja@chelsio.com
Subject: [PATCH for-stable nvmet 6/6] nvmet: fix dsm failure when payload does not match sgl descriptor
Date:   Thu, 11 Jun 2020 21:23:39 +0530
Message-Id: <20200611155339.9429-7-dakshaja@chelsio.com>
X-Mailer: git-send-email 2.18.0.232.gb7bd9486b.dirty
In-Reply-To: <20200611155339.9429-1-dakshaja@chelsio.com>
References: <20200611155339.9429-1-dakshaja@chelsio.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The host is allowed to pass the controller an sgl describing a buffer
that is larger than the dsm payload itself, allow it when executing
dsm.

Reported-by: Dakshaja Uppalapati <dakshaja@chelsio.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>,
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Signed-off-by: Dakshaja Uppalapati <dakshaja@chelsio.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/nvme/target/core.c        | 11 +++++++++++
 drivers/nvme/target/io-cmd-bdev.c |  2 +-
 drivers/nvme/target/io-cmd-file.c |  2 +-
 drivers/nvme/target/nvmet.h       |  1 +
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 03b56ed7eca0..7c91e1d64ed6 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -943,6 +943,17 @@ bool nvmet_check_data_len(struct nvmet_req *req, size_t data_len)
 }
 EXPORT_SYMBOL_GPL(nvmet_check_data_len);
 
+bool nvmet_check_data_len_lte(struct nvmet_req *req, size_t data_len)
+{
+	if (unlikely(data_len > req->transfer_len)) {
+		req->error_loc = offsetof(struct nvme_common_command, dptr);
+		nvmet_req_complete(req, NVME_SC_SGL_INVALID_DATA | NVME_SC_DNR);
+		return false;
+	}
+
+	return true;
+}
+
 int nvmet_req_alloc_sgl(struct nvmet_req *req)
 {
 	struct pci_dev *p2p_dev = NULL;
diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 2d62347573fa..7a88fd75b79c 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -280,7 +280,7 @@ static void nvmet_bdev_execute_discard(struct nvmet_req *req)
 
 static void nvmet_bdev_execute_dsm(struct nvmet_req *req)
 {
-	if (!nvmet_check_data_len(req, nvmet_dsm_len(req)))
+	if (!nvmet_check_data_len_lte(req, nvmet_dsm_len(req)))
 		return;
 
 	switch (le32_to_cpu(req->cmd->dsm.attributes)) {
diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index caebfce06605..cd5670b83118 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -336,7 +336,7 @@ static void nvmet_file_dsm_work(struct work_struct *w)
 
 static void nvmet_file_execute_dsm(struct nvmet_req *req)
 {
-	if (!nvmet_check_data_len(req, nvmet_dsm_len(req)))
+	if (!nvmet_check_data_len_lte(req, nvmet_dsm_len(req)))
 		return;
 	INIT_WORK(&req->f.work, nvmet_file_dsm_work);
 	schedule_work(&req->f.work);
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 46df45e837c9..eda28b22a2c8 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -374,6 +374,7 @@ bool nvmet_req_init(struct nvmet_req *req, struct nvmet_cq *cq,
 		struct nvmet_sq *sq, const struct nvmet_fabrics_ops *ops);
 void nvmet_req_uninit(struct nvmet_req *req);
 bool nvmet_check_data_len(struct nvmet_req *req, size_t data_len);
+bool nvmet_check_data_len_lte(struct nvmet_req *req, size_t data_len);
 void nvmet_req_complete(struct nvmet_req *req, u16 status);
 int nvmet_req_alloc_sgl(struct nvmet_req *req);
 void nvmet_req_free_sgl(struct nvmet_req *req);
-- 
2.18.0.232.gb7bd9486b.dirty

