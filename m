Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3535A38349C
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241884AbhEQPKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:10:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242777AbhEQPIH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:08:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EEF761C33;
        Mon, 17 May 2021 14:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261781;
        bh=Gx1LBnnPj0pr9o94Sst8k615WiFe2p61ZOmm8tYhXU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rS4mSEYhf4mvqHY6Hw9vPyLzaeyUoj7prqDGGsJhTa/lZQCYSoAKKGCHLD3wTvbQO
         D7fRy0Zbvy42om3WnzC5PqSLH4+/3lWLCBzl1VbhbjfZyPJuMRp9m0/usFnJ0W7+Q6
         UJMQNbUEAg4irHIujbAYMmYW+OTv1Qk4ZXlTkdrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 163/329] dmaengine: idxd: fix group conf_dev lifetime
Date:   Mon, 17 May 2021 16:01:14 +0200
Message-Id: <20210517140307.660102314@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit defe49f96012ca91e8e673cb95b5c30b4a3735e8 ]

Remove devm_* allocation and fix group->conf_dev 'struct device'
lifetime. Address issues flagged by CONFIG_DEBUG_KOBJECT_RELEASE.
Add release functions in order to free the allocated memory at the
group->conf_dev destruction time.

Reported-by: Jason Gunthorpe <jgg@nvidia.com>
Fixes: bfe1d56091c1 ("dmaengine: idxd: Init and probe for Intel data accelerators")
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/161852987144.2203940.8830315575880047.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c |  8 ++---
 drivers/dma/idxd/idxd.h   |  3 +-
 drivers/dma/idxd/init.c   | 68 ++++++++++++++++++++++++++++++---------
 drivers/dma/idxd/sysfs.c  | 68 +++++++++++++++++----------------------
 4 files changed, 88 insertions(+), 59 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index be1dcddfe3c4..4fef57717049 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -659,7 +659,7 @@ static int idxd_groups_config_write(struct idxd_device *idxd)
 		ioread32(idxd->reg_base + IDXD_GENCFG_OFFSET));
 
 	for (i = 0; i < idxd->max_groups; i++) {
-		struct idxd_group *group = &idxd->groups[i];
+		struct idxd_group *group = idxd->groups[i];
 
 		idxd_group_config_write(group);
 	}
