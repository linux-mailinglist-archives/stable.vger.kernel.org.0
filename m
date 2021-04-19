Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEDC364364
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240391AbhDSNRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:17:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240631AbhDSNPy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:15:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D205613D1;
        Mon, 19 Apr 2021 13:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838012;
        bh=W2/AfbJ7NmMI+8YoEzFhs6dbIdm37przwfiiI8Aky1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xs2m4pq0H7y4FjRijHK+T+vEZYwtEGUeZbv+rB+qCuk9QOFRRbZUe6SsOSK1oGy2q
         VFn/bTWJ3hIsF9DRwCETjl1g3IfQW+Z3ExbchD8l7nToZBmiE9MXdyN50BC5XE5T7F
         czPJLpnMWHnQG19pE4SWTPGQlVJc8raJyGe5pacQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shreenivaas Devarajan <shreenivaas.devarajan@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/103] dmaengine: idxd: fix wq cleanup of WQCFG registers
Date:   Mon, 19 Apr 2021 15:05:23 +0200
Message-Id: <20210419130528.212402364@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit ea9aadc06a9f10ad20a90edc0a484f1147d88a7a ]

A pre-release silicon erratum workaround where wq reset does not clear
WQCFG registers was leaked into upstream code. Use wq reset command
instead of blasting the MMIO region. This also address an issue where
we clobber registers in future devices.

Fixes: da32b28c95a7 ("dmaengine: idxd: cleanup workqueue config after disabling")
Reported-by: Shreenivaas Devarajan <shreenivaas.devarajan@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/161824330020.881560.16375921906426627033.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c | 35 ++++++++++++++++++++++++-----------
 drivers/dma/idxd/idxd.h   |  1 +
 drivers/dma/idxd/sysfs.c  |  9 ++-------
 3 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index a6704838ffcb..459e9fbc2253 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -263,6 +263,22 @@ void idxd_wq_drain(struct idxd_wq *wq)
 	idxd_cmd_exec(idxd, IDXD_CMD_DRAIN_WQ, operand, NULL);
 }
 
+void idxd_wq_reset(struct idxd_wq *wq)
+{
+	struct idxd_device *idxd = wq->idxd;
+	struct device *dev = &idxd->pdev->dev;
+	u32 operand;
+
+	if (wq->state != IDXD_WQ_ENABLED) {
+		dev_dbg(dev, "WQ %d in wrong state: %d\n", wq->id, wq->state);
+		return;
+	}
+
+	operand = BIT(wq->id % 16) | ((wq->id / 16) << 16);
+	idxd_cmd_exec(idxd, IDXD_CMD_RESET_WQ, operand, NULL);
+	wq->state = IDXD_WQ_DISABLED;
+}
+
 int idxd_wq_map_portal(struct idxd_wq *wq)
 {
 	struct idxd_device *idxd = wq->idxd;
@@ -291,8 +307,6 @@ void idxd_wq_unmap_portal(struct idxd_wq *wq)
 void idxd_wq_disable_cleanup(struct idxd_wq *wq)
 {
 	struct idxd_device *idxd = wq->idxd;
-	struct device *dev = &idxd->pdev->dev;
-	int i, wq_offset;
 
 	lockdep_assert_held(&idxd->dev_lock);
 	memset(wq->wqcfg, 0, idxd->wqcfg_size);
@@ -303,14 +317,6 @@ void idxd_wq_disable_cleanup(struct idxd_wq *wq)
 	wq->priority = 0;
 	clear_bit(WQ_FLAG_DEDICATED, &wq->flags);
 	memset(wq->name, 0, WQ_NAME_SIZE);
-
-	for (i = 0; i < WQCFG_STRIDES(idxd); i++) {
-		wq_offset = WQCFG_OFFSET(idxd, wq->id, i);
-		iowrite32(0, idxd->reg_base + wq_offset);
-		dev_dbg(dev, "WQ[%d][%d][%#x]: %#x\n",
-			wq->id, i, wq_offset,
-			ioread32(idxd->reg_base + wq_offset));
-	}
 }
 
 /* Device control bits */
@@ -560,7 +566,14 @@ static int idxd_wq_config_write(struct idxd_wq *wq)
 	if (!wq->group)
 		return 0;
 
-	memset(wq->wqcfg, 0, idxd->wqcfg_size);
+	/*
+	 * Instead of memset the entire shadow copy of WQCFG, copy from the hardware after
+	 * wq reset. This will copy back the sticky values that are present on some devices.
+	 */
+	for (i = 0; i < WQCFG_STRIDES(idxd); i++) {
+		wq_offset = WQCFG_OFFSET(idxd, wq->id, i);
+		wq->wqcfg->bits[i] = ioread32(idxd->reg_base + wq_offset);
+	}
 
 	/* byte 0-3 */
 	wq->wqcfg->wq_size = wq->size;
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 953ef6536aac..1d7849cb9100 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -295,6 +295,7 @@ void idxd_wq_free_resources(struct idxd_wq *wq);
 int idxd_wq_enable(struct idxd_wq *wq);
 int idxd_wq_disable(struct idxd_wq *wq);
 void idxd_wq_drain(struct idxd_wq *wq);
+void idxd_wq_reset(struct idxd_wq *wq);
 int idxd_wq_map_portal(struct idxd_wq *wq);
 void idxd_wq_unmap_portal(struct idxd_wq *wq);
 void idxd_wq_disable_cleanup(struct idxd_wq *wq);
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index ad46b3c648af..7566b573d546 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -241,7 +241,6 @@ static void disable_wq(struct idxd_wq *wq)
 {
 	struct idxd_device *idxd = wq->idxd;
 	struct device *dev = &idxd->pdev->dev;
-	int rc;
 
 	mutex_lock(&wq->wq_lock);
 	dev_dbg(dev, "%s removing WQ %s\n", __func__, dev_name(&wq->conf_dev));
@@ -262,17 +261,13 @@ static void disable_wq(struct idxd_wq *wq)
 	idxd_wq_unmap_portal(wq);
 
 	idxd_wq_drain(wq);
-	rc = idxd_wq_disable(wq);
+	idxd_wq_reset(wq);
 
 	idxd_wq_free_resources(wq);
 	wq->client_count = 0;
 	mutex_unlock(&wq->wq_lock);
 
-	if (rc < 0)
-		dev_warn(dev, "Failed to disable %s: %d\n",
-			 dev_name(&wq->conf_dev), rc);
-	else
-		dev_info(dev, "wq %s disabled\n", dev_name(&wq->conf_dev));
+	dev_info(dev, "wq %s disabled\n", dev_name(&wq->conf_dev));
 }
 
 static int idxd_config_bus_remove(struct device *dev)
-- 
2.30.2



