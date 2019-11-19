Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4A8101505
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbfKSFju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:39:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:33876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729029AbfKSFju (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:39:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 442AC208C3;
        Tue, 19 Nov 2019 05:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141988;
        bh=6gzoZfx52S5asSThLZ4H9TrQfRFPQlE5mcur+nGG4gA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yVOXeVXcqAQmrwsUeTnT2lS/hzmwR3h9lsZk/vwfUB9i2beE3NBiHMZHb+GGraM3J
         OuMGx12BDfhOr167tQurqjWHo4grJNupMone739IeKeqJs3mzi81VVYJ5NOEhNxRVP
         XTIkq/VTXRL5BoWUQc9vPF8qecKnIu/GaTPfN7Wc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 348/422] coresight: tmc-etr: Handle driver mode specific ETR buffers
Date:   Tue, 19 Nov 2019 06:19:05 +0100
Message-Id: <20191119051421.561782393@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 96a7f644006ecc05eaaa1a5d09373d0ee63beb0a ]

Since the ETR could be driven either by SYSFS or by perf, it
becomes complicated how we deal with the buffers used for each
of these modes. The ETR driver cannot simply free the current
attached buffer without knowing the provider (i.e, sysfs vs perf).

To solve this issue, we provide:
1) the driver-mode specific etr buffer to be retained in the drvdata
2) the etr_buf for a session should be passed on when enabling the
   hardware, which will be stored in drvdata->etr_buf. This will be
   replaced (not free'd) as soon as the hardware is disabled, after
   necessary sync operation.

The advantages of this are :

1) The common code path doesn't need to worry about how to dispose
   an existing buffer, if it is about to start a new session with a
   different buffer, possibly in a different mode.
2) The driver mode can control its buffers and can get access to the
   saved session even when the hardware is operating in a different
   mode. (e.g, we can still access a trace buffer from a sysfs mode
   even if the etr is now used in perf mode, without disrupting the
   current session.)

Towards this, we introduce a sysfs specific data which will hold the
etr_buf used for sysfs mode of operation, controlled solely by the
sysfs mode handling code.

Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hwtracing/coresight/coresight-tmc-etr.c   | 58 ++++++++++++-------
 drivers/hwtracing/coresight/coresight-tmc.h   |  2 +
 2 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-tmc-etr.c b/drivers/hwtracing/coresight/coresight-tmc-etr.c
index 11963647e19ae..2d6f428176ff8 100644
--- a/drivers/hwtracing/coresight/coresight-tmc-etr.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-etr.c
@@ -895,10 +895,15 @@ static void tmc_sync_etr_buf(struct tmc_drvdata *drvdata)
 		tmc_etr_buf_insert_barrier_packet(etr_buf, etr_buf->offset);
 }
 
