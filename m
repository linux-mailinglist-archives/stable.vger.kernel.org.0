Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921FE382FC7
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237377AbhEQOUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:20:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239128AbhEQOSs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:18:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CA426141D;
        Mon, 17 May 2021 14:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260633;
        bh=dMaOqTSdh0dUbtJHZVhX6tLdO6Bp8U5x9eQR4swSXPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dGFxJ8ftqlnitqiWbDdH1Jh28iLKoosLl8HUNFUEtSykn1NMuKnzEu+SDvSyv7kTb
         DsyLmBf1XPrPE2mnKa8yim8BvDN/O67Ug3f0lpoeiNcsw+DS6jpsd6Yx8My2WsSC8D
         wqLqqdSDhIdaAqrZpZciQ4AJIOhjmHJHzBoPKKqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 169/363] dmaengine: idxd: fix dma device lifetime
Date:   Mon, 17 May 2021 16:00:35 +0200
Message-Id: <20210517140308.317674852@linuxfoundation.org>
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

[ Upstream commit 397862855619271296e46d10f7dfa7bafe71eb81 ]

The devm managed lifetime is incompatible with 'struct device' objects that
resides in idxd context. This is one of the series that clean up the idxd
driver 'struct device' lifetime. Remove embedding of dma_device and dma_chan
in idxd since it's not the only interface that idxd will use. The freeing of
the dma_device will be managed by the ->release() function.

Reported-by: Jason Gunthorpe <jgg@nvidia.com>
Fixes: bfe1d56091c1 ("dmaengine: idxd: Init and probe for Intel data accelerators")
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Link: https://lore.kernel.org/r/161852983001.2203940.14817017492384561719.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c |  2 -
 drivers/dma/idxd/dma.c    | 77 ++++++++++++++++++++++++++++++++-------
 drivers/dma/idxd/idxd.h   | 18 +++++++--
 3 files changed, 79 insertions(+), 18 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 78d2dc5e9bd8..d255bb016c4d 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -186,8 +186,6 @@ int idxd_wq_alloc_resources(struct idxd_wq *wq)
 		desc->id = i;
 		desc->wq = wq;
 		desc->cpu = -1;
-		dma_async_tx_descriptor_init(&desc->txd, &wq->dma_chan);
-		desc->txd.tx_submit = idxd_dma_tx_submit;
 	}
 
 	return 0;
