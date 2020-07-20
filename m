Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC2F2268A7
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387516AbgGTQJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:09:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387513AbgGTQJX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:09:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 917F72064B;
        Mon, 20 Jul 2020 16:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261362;
        bh=m1vrAI3M4keS+E/alhoTU7+dmNsnDQK4b3MZvYIXHlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FH1pkzPVktEP5jRTwRLU+/6OrSSVu517aFRlvNG0n61qZeJXlEY0jgTRwge0pGYQi
         qmqM6z5o+UP2u9i6hIQndaZzhfGLSb1KX3hmUVulHscfI3cSOK3ifsssZ0STk4Qsra
         HjmgcixKDbVT/AQUeVIWM+UUb6K6+/WGJClaEQh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yixin Zhang <yixin.zhang@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 089/244] dmaengine: idxd: cleanup workqueue config after disabling
Date:   Mon, 20 Jul 2020 17:36:00 +0200
Message-Id: <20200720152830.075252592@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit da32b28c95a79e399e18c03f8178f41aec9c66e4 ]

After disabling a device, we should clean up the internal state for
the wqs and zero out the configuration registers. Without doing so can cause
issues when the user reprogram the wqs.

Fixes: c52ca478233c ("dmaengine: idxd: add configuration component of driver")
Reported-by: Yixin Zhang <yixin.zhang@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Tested-by: Yixin Zhang <yixin.zhang@intel.com>
Link: https://lore.kernel.org/r/159311264246.1198.11955791213681679428.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c | 25 +++++++++++++++++++++++++
 drivers/dma/idxd/idxd.h   |  1 +
 drivers/dma/idxd/sysfs.c  |  5 +++++
 3 files changed, 31 insertions(+)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 8d79a8787104d..8d2718c585dc6 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -320,6 +320,31 @@ void idxd_wq_unmap_portal(struct idxd_wq *wq)
 	devm_iounmap(dev, wq->dportal);
 }
 
+void idxd_wq_disable_cleanup(struct idxd_wq *wq)
+{
+	struct idxd_device *idxd = wq->idxd;
+	struct device *dev = &idxd->pdev->dev;
+	int i, wq_offset;
+
+	lockdep_assert_held(&idxd->dev_lock);
+	memset(&wq->wqcfg, 0, sizeof(wq->wqcfg));
+	wq->type = IDXD_WQT_NONE;
+	wq->size = 0;
+	wq->group = NULL;
+	wq->threshold = 0;
+	wq->priority = 0;
+	clear_bit(WQ_FLAG_DEDICATED, &wq->flags);
+	memset(wq->name, 0, WQ_NAME_SIZE);
+
+	for (i = 0; i < 8; i++) {
+		wq_offset = idxd->wqcfg_offset + wq->id * 32 + i * sizeof(u32);
+		iowrite32(0, idxd->reg_base + wq_offset);
+		dev_dbg(dev, "WQ[%d][%d][%#x]: %#x\n",
+			wq->id, i, wq_offset,
+			ioread32(idxd->reg_base + wq_offset));
+	}
+}
+
 /* Device control bits */
 static inline bool idxd_is_enabled(struct idxd_device *idxd)
 {
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index b8f8a363b4a71..908c8d0ef3ab6 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -290,6 +290,7 @@ int idxd_wq_enable(struct idxd_wq *wq);
 int idxd_wq_disable(struct idxd_wq *wq);
 int idxd_wq_map_portal(struct idxd_wq *wq);
 void idxd_wq_unmap_portal(struct idxd_wq *wq);
+void idxd_wq_disable_cleanup(struct idxd_wq *wq);
 
 /* submission */
 int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc);
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 3999827970aba..fbb455ece81e8 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -315,6 +315,11 @@ static int idxd_config_bus_remove(struct device *dev)
 		idxd_unregister_dma_device(idxd);
 		spin_lock_irqsave(&idxd->dev_lock, flags);
 		rc = idxd_device_disable(idxd);
+		for (i = 0; i < idxd->max_wqs; i++) {
+			struct idxd_wq *wq = &idxd->wqs[i];
+
+			idxd_wq_disable_cleanup(wq);
+		}
 		spin_unlock_irqrestore(&idxd->dev_lock, flags);
 		module_put(THIS_MODULE);
 		if (rc < 0)
-- 
2.25.1



