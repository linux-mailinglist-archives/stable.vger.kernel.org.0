Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E21936810C3
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237066AbjA3OGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:06:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237085AbjA3OG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:06:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE253B3C2
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:06:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1956F61025
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D76C433D2;
        Mon, 30 Jan 2023 14:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087587;
        bh=yM283uqsZhGyBbctYoENPcELMYDiYbGfVnB1kbZlVtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vdz5NtKpF/dKqNrJsHncRG8sZySSekFxjiihz8XzMK7YXMQWXws5zZ3FakIerY1IT
         +YveNBwhnc1vW01r0luwGjfNQ4onqjcPhwEevvaYhgPz17+6nFA+AXIgub9NsBN8sM
         yWe7In0k2/empzehOUXNx3/r38ca3XOZnjP9JXh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 257/313] nvme: simplify transport specific device attribute handling
Date:   Mon, 30 Jan 2023 14:51:32 +0100
Message-Id: <20230130134348.692907898@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 86adbf0cdb9ec6533234696c3e243184d4d0d040 ]

Allow the transport driver to override the attribute groups for the
control device, so that the PCIe driver doesn't manually have to add a
group after device creation and keep track of it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Tested-by Gerd Bayer <gbayer@linxu.ibm.com>
Stable-dep-of: 98e3528012cd ("nvme-fc: fix initialization order")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c |  8 ++++++--
 drivers/nvme/host/nvme.h |  2 ++
 drivers/nvme/host/pci.c  | 23 ++++++++---------------
 3 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 1ded96d1bfd2..badc6984ff83 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3903,10 +3903,11 @@ static umode_t nvme_dev_attrs_are_visible(struct kobject *kobj,
 	return a->mode;
 }
 
-static const struct attribute_group nvme_dev_attrs_group = {
+const struct attribute_group nvme_dev_attrs_group = {
 	.attrs		= nvme_dev_attrs,
 	.is_visible	= nvme_dev_attrs_are_visible,
 };
+EXPORT_SYMBOL_GPL(nvme_dev_attrs_group);
 
 static const struct attribute_group *nvme_dev_attr_groups[] = {
 	&nvme_dev_attrs_group,
@@ -5080,7 +5081,10 @@ int nvme_init_ctrl(struct nvme_ctrl *ctrl, struct device *dev,
 			ctrl->instance);
 	ctrl->device->class = nvme_class;
 	ctrl->device->parent = ctrl->dev;
-	ctrl->device->groups = nvme_dev_attr_groups;
+	if (ops->dev_attr_groups)
+		ctrl->device->groups = ops->dev_attr_groups;
+	else
+		ctrl->device->groups = nvme_dev_attr_groups;
 	ctrl->device->release = nvme_free_ctrl;
 	dev_set_drvdata(ctrl->device, ctrl);
 	ret = dev_set_name(ctrl->device, "nvme%d", ctrl->instance);
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index cbda8a19409b..aef3693ba5d3 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -508,6 +508,7 @@ struct nvme_ctrl_ops {
 	unsigned int flags;
 #define NVME_F_FABRICS			(1 << 0)
 #define NVME_F_METADATA_SUPPORTED	(1 << 1)
+	const struct attribute_group **dev_attr_groups;
 	int (*reg_read32)(struct nvme_ctrl *ctrl, u32 off, u32 *val);
 	int (*reg_write32)(struct nvme_ctrl *ctrl, u32 off, u32 val);
 	int (*reg_read64)(struct nvme_ctrl *ctrl, u32 off, u64 *val);
@@ -857,6 +858,7 @@ int nvme_dev_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags);
 extern const struct attribute_group *nvme_ns_id_attr_groups[];
 extern const struct pr_ops nvme_pr_ops;
 extern const struct block_device_operations nvme_ns_head_ops;
+extern const struct attribute_group nvme_dev_attrs_group;
 
 struct nvme_ns *nvme_find_path(struct nvme_ns_head *head);
 #ifdef CONFIG_NVME_MULTIPATH
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index e2de5d0de5d9..d839689af17c 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -158,8 +158,6 @@ struct nvme_dev {
 	unsigned int nr_allocated_queues;
 	unsigned int nr_write_queues;
 	unsigned int nr_poll_queues;
-
-	bool attrs_added;
 };
 
 static int io_queue_depth_set(const char *val, const struct kernel_param *kp)
@@ -2241,11 +2239,17 @@ static struct attribute *nvme_pci_attrs[] = {
 	NULL,
 };
 
-static const struct attribute_group nvme_pci_attr_group = {
+static const struct attribute_group nvme_pci_dev_attrs_group = {
 	.attrs		= nvme_pci_attrs,
 	.is_visible	= nvme_pci_attrs_are_visible,
 };
 
+static const struct attribute_group *nvme_pci_dev_attr_groups[] = {
+	&nvme_dev_attrs_group,
+	&nvme_pci_dev_attrs_group,
+	NULL,
+};
+
 /*
  * nirqs is the number of interrupts available for write and read
  * queues. The core already reserved an interrupt for the admin queue.
@@ -2935,10 +2939,6 @@ static void nvme_reset_work(struct work_struct *work)
 		goto out;
 	}
 
-	if (!dev->attrs_added && !sysfs_create_group(&dev->ctrl.device->kobj,
-			&nvme_pci_attr_group))
-		dev->attrs_added = true;
-
 	nvme_start_ctrl(&dev->ctrl);
 	return;
 
@@ -3011,6 +3011,7 @@ static const struct nvme_ctrl_ops nvme_pci_ctrl_ops = {
 	.name			= "pcie",
 	.module			= THIS_MODULE,
 	.flags			= NVME_F_METADATA_SUPPORTED,
+	.dev_attr_groups	= nvme_pci_dev_attr_groups,
 	.reg_read32		= nvme_pci_reg_read32,
 	.reg_write32		= nvme_pci_reg_write32,
 	.reg_read64		= nvme_pci_reg_read64,
@@ -3209,13 +3210,6 @@ static void nvme_shutdown(struct pci_dev *pdev)
 	nvme_disable_prepare_reset(dev, true);
 }
 
-static void nvme_remove_attrs(struct nvme_dev *dev)
-{
-	if (dev->attrs_added)
-		sysfs_remove_group(&dev->ctrl.device->kobj,
-				   &nvme_pci_attr_group);
-}
-
 /*
  * The driver's remove may be called on a device in a partially initialized
  * state. This function must not have any dependencies on the device state in
@@ -3237,7 +3231,6 @@ static void nvme_remove(struct pci_dev *pdev)
 	nvme_stop_ctrl(&dev->ctrl);
 	nvme_remove_namespaces(&dev->ctrl);
 	nvme_dev_disable(dev, true);
-	nvme_remove_attrs(dev);
 	nvme_free_host_mem(dev);
 	nvme_dev_remove_admin(dev);
 	nvme_free_queues(dev, 0);
-- 
2.39.0



