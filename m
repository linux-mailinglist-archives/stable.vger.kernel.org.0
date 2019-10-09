Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74766D1403
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 18:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbfJIQ3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 12:29:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729644AbfJIQ3e (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 12:29:34 -0400
Received: from washi1.fujisawa.hgst.com (unknown [199.255.47.10])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11DF020B7C;
        Wed,  9 Oct 2019 16:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570638573;
        bh=SEluYkGdZFdi1G/4No8jnOToASnRSalVGFVQ5zg3QMI=;
        h=From:To:Cc:Subject:Date:From;
        b=Un1RQirrAA0yFVr3ZlZ6xemVjl0gcek9vQyVPrxlnbC9Jo2lXeYZLUMW5PWDvU/Uv
         CwX3tQmzhc/jepqXXnSzLMOvsahhTD9dsYVDCvhCKz/6+BVK+3donxS3GS01H5f+M7
         3TBt/qToHKWmphSMWOgkUcNtZAs30z3AhUD8hICs=
From:   Keith Busch <kbusch@kernel.org>
To:     linux-nvme@lists.infradead.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>,
        Minwoo Im <minwoo.im@samsung.com>,
        Hannes Reinecke <hare@suse.com>,
        Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH 4.19] nvme: Assign subsys instance from first ctrl
Date:   Thu, 10 Oct 2019 01:29:10 +0900
Message-Id: <20191009162910.1801-1-kbusch@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 733e4b69d508d03c20adfdcf4bd27abc60fae9cc upstream

The namespace disk names must be unique for the lifetime of the
subsystem. This was accomplished by using their parent subsystems'
instances which were allocated independently from the controllers
connected to that subsystem. This allowed name prefixes assigned to
namespaces to match a controller from an unrelated subsystem, and has
created confusion among users examining device nodes.

Ensure a namespace's subsystem instance never clashes with a controller
instance of another subsystem by transferring the instance ownership
to the parent subsystem from the first controller discovered in that
subsystem.

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Minwoo Im <minwoo.im@samsung.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/nvme/host/core.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index ae0b01059fc6..cab4f368ef2d 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -88,7 +88,6 @@ EXPORT_SYMBOL_GPL(nvme_reset_wq);
 struct workqueue_struct *nvme_delete_wq;
 EXPORT_SYMBOL_GPL(nvme_delete_wq);
 
-static DEFINE_IDA(nvme_subsystems_ida);
 static LIST_HEAD(nvme_subsystems);
 static DEFINE_MUTEX(nvme_subsystems_lock);
 
@@ -2139,7 +2138,8 @@ static void nvme_init_subnqn(struct nvme_subsystem *subsys, struct nvme_ctrl *ct
 
 static void __nvme_release_subsystem(struct nvme_subsystem *subsys)
 {
-	ida_simple_remove(&nvme_subsystems_ida, subsys->instance);
+	if (subsys->instance >= 0)
+		ida_simple_remove(&nvme_instance_ida, subsys->instance);
 	kfree(subsys);
 }
 
@@ -2255,12 +2255,8 @@ static int nvme_init_subsystem(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
 	subsys = kzalloc(sizeof(*subsys), GFP_KERNEL);
 	if (!subsys)
 		return -ENOMEM;
-	ret = ida_simple_get(&nvme_subsystems_ida, 0, 0, GFP_KERNEL);
-	if (ret < 0) {
-		kfree(subsys);
-		return ret;
-	}
-	subsys->instance = ret;
+
+	subsys->instance = -1;
 	mutex_init(&subsys->lock);
 	kref_init(&subsys->ref);
 	INIT_LIST_HEAD(&subsys->ctrls);
@@ -2275,7 +2271,7 @@ static int nvme_init_subsystem(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
 	subsys->dev.class = nvme_subsys_class;
 	subsys->dev.release = nvme_release_subsystem;
 	subsys->dev.groups = nvme_subsys_attrs_groups;
-	dev_set_name(&subsys->dev, "nvme-subsys%d", subsys->instance);
+	dev_set_name(&subsys->dev, "nvme-subsys%d", ctrl->instance);
 	device_initialize(&subsys->dev);
 
 	mutex_lock(&nvme_subsystems_lock);
@@ -2308,6 +2304,8 @@ static int nvme_init_subsystem(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
 		list_add_tail(&subsys->entry, &nvme_subsystems);
 	}
 
+	if (!found)
+		subsys->instance = ctrl->instance;
 	ctrl->subsys = subsys;
 	mutex_unlock(&nvme_subsystems_lock);
 
@@ -2319,7 +2317,6 @@ static int nvme_init_subsystem(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
 		return -EINVAL;
 	}
 
-	mutex_lock(&subsys->lock);
 	list_add_tail(&ctrl->subsys_entry, &subsys->ctrls);
 	mutex_unlock(&subsys->lock);
 
@@ -3545,7 +3542,9 @@ static void nvme_free_ctrl(struct device *dev)
 		container_of(dev, struct nvme_ctrl, ctrl_device);
 	struct nvme_subsystem *subsys = ctrl->subsys;
 
-	ida_simple_remove(&nvme_instance_ida, ctrl->instance);
+	if (subsys && ctrl->instance != subsys->instance)
+		ida_simple_remove(&nvme_instance_ida, ctrl->instance);
+
 	kfree(ctrl->effects);
 	nvme_mpath_uninit(ctrl);
 
@@ -3775,7 +3774,6 @@ int __init nvme_core_init(void)
 
 void nvme_core_exit(void)
 {
-	ida_destroy(&nvme_subsystems_ida);
 	class_destroy(nvme_subsys_class);
 	class_destroy(nvme_class);
 	unregister_chrdev_region(nvme_chr_devt, NVME_MINORS);
-- 
2.21.0

