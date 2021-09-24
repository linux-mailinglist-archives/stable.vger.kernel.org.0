Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6AE4173BF
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345857AbhIXM7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:59:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345550AbhIXM6c (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:58:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CA9E613A5;
        Fri, 24 Sep 2021 12:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487956;
        bh=3UNzu6kqhalW1RuVHQuFhuGHT4cvWQon7tc9wF8OoyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xEtFCzpVX437WHstkGukJyRwx34vsF8nzn5oLl5DQbh2VU0SI3UfuJh6B5/qFmbYF
         fYVKVkGViD2aG+8RJwMgwhUb7yRzi061oQONUnYWRH6p3TFgh7kWMnpX4mosKQT8dX
         k3V7UhTPsypK8JdBBQ9BoVN/Be7k5N2AksEglUwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 027/100] dmanegine: idxd: cleanup all device related bits after disabling device
Date:   Fri, 24 Sep 2021 14:43:36 +0200
Message-Id: <20210924124342.363213343@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 0dcfe41e9a4ca759ccc87a48e3bb9cc3b08ff1e8 ]

The previous state cleanup patch only performed wq state cleanups. This
does not go far enough as when device is disabled or reset, the state
for groups and engines must also be cleaned up. Add additional state
cleanup beyond wq cleanup. Tie those cleanups directly to device
disable and reset, and wq disable and reset.

Fixes: da32b28c95a7 ("dmaengine: idxd: cleanup workqueue config after disabling")
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/162285154108.2096632.5572805472362321307.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c | 88 +++++++++++++++++++++++++++++----------
 drivers/dma/idxd/idxd.h   |  6 +--
 drivers/dma/idxd/irq.c    |  4 +-
 drivers/dma/idxd/sysfs.c  | 22 +++-------
 4 files changed, 74 insertions(+), 46 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 420b93fe5feb..928c2c8817f0 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -15,6 +15,8 @@
 
 static void idxd_cmd_exec(struct idxd_device *idxd, int cmd_code, u32 operand,
 			  u32 *status);
+static void idxd_device_wqs_clear_state(struct idxd_device *idxd);
+static void idxd_wq_disable_cleanup(struct idxd_wq *wq);
 
 /* Interrupt control bits */
 void idxd_mask_msix_vector(struct idxd_device *idxd, int vec_id)
@@ -234,7 +236,7 @@ int idxd_wq_enable(struct idxd_wq *wq)
 	return 0;
 }
 
-int idxd_wq_disable(struct idxd_wq *wq)
+int idxd_wq_disable(struct idxd_wq *wq, bool reset_config)
 {
 	struct idxd_device *idxd = wq->idxd;
 	struct device *dev = &idxd->pdev->dev;
@@ -255,6 +257,8 @@ int idxd_wq_disable(struct idxd_wq *wq)
 		return -ENXIO;
 	}
 
+	if (reset_config)
+		idxd_wq_disable_cleanup(wq);
 	wq->state = IDXD_WQ_DISABLED;
 	dev_dbg(dev, "WQ %d disabled\n", wq->id);
 	return 0;
@@ -289,6 +293,7 @@ void idxd_wq_reset(struct idxd_wq *wq)
 
 	operand = BIT(wq->id % 16) | ((wq->id / 16) << 16);
 	idxd_cmd_exec(idxd, IDXD_CMD_RESET_WQ, operand, NULL);
+	idxd_wq_disable_cleanup(wq);
 	wq->state = IDXD_WQ_DISABLED;
 }
 
@@ -337,7 +342,7 @@ int idxd_wq_set_pasid(struct idxd_wq *wq, int pasid)
 	unsigned int offset;
 	unsigned long flags;
 
-	rc = idxd_wq_disable(wq);
+	rc = idxd_wq_disable(wq, false);
 	if (rc < 0)
 		return rc;
 
@@ -364,7 +369,7 @@ int idxd_wq_disable_pasid(struct idxd_wq *wq)
 	unsigned int offset;
 	unsigned long flags;
 
-	rc = idxd_wq_disable(wq);
+	rc = idxd_wq_disable(wq, false);
 	if (rc < 0)
 		return rc;
 
@@ -383,11 +388,11 @@ int idxd_wq_disable_pasid(struct idxd_wq *wq)
 	return 0;
 }
 
