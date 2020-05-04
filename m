Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8DFF1C4469
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732089AbgEDSHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:07:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731556AbgEDSHJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:07:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6D022073B;
        Mon,  4 May 2020 18:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615628;
        bh=cNHYncv6nI3E1IZ9bJ2r7TR/o+trGDi/hKmbzKFpJPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CB7sDHtBI5D54JlB49Y62qyyFefygr1g4W8xPqQJxXX28aGI/fsqHwbZqO/EsSvQ4
         VMEHCSHChv7JiYmxkPspIi6XhFPDs0hDqv4IWM6KBzcYlxZiykeFxy3WEPQTMe1JRS
         jS7f6FwCYhoeDvs0ZhwBp2d2iCAFO69QWkKrvCz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yixin Zhang <yixin.zhang@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.6 58/73] dmaengine: fix channel index enumeration
Date:   Mon,  4 May 2020 19:58:01 +0200
Message-Id: <20200504165509.665982542@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165501.781878940@linuxfoundation.org>
References: <20200504165501.781878940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

commit 0821009445a8261ac4d32a6df4b83938e007c765 upstream.

When the channel register code was changed to allow hotplug operations,
dynamic indexing wasn't taken into account. When channels are randomly
plugged and unplugged out of order, the serial indexing breaks. Convert
channel indexing to using IDA tracking in order to allow dynamic
assignment. The previous code does not cause any regression bug for
existing channel allocation besides idxd driver since the hotplug usage
case is only used by idxd at this point.

With this change, the chan->idr_ref is also not needed any longer. We can
have a device with no channels registered due to hot plug. The channel
device release code no longer should attempt to free the dma device id on
the last channel release.

Fixes: e81274cd6b52 ("dmaengine: add support to dynamic register/unregister of channels")

Reported-by: Yixin Zhang <yixin.zhang@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Tested-by: Yixin Zhang <yixin.zhang@intel.com>
Link: https://lore.kernel.org/r/158679961260.7674.8485924270472851852.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/dmaengine.c   |   60 +++++++++++++++++++---------------------------
 include/linux/dmaengine.h |    4 +--
 2 files changed, 28 insertions(+), 36 deletions(-)

--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -151,10 +151,6 @@ static void chan_dev_release(struct devi
 	struct dma_chan_dev *chan_dev;
 
 	chan_dev = container_of(dev, typeof(*chan_dev), device);
-	if (atomic_dec_and_test(chan_dev->idr_ref)) {
-		ida_free(&dma_ida, chan_dev->dev_id);
-		kfree(chan_dev->idr_ref);
-	}
 	kfree(chan_dev);
 }
 
@@ -952,27 +948,9 @@ static int get_dma_id(struct dma_device
 }
 
 static int __dma_async_device_channel_register(struct dma_device *device,
-					       struct dma_chan *chan,
-					       int chan_id)
+					       struct dma_chan *chan)
 {
 	int rc = 0;
-	int chancnt = device->chancnt;
-	atomic_t *idr_ref;
-	struct dma_chan *tchan;
-
-	tchan = list_first_entry_or_null(&device->channels,
-					 struct dma_chan, device_node);
-	if (!tchan)
-		return -ENODEV;
-
-	if (tchan->dev) {
-		idr_ref = tchan->dev->idr_ref;
-	} else {
-		idr_ref = kmalloc(sizeof(*idr_ref), GFP_KERNEL);
-		if (!idr_ref)
-			return -ENOMEM;
-		atomic_set(idr_ref, 0);
-	}
 
 	chan->local = alloc_percpu(typeof(*chan->local));
 	if (!chan->local)
@@ -988,29 +966,36 @@ static int __dma_async_device_channel_re
 	 * When the chan_id is a negative value, we are dynamically adding
 	 * the channel. Otherwise we are static enumerating.
 	 */
-	chan->chan_id = chan_id < 0 ? chancnt : chan_id;
+	mutex_lock(&device->chan_mutex);
+	chan->chan_id = ida_alloc(&device->chan_ida, GFP_KERNEL);
+	mutex_unlock(&device->chan_mutex);
+	if (chan->chan_id < 0) {
+		pr_err("%s: unable to alloc ida for chan: %d\n",
+		       __func__, chan->chan_id);
+		goto err_out;
+	}
+
 	chan->dev->device.class = &dma_devclass;
 	chan->dev->device.parent = device->dev;
 	chan->dev->chan = chan;
-	chan->dev->idr_ref = idr_ref;
 	chan->dev->dev_id = device->dev_id;
-	atomic_inc(idr_ref);
 	dev_set_name(&chan->dev->device, "dma%dchan%d",
 		     device->dev_id, chan->chan_id);
-
 	rc = device_register(&chan->dev->device);
 	if (rc)
-		goto err_out;
+		goto err_out_ida;
 	chan->client_count = 0;
-	device->chancnt = chan->chan_id + 1;
+	device->chancnt++;
 
 	return 0;
 
+ err_out_ida:
+	mutex_lock(&device->chan_mutex);
+	ida_free(&device->chan_ida, chan->chan_id);
+	mutex_unlock(&device->chan_mutex);
  err_out:
 	free_percpu(chan->local);
 	kfree(chan->dev);
-	if (atomic_dec_return(idr_ref) == 0)
-		kfree(idr_ref);
 	return rc;
 }
 
