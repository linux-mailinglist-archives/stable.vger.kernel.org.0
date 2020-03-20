Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A18C518C74A
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 07:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbgCTGDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 02:03:18 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58928 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgCTGDS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Mar 2020 02:03:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=162dfHeJQ7GH7/Bx8yP8yxuqC3X76ilbm0hXcj0/j0A=; b=hAosxfS5MftvWL3yTpL2yrnmdM
        l31SLlxDr4zmqlWWvmttnaN26qrw3IoFmWk9zXBT2pVO6um0yGCN1P7MwCBoPtwBanQmJVy4oE9Rd
        PnCn+hA5LLzgVqxwYn5tJTxVUuCgxE78HnkLCw/XM5lczxcE48PjMT1Ez1lk+20bWDGEXSbJU3kpV
        HSNzZ+n//A6k6ZdbV95ndrMAcWerCV01Absjlqjjq2672s6VBEgmfjsWv6A4IM5y1LJyItCVqjjVf
        cx7Ra9KejiiJk99MX8IqknAUxsZ7JLqfyQv4o+cS15ZVcqaxz6gD8JU6r5SENpYj9QL1p1HPminM8
        qN8AIoVQ==;
Received: from [2601:647:4802:9070:f092:4ccc:3e48:6081] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jFAkY-00045q-CC; Fri, 20 Mar 2020 06:03:18 +0000
From:   Sagi Grimberg <sagi@grimberg.me>
To:     stable@vger.kernel.org
Cc:     Potnuri Bharat Teja <bharat@chelsio.com>
Subject: [PATCH stable 5.4] nvmet: fix dsm failure when payload does not match sgl descriptor
Date:   Thu, 19 Mar 2020 23:03:14 -0700
Message-Id: <20200320060314.31192-1-sagi@grimberg.me>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b716e6889c95f64ba32af492461f6cc9341f3f05 upstream.

The host is allowed to pass the controller an sgl describing a buffer
that is larger than the dsm payload itself, allow it when executing
dsm.

Reported-by: Dakshaja Uppalapati <dakshaja@chelsio.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>,
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/nvme/target/core.c        | 11 +++++++++++
 drivers/nvme/target/io-cmd-bdev.c |  2 +-
 drivers/nvme/target/io-cmd-file.c |  2 +-
 drivers/nvme/target/nvmet.h       |  1 +
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 35810a0a8d21..461987f669c5 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -939,6 +939,17 @@ bool nvmet_check_data_len(struct nvmet_req *req, size_t data_len)
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
index b6fca0e421ef..ea0e596be15d 100644
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
2.20.1