-static void tmc_etr_enable_hw(struct tmc_drvdata *drvdata)
+static void tmc_etr_enable_hw(struct tmc_drvdata *drvdata,
+			      struct etr_buf *etr_buf)
 {
 	u32 axictl, sts;
-	struct etr_buf *etr_buf = drvdata->etr_buf;
+
+	/* Callers should provide an appropriate buffer for use */
+	if (WARN_ON(!etr_buf || drvdata->etr_buf))
+		return;
+	drvdata->etr_buf = etr_buf;
 
 	/*
 	 * If this ETR is connected to a CATU, enable it before we turn
@@ -960,13 +965,16 @@ static void tmc_etr_enable_hw(struct tmc_drvdata *drvdata)
  * also updating the @bufpp on where to find it. Since the trace data
  * starts at anywhere in the buffer, depending on the RRP, we adjust the
  * @len returned to handle buffer wrapping around.
+ *
+ * We are protected here by drvdata->reading != 0, which ensures the
+ * sysfs_buf stays alive.
  */
 ssize_t tmc_etr_get_sysfs_trace(struct tmc_drvdata *drvdata,
 				loff_t pos, size_t len, char **bufpp)
 {
 	s64 offset;
 	ssize_t actual = len;
-	struct etr_buf *etr_buf = drvdata->etr_buf;
+	struct etr_buf *etr_buf = drvdata->sysfs_buf;
 
 	if (pos + actual > etr_buf->len)
 		actual = etr_buf->len - pos;
@@ -996,7 +1004,14 @@ tmc_etr_free_sysfs_buf(struct etr_buf *buf)
 
 static void tmc_etr_sync_sysfs_buf(struct tmc_drvdata *drvdata)
 {
-	tmc_sync_etr_buf(drvdata);
+	struct etr_buf *etr_buf = drvdata->etr_buf;
+
+	if (WARN_ON(drvdata->sysfs_buf != etr_buf)) {
+		tmc_etr_free_sysfs_buf(drvdata->sysfs_buf);
+		drvdata->sysfs_buf = NULL;
+	} else {
+		tmc_sync_etr_buf(drvdata);
+	}
 }
 
 static void tmc_etr_disable_hw(struct tmc_drvdata *drvdata)
@@ -1017,6 +1032,8 @@ static void tmc_etr_disable_hw(struct tmc_drvdata *drvdata)
 
 	/* Disable CATU device if this ETR is connected to one */
 	tmc_etr_disable_catu(drvdata);
+	/* Reset the ETR buf used by hardware */
+	drvdata->etr_buf = NULL;
 }
 
 static int tmc_enable_etr_sink_sysfs(struct coresight_device *csdev)
@@ -1024,7 +1041,7 @@ static int tmc_enable_etr_sink_sysfs(struct coresight_device *csdev)
 	int ret = 0;
 	unsigned long flags;
 	struct tmc_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
-	struct etr_buf *new_buf = NULL, *free_buf = NULL;
+	struct etr_buf *sysfs_buf = NULL, *new_buf = NULL, *free_buf = NULL;
 
 	/*
 	 * If we are enabling the ETR from disabled state, we need to make
@@ -1035,7 +1052,8 @@ static int tmc_enable_etr_sink_sysfs(struct coresight_device *csdev)
 	 * with the lock released.
 	 */
 	spin_lock_irqsave(&drvdata->spinlock, flags);
-	if (!drvdata->etr_buf || (drvdata->etr_buf->size != drvdata->size)) {
+	sysfs_buf = READ_ONCE(drvdata->sysfs_buf);
+	if (!sysfs_buf || (sysfs_buf->size != drvdata->size)) {
 		spin_unlock_irqrestore(&drvdata->spinlock, flags);
 
 		/* Allocate memory with the locks released */
@@ -1064,14 +1082,14 @@ static int tmc_enable_etr_sink_sysfs(struct coresight_device *csdev)
 	 * If we don't have a buffer or it doesn't match the requested size,
 	 * use the buffer allocated above. Otherwise reuse the existing buffer.
 	 */
-	if (!drvdata->etr_buf ||
-	    (new_buf && drvdata->etr_buf->size != new_buf->size)) {
-		free_buf = drvdata->etr_buf;
-		drvdata->etr_buf = new_buf;
+	sysfs_buf = READ_ONCE(drvdata->sysfs_buf);
+	if (!sysfs_buf || (new_buf && sysfs_buf->size != new_buf->size)) {
+		free_buf = sysfs_buf;
+		drvdata->sysfs_buf = new_buf;
 	}
 
 	drvdata->mode = CS_MODE_SYSFS;
-	tmc_etr_enable_hw(drvdata);
+	tmc_etr_enable_hw(drvdata, drvdata->sysfs_buf);
 out:
 	spin_unlock_irqrestore(&drvdata->spinlock, flags);
 
@@ -1156,13 +1174,13 @@ int tmc_read_prepare_etr(struct tmc_drvdata *drvdata)
 		goto out;
 	}
 
-	/* If drvdata::etr_buf is NULL the trace data has been read already */
-	if (drvdata->etr_buf == NULL) {
+	/* If sysfs_buf is NULL the trace data has been read already */
+	if (!drvdata->sysfs_buf) {
 		ret = -EINVAL;
 		goto out;
 	}
 
-	/* Disable the TMC if need be */
+	/* Disable the TMC if we are trying to read from a running session */
 	if (drvdata->mode == CS_MODE_SYSFS)
 		tmc_etr_disable_hw(drvdata);
 
@@ -1176,7 +1194,7 @@ out:
 int tmc_read_unprepare_etr(struct tmc_drvdata *drvdata)
 {
 	unsigned long flags;
-	struct etr_buf *etr_buf = NULL;
+	struct etr_buf *sysfs_buf = NULL;
 
 	/* config types are set a boot time and never change */
 	if (WARN_ON_ONCE(drvdata->config_type != TMC_CONFIG_TYPE_ETR))
@@ -1191,22 +1209,22 @@ int tmc_read_unprepare_etr(struct tmc_drvdata *drvdata)
 		 * buffer. Since the tracer is still enabled drvdata::buf can't
 		 * be NULL.
 		 */
-		tmc_etr_enable_hw(drvdata);
+		tmc_etr_enable_hw(drvdata, drvdata->sysfs_buf);
 	} else {
 		/*
 		 * The ETR is not tracing and the buffer was just read.
 		 * As such prepare to free the trace buffer.
 		 */
-		etr_buf =  drvdata->etr_buf;
-		drvdata->etr_buf = NULL;
+		sysfs_buf = drvdata->sysfs_buf;
+		drvdata->sysfs_buf = NULL;
 	}
 
 	drvdata->reading = false;
 	spin_unlock_irqrestore(&drvdata->spinlock, flags);
 
 	/* Free allocated memory out side of the spinlock */
-	if (etr_buf)
-		tmc_free_etr_buf(etr_buf);
+	if (sysfs_buf)
+		tmc_etr_free_sysfs_buf(sysfs_buf);
 
 	return 0;
 }
diff --git a/drivers/hwtracing/coresight/coresight-tmc.h b/drivers/hwtracing/coresight/coresight-tmc.h
index 7027bd60c4cc8..872f63e3651ba 100644
--- a/drivers/hwtracing/coresight/coresight-tmc.h
+++ b/drivers/hwtracing/coresight/coresight-tmc.h
@@ -170,6 +170,7 @@ struct etr_buf {
  * @trigger_cntr: amount of words to store after a trigger.
  * @etr_caps:	Bitmask of capabilities of the TMC ETR, inferred from the
  *		device configuration register (DEVID)
+ * @sysfs_data:	SYSFS buffer for ETR.
  */
 struct tmc_drvdata {
 	void __iomem		*base;
@@ -189,6 +190,7 @@ struct tmc_drvdata {
 	enum tmc_mem_intf_width	memwidth;
 	u32			trigger_cntr;
 	u32			etr_caps;
+	struct etr_buf		*sysfs_buf;
 };
 
 struct etr_buf_operations {
-- 
2.20.1



