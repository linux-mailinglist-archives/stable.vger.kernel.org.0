Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA5691214AC
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731120AbfLPSNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:13:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:60014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730943AbfLPSNg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:13:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FFCB207FF;
        Mon, 16 Dec 2019 18:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520015;
        bh=MApAn1LiFpmMMp7p7rG3AUeKjVGj+TJQna3hVUzD90k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dh4PXQtzkFONTUsdyusN7yKmcsz51nnGpndJxRqeHEnANC1v71Ro72aaTByB45yDa
         jJn0C56g8ANN2wjm4vBUUUhsOIJV+2mevax9gU6pBEhJM3ka9rn6LD82GlJC7olYqW
         WzWgnIOjb2wLjXU7/D+boTrxSwi6FQaCKXf1YhnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yabin Cui <yabinc@google.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.3 123/180] coresight: Serialize enabling/disabling a link device.
Date:   Mon, 16 Dec 2019 18:49:23 +0100
Message-Id: <20191216174841.052137087@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yabin Cui <yabinc@google.com>

commit edda32dabedb01f98b9d7b9a4492c13357834bbe upstream.

When tracing etm data of multiple threads on multiple cpus through perf
interface, some link devices are shared between paths of different cpus.
It creates race conditions when different cpus wants to enable/disable
the same link device at the same time.

Example 1:
Two cpus want to enable different ports of a coresight funnel, thus
calling the funnel enable operation at the same time. But the funnel
enable operation isn't reentrantable.

Example 2:
For an enabled coresight dynamic replicator with refcnt=1, one cpu wants
to disable it, while another cpu wants to enable it. Ideally we still have
an enabled replicator with refcnt=1 at the end. But in reality the result
is uncertain.

Since coresight devices claim themselves when enabled for self-hosted
usage, the race conditions above usually make the link devices not usable
after many cycles.

To fix the race conditions, this patch uses spinlocks to serialize
enabling/disabling link devices.

Fixes: a06ae8609b3d ("coresight: add CoreSight core layer framework")
Signed-off-by: Yabin Cui <yabinc@google.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: stable <stable@vger.kernel.org> # 5.3
Link: https://lore.kernel.org/r/20191104181251.26732-14-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/coresight/coresight-funnel.c     |   32 +++++++++++---
 drivers/hwtracing/coresight/coresight-replicator.c |   33 ++++++++++++--
 drivers/hwtracing/coresight/coresight-tmc-etf.c    |   26 ++++++++---
 drivers/hwtracing/coresight/coresight.c            |   47 ++++++---------------
 4 files changed, 88 insertions(+), 50 deletions(-)

