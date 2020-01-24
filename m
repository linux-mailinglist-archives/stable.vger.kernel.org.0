Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C72AB14818C
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390779AbgAXLUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:20:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:58752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390751AbgAXLUy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:20:54 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0421B206D4;
        Fri, 24 Jan 2020 11:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864853;
        bh=+RoMhEj+9YhQFXke/bEqHkiatIjCEXPSaEiIlHVDllQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HpvQRz9ePLxTSsjO1IoxECyB9K3JK+G22L0SAS0LJkRaZJNb5C2aSDkfgla+msChG
         5GkEkA39M0K2OIDWNCKLPo0NWBJ9dFyI6IBNO50ODEqodujZRsAMrJcWslS+BZ20hO
         +riwZIPbOI+0g5RgORSGK44ytU0NQlwWO9hNd4MY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiada Wang <jiada_wang@mentor.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Eduardo Valentin <edubezval@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 372/639] thermal: rcar_gen3_thermal: fix interrupt type
Date:   Fri, 24 Jan 2020 10:29:02 +0100
Message-Id: <20200124093133.632629463@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiada Wang <jiada_wang@mentor.com>

[ Upstream commit 2c0928c9e004589dc9e7672c40a38d6c4ca12701 ]

Currently IRQF_SHARED type interrupt line is allocated, but it
is not appropriate, as the interrupt line isn't shared between
different devices, instead IRQF_ONESHOT is the proper type.

By changing interrupt type to IRQF_ONESHOT, now irq handler is
no longer needed, as clear of interrupt status can be done in
threaded interrupt context.

Because IRQF_ONESHOT type interrupt line is kept disabled until
the threaded handler has been run, so there is no need to protect
read/write of REG_GEN3_IRQSTR with lock.

Fixes: 7d4b269776ec6 ("enable hardware interrupts for trip points")
Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Tested-by: Simon Horman <horms+renesas@verge.net.au>
Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Eduardo Valentin <edubezval@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/rcar_gen3_thermal.c | 38 +++++------------------------
 1 file changed, 6 insertions(+), 32 deletions(-)

diff --git a/drivers/thermal/rcar_gen3_thermal.c b/drivers/thermal/rcar_gen3_thermal.c
index 704c8ad045bb5..8f553453dd7fc 100644
--- a/drivers/thermal/rcar_gen3_thermal.c
+++ b/drivers/thermal/rcar_gen3_thermal.c
@@ -14,7 +14,6 @@
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
-#include <linux/spinlock.h>
 #include <linux/sys_soc.h>
 #include <linux/thermal.h>
 
@@ -81,7 +80,6 @@ struct rcar_gen3_thermal_tsc {
 struct rcar_gen3_thermal_priv {
 	struct rcar_gen3_thermal_tsc *tscs[TSC_MAX_NUM];
 	unsigned int num_tscs;
-	spinlock_t lock; /* Protect interrupts on and off */
 	void (*thermal_init)(struct rcar_gen3_thermal_tsc *tsc);
 };
 
@@ -231,38 +229,16 @@ static irqreturn_t rcar_gen3_thermal_irq(int irq, void *data)
 {
 	struct rcar_gen3_thermal_priv *priv = data;
 	u32 status;
-	int i, ret = IRQ_HANDLED;
+	int i;
 
-	spin_lock(&priv->lock);
 	for (i = 0; i < priv->num_tscs; i++) {
 		status = rcar_gen3_thermal_read(priv->tscs[i], REG_GEN3_IRQSTR);
 		rcar_gen3_thermal_write(priv->tscs[i], REG_GEN3_IRQSTR, 0);
 		if (status)
-			ret = IRQ_WAKE_THREAD;
+			thermal_zone_device_update(priv->tscs[i]->zone,
+						   THERMAL_EVENT_UNSPECIFIED);
 	}
 
-	if (ret == IRQ_WAKE_THREAD)
-		rcar_thermal_irq_set(priv, false);
-
-	spin_unlock(&priv->lock);
-
-	return ret;
-}
-
-static irqreturn_t rcar_gen3_thermal_irq_thread(int irq, void *data)
-{
-	struct rcar_gen3_thermal_priv *priv = data;
-	unsigned long flags;
-	int i;
-
-	for (i = 0; i < priv->num_tscs; i++)
-		thermal_zone_device_update(priv->tscs[i]->zone,
-					   THERMAL_EVENT_UNSPECIFIED);
-
-	spin_lock_irqsave(&priv->lock, flags);
-	rcar_thermal_irq_set(priv, true);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
 	return IRQ_HANDLED;
 }
 
@@ -364,8 +340,6 @@ static int rcar_gen3_thermal_probe(struct platform_device *pdev)
 	if (soc_device_match(r8a7795es1))
 		priv->thermal_init = rcar_gen3_thermal_init_r8a7795es1;
 
-	spin_lock_init(&priv->lock);
-
 	platform_set_drvdata(pdev, priv);
 
 	/*
@@ -383,9 +357,9 @@ static int rcar_gen3_thermal_probe(struct platform_device *pdev)
 		if (!irqname)
 			return -ENOMEM;
 
-		ret = devm_request_threaded_irq(dev, irq, rcar_gen3_thermal_irq,
-						rcar_gen3_thermal_irq_thread,
-						IRQF_SHARED, irqname, priv);
+		ret = devm_request_threaded_irq(dev, irq, NULL,
+						rcar_gen3_thermal_irq,
+						IRQF_ONESHOT, irqname, priv);
 		if (ret)
 			return ret;
 	}
-- 
2.20.1



