Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6C7382FD3
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239527AbhEQOVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:21:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237315AbhEQOTA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:19:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FA33613AE;
        Mon, 17 May 2021 14:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260647;
        bh=/7kl0Aw2AdeBhoA2dAW4/dxNm4c+PZhtISExl3+KLhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jSzDDH6h2SonCD46NflG7ebiWG0ww31/XmpRQ+rxKMUBbcGLXYPfckIRqrYPKEPYI
         CcFOa5jZDjwtnlnoug9B3djp99lFUrGpUMq3q5J+AL0p1qogKmObzrwyayWllQ86Eu
         SnSs6Lc1gD+0Vfmdai2S8ZzzcU8UAWqLVor+iGSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 175/363] dmaengine: idxd: fix engine conf_dev lifetime
Date:   Mon, 17 May 2021 16:00:41 +0200
Message-Id: <20210517140308.518429211@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 75b911309060f42ba94bbbf46f5f497d35d5cd02 ]

Remove devm_* allocation and fix engine->conf_dev 'struct device'
lifetime. Address issues flagged by CONFIG_DEBUG_KOBJECT_RELEASE.
Add release functions in order to free the allocated memory at the
engine conf_dev destruction time.

Reported-by: Jason Gunthorpe <jgg@nvidia.com>
Fixes: bfe1d56091c1 ("dmaengine: idxd: Init and probe for Intel data accelerators")
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/161852986460.2203940.16603218225412118431.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c |  2 +-
 drivers/dma/idxd/idxd.h   |  3 +-
 drivers/dma/idxd/init.c   | 60 +++++++++++++++++++++++++-------
 drivers/dma/idxd/sysfs.c  | 72 +++++++++++++++++++--------------------
 4 files changed, 86 insertions(+), 51 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index c4183294a704..be1dcddfe3c4 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -786,7 +786,7 @@ static int idxd_engines_setup(struct idxd_device *idxd)
 	}
 
 	for (i = 0; i < idxd->max_engines; i++) {
-		eng = &idxd->engines[i];
+		eng = idxd->engines[i];
 		group = eng->group;
 
 		if (!group)
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 6cade6a05314..b9b7e8e8c384 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -195,7 +195,7 @@ struct idxd_device {
 	struct completion *cmd_done;
 	struct idxd_group *groups;
 	struct idxd_wq **wqs;
-	struct idxd_engine *engines;
+	struct idxd_engine **engines;
 
 	struct iommu_sva *sva;
 	unsigned int pasid;
@@ -259,6 +259,7 @@ extern bool support_enqcmd;
 extern struct device_type dsa_device_type;
 extern struct device_type iax_device_type;
 extern struct device_type idxd_wq_device_type;
+extern struct device_type idxd_engine_device_type;
 
 static inline bool is_dsa_dev(struct device *dev)
 {
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index a2dca27aebc3..b90ef2f519eb 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -196,6 +196,46 @@ static int idxd_setup_wqs(struct idxd_device *idxd)
 	return rc;
 }
 
+static int idxd_setup_engines(struct idxd_device *idxd)
+{
+	struct idxd_engine *engine;
+	struct device *dev = &idxd->pdev->dev;
+	int i, rc;
+
+	idxd->engines = kcalloc_node(idxd->max_engines, sizeof(struct idxd_engine *),
+				     GFP_KERNEL, dev_to_node(dev));
+	if (!idxd->engines)
+		return -ENOMEM;
+
+	for (i = 0; i < idxd->max_engines; i++) {
+		engine = kzalloc_node(sizeof(*engine), GFP_KERNEL, dev_to_node(dev));
+		if (!engine) {
+			rc = -ENOMEM;
+			goto err;
+		}
+
+		engine->id = i;
+		engine->idxd = idxd;
+		device_initialize(&engine->conf_dev);
+		engine->conf_dev.parent = &idxd->conf_dev;
+		engine->conf_dev.type = &idxd_engine_device_type;
+		rc = dev_set_name(&engine->conf_dev, "engine%d.%d", idxd->id, engine->id);
+		if (rc < 0) {
+			put_device(&engine->conf_dev);
+			goto err;
+		}
+
+		idxd->engines[i] = engine;
+	}
+
+	return 0;
+
+ err:
+	while (--i >= 0)
+		put_device(&idxd->engines[i]->conf_dev);
+	return rc;
+}
+
 static int idxd_setup_internals(struct idxd_device *idxd)
 {
 	struct device *dev = &idxd->pdev->dev;
@@ -207,6 +247,10 @@ static int idxd_setup_internals(struct idxd_device *idxd)
 	if (rc < 0)
 		return rc;
 
+	rc = idxd_setup_engines(idxd);
+	if (rc < 0)
+		goto err_engine;
+
 	idxd->groups = devm_kcalloc(dev, idxd->max_groups,
 				    sizeof(struct idxd_group), GFP_KERNEL);
 	if (!idxd->groups) {
@@ -221,19 +265,6 @@ static int idxd_setup_internals(struct idxd_device *idxd)
 		idxd->groups[i].tc_b = -1;
 	}
 
-	idxd->engines = devm_kcalloc(dev, idxd->max_engines,
-				     sizeof(struct idxd_engine), GFP_KERNEL);
-	if (!idxd->engines) {
-		rc = -ENOMEM;
-		goto err;
-	}
-
-
-	for (i = 0; i < idxd->max_engines; i++) {
-		idxd->engines[i].idxd = idxd;
-		idxd->engines[i].id = i;
-	}
-
 	idxd->wq = create_workqueue(dev_name(dev));
 	if (!idxd->wq) {
 		rc = -ENOMEM;
@@ -243,6 +274,9 @@ static int idxd_setup_internals(struct idxd_device *idxd)
 	return 0;
 
  err:
+	for (i = 0; i < idxd->max_engines; i++)
+		put_device(&idxd->engines[i]->conf_dev);
+ err_engine:
 	for (i = 0; i < idxd->max_wqs; i++)
 		put_device(&idxd->wqs[i]->conf_dev);
 	return rc;
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 409b3ce52f07..ab02e3b4d75d 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -26,11 +26,6 @@ static struct device_type idxd_group_device_type = {
 	.release = idxd_conf_sub_device_release,
 };
 
-static struct device_type idxd_engine_device_type = {
-	.name = "engine",
-	.release = idxd_conf_sub_device_release,
-};
-
 static int idxd_config_bus_match(struct device *dev,
 				 struct device_driver *drv)
 {
@@ -464,6 +459,19 @@ static const struct attribute_group *idxd_engine_attribute_groups[] = {
 	NULL,
 };
 
+static void idxd_conf_engine_release(struct device *dev)
+{
+	struct idxd_engine *engine = container_of(dev, struct idxd_engine, conf_dev);
+
+	kfree(engine);
+}
+
+struct device_type idxd_engine_device_type = {
+	.name = "engine",
+	.release = idxd_conf_engine_release,
+	.groups = idxd_engine_attribute_groups,
+};
+
 /* Group attributes */
 
 static void idxd_set_free_tokens(struct idxd_device *idxd)
@@ -626,7 +634,7 @@ static ssize_t group_engines_show(struct device *dev,
 	struct idxd_device *idxd = group->idxd;
 
 	for (i = 0; i < idxd->max_engines; i++) {
-		struct idxd_engine *engine = &idxd->engines[i];
+		struct idxd_engine *engine = idxd->engines[i];
 
 		if (!engine->group)
 			continue;
@@ -1634,37 +1642,27 @@ struct device_type iax_device_type = {
 	.groups = idxd_attribute_groups,
 };
 
-static int idxd_setup_engine_sysfs(struct idxd_device *idxd)
+static int idxd_register_engine_devices(struct idxd_device *idxd)
 {
-	struct device *dev = &idxd->pdev->dev;
-	int i, rc;
+	int i, j, rc;
 
 	for (i = 0; i < idxd->max_engines; i++) {
-		struct idxd_engine *engine = &idxd->engines[i];
-
-		engine->conf_dev.parent = &idxd->conf_dev;
-		dev_set_name(&engine->conf_dev, "engine%d.%d",
-			     idxd->id, engine->id);
-		engine->conf_dev.bus = idxd_get_bus_type(idxd);
-		engine->conf_dev.groups = idxd_engine_attribute_groups;
-		engine->conf_dev.type = &idxd_engine_device_type;
-		dev_dbg(dev, "Engine device register: %s\n",
-			dev_name(&engine->conf_dev));
-		rc = device_register(&engine->conf_dev);
-		if (rc < 0) {
-			put_device(&engine->conf_dev);
+		struct idxd_engine *engine = idxd->engines[i];
+
+		rc = device_add(&engine->conf_dev);
+		if (rc < 0)
 			goto cleanup;
-		}
 	}
 
 	return 0;
 
 cleanup:
-	while (i--) {
-		struct idxd_engine *engine = &idxd->engines[i];
+	j = i - 1;
+	for (; i < idxd->max_engines; i++)
+		put_device(&idxd->engines[i]->conf_dev);
 
-		device_unregister(&engine->conf_dev);
-	}
+	while (j--)
+		device_unregister(&idxd->engines[j]->conf_dev);
 	return rc;
 }
 
@@ -1741,23 +1739,25 @@ int idxd_register_devices(struct idxd_device *idxd)
 		goto err_wq;
 	}
 
-	rc = idxd_setup_group_sysfs(idxd);
+	rc = idxd_register_engine_devices(idxd);
 	if (rc < 0) {
-		/* unregister conf dev */
-		dev_dbg(dev, "Group sysfs registering failed: %d\n", rc);
-		goto err;
+		dev_dbg(dev, "Engine devices registering failed: %d\n", rc);
+		goto err_engine;
 	}
 
-	rc = idxd_setup_engine_sysfs(idxd);
+	rc = idxd_setup_group_sysfs(idxd);
 	if (rc < 0) {
 		/* unregister conf dev */
-		dev_dbg(dev, "Engine sysfs registering failed: %d\n", rc);
-		goto err;
+		dev_dbg(dev, "Group sysfs registering failed: %d\n", rc);
+		goto err_group;
 	}
 
 	return 0;
 
- err:
+ err_group:
+	for (i = 0; i < idxd->max_engines; i++)
+		device_unregister(&idxd->engines[i]->conf_dev);
+ err_engine:
 	for (i = 0; i < idxd->max_wqs; i++)
 		device_unregister(&idxd->wqs[i]->conf_dev);
  err_wq:
@@ -1776,7 +1776,7 @@ void idxd_unregister_devices(struct idxd_device *idxd)
 	}
 
 	for (i = 0; i < idxd->max_engines; i++) {
-		struct idxd_engine *engine = &idxd->engines[i];
+		struct idxd_engine *engine = idxd->engines[i];
 
 		device_unregister(&engine->conf_dev);
 	}
-- 
2.30.2