@@ -1019,7 +1004,7 @@ int dma_async_device_channel_register(st
 {
 	int rc;
 
-	rc = __dma_async_device_channel_register(device, chan, -1);
+	rc = __dma_async_device_channel_register(device, chan);
 	if (rc < 0)
 		return rc;
 
@@ -1039,6 +1024,9 @@ static void __dma_async_device_channel_u
 	device->chancnt--;
 	chan->dev->chan = NULL;
 	mutex_unlock(&dma_list_mutex);
+	mutex_lock(&device->chan_mutex);
+	ida_free(&device->chan_ida, chan->chan_id);
+	mutex_unlock(&device->chan_mutex);
 	device_unregister(&chan->dev->device);
 	free_percpu(chan->local);
 }
@@ -1061,7 +1049,7 @@ EXPORT_SYMBOL_GPL(dma_async_device_chann
  */
 int dma_async_device_register(struct dma_device *device)
 {
-	int rc, i = 0;
+	int rc;
 	struct dma_chan* chan;
 
 	if (!device)
@@ -1166,9 +1154,12 @@ int dma_async_device_register(struct dma
 	if (rc != 0)
 		return rc;
 
+	mutex_init(&device->chan_mutex);
+	ida_init(&device->chan_ida);
+
 	/* represent channels in sysfs. Probably want devs too */
 	list_for_each_entry(chan, &device->channels, device_node) {
-		rc = __dma_async_device_channel_register(device, chan, i++);
+		rc = __dma_async_device_channel_register(device, chan);
 		if (rc < 0)
 			goto err_out;
 	}
@@ -1239,6 +1230,7 @@ void dma_async_device_unregister(struct
 	 */
 	dma_cap_set(DMA_PRIVATE, device->cap_mask);
 	dma_channel_rebalance();
+	ida_free(&dma_ida, device->dev_id);
 	dma_device_put(device);
 	mutex_unlock(&dma_list_mutex);
 }
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -336,13 +336,11 @@ struct dma_chan {
  * @chan: driver channel device
  * @device: sysfs device
  * @dev_id: parent dma_device dev_id
- * @idr_ref: reference count to gate release of dma_device dev_id
  */
 struct dma_chan_dev {
 	struct dma_chan *chan;
 	struct device device;
 	int dev_id;
-	atomic_t *idr_ref;
 };
 
 /**
@@ -827,6 +825,8 @@ struct dma_device {
 	int dev_id;
 	struct device *dev;
 	struct module *owner;
+	struct ida chan_ida;
+	struct mutex chan_mutex;	/* to protect chan_ida */
 
 	u32 src_addr_widths;
 	u32 dst_addr_widths;


