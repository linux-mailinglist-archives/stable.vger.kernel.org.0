Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0684B2A577F
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732240AbgKCVm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:42:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:55318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732227AbgKCUzL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:55:11 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CE9C223BD;
        Tue,  3 Nov 2020 20:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436910;
        bh=Yccps9gYgPKpigz26JRSlXIy0z/IxumpcoIbGKZUwcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nLUJheRKFwMW6kv/OA4LdG9oEV3C0vpPSiR6FlqppYIjynfJDodYg5Dzltex8SD2Q
         71Aaeufh+SpZEtTMN4SqEDp4iYqH16/oVwdnFMrOlCXioZ0i9+a5XpOOFEfiTLfn10
         d5DsSZyz0fmfl62+zY14dx+8AcwOGYQRHojwuRso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Sean Nyekjaer <sean@geanix.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 063/214] can: flexcan: disable clocks during stop mode
Date:   Tue,  3 Nov 2020 21:35:11 +0100
Message-Id: <20201103203256.273290458@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
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
index aaa7ed1dc97ee..d59c6c87164f4 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1703,8 +1703,6 @@ static int __maybe_unused flexcan_suspend(struct device *device)
 			err = flexcan_chip_disable(priv);
 			if (err)
 				return err;
-
-			err = pm_runtime_force_suspend(device);
 		}
 		netif_stop_queue(dev);
 		netif_device_detach(dev);
@@ -1730,10 +1728,6 @@ static int __maybe_unused flexcan_resume(struct device *device)
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
@@ -1764,8 +1758,16 @@ static int __maybe_unused flexcan_noirq_suspend(struct device *device)
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
@@ -1775,8 +1777,16 @@ static int __maybe_unused flexcan_noirq_resume(struct device *device)
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