-void idxd_wq_disable_cleanup(struct idxd_wq *wq)
+static void idxd_wq_disable_cleanup(struct idxd_wq *wq)
 {
 	struct idxd_device *idxd = wq->idxd;
 
-	lockdep_assert_held(&idxd->dev_lock);
+	lockdep_assert_held(&wq->wq_lock);
 	memset(wq->wqcfg, 0, idxd->wqcfg_size);
 	wq->type = IDXD_WQT_NONE;
 	wq->size = 0;
@@ -548,22 +553,6 @@ int idxd_device_enable(struct idxd_device *idxd)
 	return 0;
 }
 
-void idxd_device_wqs_clear_state(struct idxd_device *idxd)
-{
-	int i;
-
-	lockdep_assert_held(&idxd->dev_lock);
-
-	for (i = 0; i < idxd->max_wqs; i++) {
-		struct idxd_wq *wq = idxd->wqs[i];
-
-		if (wq->state == IDXD_WQ_ENABLED) {
-			idxd_wq_disable_cleanup(wq);
-			wq->state = IDXD_WQ_DISABLED;
-		}
-	}
-}
-
 int idxd_device_disable(struct idxd_device *idxd)
 {
 	struct device *dev = &idxd->pdev->dev;
@@ -585,7 +574,7 @@ int idxd_device_disable(struct idxd_device *idxd)
 	}
 
 	spin_lock_irqsave(&idxd->dev_lock, flags);
-	idxd_device_wqs_clear_state(idxd);
+	idxd_device_clear_state(idxd);
 	idxd->state = IDXD_DEV_CONF_READY;
 	spin_unlock_irqrestore(&idxd->dev_lock, flags);
 	return 0;
@@ -597,7 +586,7 @@ void idxd_device_reset(struct idxd_device *idxd)
 
 	idxd_cmd_exec(idxd, IDXD_CMD_RESET_DEVICE, 0, NULL);
 	spin_lock_irqsave(&idxd->dev_lock, flags);
-	idxd_device_wqs_clear_state(idxd);
+	idxd_device_clear_state(idxd);
 	idxd->state = IDXD_DEV_CONF_READY;
 	spin_unlock_irqrestore(&idxd->dev_lock, flags);
 }
@@ -685,6 +674,59 @@ int idxd_device_release_int_handle(struct idxd_device *idxd, int handle,
 }
 
 /* Device configuration bits */