diff --git a/drivers/dma/idxd/dma.c b/drivers/dma/idxd/dma.c
index a15e50126434..77439b645044 100644
--- a/drivers/dma/idxd/dma.c
+++ b/drivers/dma/idxd/dma.c
@@ -14,7 +14,10 @@
 
 static inline struct idxd_wq *to_idxd_wq(struct dma_chan *c)
 {
-	return container_of(c, struct idxd_wq, dma_chan);
+	struct idxd_dma_chan *idxd_chan;
+
+	idxd_chan = container_of(c, struct idxd_dma_chan, chan);
+	return idxd_chan->wq;
 }
 
 void idxd_dma_complete_txd(struct idxd_desc *desc,
@@ -135,7 +138,7 @@ static void idxd_dma_issue_pending(struct dma_chan *dma_chan)
 {
 }
 
-dma_cookie_t idxd_dma_tx_submit(struct dma_async_tx_descriptor *tx)
+static dma_cookie_t idxd_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 {
 	struct dma_chan *c = tx->chan;
 	struct idxd_wq *wq = to_idxd_wq(c);
@@ -156,14 +159,25 @@ dma_cookie_t idxd_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 
 static void idxd_dma_release(struct dma_device *device)
 {
+	struct idxd_dma_dev *idxd_dma = container_of(device, struct idxd_dma_dev, dma);
+
+	kfree(idxd_dma);
 }
 
 int idxd_register_dma_device(struct idxd_device *idxd)
 {
-	struct dma_device *dma = &idxd->dma_dev;
+	struct idxd_dma_dev *idxd_dma;
+	struct dma_device *dma;
+	struct device *dev = &idxd->pdev->dev;
+	int rc;
 
+	idxd_dma = kzalloc_node(sizeof(*idxd_dma), GFP_KERNEL, dev_to_node(dev));
+	if (!idxd_dma)
+		return -ENOMEM;
+
+	dma = &idxd_dma->dma;
 	INIT_LIST_HEAD(&dma->channels);
-	dma->dev = &idxd->pdev->dev;
+	dma->dev = dev;
 
 	dma_cap_set(DMA_PRIVATE, dma->cap_mask);
 	dma_cap_set(DMA_COMPLETION_NO_ORDER, dma->cap_mask);
@@ -179,35 +193,72 @@ int idxd_register_dma_device(struct idxd_device *idxd)
 	dma->device_alloc_chan_resources = idxd_dma_alloc_chan_resources;
 	dma->device_free_chan_resources = idxd_dma_free_chan_resources;
 
-	return dma_async_device_register(&idxd->dma_dev);
+	rc = dma_async_device_register(dma);
+	if (rc < 0) {
+		kfree(idxd_dma);
+		return rc;
+	}
+
+	idxd_dma->idxd = idxd;
+	/*
+	 * This pointer is protected by the refs taken by the dma_chan. It will remain valid
+	 * as long as there are outstanding channels.
+	 */
+	idxd->idxd_dma = idxd_dma;
+	return 0;
 }
 
 void idxd_unregister_dma_device(struct idxd_device *idxd)
 {
-	dma_async_device_unregister(&idxd->dma_dev);
+	dma_async_device_unregister(&idxd->idxd_dma->dma);
 }
 
 int idxd_register_dma_channel(struct idxd_wq *wq)
 {
 	struct idxd_device *idxd = wq->idxd;
-	struct dma_device *dma = &idxd->dma_dev;
-	struct dma_chan *chan = &wq->dma_chan;
-	int rc;
+	struct dma_device *dma = &idxd->idxd_dma->dma;
+	struct device *dev = &idxd->pdev->dev;
+	struct idxd_dma_chan *idxd_chan;
+	struct dma_chan *chan;
+	int rc, i;
+
+	idxd_chan = kzalloc_node(sizeof(*idxd_chan), GFP_KERNEL, dev_to_node(dev));
+	if (!idxd_chan)
+		return -ENOMEM;
 
-	memset(&wq->dma_chan, 0, sizeof(struct dma_chan));
+	chan = &idxd_chan->chan;
 	chan->device = dma;
 	list_add_tail(&chan->device_node, &dma->channels);
+
+	for (i = 0; i < wq->num_descs; i++) {
+		struct idxd_desc *desc = wq->descs[i];
+
+		dma_async_tx_descriptor_init(&desc->txd, chan);
+		desc->txd.tx_submit = idxd_dma_tx_submit;
+	}
+
 	rc = dma_async_device_channel_register(dma, chan);
-	if (rc < 0)
+	if (rc < 0) {
+		kfree(idxd_chan);
 		return rc;
+	}
+
+	wq->idxd_chan = idxd_chan;
+	idxd_chan->wq = wq;
+	get_device(&wq->conf_dev);
 
 	return 0;
 }
 
 void idxd_unregister_dma_channel(struct idxd_wq *wq)
 {
-	struct dma_chan *chan = &wq->dma_chan;
+	struct idxd_dma_chan *idxd_chan = wq->idxd_chan;
+	struct dma_chan *chan = &idxd_chan->chan;
+	struct idxd_dma_dev *idxd_dma = wq->idxd->idxd_dma;
 
-	dma_async_device_channel_unregister(&wq->idxd->dma_dev, chan);
+	dma_async_device_channel_unregister(&idxd_dma->dma, chan);
 	list_del(&chan->device_node);
+	kfree(wq->idxd_chan);
+	wq->idxd_chan = NULL;
+	put_device(&wq->conf_dev);
 }
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 76014c14f473..80e534680c9a 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -14,6 +14,9 @@
 
 extern struct kmem_cache *idxd_desc_pool;
 
+struct idxd_device;
+struct idxd_wq;
+
 #define IDXD_REG_TIMEOUT	50
 #define IDXD_DRAIN_TIMEOUT	5000
 
@@ -96,6 +99,11 @@ enum idxd_complete_type {
 	IDXD_COMPLETE_DEV_FAIL,
 };
 
+struct idxd_dma_chan {
+	struct dma_chan chan;
+	struct idxd_wq *wq;
+};
+
 struct idxd_wq {
 	void __iomem *portal;
 	struct device conf_dev;
@@ -125,7 +133,7 @@ struct idxd_wq {
 	int compls_size;
 	struct idxd_desc **descs;
 	struct sbitmap_queue sbq;
-	struct dma_chan dma_chan;
+	struct idxd_dma_chan *idxd_chan;
 	char name[WQ_NAME_SIZE + 1];
 	u64 max_xfer_bytes;
 	u32 max_batch_size;
@@ -162,6 +170,11 @@ enum idxd_device_flag {
 	IDXD_FLAG_PASID_ENABLED,
 };
 
+struct idxd_dma_dev {
+	struct idxd_device *idxd;
+	struct dma_device dma;
+};
+
 struct idxd_device {
 	enum idxd_type type;
 	struct device conf_dev;
@@ -210,7 +223,7 @@ struct idxd_device {
 	int num_wq_irqs;
 	struct idxd_irq_entry *irq_entries;
 
-	struct dma_device dma_dev;
+	struct idxd_dma_dev *idxd_dma;
 	struct workqueue_struct *wq;
 	struct work_struct work;
 };
@@ -363,7 +376,6 @@ void idxd_unregister_dma_channel(struct idxd_wq *wq);
 void idxd_parse_completion_status(u8 status, enum dmaengine_tx_result *res);
 void idxd_dma_complete_txd(struct idxd_desc *desc,
 			   enum idxd_complete_type comp_type);
-dma_cookie_t idxd_dma_tx_submit(struct dma_async_tx_descriptor *tx);
 
 /* cdev */
 int idxd_cdev_register(void);
-- 
2.30.2



