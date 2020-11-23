Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3C52C09F7
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730945AbgKWNPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:15:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:58474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733264AbgKWMpG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:45:06 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 022C020732;
        Mon, 23 Nov 2020 12:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135505;
        bh=1LR9Gy2BB10ghhxSF7doDfTPTVmpM4ONLvDWaRTEWzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BmmM3HJGoZMiWQ8s/bqe7LB5iCi8BvMf02r2f/8N92HIGRY/N69nPB1Q4Wox34bCe
         ynyvNeqrR/o1qcpf+lopVSFkxW1hL61MXq+Ak5myFI3eCACrPXkH2VkHfiBKv5rdln
         cI+caU7nprjTUyNBU/WQTK0BJ1klJgMq6fpBUYGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 093/252] dmaengine: idxd: fix wq config registers offset programming
Date:   Mon, 23 Nov 2020 13:20:43 +0100
Message-Id: <20201123121840.078638249@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 484f910e93b48c1d8890d8330a87e34ae61f4782 ]

DSA spec v1.1 [1] updated to include a stride size register for WQ
configuration that will specify how much space is reserved for the WQ
configuration register set. This change is expected to be in the final
gen1 DSA hardware. Fix the driver to use WQCFG_OFFSET() for all WQ
offset calculation and fixup WQCFG_OFFSET() to use the new calculated
wq size.

[1]: https://software.intel.com/content/www/us/en/develop/download/intel-data-streaming-accelerator-preliminary-architecture-specification.html

Fixes: bfe1d56091c1 ("dmaengine: idxd: Init and probe for Intel data accelerators")
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/160383444959.48058.14249265538404901781.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c    | 29 ++++++++++++++---------------
 drivers/dma/idxd/idxd.h      |  3 ++-
 drivers/dma/idxd/init.c      |  5 +++++
 drivers/dma/idxd/registers.h | 23 ++++++++++++++++++++++-
 4 files changed, 43 insertions(+), 17 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index b75d699160bfa..c2beece445215 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -295,7 +295,7 @@ void idxd_wq_disable_cleanup(struct idxd_wq *wq)
 	int i, wq_offset;
 
 	lockdep_assert_held(&idxd->dev_lock);
-	memset(&wq->wqcfg, 0, sizeof(wq->wqcfg));
+	memset(wq->wqcfg, 0, idxd->wqcfg_size);
 	wq->type = IDXD_WQT_NONE;
 	wq->size = 0;
 	wq->group = NULL;
@@ -304,8 +304,8 @@ void idxd_wq_disable_cleanup(struct idxd_wq *wq)
 	clear_bit(WQ_FLAG_DEDICATED, &wq->flags);
 	memset(wq->name, 0, WQ_NAME_SIZE);
 