+static void idxd_engines_clear_state(struct idxd_device *idxd)
+{
+	struct idxd_engine *engine;
+	int i;
+
+	lockdep_assert_held(&idxd->dev_lock);
+	for (i = 0; i < idxd->max_engines; i++) {
+		engine = idxd->engines[i];
+		engine->group = NULL;
+	}
+}
+
+static void idxd_groups_clear_state(struct idxd_device *idxd)
+{
+	struct idxd_group *group;
+	int i;
+
+	lockdep_assert_held(&idxd->dev_lock);
+	for (i = 0; i < idxd->max_groups; i++) {
+		group = idxd->groups[i];
+		memset(&group->grpcfg, 0, sizeof(group->grpcfg));
+		group->num_engines = 0;
+		group->num_wqs = 0;
+		group->use_token_limit = false;
+		group->tokens_allowed = 0;
+		group->tokens_reserved = 0;
+		group->tc_a = -1;
+		group->tc_b = -1;
+	}
+}
+
+static void idxd_device_wqs_clear_state(struct idxd_device *idxd)
+{
+	int i;
+
+	lockdep_assert_held(&idxd->dev_lock);
+	for (i = 0; i < idxd->max_wqs; i++) {
+		struct idxd_wq *wq = idxd->wqs[i];
+
+		if (wq->state == IDXD_WQ_ENABLED) {
+			idxd_wq_disable_cleanup(wq);
+			wq->state = IDXD_WQ_DISABLED;
+		}
+	}
+}
+
+void idxd_device_clear_state(struct idxd_device *idxd)
+{
+	idxd_groups_clear_state(idxd);
+	idxd_engines_clear_state(idxd);
+	idxd_device_wqs_clear_state(idxd);
+}
+
 void idxd_msix_perm_setup(struct idxd_device *idxd)
 {
 	union msix_perm mperm;
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index fc708be7ad9a..0f27374eae4b 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -428,9 +428,8 @@ int idxd_device_init_reset(struct idxd_device *idxd);
 int idxd_device_enable(struct idxd_device *idxd);
 int idxd_device_disable(struct idxd_device *idxd);
 void idxd_device_reset(struct idxd_device *idxd);
-void idxd_device_cleanup(struct idxd_device *idxd);
+void idxd_device_clear_state(struct idxd_device *idxd);
 int idxd_device_config(struct idxd_device *idxd);
-void idxd_device_wqs_clear_state(struct idxd_device *idxd);
 void idxd_device_drain_pasid(struct idxd_device *idxd, int pasid);
 int idxd_device_load_config(struct idxd_device *idxd);
 int idxd_device_request_int_handle(struct idxd_device *idxd, int idx, int *handle,
@@ -443,12 +442,11 @@ void idxd_wqs_unmap_portal(struct idxd_device *idxd);
 int idxd_wq_alloc_resources(struct idxd_wq *wq);
 void idxd_wq_free_resources(struct idxd_wq *wq);
 int idxd_wq_enable(struct idxd_wq *wq);
-int idxd_wq_disable(struct idxd_wq *wq);
+int idxd_wq_disable(struct idxd_wq *wq, bool reset_config);
 void idxd_wq_drain(struct idxd_wq *wq);
 void idxd_wq_reset(struct idxd_wq *wq);
 int idxd_wq_map_portal(struct idxd_wq *wq);
 void idxd_wq_unmap_portal(struct idxd_wq *wq);
-void idxd_wq_disable_cleanup(struct idxd_wq *wq);
 int idxd_wq_set_pasid(struct idxd_wq *wq, int pasid);
 int idxd_wq_disable_pasid(struct idxd_wq *wq);
 void idxd_wq_quiesce(struct idxd_wq *wq);
diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index 4e3a7198c0ca..2924819ca8f3 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -59,7 +59,7 @@ static void idxd_device_reinit(struct work_struct *work)
 	return;
 
  out:
-	idxd_device_wqs_clear_state(idxd);
+	idxd_device_clear_state(idxd);
 }
 
 static void idxd_device_fault_work(struct work_struct *work)
@@ -192,7 +192,7 @@ static int process_misc_interrupts(struct idxd_device *idxd, u32 cause)
 			spin_lock_bh(&idxd->dev_lock);
 			idxd_wqs_quiesce(idxd);
 			idxd_wqs_unmap_portal(idxd);
-			idxd_device_wqs_clear_state(idxd);
+			idxd_device_clear_state(idxd);
 			dev_err(&idxd->pdev->dev,
 				"idxd halted, need %s.\n",
 				gensts.reset_type == IDXD_DEVICE_RESET_FLR ?
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index bb4df63906a7..528cde54724b 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -129,7 +129,7 @@ static int enable_wq(struct idxd_wq *wq)
 	rc = idxd_wq_map_portal(wq);
 	if (rc < 0) {
 		dev_warn(dev, "wq portal mapping failed: %d\n", rc);
-		rc = idxd_wq_disable(wq);
+		rc = idxd_wq_disable(wq, false);
 		if (rc < 0)
 			dev_warn(dev, "IDXD wq disable failed\n");
 		mutex_unlock(&wq->wq_lock);
@@ -262,8 +262,6 @@ static void disable_wq(struct idxd_wq *wq)
 
 static int idxd_config_bus_remove(struct device *dev)
 {
-	int rc;
-
 	dev_dbg(dev, "%s called for %s\n", __func__, dev_name(dev));
 
 	/* disable workqueue here */
@@ -288,22 +286,12 @@ static int idxd_config_bus_remove(struct device *dev)
 		}
 
 		idxd_unregister_dma_device(idxd);
-		rc = idxd_device_disable(idxd);
-		if (test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags)) {
-			for (i = 0; i < idxd->max_wqs; i++) {
-				struct idxd_wq *wq = idxd->wqs[i];
-
-				mutex_lock(&wq->wq_lock);
-				idxd_wq_disable_cleanup(wq);
-				mutex_unlock(&wq->wq_lock);
-			}
-		}
+		idxd_device_disable(idxd);
+		if (test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags))
+			idxd_device_reset(idxd);
 		module_put(THIS_MODULE);
-		if (rc < 0)
-			dev_warn(dev, "Device disable failed\n");
-		else
-			dev_info(dev, "Device %s disabled\n", dev_name(dev));
 
+		dev_info(dev, "Device %s disabled\n", dev_name(dev));
 	}
 
 	return 0;
-- 
2.33.0



