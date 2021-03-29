Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F143634C687
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbhC2IIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:08:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231756AbhC2IGy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:06:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5059A61959;
        Mon, 29 Mar 2021 08:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005213;
        bh=4T5nshDnSfdrBR1gefSFliG79GvTAw5WAZSSBIwntxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yy0/GLqVkXkfdmEndhQqQ/qiOol6Xl71eBHQRl8+oMADduxdawbV+fk0nhNSiAlVY
         nMgTg3F6VluDwtNshN0rNT+Y8+hp8DsFeQiLWFagOOYLhaLC1tb2Q3S0FKkP5ck0uk
         O/o5gx01kYIleAQOruDDRyf14knF4V4nQrhonU90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Zhang <ztong0001@gmail.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 39/59] can: c_can: move runtime PM enable/disable to c_can_platform
Date:   Mon, 29 Mar 2021 09:58:19 +0200
Message-Id: <20210329075610.174207337@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075608.898173317@linuxfoundation.org>
References: <20210329075608.898173317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit 6e2fe01dd6f98da6cae8b07cd5cfa67abc70d97d ]

Currently doing modprobe c_can_pci will make the kernel complain:

    Unbalanced pm_runtime_enable!

this is caused by pm_runtime_enable() called before pm is initialized.

This fix is similar to 227619c3ff7c, move those pm_enable/disable code
to c_can_platform.

Fixes: 4cdd34b26826 ("can: c_can: Add runtime PM support to Bosch C_CAN/D_CAN controller")
Link: http://lore.kernel.org/r/20210302025542.987600-1-ztong0001@gmail.com
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Tested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/c_can/c_can.c          | 24 +-----------------------
 drivers/net/can/c_can/c_can_platform.c |  6 +++++-
 2 files changed, 6 insertions(+), 24 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 24c6015f6c92..2278c5fff5c6 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -212,18 +212,6 @@ static const struct can_bittiming_const c_can_bittiming_const = {
 	.brp_inc = 1,
 };
 
-static inline void c_can_pm_runtime_enable(const struct c_can_priv *priv)
-{
-	if (priv->device)
-		pm_runtime_enable(priv->device);
-}
-
-static inline void c_can_pm_runtime_disable(const struct c_can_priv *priv)
-{
-	if (priv->device)
-		pm_runtime_disable(priv->device);
-}
-
 static inline void c_can_pm_runtime_get_sync(const struct c_can_priv *priv)
 {
 	if (priv->device)
@@ -1318,7 +1306,6 @@ static const struct net_device_ops c_can_netdev_ops = {
 
 int register_c_can_dev(struct net_device *dev)
 {
-	struct c_can_priv *priv = netdev_priv(dev);
 	int err;
 
 	/* Deactivate pins to prevent DRA7 DCAN IP from being
@@ -1328,28 +1315,19 @@ int register_c_can_dev(struct net_device *dev)
 	 */
 	pinctrl_pm_select_sleep_state(dev->dev.parent);
 
-	c_can_pm_runtime_enable(priv);
-
 	dev->flags |= IFF_ECHO;	/* we support local echo */
 	dev->netdev_ops = &c_can_netdev_ops;
 
 	err = register_candev(dev);
-	if (err)
-		c_can_pm_runtime_disable(priv);
-	else
+	if (!err)
 		devm_can_led_init(dev);
-
 	return err;
 }
 EXPORT_SYMBOL_GPL(register_c_can_dev);
 
 void unregister_c_can_dev(struct net_device *dev)
 {
-	struct c_can_priv *priv = netdev_priv(dev);
-
 	unregister_candev(dev);
-
-	c_can_pm_runtime_disable(priv);
 }
 EXPORT_SYMBOL_GPL(unregister_c_can_dev);
 
diff --git a/drivers/net/can/c_can/c_can_platform.c b/drivers/net/can/c_can/c_can_platform.c
index b5145a7f874c..f2b0408ce87d 100644
--- a/drivers/net/can/c_can/c_can_platform.c
+++ b/drivers/net/can/c_can/c_can_platform.c
@@ -29,6 +29,7 @@
 #include <linux/list.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/clk.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
@@ -385,6 +386,7 @@ static int c_can_plat_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, dev);
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
+	pm_runtime_enable(priv->device);
 	ret = register_c_can_dev(dev);
 	if (ret) {
 		dev_err(&pdev->dev, "registering %s failed (err=%d)\n",
@@ -397,6 +399,7 @@ static int c_can_plat_probe(struct platform_device *pdev)
 	return 0;
 
 exit_free_device:
+	pm_runtime_disable(priv->device);
 	free_c_can_dev(dev);
 exit:
 	dev_err(&pdev->dev, "probe failed\n");
@@ -407,9 +410,10 @@ exit:
 static int c_can_plat_remove(struct platform_device *pdev)
 {
 	struct net_device *dev = platform_get_drvdata(pdev);
+	struct c_can_priv *priv = netdev_priv(dev);
 
 	unregister_c_can_dev(dev);
-
+	pm_runtime_disable(priv->device);
 	free_c_can_dev(dev);
 
 	return 0;
-- 
2.30.1



