Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11569628025
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237739AbiKNNDb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:03:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237734AbiKNNDa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:03:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E357511A1B
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:03:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 904F9B80EA5
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE50EC433D7;
        Mon, 14 Nov 2022 13:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431006;
        bh=ptsU9NG3LE77pqKxrIBlbh9k9aDr3kUXC7v/3HEQnZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NAKgbNdDKoufltbVHJWd72k3ynyx7W8zKZ94Ah/lzYXDIu+R6HJ505CQl3HiQA+3r
         DzgEbE7f26K4MuDeWIix5/lZq7/V5R6/RoWb4lzJ4/k1HGRpZjVPqufzs9nBva4K+i
         pYSTYm69FqFXjaSNIU2xZ0ymGCRjgovIV2Ma37L4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiaochen Shen <xiaochen.shen@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 065/190] dmaengine: idxd: Fix max batch size for Intel IAA
Date:   Mon, 14 Nov 2022 13:44:49 +0100
Message-Id: <20221114124501.558984570@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaochen Shen <xiaochen.shen@intel.com>

[ Upstream commit e8dbd6445dd6b38c4c50410a86f13158486ee99a ]

>From Intel IAA spec [1], Intel IAA does not support batch processing.

Two batch related default values for IAA are incorrect in current code:
(1) The max batch size of device is set during device initialization,
    that indicates batch is supported. It should be always 0 on IAA.
(2) The max batch size of work queue is set to WQ_DEFAULT_MAX_BATCH (32)
    as the default value regardless of Intel DSA or IAA device during
    work queue setup and cleanup. It should be always 0 on IAA.

Fix the issues by setting the max batch size of device and max batch
size of work queue to 0 on IAA device, that means batch is not
supported.

[1]: https://cdrdv2.intel.com/v1/dl/getContent/721858

Fixes: 23084545dbb0 ("dmaengine: idxd: set max_xfer and max_batch for RO device")
Fixes: 92452a72ebdf ("dmaengine: idxd: set defaults for wq configs")
Fixes: bfe1d56091c1 ("dmaengine: idxd: Init and probe for Intel data accelerators")
Signed-off-by: Xiaochen Shen <xiaochen.shen@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
Link: https://lore.kernel.org/r/20220930201528.18621-2-xiaochen.shen@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c |  6 +++---
 drivers/dma/idxd/idxd.h   | 32 ++++++++++++++++++++++++++++++++
 drivers/dma/idxd/init.c   |  4 ++--
 drivers/dma/idxd/sysfs.c  |  2 +-
 4 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 5a8cc52c1abf..cc7aabe4dc84 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -388,7 +388,7 @@ static void idxd_wq_disable_cleanup(struct idxd_wq *wq)
 	clear_bit(WQ_FLAG_BLOCK_ON_FAULT, &wq->flags);
 	memset(wq->name, 0, WQ_NAME_SIZE);
 	wq->max_xfer_bytes = WQ_DEFAULT_MAX_XFER;
-	wq->max_batch_size = WQ_DEFAULT_MAX_BATCH;
+	idxd_wq_set_max_batch_size(idxd->data->type, wq, WQ_DEFAULT_MAX_BATCH);
 }
 
 static void idxd_wq_device_reset_cleanup(struct idxd_wq *wq)
@@ -863,7 +863,7 @@ static int idxd_wq_config_write(struct idxd_wq *wq)
 
 	/* bytes 12-15 */
 	wq->wqcfg->max_xfer_shift = ilog2(wq->max_xfer_bytes);
