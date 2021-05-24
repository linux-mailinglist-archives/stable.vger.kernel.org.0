Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8373438EEA3
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234625AbhEXPwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:52:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233350AbhEXPuh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:50:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67BD761624;
        Mon, 24 May 2021 15:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870705;
        bh=p/wgZd/RuayYcBSTUKsWbTD5ia98IlAWOs9d3Ke2Cv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GLigzpzoQTmms8WXqAeU4mDDpeP68jeFF/SQNzOKeHi9AM90rq0YLjoK5zwjjqZyt
         o1SAcQxreyCR+JN1MnpWqx+buuH44LO3ivwr1dPuDJBtGeM1WfJqI8LQ/kpxnlRU87
         YpjW4jKm9QMmQynEqVEi1LiIKogrmLjN3zu2duJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Wilck <mwilck@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5.4 69/71] nvme-multipath: fix double initialization of ANA state
Date:   Mon, 24 May 2021 17:26:15 +0200
Message-Id: <20210524152328.686476606@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

commit 5e1f689913a4498e3081093670ef9d85b2c60920 upstream.

nvme_init_identify and thus nvme_mpath_init can be called multiple
times and thus must not overwrite potentially initialized or in-use
fields.  Split out a helper for the basic initialization when the
controller is initialized and make sure the init_identify path does
not blindly change in-use data structures.

Fixes: 0d0b660f214d ("nvme: add ANA support")
Reported-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c      |    3 +-
 drivers/nvme/host/multipath.c |   55 ++++++++++++++++++++++--------------------
 drivers/nvme/host/nvme.h      |    8 ++++--
 3 files changed, 37 insertions(+), 29 deletions(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2904,7 +2904,7 @@ int nvme_init_identify(struct nvme_ctrl
 		ctrl->hmmaxd = le16_to_cpu(id->hmmaxd);
 	}
 
-	ret = nvme_mpath_init(ctrl, id);
+	ret = nvme_mpath_init_identify(ctrl, id);
 	kfree(id);
 
 	if (ret < 0)
@@ -4145,6 +4145,7 @@ int nvme_init_ctrl(struct nvme_ctrl *ctr
 		min(default_ps_max_latency_us, (unsigned long)S32_MAX));
 
 	nvme_fault_inject_init(&ctrl->fault_inject, dev_name(ctrl->device));
+	nvme_mpath_init_ctrl(ctrl);
 
 	return 0;
 out_free_name:
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -718,9 +718,18 @@ void nvme_mpath_remove_disk(struct nvme_
 	put_disk(head->disk);
 }
 
-int nvme_mpath_init(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
+void nvme_mpath_init_ctrl(struct nvme_ctrl *ctrl)
 {
-	int error;
+	mutex_init(&ctrl->ana_lock);
+	timer_setup(&ctrl->anatt_timer, nvme_anatt_timeout, 0);
+	INIT_WORK(&ctrl->ana_work, nvme_ana_work);
+}
+
+int nvme_mpath_init_identify(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
+{
+	size_t max_transfer_size = ctrl->max_hw_sectors << SECTOR_SHIFT;
+	size_t ana_log_size;
+	int error = 0;
 
 	/* check if multipath is enabled and we have the capability */
 	if (!multipath || !ctrl->subsys || !(ctrl->subsys->cmic & (1 << 3)))
@@ -731,37 +740,31 @@ int nvme_mpath_init(struct nvme_ctrl *ct
 	ctrl->nanagrpid = le32_to_cpu(id->nanagrpid);
 	ctrl->anagrpmax = le32_to_cpu(id->anagrpmax);
 
-	mutex_init(&ctrl->ana_lock);
-	timer_setup(&ctrl->anatt_timer, nvme_anatt_timeout, 0);
-	ctrl->ana_log_size = sizeof(struct nvme_ana_rsp_hdr) +
-		ctrl->nanagrpid * sizeof(struct nvme_ana_group_desc);
-	ctrl->ana_log_size += ctrl->max_namespaces * sizeof(__le32);
-
-	if (ctrl->ana_log_size > ctrl->max_hw_sectors << SECTOR_SHIFT) {
+	ana_log_size = sizeof(struct nvme_ana_rsp_hdr) +
+		ctrl->nanagrpid * sizeof(struct nvme_ana_group_desc) +
+		ctrl->max_namespaces * sizeof(__le32);
+	if (ana_log_size > max_transfer_size) {
 		dev_err(ctrl->device,
-			"ANA log page size (%zd) larger than MDTS (%d).\n",
-			ctrl->ana_log_size,
-			ctrl->max_hw_sectors << SECTOR_SHIFT);
+			"ANA log page size (%zd) larger than MDTS (%zd).\n",
+			ana_log_size, max_transfer_size);
 		dev_err(ctrl->device, "disabling ANA support.\n");
-		return 0;
+		goto out_uninit;
 	}
-
-	INIT_WORK(&ctrl->ana_work, nvme_ana_work);
-	kfree(ctrl->ana_log_buf);
-	ctrl->ana_log_buf = kmalloc(ctrl->ana_log_size, GFP_KERNEL);
-	if (!ctrl->ana_log_buf) {
-		error = -ENOMEM;
-		goto out;
+	if (ana_log_size > ctrl->ana_log_size) {
+		nvme_mpath_stop(ctrl);
+		kfree(ctrl->ana_log_buf);
+		ctrl->ana_log_buf = kmalloc(ctrl->ana_log_size, GFP_KERNEL);
+		if (!ctrl->ana_log_buf)
+			return -ENOMEM;
 	}
-
+	ctrl->ana_log_size = ana_log_size;
 	error = nvme_read_ana_log(ctrl);
 	if (error)
-		goto out_free_ana_log_buf;
+		goto out_uninit;
 	return 0;
-out_free_ana_log_buf:
-	kfree(ctrl->ana_log_buf);
-	ctrl->ana_log_buf = NULL;
-out:
+
+out_uninit:
+	nvme_mpath_uninit(ctrl);
 	return error;
 }
 
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -549,7 +549,8 @@ void nvme_kick_requeue_lists(struct nvme
 int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl,struct nvme_ns_head *head);
 void nvme_mpath_add_disk(struct nvme_ns *ns, struct nvme_id_ns *id);
 void nvme_mpath_remove_disk(struct nvme_ns_head *head);
-int nvme_mpath_init(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id);
+int nvme_mpath_init_identify(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id);
+void nvme_mpath_init_ctrl(struct nvme_ctrl *ctrl);
 void nvme_mpath_uninit(struct nvme_ctrl *ctrl);
 void nvme_mpath_stop(struct nvme_ctrl *ctrl);
 bool nvme_mpath_clear_current_path(struct nvme_ns *ns);
@@ -636,7 +637,10 @@ static inline void nvme_trace_bio_comple
         blk_status_t status)
 {
 }
-static inline int nvme_mpath_init(struct nvme_ctrl *ctrl,
+static inline void nvme_mpath_init_ctrl(struct nvme_ctrl *ctrl)
+{
+}
+static inline int nvme_mpath_init_identify(struct nvme_ctrl *ctrl,
 		struct nvme_id_ctrl *id)
 {
 	if (ctrl->subsys->cmic & (1 << 3))


