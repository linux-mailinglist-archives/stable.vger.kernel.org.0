Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCDC3364265
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238333AbhDSNI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:08:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238543AbhDSNI1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:08:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD58061245;
        Mon, 19 Apr 2021 13:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837676;
        bh=JwLHNOHFTRomgVbNXEbB4pjdNqLWKCafHV8oJ2KDTh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+ypKfCcW+mTWi87FYJDh/oHDGeUQusNUJ9BB4ZMN7r9J1jJfy/0bPSnJzLJKD8nc
         hPChElmjbwdRhs+WA73IOm4hsl3KXv6r6w+Iq5mlanajBfaob5gWWZ7Aed8D/tY+5s
         aTD8EMbHC3E2JcvLbLgGSLAkrqkYD+0m1kDaj32Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shreenivaas Devarajan <shreenivaas.devarajan@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 015/122] dmaengine: idxd: fix wq cleanup of WQCFG registers
Date:   Mon, 19 Apr 2021 15:04:55 +0200
Message-Id: <20210419130530.680743677@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
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
index c09687013d29..31c819544a22 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -282,6 +282,22 @@ void idxd_wq_drain(struct idxd_wq *wq)
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
@@ -363,8 +379,6 @@ int idxd_wq_disable_pasid(struct idxd_wq *wq)
 void idxd_wq_disable_cleanup(struct idxd_wq *wq)
 {
 	struct idxd_device *idxd = wq->idxd;
-	struct device *dev = &idxd->pdev->dev;
-	int i, wq_offset;
 
 	lockdep_assert_held(&idxd->dev_lock);
 	memset(wq->wqcfg, 0, idxd->wqcfg_size);
@@ -376,14 +390,6 @@ void idxd_wq_disable_cleanup(struct idxd_wq *wq)
 	wq->ats_dis = 0;
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
@@ -672,7 +678,14 @@ static int idxd_wq_config_write(struct idxd_wq *wq)
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
index eda2ee10501f..76014c14f473 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -343,6 +343,7 @@ void idxd_wq_free_resources(struct idxd_wq *wq);
 int idxd_wq_enable(struct idxd_wq *wq);
 int idxd_wq_disable(struct idxd_wq *wq);
 void idxd_wq_drain(struct idxd_wq *wq);
+void idxd_wq_reset(struct idxd_wq *wq);
 int idxd_wq_map_portal(struct idxd_wq *wq);
 void idxd_wq_unmap_portal(struct idxd_wq *wq);
 void idxd_wq_disable_cleanup(struct idxd_wq *wq);
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 5f7bc4b1621a..18bf4d148989 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -275,7 +275,6 @@ static void disable_wq(struct idxd_wq *wq)
 {
 	struct idxd_device *idxd = wq->idxd;
 	struct device *dev = &idxd->pdev->dev;
-	int rc;
 
 	mutex_lock(&wq->wq_lock);
 	dev_dbg(dev, "%s removing WQ %s\n", __func__, dev_name(&wq->conf_dev));
@@ -296,17 +295,13 @@ static void disable_wq(struct idxd_wq *wq)
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