--- a/drivers/hwtracing/coresight/coresight-funnel.c
+++ b/drivers/hwtracing/coresight/coresight-funnel.c
@@ -37,12 +37,14 @@ DEFINE_CORESIGHT_DEVLIST(funnel_devs, "f
  * @atclk:	optional clock for the core parts of the funnel.
  * @csdev:	component vitals needed by the framework.
  * @priority:	port selection order.
+ * @spinlock:	serialize enable/disable operations.
  */
 struct funnel_drvdata {
 	void __iomem		*base;
 	struct clk		*atclk;
 	struct coresight_device	*csdev;
 	unsigned long		priority;
+	spinlock_t		spinlock;
 };
 
 static int dynamic_funnel_enable_hw(struct funnel_drvdata *drvdata, int port)
@@ -75,11 +77,21 @@ static int funnel_enable(struct coresigh
 {
 	int rc = 0;
 	struct funnel_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+	unsigned long flags;
+	bool first_enable = false;
 
-	if (drvdata->base)
-		rc = dynamic_funnel_enable_hw(drvdata, inport);
-
+	spin_lock_irqsave(&drvdata->spinlock, flags);
+	if (atomic_read(&csdev->refcnt[inport]) == 0) {
+		if (drvdata->base)
+			rc = dynamic_funnel_enable_hw(drvdata, inport);
+		if (!rc)
+			first_enable = true;
+	}
 	if (!rc)
+		atomic_inc(&csdev->refcnt[inport]);
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+
+	if (first_enable)
 		dev_dbg(&csdev->dev, "FUNNEL inport %d enabled\n", inport);
 	return rc;
 }
@@ -106,11 +118,19 @@ static void funnel_disable(struct coresi
 			   int outport)
 {
 	struct funnel_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+	unsigned long flags;
+	bool last_disable = false;
 
-	if (drvdata->base)
-		dynamic_funnel_disable_hw(drvdata, inport);
+	spin_lock_irqsave(&drvdata->spinlock, flags);
+	if (atomic_dec_return(&csdev->refcnt[inport]) == 0) {
+		if (drvdata->base)
+			dynamic_funnel_disable_hw(drvdata, inport);
+		last_disable = true;
+	}
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
 
-	dev_dbg(&csdev->dev, "FUNNEL inport %d disabled\n", inport);
+	if (last_disable)
+		dev_dbg(&csdev->dev, "FUNNEL inport %d disabled\n", inport);
 }
 
 static const struct coresight_ops_link funnel_link_ops = {
--- a/drivers/hwtracing/coresight/coresight-replicator.c
+++ b/drivers/hwtracing/coresight/coresight-replicator.c
@@ -31,11 +31,13 @@ DEFINE_CORESIGHT_DEVLIST(replicator_devs
  *		whether this one is programmable or not.
  * @atclk:	optional clock for the core parts of the replicator.
  * @csdev:	component vitals needed by the framework
+ * @spinlock:	serialize enable/disable operations.
  */
 struct replicator_drvdata {
 	void __iomem		*base;
 	struct clk		*atclk;
 	struct coresight_device	*csdev;
+	spinlock_t		spinlock;
 };
 
 static void dynamic_replicator_reset(struct replicator_drvdata *drvdata)
@@ -97,10 +99,22 @@ static int replicator_enable(struct core
 {
 	int rc = 0;
 	struct replicator_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+	unsigned long flags;
+	bool first_enable = false;
 
-	if (drvdata->base)
-		rc = dynamic_replicator_enable(drvdata, inport, outport);
+	spin_lock_irqsave(&drvdata->spinlock, flags);
+	if (atomic_read(&csdev->refcnt[outport]) == 0) {
+		if (drvdata->base)
+			rc = dynamic_replicator_enable(drvdata, inport,
+						       outport);
+		if (!rc)
+			first_enable = true;
+	}
 	if (!rc)
+		atomic_inc(&csdev->refcnt[outport]);
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+
+	if (first_enable)
 		dev_dbg(&csdev->dev, "REPLICATOR enabled\n");
 	return rc;
 }
@@ -137,10 +151,19 @@ static void replicator_disable(struct co
 			       int outport)
 {
 	struct replicator_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+	unsigned long flags;
+	bool last_disable = false;
 
-	if (drvdata->base)
-		dynamic_replicator_disable(drvdata, inport, outport);
-	dev_dbg(&csdev->dev, "REPLICATOR disabled\n");
+	spin_lock_irqsave(&drvdata->spinlock, flags);
+	if (atomic_dec_return(&csdev->refcnt[outport]) == 0) {
+		if (drvdata->base)
+			dynamic_replicator_disable(drvdata, inport, outport);
+		last_disable = true;
+	}
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+
+	if (last_disable)
+		dev_dbg(&csdev->dev, "REPLICATOR disabled\n");
 }
 
 static const struct coresight_ops_link replicator_link_ops = {
--- a/drivers/hwtracing/coresight/coresight-tmc-etf.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-etf.c
@@ -334,9 +334,10 @@ static int tmc_disable_etf_sink(struct c
 static int tmc_enable_etf_link(struct coresight_device *csdev,
 			       int inport, int outport)
 {
-	int ret;
+	int ret = 0;
 	unsigned long flags;
 	struct tmc_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+	bool first_enable = false;
 
 	spin_lock_irqsave(&drvdata->spinlock, flags);
 	if (drvdata->reading) {
@@ -344,12 +345,18 @@ static int tmc_enable_etf_link(struct co
 		return -EBUSY;
 	}
 
-	ret = tmc_etf_enable_hw(drvdata);
+	if (atomic_read(&csdev->refcnt[0]) == 0) {
+		ret = tmc_etf_enable_hw(drvdata);
+		if (!ret) {
+			drvdata->mode = CS_MODE_SYSFS;
+			first_enable = true;
+		}
+	}
 	if (!ret)
-		drvdata->mode = CS_MODE_SYSFS;
+		atomic_inc(&csdev->refcnt[0]);
 	spin_unlock_irqrestore(&drvdata->spinlock, flags);
 
-	if (!ret)
+	if (first_enable)
 		dev_dbg(&csdev->dev, "TMC-ETF enabled\n");
 	return ret;
 }
@@ -359,6 +366,7 @@ static void tmc_disable_etf_link(struct
 {
 	unsigned long flags;
 	struct tmc_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+	bool last_disable = false;
 
 	spin_lock_irqsave(&drvdata->spinlock, flags);
 	if (drvdata->reading) {
@@ -366,11 +374,15 @@ static void tmc_disable_etf_link(struct
 		return;
 	}
 
-	tmc_etf_disable_hw(drvdata);
-	drvdata->mode = CS_MODE_DISABLED;
+	if (atomic_dec_return(&csdev->refcnt[0]) == 0) {
+		tmc_etf_disable_hw(drvdata);
+		drvdata->mode = CS_MODE_DISABLED;
+		last_disable = true;
+	}
 	spin_unlock_irqrestore(&drvdata->spinlock, flags);
 
-	dev_dbg(&csdev->dev, "TMC-ETF disabled\n");
+	if (last_disable)
+		dev_dbg(&csdev->dev, "TMC-ETF disabled\n");
 }
 
 static void *tmc_alloc_etf_buffer(struct coresight_device *csdev,
--- a/drivers/hwtracing/coresight/coresight.c
+++ b/drivers/hwtracing/coresight/coresight.c
@@ -253,9 +253,9 @@ static int coresight_enable_link(struct
 				 struct coresight_device *parent,
 				 struct coresight_device *child)
 {
-	int ret;
+	int ret = 0;
 	int link_subtype;
-	int refport, inport, outport;
+	int inport, outport;
 
 	if (!parent || !child)
 		return -EINVAL;
@@ -264,29 +264,17 @@ static int coresight_enable_link(struct
 	outport = coresight_find_link_outport(csdev, child);
 	link_subtype = csdev->subtype.link_subtype;
 
-	if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_MERG)
-		refport = inport;
-	else if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_SPLIT)
-		refport = outport;
-	else
-		refport = 0;
-
-	if (refport < 0)
-		return refport;
-
-	if (atomic_inc_return(&csdev->refcnt[refport]) == 1) {
-		if (link_ops(csdev)->enable) {
-			ret = link_ops(csdev)->enable(csdev, inport, outport);
-			if (ret) {
-				atomic_dec(&csdev->refcnt[refport]);
-				return ret;
-			}
-		}
-	}
-
-	csdev->enable = true;
+	if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_MERG && inport < 0)
+		return inport;
+	if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_SPLIT && outport < 0)
+		return outport;
+
+	if (link_ops(csdev)->enable)
+		ret = link_ops(csdev)->enable(csdev, inport, outport);
+	if (!ret)
+		csdev->enable = true;
 
-	return 0;
+	return ret;
 }
 
 static void coresight_disable_link(struct coresight_device *csdev,
@@ -295,7 +283,7 @@ static void coresight_disable_link(struc
 {
 	int i, nr_conns;
 	int link_subtype;
-	int refport, inport, outport;
+	int inport, outport;
 
 	if (!parent || !child)
 		return;
@@ -305,20 +293,15 @@ static void coresight_disable_link(struc
 	link_subtype = csdev->subtype.link_subtype;
 
 	if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_MERG) {
-		refport = inport;
 		nr_conns = csdev->pdata->nr_inport;
 	} else if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_SPLIT) {
-		refport = outport;
 		nr_conns = csdev->pdata->nr_outport;
 	} else {
-		refport = 0;
 		nr_conns = 1;
 	}
 
-	if (atomic_dec_return(&csdev->refcnt[refport]) == 0) {
-		if (link_ops(csdev)->disable)
-			link_ops(csdev)->disable(csdev, inport, outport);
-	}
+	if (link_ops(csdev)->disable)
+		link_ops(csdev)->disable(csdev, inport, outport);
 
 	for (i = 0; i < nr_conns; i++)
 		if (atomic_read(&csdev->refcnt[i]) != 0)


