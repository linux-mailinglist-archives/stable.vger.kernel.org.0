Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1424DF65F4
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbfKJCno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:43:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:42296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728402AbfKJCnm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:43:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5584521924;
        Sun, 10 Nov 2019 02:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353822;
        bh=Si7KddTlpBoJb+HqiYLW4wmn16wkQOtypJpyIXeDOJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zqXVHjBS6wgjr2kdwZMCVsK/TVBhclom43LgObfOkjl2DhLgl99LcCKpzp+QFveSf
         G0hi+e2PkLX+CkOEHEoAie1ztU7KSlAriVcaTVx/bPnL5EH4bgGdCY9yPhq3rcGpVS
         sagzCAcxqWkAeUdtKwYji+eRN+70QNcoj5aBuDm0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 117/191] coresight: dynamic-replicator: Handle multiple connections
Date:   Sat,  9 Nov 2019 21:38:59 -0500
Message-Id: <20191110024013.29782-117-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 30af4fb619e5126cb3152072e687b377fc9398d6 ]

When a replicator port is enabled, we block the traffic
on the other port and route all traffic to the new enabled
port. If there are two active trace sessions each targeting
the two different paths from the replicator, the second session
will disable the first session and route all the data to the
second path.
                    ETR
                 /
e.g, replicator
                 \
                    ETB

If CPU0 is operated in sysfs mode to ETR and CPU1 is operated
in perf mode to ETB, depending on the order in which the
replicator is enabled one device is blocked.

Ideally we need trace-id for the session to make the
right choice. That implies we need a trace-id allocation
logic for the coresight subsystem and use that to route
the traffic. The short term solution is to only manage
the "target port" and leave the other port untouched.
That leaves both the paths unaffected, except that some
unwanted traffic may be pushed to the paths (if the Trace-IDs
are not far enough), which is still fine and can be filtered
out while processing rather than silently blocking the data.

Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../coresight/coresight-dynamic-replicator.c  | 64 ++++++++++++++-----
 1 file changed, 47 insertions(+), 17 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-dynamic-replicator.c b/drivers/hwtracing/coresight/coresight-dynamic-replicator.c
index f6d0571ab9dd5..d31f1d8758b24 100644
--- a/drivers/hwtracing/coresight/coresight-dynamic-replicator.c
+++ b/drivers/hwtracing/coresight/coresight-dynamic-replicator.c
@@ -34,26 +34,42 @@ struct replicator_state {
 	struct coresight_device	*csdev;
 };
 
+/*
+ * replicator_reset : Reset the replicator configuration to sane values.
+ */
+static void replicator_reset(struct replicator_state *drvdata)
+{
+	CS_UNLOCK(drvdata->base);
+
+	writel_relaxed(0xff, drvdata->base + REPLICATOR_IDFILTER0);
+	writel_relaxed(0xff, drvdata->base + REPLICATOR_IDFILTER1);
+
+	CS_LOCK(drvdata->base);
+}
+
 static int replicator_enable(struct coresight_device *csdev, int inport,
 			      int outport)
 {
+	u32 reg;
 	struct replicator_state *drvdata = dev_get_drvdata(csdev->dev.parent);
 
+	switch (outport) {
+	case 0:
+		reg = REPLICATOR_IDFILTER0;
+		break;
+	case 1:
+		reg = REPLICATOR_IDFILTER1;
+		break;
+	default:
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
 	CS_UNLOCK(drvdata->base);
 
-	/*
-	 * Ensure that the other port is disabled
-	 * 0x00 - passing through the replicator unimpeded
-	 * 0xff - disable (or impede) the flow of ATB data
-	 */
-	if (outport == 0) {
-		writel_relaxed(0x00, drvdata->base + REPLICATOR_IDFILTER0);
-		writel_relaxed(0xff, drvdata->base + REPLICATOR_IDFILTER1);
-	} else {
-		writel_relaxed(0x00, drvdata->base + REPLICATOR_IDFILTER1);
-		writel_relaxed(0xff, drvdata->base + REPLICATOR_IDFILTER0);
-	}
 
+	/* Ensure that the outport is enabled. */
+	writel_relaxed(0x00, drvdata->base + reg);
 	CS_LOCK(drvdata->base);
 
 	dev_info(drvdata->dev, "REPLICATOR enabled\n");
@@ -63,15 +79,25 @@ static int replicator_enable(struct coresight_device *csdev, int inport,
 static void replicator_disable(struct coresight_device *csdev, int inport,
 				int outport)
 {
+	u32 reg;
 	struct replicator_state *drvdata = dev_get_drvdata(csdev->dev.parent);
 
+	switch (outport) {
+	case 0:
+		reg = REPLICATOR_IDFILTER0;
+		break;
+	case 1:
+		reg = REPLICATOR_IDFILTER1;
+		break;
+	default:
+		WARN_ON(1);
+		return;
+	}
+
 	CS_UNLOCK(drvdata->base);
 
 	/* disable the flow of ATB data through port */
-	if (outport == 0)
-		writel_relaxed(0xff, drvdata->base + REPLICATOR_IDFILTER0);
-	else
-		writel_relaxed(0xff, drvdata->base + REPLICATOR_IDFILTER1);
+	writel_relaxed(0xff, drvdata->base + reg);
 
 	CS_LOCK(drvdata->base);
 
@@ -156,7 +182,11 @@ static int replicator_probe(struct amba_device *adev, const struct amba_id *id)
 	desc.groups = replicator_groups;
 	drvdata->csdev = coresight_register(&desc);
 
-	return PTR_ERR_OR_ZERO(drvdata->csdev);
+	if (!IS_ERR(drvdata->csdev)) {
+		replicator_reset(drvdata);
+		return 0;
+	}
+	return PTR_ERR(drvdata->csdev);
 }
 
 #ifdef CONFIG_PM
-- 
2.20.1

