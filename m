Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0911C36EA43
	for <lists+stable@lfdr.de>; Thu, 29 Apr 2021 14:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhD2MZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 08:25:24 -0400
Received: from verein.lst.de ([213.95.11.211]:52899 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230148AbhD2MZX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Apr 2021 08:25:23 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4A8E767373; Thu, 29 Apr 2021 14:24:34 +0200 (CEST)
Date:   Thu, 29 Apr 2021 14:24:33 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     mwilck@suse.com
Cc:     Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Chao Leng <lengchao@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>,
        linux-nvme@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH v4] nvme: rdma/tcp: fix list corruption with anatt timer
Message-ID: <20210429122433.GA27567@lst.de>
References: <20210427093110.16461-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210427093110.16461-1-mwilck@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Martin,

can you give this patch a spin and check if this solves your issue?

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 0d0de3433f37..68f4d9d0ce58 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -780,6 +780,8 @@ void nvme_mpath_remove_disk(struct nvme_ns_head *head)
 
 int nvme_mpath_init(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
 {
+	size_t max_transfer_size = ctrl->max_hw_sectors << SECTOR_SHIFT;
+	size_t ana_log_size;
 	int error;
 
 	/* check if multipath is enabled and we have the capability */
@@ -787,47 +789,45 @@ int nvme_mpath_init(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
 	    !(ctrl->subsys->cmic & NVME_CTRL_CMIC_ANA))
 		return 0;
 
+	if (!ctrl->identified) {
+		mutex_init(&ctrl->ana_lock);
+		timer_setup(&ctrl->anatt_timer, nvme_anatt_timeout, 0);
+		INIT_WORK(&ctrl->ana_work, nvme_ana_work);
+	}
+
 	ctrl->anacap = id->anacap;
 	ctrl->anatt = id->anatt;
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
 		return 0;
 	}
 
-	INIT_WORK(&ctrl->ana_work, nvme_ana_work);
-	kfree(ctrl->ana_log_buf);
-	ctrl->ana_log_buf = kmalloc(ctrl->ana_log_size, GFP_KERNEL);
-	if (!ctrl->ana_log_buf) {
-		error = -ENOMEM;
-		goto out;
+	if (ana_log_size > ctrl->ana_log_size) {
+		nvme_mpath_uninit(ctrl);
+		ctrl->ana_log_buf = kmalloc(ctrl->ana_log_size, GFP_KERNEL);
+		if (!ctrl->ana_log_buf)
+			return -ENOMEM;
+		ctrl->ana_log_size = ana_log_size;
 	}
 
 	error = nvme_read_ana_log(ctrl);
 	if (error)
-		goto out_free_ana_log_buf;
-	return 0;
-out_free_ana_log_buf:
-	kfree(ctrl->ana_log_buf);
-	ctrl->ana_log_buf = NULL;
-out:
+		nvme_mpath_uninit(ctrl);
 	return error;
 }
 
 void nvme_mpath_uninit(struct nvme_ctrl *ctrl)
 {
+	nvme_mpath_stop(ctrl);
 	kfree(ctrl->ana_log_buf);
 	ctrl->ana_log_buf = NULL;
 }
