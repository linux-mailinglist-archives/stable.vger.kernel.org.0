Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D763227DF
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 10:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbhBWJcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 04:32:02 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:47094 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232133AbhBWJ3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 04:29:48 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UPMP7ZC_1614072542;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UPMP7ZC_1614072542)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 23 Feb 2021 17:29:03 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, joseph.qi@linux.alibaba.com,
        jefflexu@linux.alibaba.com, hare@suse.com
Subject: [PATCH v2 4.19 3/6] nvme: register ns_id attributes as default sysfs groups
Date:   Tue, 23 Feb 2021 17:28:56 +0800
Message-Id: <20210223092859.17033-4-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210223092859.17033-1-jefflexu@linux.alibaba.com>
References: <20210223092859.17033-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

commit 33b14f67a4e1eabd219fd6543da8f15ed86b641c upstream.

We should be registering the ns_id attribute as default sysfs
attribute groups, otherwise we have a race condition between
the uevent and the attributes appearing in sysfs.

[Backport Notes]
Resolve two context conflicts introduced by following two commits. These
two commits are applied after the current commit in upstream, while have
been merged into 4.19.y stable tree before the current commit.
1. drivers/nvme/host/core.c:nvme_ns_remove, introduced by commit
2181e455612a ("nvme: fix possible io failures when removing multipathed
ns").
2. drivers/nvme/host/multipath.c:nvme_mpath_set_live, introduced by
commit 5e416b11b4a9 ("nvme-multipath: fix possible I/O hang when paths
are updated").

Suggested-by: Bart van Assche <bvanassche@acm.org>
Reviewed-by: Keith Busch <keith.busch@intel.com>
Signed-off-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 drivers/nvme/host/core.c      |  21 +++----
 drivers/nvme/host/lightnvm.c  | 105 ++++++++++++++--------------------
 drivers/nvme/host/multipath.c |  15 ++---
 drivers/nvme/host/nvme.h      |  10 +---
 4 files changed, 59 insertions(+), 92 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 244a693c35de..513dd1e2aac7 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2842,6 +2842,14 @@ const struct attribute_group nvme_ns_id_attr_group = {
 	.is_visible	= nvme_ns_id_attrs_are_visible,
 };
 
+const struct attribute_group *nvme_ns_id_attr_groups[] = {
+	&nvme_ns_id_attr_group,
+#ifdef CONFIG_NVM
+	&nvme_nvm_attr_group,
+#endif
+	NULL,
+};
+
 #define nvme_show_str_function(field)						\
 static ssize_t  field##_show(struct device *dev,				\
 			    struct device_attribute *attr, char *buf)		\
@@ -3211,14 +3219,7 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 
 	nvme_get_ctrl(ctrl);
 
-	device_add_disk(ctrl->device, ns->disk, NULL);
-	if (sysfs_create_group(&disk_to_dev(ns->disk)->kobj,
-					&nvme_ns_id_attr_group))
-		pr_warn("%s: failed to create sysfs group for identification\n",
-			ns->disk->disk_name);
-	if (ns->ndev && nvme_nvm_register_sysfs(ns))
-		pr_warn("%s: failed to register lightnvm sysfs group for identification\n",
-			ns->disk->disk_name);
+	device_add_disk(ctrl->device, ns->disk, nvme_ns_id_attr_groups);
 
 	nvme_mpath_add_disk(ns, id);
 	nvme_fault_inject_init(ns);
@@ -3252,10 +3253,6 @@ static void nvme_ns_remove(struct nvme_ns *ns)
 	synchronize_srcu(&ns->head->srcu); /* wait for concurrent submissions */
 
 	if (ns->disk && ns->disk->flags & GENHD_FL_UP) {
-		sysfs_remove_group(&disk_to_dev(ns->disk)->kobj,
-					&nvme_ns_id_attr_group);
-		if (ns->ndev)
-			nvme_nvm_unregister_sysfs(ns);
 		del_gendisk(ns->disk);
 		blk_cleanup_queue(ns->queue);
 		if (blk_get_integrity(ns->disk))
diff --git a/drivers/nvme/host/lightnvm.c b/drivers/nvme/host/lightnvm.c
index a69553e75f38..d10257b9c523 100644
--- a/drivers/nvme/host/lightnvm.c
+++ b/drivers/nvme/host/lightnvm.c
@@ -1193,10 +1193,29 @@ static NVM_DEV_ATTR_12_RO(multiplane_modes);
 static NVM_DEV_ATTR_12_RO(media_capabilities);
 static NVM_DEV_ATTR_12_RO(max_phys_secs);
 
-static struct attribute *nvm_dev_attrs_12[] = {
+/* 2.0 values */
+static NVM_DEV_ATTR_20_RO(groups);
+static NVM_DEV_ATTR_20_RO(punits);
+static NVM_DEV_ATTR_20_RO(chunks);
+static NVM_DEV_ATTR_20_RO(clba);
+static NVM_DEV_ATTR_20_RO(ws_min);
+static NVM_DEV_ATTR_20_RO(ws_opt);
+static NVM_DEV_ATTR_20_RO(maxoc);
+static NVM_DEV_ATTR_20_RO(maxocpu);
+static NVM_DEV_ATTR_20_RO(mw_cunits);
+static NVM_DEV_ATTR_20_RO(write_typ);
+static NVM_DEV_ATTR_20_RO(write_max);
+static NVM_DEV_ATTR_20_RO(reset_typ);
+static NVM_DEV_ATTR_20_RO(reset_max);
+
+static struct attribute *nvm_dev_attrs[] = {
+	/* version agnostic attrs */
 	&dev_attr_version.attr,
 	&dev_attr_capabilities.attr,
+	&dev_attr_read_typ.attr,
+	&dev_attr_read_max.attr,
 
+	/* 1.2 attrs */
 	&dev_attr_vendor_opcode.attr,
 	&dev_attr_device_mode.attr,
 	&dev_attr_media_manager.attr,
@@ -1211,8 +1230,6 @@ static struct attribute *nvm_dev_attrs_12[] = {
 	&dev_attr_page_size.attr,
 	&dev_attr_hw_sector_size.attr,
 	&dev_attr_oob_sector_size.attr,
-	&dev_attr_read_typ.attr,
-	&dev_attr_read_max.attr,
 	&dev_attr_prog_typ.attr,
 	&dev_attr_prog_max.attr,
 	&dev_attr_erase_typ.attr,
@@ -1221,33 +1238,7 @@ static struct attribute *nvm_dev_attrs_12[] = {
 	&dev_attr_media_capabilities.attr,
 	&dev_attr_max_phys_secs.attr,
 
-	NULL,
-};
-
-static const struct attribute_group nvm_dev_attr_group_12 = {
-	.name		= "lightnvm",
-	.attrs		= nvm_dev_attrs_12,
-};
-
-/* 2.0 values */
-static NVM_DEV_ATTR_20_RO(groups);
-static NVM_DEV_ATTR_20_RO(punits);
-static NVM_DEV_ATTR_20_RO(chunks);
-static NVM_DEV_ATTR_20_RO(clba);
-static NVM_DEV_ATTR_20_RO(ws_min);
-static NVM_DEV_ATTR_20_RO(ws_opt);
-static NVM_DEV_ATTR_20_RO(maxoc);
-static NVM_DEV_ATTR_20_RO(maxocpu);
-static NVM_DEV_ATTR_20_RO(mw_cunits);
-static NVM_DEV_ATTR_20_RO(write_typ);
-static NVM_DEV_ATTR_20_RO(write_max);
-static NVM_DEV_ATTR_20_RO(reset_typ);
-static NVM_DEV_ATTR_20_RO(reset_max);
-
-static struct attribute *nvm_dev_attrs_20[] = {
-	&dev_attr_version.attr,
-	&dev_attr_capabilities.attr,
-
+	/* 2.0 attrs */
 	&dev_attr_groups.attr,
 	&dev_attr_punits.attr,
 	&dev_attr_chunks.attr,
@@ -1258,8 +1249,6 @@ static struct attribute *nvm_dev_attrs_20[] = {
 	&dev_attr_maxocpu.attr,
 	&dev_attr_mw_cunits.attr,
 
-	&dev_attr_read_typ.attr,
-	&dev_attr_read_max.attr,
 	&dev_attr_write_typ.attr,
 	&dev_attr_write_max.attr,
 	&dev_attr_reset_typ.attr,
@@ -1268,44 +1257,38 @@ static struct attribute *nvm_dev_attrs_20[] = {
 	NULL,
 };
 
-static const struct attribute_group nvm_dev_attr_group_20 = {
-	.name		= "lightnvm",
-	.attrs		= nvm_dev_attrs_20,
-};
-
-int nvme_nvm_register_sysfs(struct nvme_ns *ns)
+static umode_t nvm_dev_attrs_visible(struct kobject *kobj,
+				     struct attribute *attr, int index)
 {
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct gendisk *disk = dev_to_disk(dev);
+	struct nvme_ns *ns = disk->private_data;
 	struct nvm_dev *ndev = ns->ndev;
-	struct nvm_geo *geo = &ndev->geo;
+	struct device_attribute *dev_attr =
+		container_of(attr, typeof(*dev_attr), attr);
 
 	if (!ndev)
-		return -EINVAL;
-
-	switch (geo->major_ver_id) {
-	case 1:
-		return sysfs_create_group(&disk_to_dev(ns->disk)->kobj,
-					&nvm_dev_attr_group_12);
-	case 2:
-		return sysfs_create_group(&disk_to_dev(ns->disk)->kobj,
-					&nvm_dev_attr_group_20);
-	}
-
-	return -EINVAL;
-}
+		return 0;
 
-void nvme_nvm_unregister_sysfs(struct nvme_ns *ns)
-{
-	struct nvm_dev *ndev = ns->ndev;
-	struct nvm_geo *geo = &ndev->geo;
+	if (dev_attr->show == nvm_dev_attr_show)
+		return attr->mode;
 
-	switch (geo->major_ver_id) {
+	switch (ndev->geo.major_ver_id) {
 	case 1:
-		sysfs_remove_group(&disk_to_dev(ns->disk)->kobj,
-					&nvm_dev_attr_group_12);
+		if (dev_attr->show == nvm_dev_attr_show_12)
+			return attr->mode;
 		break;
 	case 2:
-		sysfs_remove_group(&disk_to_dev(ns->disk)->kobj,
-					&nvm_dev_attr_group_20);
+		if (dev_attr->show == nvm_dev_attr_show_20)
+			return attr->mode;
 		break;
 	}
+
+	return 0;
 }
+
+const struct attribute_group nvme_nvm_attr_group = {
+	.name		= "lightnvm",
+	.attrs		= nvm_dev_attrs,
+	.is_visible	= nvm_dev_attrs_visible,
+};
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index ee9e092ace4a..4ef05fe00dac 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -313,13 +313,9 @@ static void nvme_mpath_set_live(struct nvme_ns *ns)
 	if (!head->disk)
 		return;
 
-	if (!(head->disk->flags & GENHD_FL_UP)) {
-		device_add_disk(&head->subsys->dev, head->disk, NULL);
-		if (sysfs_create_group(&disk_to_dev(head->disk)->kobj,
-				&nvme_ns_id_attr_group))
-			dev_warn(&head->subsys->dev,
-				 "failed to create id group.\n");
-	}
+	if (!(head->disk->flags & GENHD_FL_UP))
+		device_add_disk(&head->subsys->dev, head->disk,
+				nvme_ns_id_attr_groups);
 
 	synchronize_srcu(&ns->head->srcu);
 	kblockd_schedule_work(&ns->head->requeue_work);
@@ -541,11 +537,8 @@ void nvme_mpath_remove_disk(struct nvme_ns_head *head)
 {
 	if (!head->disk)
 		return;
-	if (head->disk->flags & GENHD_FL_UP) {
-		sysfs_remove_group(&disk_to_dev(head->disk)->kobj,
-				   &nvme_ns_id_attr_group);
+	if (head->disk->flags & GENHD_FL_UP)
 		del_gendisk(head->disk);
-	}
 	blk_set_queue_dying(head->disk->queue);
 	/* make sure all pending bios are cleaned up */
 	kblockd_schedule_work(&head->requeue_work);
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 9c2e7a151e40..276975506709 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -464,7 +464,7 @@ int nvme_delete_ctrl_sync(struct nvme_ctrl *ctrl);
 int nvme_get_log(struct nvme_ctrl *ctrl, u32 nsid, u8 log_page, u8 lsp,
 		void *log, size_t size, u64 offset);
 
-extern const struct attribute_group nvme_ns_id_attr_group;
+extern const struct attribute_group *nvme_ns_id_attr_groups[];
 extern const struct block_device_operations nvme_ns_head_ops;
 
 #ifdef CONFIG_NVME_MULTIPATH
@@ -589,8 +589,7 @@ static inline void nvme_mpath_update_disk_size(struct gendisk *disk)
 void nvme_nvm_update_nvm_info(struct nvme_ns *ns);
 int nvme_nvm_register(struct nvme_ns *ns, char *disk_name, int node);
 void nvme_nvm_unregister(struct nvme_ns *ns);
-int nvme_nvm_register_sysfs(struct nvme_ns *ns);
-void nvme_nvm_unregister_sysfs(struct nvme_ns *ns);
+extern const struct attribute_group nvme_nvm_attr_group;
 int nvme_nvm_ioctl(struct nvme_ns *ns, unsigned int cmd, unsigned long arg);
 #else
 static inline void nvme_nvm_update_nvm_info(struct nvme_ns *ns) {};
@@ -601,11 +600,6 @@ static inline int nvme_nvm_register(struct nvme_ns *ns, char *disk_name,
 }
 
 static inline void nvme_nvm_unregister(struct nvme_ns *ns) {};
-static inline int nvme_nvm_register_sysfs(struct nvme_ns *ns)
-{
-	return 0;
-}
-static inline void nvme_nvm_unregister_sysfs(struct nvme_ns *ns) {};
 static inline int nvme_nvm_ioctl(struct nvme_ns *ns, unsigned int cmd,
 							unsigned long arg)
 {
-- 
2.27.0