-	wq->wqcfg->max_batch_shift = ilog2(wq->max_batch_size);
+	idxd_wqcfg_set_max_batch_shift(idxd->data->type, wq->wqcfg, ilog2(wq->max_batch_size));
 
 	dev_dbg(dev, "WQ %d CFGs\n", wq->id);
 	for (i = 0; i < WQCFG_STRIDES(idxd); i++) {
@@ -1031,7 +1031,7 @@ static int idxd_wq_load_config(struct idxd_wq *wq)
 	wq->priority = wq->wqcfg->priority;
 
 	wq->max_xfer_bytes = 1ULL << wq->wqcfg->max_xfer_shift;
-	wq->max_batch_size = 1ULL << wq->wqcfg->max_batch_shift;
+	idxd_wq_set_max_batch_size(idxd->data->type, wq, 1U << wq->wqcfg->max_batch_shift);
 
 	for (i = 0; i < WQCFG_STRIDES(idxd); i++) {
 		wqcfg_offset = WQCFG_OFFSET(idxd, wq->id, i);
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 33640a41e172..05c3f8694478 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -542,6 +542,38 @@ static inline int idxd_wq_refcount(struct idxd_wq *wq)
 	return wq->client_count;
 };
 
+/*
+ * Intel IAA does not support batch processing.
+ * The max batch size of device, max batch size of wq and
+ * max batch shift of wqcfg should be always 0 on IAA.
+ */
+static inline void idxd_set_max_batch_size(int idxd_type, struct idxd_device *idxd,
+					   u32 max_batch_size)
+{
+	if (idxd_type == IDXD_TYPE_IAX)
+		idxd->max_batch_size = 0;
+	else
+		idxd->max_batch_size = max_batch_size;
+}
+
+static inline void idxd_wq_set_max_batch_size(int idxd_type, struct idxd_wq *wq,
+					      u32 max_batch_size)
+{
+	if (idxd_type == IDXD_TYPE_IAX)
+		wq->max_batch_size = 0;
+	else
+		wq->max_batch_size = max_batch_size;
+}
+
+static inline void idxd_wqcfg_set_max_batch_shift(int idxd_type, union wqcfg *wqcfg,
+						  u32 max_batch_shift)
+{
+	if (idxd_type == IDXD_TYPE_IAX)
+		wqcfg->max_batch_shift = 0;
+	else
+		wqcfg->max_batch_shift = max_batch_shift;
+}
+
 int __must_check __idxd_driver_register(struct idxd_device_driver *idxd_drv,
 					struct module *module, const char *mod_name);
 #define idxd_driver_register(driver) \
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 913a55ccb864..cf94795ca1af 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -177,7 +177,7 @@ static int idxd_setup_wqs(struct idxd_device *idxd)
 		init_completion(&wq->wq_dead);
 		init_completion(&wq->wq_resurrect);
 		wq->max_xfer_bytes = WQ_DEFAULT_MAX_XFER;
-		wq->max_batch_size = WQ_DEFAULT_MAX_BATCH;
+		idxd_wq_set_max_batch_size(idxd->data->type, wq, WQ_DEFAULT_MAX_BATCH);
 		wq->enqcmds_retries = IDXD_ENQCMDS_RETRIES;
 		wq->wqcfg = kzalloc_node(idxd->wqcfg_size, GFP_KERNEL, dev_to_node(dev));
 		if (!wq->wqcfg) {
@@ -402,7 +402,7 @@ static void idxd_read_caps(struct idxd_device *idxd)
 
 	idxd->max_xfer_bytes = 1ULL << idxd->hw.gen_cap.max_xfer_shift;
 	dev_dbg(dev, "max xfer size: %llu bytes\n", idxd->max_xfer_bytes);
-	idxd->max_batch_size = 1U << idxd->hw.gen_cap.max_batch_shift;
+	idxd_set_max_batch_size(idxd->data->type, idxd, 1U << idxd->hw.gen_cap.max_batch_shift);
 	dev_dbg(dev, "max batch size: %u\n", idxd->max_batch_size);
 	if (idxd->hw.gen_cap.config_en)
 		set_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags);
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index b6760b28a963..82538622320a 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -961,7 +961,7 @@ static ssize_t wq_max_batch_size_store(struct device *dev, struct device_attribu
 	if (batch_size > idxd->max_batch_size)
 		return -EINVAL;
 
-	wq->max_batch_size = (u32)batch_size;
+	idxd_wq_set_max_batch_size(idxd->data->type, wq, (u32)batch_size);
 
 	return count;
 }
-- 
2.35.1



