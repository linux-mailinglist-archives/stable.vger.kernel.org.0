Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F452A592D
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730524AbgKCUm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:42:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:54636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730512AbgKCUm0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:42:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D90F92224E;
        Tue,  3 Nov 2020 20:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436145;
        bh=21+ewuTa5wyniFozU/IuS2zgpY0tSE0mI44UGqmQujo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TxgBXppA9aNBuXZnxKeB6i/0lqvTWGVy9graPoCRRII81EaG8TqF3cv1EVb8XBl/O
         zSDBDCPq9DIIqhiSZh09TvoXDehVTeASIWQB/x9oO3y6ZkMjLToUvXZeF0B7+4Kll4
         E8jxf3lgdxlwOJ/hS9EaWYlSnABS/L75Gs7NMww0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Sean Nyekjaer <sean@geanix.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 122/391] can: flexcan: disable clocks during stop mode
Date:   Tue,  3 Nov 2020 21:32:53 +0100
Message-Id: <20201103203355.057274785@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

[ Upstream commit 02f71c6605e1f8259c07f16178330db766189a74 ]

Disable clocks while CAN core is in stop mode.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Tested-by: Sean Nyekjaer <sean@geanix.com>
Link: https://lore.kernel.org/r/20191210085721.9853-2-qiangqing.zhang@nxp.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/flexcan.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 2ac7a667bde35..bc21a82cf3a76 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1722,8 +1722,6 @@ static int __maybe_unused flexcan_suspend(struct device *device)
 			err = flexcan_chip_disable(priv);
 			if (err)
 				return err;
-
-			err = pm_runtime_force_suspend(device);
 		}
 		netif_stop_queue(dev);
 		netif_device_detach(dev);
@@ -1749,10 +1747,6 @@ static int __maybe_unused flexcan_resume(struct device *device)
 			if (err)
 				return err;
 		} else {
-			err = pm_runtime_force_resume(device);
-			if (err)
-				return err;
-
 			err = flexcan_chip_enable(priv);
 		}
 	}
@@ -1783,8 +1777,16 @@ static int __maybe_unused flexcan_noirq_suspend(struct device *device)
 	struct net_device *dev = dev_get_drvdata(device);
 	struct flexcan_priv *priv = netdev_priv(dev);
 
-	if (netif_running(dev) && device_may_wakeup(device))
-		flexcan_enable_wakeup_irq(priv, true);
+	if (netif_running(dev)) {
+		int err;
+
+		if (device_may_wakeup(device))
+			flexcan_enable_wakeup_irq(priv, true);
+
+		err = pm_runtime_force_suspend(device);
+		if (err)
+			return err;
+	}
 
 	return 0;
 }
@@ -1794,8 +1796,16 @@ static int __maybe_unused flexcan_noirq_resume(struct device *device)
 	struct net_device *dev = dev_get_drvdata(device);
 	struct flexcan_priv *priv = netdev_priv(dev);
 
-	if (netif_running(dev) && device_may_wakeup(device))
-		flexcan_enable_wakeup_irq(priv, false);
+	if (netif_running(dev)) {
+		int err;
+
+		err = pm_runtime_force_resume(device);
+		if (err)
+			return err;
+
+		if (device_may_wakeup(device))
+			flexcan_enable_wakeup_irq(priv, false);
+	}
 
 	return 0;
 }
-- 
2.27.0