-	for (i = 0; i < 8; i++) {
-		wq_offset = idxd->wqcfg_offset + wq->id * 32 + i * sizeof(u32);
+	for (i = 0; i < WQCFG_STRIDES(idxd); i++) {
+		wq_offset = WQCFG_OFFSET(idxd, wq->id, i);
 		iowrite32(0, idxd->reg_base + wq_offset);
 		dev_dbg(dev, "WQ[%d][%d][%#x]: %#x\n",
 			wq->id, i, wq_offset,
@@ -535,10 +535,10 @@ static int idxd_wq_config_write(struct idxd_wq *wq)
 	if (!wq->group)
 		return 0;
 
-	memset(&wq->wqcfg, 0, sizeof(union wqcfg));
+	memset(wq->wqcfg, 0, idxd->wqcfg_size);
 
 	/* byte 0-3 */
-	wq->wqcfg.wq_size = wq->size;
+	wq->wqcfg->wq_size = wq->size;
 
 	if (wq->size == 0) {
 		dev_warn(dev, "Incorrect work queue size: 0\n");
@@ -546,22 +546,21 @@ static int idxd_wq_config_write(struct idxd_wq *wq)
 	}
 
 	/* bytes 4-7 */
-	wq->wqcfg.wq_thresh = wq->threshold;
+	wq->wqcfg->wq_thresh = wq->threshold;
 
 	/* byte 8-11 */
-	wq->wqcfg.priv = !!(wq->type == IDXD_WQT_KERNEL);
-	wq->wqcfg.mode = 1;
-
-	wq->wqcfg.priority = wq->priority;
+	wq->wqcfg->priv = !!(wq->type == IDXD_WQT_KERNEL);
+	wq->wqcfg->mode = 1;
+	wq->wqcfg->priority = wq->priority;
 
 	/* bytes 12-15 */
-	wq->wqcfg.max_xfer_shift = idxd->hw.gen_cap.max_xfer_shift;
-	wq->wqcfg.max_batch_shift = idxd->hw.gen_cap.max_batch_shift;
+	wq->wqcfg->max_xfer_shift = idxd->hw.gen_cap.max_xfer_shift;
+	wq->wqcfg->max_batch_shift = idxd->hw.gen_cap.max_batch_shift;
 
 	dev_dbg(dev, "WQ %d CFGs\n", wq->id);
-	for (i = 0; i < 8; i++) {
-		wq_offset = idxd->wqcfg_offset + wq->id * 32 + i * sizeof(u32);
-		iowrite32(wq->wqcfg.bits[i], idxd->reg_base + wq_offset);
+	for (i = 0; i < WQCFG_STRIDES(idxd); i++) {
+		wq_offset = WQCFG_OFFSET(idxd, wq->id, i);
+		iowrite32(wq->wqcfg->bits[i], idxd->reg_base + wq_offset);
 		dev_dbg(dev, "WQ[%d][%d][%#x]: %#x\n",
 			wq->id, i, wq_offset,
 			ioread32(idxd->reg_base + wq_offset));
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index e62b4799d1896..a3e5b83c80ef7 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -103,7 +103,7 @@ struct idxd_wq {
 	u32 priority;
 	enum idxd_wq_state state;
 	unsigned long flags;
-	union wqcfg wqcfg;
+	union wqcfg *wqcfg;
 	u32 vec_ptr;		/* interrupt steering */
 	struct dsa_hw_desc **hw_descs;
 	int num_descs;
@@ -180,6 +180,7 @@ struct idxd_device {
 	int max_wq_size;
 	int token_limit;
 	int nr_tokens;		/* non-reserved tokens */
+	unsigned int wqcfg_size;
 
 	union sw_err_reg sw_err;
 	wait_queue_head_t cmd_waitq;
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index c7c61974f20f6..4bf9ed369bb7b 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -176,6 +176,9 @@ static int idxd_setup_internals(struct idxd_device *idxd)
 		wq->idxd = idxd;
 		mutex_init(&wq->wq_lock);
 		wq->idxd_cdev.minor = -1;
+		wq->wqcfg = devm_kzalloc(dev, idxd->wqcfg_size, GFP_KERNEL);
+		if (!wq->wqcfg)
+			return -ENOMEM;
 	}
 
 	for (i = 0; i < idxd->max_engines; i++) {
@@ -249,6 +252,8 @@ static void idxd_read_caps(struct idxd_device *idxd)
 	dev_dbg(dev, "total workqueue size: %u\n", idxd->max_wq_size);
 	idxd->max_wqs = idxd->hw.wq_cap.num_wqs;
 	dev_dbg(dev, "max workqueues: %u\n", idxd->max_wqs);
+	idxd->wqcfg_size = 1 << (idxd->hw.wq_cap.wqcfg_size + IDXD_WQCFG_MIN);
+	dev_dbg(dev, "wqcfg size: %u\n", idxd->wqcfg_size);
 
 	/* reading operation capabilities */
 	for (i = 0; i < 4; i++) {
diff --git a/drivers/dma/idxd/registers.h b/drivers/dma/idxd/registers.h
index a39e7ae6b3d93..aef5a902829ee 100644
--- a/drivers/dma/idxd/registers.h
+++ b/drivers/dma/idxd/registers.h
@@ -43,7 +43,8 @@ union wq_cap_reg {
 	struct {
 		u64 total_wq_size:16;
 		u64 num_wqs:8;
-		u64 rsvd:24;
+		u64 wqcfg_size:4;
+		u64 rsvd:20;
 		u64 shared_mode:1;
 		u64 dedicated_mode:1;
 		u64 rsvd2:1;
@@ -55,6 +56,7 @@ union wq_cap_reg {
 	u64 bits;
 } __packed;
 #define IDXD_WQCAP_OFFSET		0x20
+#define IDXD_WQCFG_MIN			5
 
 union group_cap_reg {
 	struct {
@@ -333,4 +335,23 @@ union wqcfg {
 	};
 	u32 bits[8];
 } __packed;
+
+/*
+ * This macro calculates the offset into the WQCFG register
+ * idxd - struct idxd *
+ * n - wq id
+ * ofs - the index of the 32b dword for the config register
+ *
+ * The WQCFG register block is divided into groups per each wq. The n index
+ * allows us to move to the register group that's for that particular wq.
+ * Each register is 32bits. The ofs gives us the number of register to access.
+ */
+#define WQCFG_OFFSET(_idxd_dev, n, ofs) \
+({\
+	typeof(_idxd_dev) __idxd_dev = (_idxd_dev);	\
+	(__idxd_dev)->wqcfg_offset + (n) * (__idxd_dev)->wqcfg_size + sizeof(u32) * (ofs);	\
+})
+
+#define WQCFG_STRIDES(_idxd_dev) ((_idxd_dev)->wqcfg_size / sizeof(u32))
+
 #endif
-- 
2.27.0



