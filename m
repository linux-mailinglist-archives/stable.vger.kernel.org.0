Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 841AC13F558
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389173AbgAPRH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:07:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:39336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389169AbgAPRH1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:07:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 015F12081E;
        Thu, 16 Jan 2020 17:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194446;
        bh=hBuBI2R1N9tqyEoCpNH88R2pYUVEAJ7+0Sj6SoGPYp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ic5kAoWMYAX4kbzHpbFz5s0TvBiRKN7gC7mkXTflkmLNIYCKvWAPg4Fzte5MRqTyz
         jlpzPW1v/2oiXShTIEzGVjZSHzy6EnVNQH7ne7qwa/ut8AjArxNw6vfB9fnxWx7NGZ
         FZCcQG2NF2cPKlzk8BiEp2swTVViGH7UXNL4CuAo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiada Wang <jiada_wang@mentor.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Eduardo Valentin <edubezval@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 357/671] thermal: rcar_gen3_thermal: fix interrupt type
Date:   Thu, 16 Jan 2020 11:59:55 -0500
Message-Id: <20200116170509.12787-94-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 704c8ad045bb..8f553453dd7f 100644
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