@@ -754,7 +754,7 @@ static void idxd_group_flags_setup(struct idxd_device *idxd)
 
 	/* TC-A 0 and TC-B 1 should be defaults */
 	for (i = 0; i < idxd->max_groups; i++) {
-		struct idxd_group *group = &idxd->groups[i];
+		struct idxd_group *group = idxd->groups[i];
 
 		if (group->tc_a == -1)
 			group->tc_a = group->grpcfg.flags.tc_a = 0;
@@ -781,7 +781,7 @@ static int idxd_engines_setup(struct idxd_device *idxd)
 	struct idxd_group *group;
 
 	for (i = 0; i < idxd->max_groups; i++) {
-		group = &idxd->groups[i];
+		group = idxd->groups[i];
 		group->grpcfg.engines = 0;
 	}
 
@@ -810,7 +810,7 @@ static int idxd_wqs_setup(struct idxd_device *idxd)
 	struct device *dev = &idxd->pdev->dev;
 
 	for (i = 0; i < idxd->max_groups; i++) {
-		group = &idxd->groups[i];
+		group = idxd->groups[i];
 		for (j = 0; j < 4; j++)
 			group->grpcfg.wqs[j] = 0;
 	}
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index b9b7e8e8c384..3c4ce7997c88 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -193,7 +193,7 @@ struct idxd_device {
 
 	spinlock_t dev_lock;	/* spinlock for device */
 	struct completion *cmd_done;
-	struct idxd_group *groups;
+	struct idxd_group **groups;
 	struct idxd_wq **wqs;
 	struct idxd_engine **engines;
 
@@ -260,6 +260,7 @@ extern struct device_type dsa_device_type;
 extern struct device_type iax_device_type;
 extern struct device_type idxd_wq_device_type;
 extern struct device_type idxd_engine_device_type;
+extern struct device_type idxd_group_device_type;
 
 static inline bool is_dsa_dev(struct device *dev)
 {
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 68b58869b0cc..25d801916aec 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -232,11 +232,54 @@ static int idxd_setup_engines(struct idxd_device *idxd)
 	return rc;
 }
 
-static int idxd_setup_internals(struct idxd_device *idxd)
+static int idxd_setup_groups(struct idxd_device *idxd)
 {
 	struct device *dev = &idxd->pdev->dev;
+	struct idxd_group *group;
 	int i, rc;
 
+	idxd->groups = kcalloc_node(idxd->max_groups, sizeof(struct idxd_group *),
+				    GFP_KERNEL, dev_to_node(dev));
+	if (!idxd->groups)
+		return -ENOMEM;
+
+	for (i = 0; i < idxd->max_groups; i++) {
+		group = kzalloc_node(sizeof(*group), GFP_KERNEL, dev_to_node(dev));
+		if (!group) {
+			rc = -ENOMEM;
+			goto err;
+		}
+
+		group->id = i;
+		group->idxd = idxd;
+		device_initialize(&group->conf_dev);
+		group->conf_dev.parent = &idxd->conf_dev;
+		group->conf_dev.bus = idxd_get_bus_type(idxd);
+		group->conf_dev.type = &idxd_group_device_type;
+		rc = dev_set_name(&group->conf_dev, "group%d.%d", idxd->id, group->id);
+		if (rc < 0) {
+			put_device(&group->conf_dev);
+			goto err;
+		}
+
+		idxd->groups[i] = group;
+		group->tc_a = -1;
+		group->tc_b = -1;
+	}
+
+	return 0;
+
+ err:
+	while (--i >= 0)
+		put_device(&idxd->groups[i]->conf_dev);
+	return rc;
+}
+
+static int idxd_setup_internals(struct idxd_device *idxd)
+{
+	struct device *dev = &idxd->pdev->dev;
+	int rc, i;
+
 	init_waitqueue_head(&idxd->cmd_waitq);
 
 	rc = idxd_setup_wqs(idxd);
@@ -247,29 +290,22 @@ static int idxd_setup_internals(struct idxd_device *idxd)
 	if (rc < 0)
 		goto err_engine;
 
-	idxd->groups = devm_kcalloc(dev, idxd->max_groups,
-				    sizeof(struct idxd_group), GFP_KERNEL);
-	if (!idxd->groups) {
-		rc = -ENOMEM;
-		goto err;
-	}
-
-	for (i = 0; i < idxd->max_groups; i++) {
-		idxd->groups[i].idxd = idxd;
-		idxd->groups[i].id = i;
-		idxd->groups[i].tc_a = -1;
-		idxd->groups[i].tc_b = -1;
-	}
+	rc = idxd_setup_groups(idxd);
+	if (rc < 0)
+		goto err_group;
 
 	idxd->wq = create_workqueue(dev_name(dev));
 	if (!idxd->wq) {
 		rc = -ENOMEM;
-		goto err;
+		goto err_wkq_create;
 	}
 
 	return 0;
 
- err:
+ err_wkq_create:
+	for (i = 0; i < idxd->max_groups; i++)
+		put_device(&idxd->groups[i]->conf_dev);
+ err_group:
 	for (i = 0; i < idxd->max_engines; i++)
 		put_device(&idxd->engines[i]->conf_dev);
  err_engine:
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index ab02e3b4d75d..f793688039c9 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -16,16 +16,6 @@ static char *idxd_wq_type_names[] = {
 	[IDXD_WQT_USER]		= "user",
 };
 
-static void idxd_conf_sub_device_release(struct device *dev)
-{
-	dev_dbg(dev, "%s for %s\n", __func__, dev_name(dev));
-}
-
-static struct device_type idxd_group_device_type = {
-	.name = "group",
-	.release = idxd_conf_sub_device_release,
-};
-
 static int idxd_config_bus_match(struct device *dev,
 				 struct device_driver *drv)
 {
@@ -435,7 +425,7 @@ static ssize_t engine_group_id_store(struct device *dev,
 
 	if (prevg)
 		prevg->num_engines--;
-	engine->group = &idxd->groups[id];
+	engine->group = idxd->groups[id];
 	engine->group->num_engines++;
 
 	return count;
@@ -479,7 +469,7 @@ static void idxd_set_free_tokens(struct idxd_device *idxd)
 	int i, tokens;
 
 	for (i = 0, tokens = 0; i < idxd->max_groups; i++) {
-		struct idxd_group *g = &idxd->groups[i];
+		struct idxd_group *g = idxd->groups[i];
 
 		tokens += g->tokens_reserved;
 	}
@@ -784,6 +774,19 @@ static const struct attribute_group *idxd_group_attribute_groups[] = {
 	NULL,
 };
 
+static void idxd_conf_group_release(struct device *dev)
+{
+	struct idxd_group *group = container_of(dev, struct idxd_group, conf_dev);
+
+	kfree(group);
+}
+
+struct device_type idxd_group_device_type = {
+	.name = "group",
+	.release = idxd_conf_group_release,
+	.groups = idxd_group_attribute_groups,
+};
+
 /* IDXD work queue attribs */
 static ssize_t wq_clients_show(struct device *dev,
 			       struct device_attribute *attr, char *buf)
@@ -856,7 +859,7 @@ static ssize_t wq_group_id_store(struct device *dev,
 		return count;
 	}
 
-	group = &idxd->groups[id];
+	group = idxd->groups[id];
 	prevg = wq->group;
 
 	if (prevg)
@@ -1666,37 +1669,27 @@ cleanup:
 	return rc;
 }
 
-static int idxd_setup_group_sysfs(struct idxd_device *idxd)
+static int idxd_register_group_devices(struct idxd_device *idxd)
 {
-	struct device *dev = &idxd->pdev->dev;
-	int i, rc;
+	int i, j, rc;
 
 	for (i = 0; i < idxd->max_groups; i++) {
-		struct idxd_group *group = &idxd->groups[i];
-
-		group->conf_dev.parent = &idxd->conf_dev;
-		dev_set_name(&group->conf_dev, "group%d.%d",
-			     idxd->id, group->id);
-		group->conf_dev.bus = idxd_get_bus_type(idxd);
-		group->conf_dev.groups = idxd_group_attribute_groups;
-		group->conf_dev.type = &idxd_group_device_type;
-		dev_dbg(dev, "Group device register: %s\n",
-			dev_name(&group->conf_dev));
-		rc = device_register(&group->conf_dev);
-		if (rc < 0) {
-			put_device(&group->conf_dev);
+		struct idxd_group *group = idxd->groups[i];
+
+		rc = device_add(&group->conf_dev);
+		if (rc < 0)
 			goto cleanup;
-		}
 	}
 
 	return 0;
 
 cleanup:
-	while (i--) {
-		struct idxd_group *group = &idxd->groups[i];
+	j = i - 1;
+	for (; i < idxd->max_groups; i++)
+		put_device(&idxd->groups[i]->conf_dev);
 
-		device_unregister(&group->conf_dev);
-	}
+	while (j--)
+		device_unregister(&idxd->groups[j]->conf_dev);
 	return rc;
 }
 
@@ -1745,10 +1738,9 @@ int idxd_register_devices(struct idxd_device *idxd)
 		goto err_engine;
 	}
 
-	rc = idxd_setup_group_sysfs(idxd);
+	rc = idxd_register_group_devices(idxd);
 	if (rc < 0) {
-		/* unregister conf dev */
-		dev_dbg(dev, "Group sysfs registering failed: %d\n", rc);
+		dev_dbg(dev, "Group device registering failed: %d\n", rc);
 		goto err_group;
 	}
 
@@ -1782,7 +1774,7 @@ void idxd_unregister_devices(struct idxd_device *idxd)
 	}
 
 	for (i = 0; i < idxd->max_groups; i++) {
-		struct idxd_group *group = &idxd->groups[i];
+		struct idxd_group *group = idxd->groups[i];
 
 		device_unregister(&group->conf_dev);
 	}
-- 
2.30.2



