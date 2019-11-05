Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA1E6EF590
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 07:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbfKEGgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 01:36:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:49380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725806AbfKEGgW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 01:36:22 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55DE92084D;
        Tue,  5 Nov 2019 06:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572935780;
        bh=Embf2CZpAblzJhAAQrJsZOZXCCR9pTKT+WrRf+KTiy0=;
        h=Subject:To:From:Date:From;
        b=dZHRX4YtHXeGvyf0l/F4/lq+GDTq4e4xbCYguOaUDY0pGDcvcfnLSc1IY2TM/suX+
         KXuoUs+tMw92xaG59iHbJryFBuyW9BKabUf6D8u245OSCtBHt2SXW7ld31bpmRPg+t
         23waJNAnSEQc2vFwQ63uOCfZ+42hyn1XQK5tSThk=
Subject: patch "coresight: Serialize enabling/disabling a link device." added to char-misc-next
To:     yabinc@google.com, gregkh@linuxfoundation.org,
        mathieu.poirier@linaro.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 Nov 2019 07:34:49 +0100
Message-ID: <1572935689211147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    coresight: Serialize enabling/disabling a link device.

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From edda32dabedb01f98b9d7b9a4492c13357834bbe Mon Sep 17 00:00:00 2001
From: Yabin Cui <yabinc@google.com>
Date: Mon, 4 Nov 2019 11:12:50 -0700
Subject: coresight: Serialize enabling/disabling a link device.

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
 .../hwtracing/coresight/coresight-funnel.c    | 36 +++++++++++----
 .../coresight/coresight-replicator.c          | 35 ++++++++++++---
 .../hwtracing/coresight/coresight-tmc-etf.c   | 26 ++++++++---
 drivers/hwtracing/coresight/coresight.c       | 45 ++++++-------------
 4 files changed, 90 insertions(+), 52 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-funnel.c b/drivers/hwtracing/coresight/coresight-funnel.c
index 05f7896c3a01..b605889b507a 100644
--- a/drivers/hwtracing/coresight/coresight-funnel.c
+++ b/drivers/hwtracing/coresight/coresight-funnel.c
@@ -38,12 +38,14 @@ DEFINE_CORESIGHT_DEVLIST(funnel_devs, "funnel");
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
@@ -76,11 +78,21 @@ static int funnel_enable(struct coresight_device *csdev, int inport,
 {
 	int rc = 0;
 	struct funnel_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
-
-	if (drvdata->base)
-		rc = dynamic_funnel_enable_hw(drvdata, inport);
-
+	unsigned long flags;
+	bool first_enable = false;
+
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
@@ -107,11 +119,19 @@ static void funnel_disable(struct coresight_device *csdev, int inport,
 			   int outport)
 {
 	struct funnel_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+	unsigned long flags;
+	bool last_disable = false;
+
+	spin_lock_irqsave(&drvdata->spinlock, flags);
+	if (atomic_dec_return(&csdev->refcnt[inport]) == 0) {
+		if (drvdata->base)
+			dynamic_funnel_disable_hw(drvdata, inport);
+		last_disable = true;
+	}
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
 
-	if (drvdata->base)
-		dynamic_funnel_disable_hw(drvdata, inport);
-
-	dev_dbg(&csdev->dev, "FUNNEL inport %d disabled\n", inport);
+	if (last_disable)
+		dev_dbg(&csdev->dev, "FUNNEL inport %d disabled\n", inport);
 }
 
 static const struct coresight_ops_link funnel_link_ops = {
diff --git a/drivers/hwtracing/coresight/coresight-replicator.c b/drivers/hwtracing/coresight/coresight-replicator.c
index b29ba640eb25..43304196a1a6 100644
--- a/drivers/hwtracing/coresight/coresight-replicator.c
+++ b/drivers/hwtracing/coresight/coresight-replicator.c
@@ -31,11 +31,13 @@ DEFINE_CORESIGHT_DEVLIST(replicator_devs, "replicator");
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
@@ -97,10 +99,22 @@ static int replicator_enable(struct coresight_device *csdev, int inport,
 {
 	int rc = 0;
 	struct replicator_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
-
-	if (drvdata->base)
-		rc = dynamic_replicator_enable(drvdata, inport, outport);
+	unsigned long flags;
+	bool first_enable = false;
+
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
@@ -137,10 +151,19 @@ static void replicator_disable(struct coresight_device *csdev, int inport,
 			       int outport)
 {
 	struct replicator_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+	unsigned long flags;
+	bool last_disable = false;
+
+	spin_lock_irqsave(&drvdata->spinlock, flags);
+	if (atomic_dec_return(&csdev->refcnt[outport]) == 0) {
+		if (drvdata->base)
+			dynamic_replicator_disable(drvdata, inport, outport);
+		last_disable = true;
+	}
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
 
-	if (drvdata->base)
-		dynamic_replicator_disable(drvdata, inport, outport);
-	dev_dbg(&csdev->dev, "REPLICATOR disabled\n");
+	if (last_disable)
+		dev_dbg(&csdev->dev, "REPLICATOR disabled\n");
 }
 
 static const struct coresight_ops_link replicator_link_ops = {
diff --git a/drivers/hwtracing/coresight/coresight-tmc-etf.c b/drivers/hwtracing/coresight/coresight-tmc-etf.c
index 807416b75ecc..d0cc3985b72a 100644
--- a/drivers/hwtracing/coresight/coresight-tmc-etf.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-etf.c
@@ -334,9 +334,10 @@ static int tmc_disable_etf_sink(struct coresight_device *csdev)
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
@@ -344,12 +345,18 @@ static int tmc_enable_etf_link(struct coresight_device *csdev,
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
@@ -359,6 +366,7 @@ static void tmc_disable_etf_link(struct coresight_device *csdev,
 {
 	unsigned long flags;
 	struct tmc_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+	bool last_disable = false;
 
 	spin_lock_irqsave(&drvdata->spinlock, flags);
 	if (drvdata->reading) {
@@ -366,11 +374,15 @@ static void tmc_disable_etf_link(struct coresight_device *csdev,
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
diff --git a/drivers/hwtracing/coresight/coresight.c b/drivers/hwtracing/coresight/coresight.c
index e6ca899fea4e..ef20f74c85fa 100644
--- a/drivers/hwtracing/coresight/coresight.c
+++ b/drivers/hwtracing/coresight/coresight.c
@@ -253,9 +253,9 @@ static int coresight_enable_link(struct coresight_device *csdev,
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
@@ -264,29 +264,17 @@ static int coresight_enable_link(struct coresight_device *csdev,
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
+	if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_MERG && inport < 0)
+		return inport;
+	if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_SPLIT && outport < 0)
+		return outport;
 
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
+	if (link_ops(csdev)->enable)
+		ret = link_ops(csdev)->enable(csdev, inport, outport);
+	if (!ret)
+		csdev->enable = true;
 
-	return 0;
+	return ret;
 }
 
 static void coresight_disable_link(struct coresight_device *csdev,
@@ -295,7 +283,7 @@ static void coresight_disable_link(struct coresight_device *csdev,
 {
 	int i, nr_conns;
 	int link_subtype;
-	int refport, inport, outport;
+	int inport, outport;
 
 	if (!parent || !child)
 		return;
@@ -305,20 +293,15 @@ static void coresight_disable_link(struct coresight_device *csdev,
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
-- 
2.23.0


