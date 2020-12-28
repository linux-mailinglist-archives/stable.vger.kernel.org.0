Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A34B2E3D96
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391808AbgL1ORa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:17:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:51268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391803AbgL1OR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:17:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C249321D94;
        Mon, 28 Dec 2020 14:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165027;
        bh=Y8Yjzzyg2psTteEyj1alrB7veaOofi92smNum4P2V8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FZ2jIcAHliDAaSlVZ6KaExJ7tGDxPmqD31HaGwrLEMYK25ZQbk5Guryh6dMD22Js6
         uHf633osVS4+E9KnV3z5ZSX5DTu1NnkDAxFkTjFDQFlPREDib9qkiQL6WTilHSmL0s
         d4SwdDUzvUyPdOn1AQ4znvIl2rBrpiHmB7eb4OZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Milton Miller <miltonm@us.ibm.com>,
        Eddie James <eajames@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 385/717] fsi: Aspeed: Add mutex to protect HW access
Date:   Mon, 28 Dec 2020 13:46:23 +0100
Message-Id: <20201228125039.449097140@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit dfd7f2c1c532efaeff6084970bb60ec2f2e44191 ]

There is nothing to prevent multiple commands being executed
simultaneously. Add a mutex to prevent this.

Fixes: 606397d67f41 ("fsi: Add ast2600 master driver")
Reviewed-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Milton Miller <miltonm@us.ibm.com>
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20201120004929.185239-1-joel@jms.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fsi/fsi-master-aspeed.c | 45 +++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/drivers/fsi/fsi-master-aspeed.c b/drivers/fsi/fsi-master-aspeed.c
index c006ec008a1aa..90dbe58ca1edc 100644
--- a/drivers/fsi/fsi-master-aspeed.c
+++ b/drivers/fsi/fsi-master-aspeed.c
@@ -8,6 +8,7 @@
 #include <linux/io.h>
 #include <linux/mfd/syscon.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
@@ -19,6 +20,7 @@
 
 struct fsi_master_aspeed {
 	struct fsi_master	master;
+	struct mutex		lock;	/* protect HW access */
 	struct device		*dev;
 	void __iomem		*base;
 	struct clk		*clk;
@@ -254,6 +256,8 @@ static int aspeed_master_read(struct fsi_master *master, int link,
 	addr |= id << 21;
 	addr += link * FSI_HUB_LINK_SIZE;
 
+	mutex_lock(&aspeed->lock);
+
 	switch (size) {
 	case 1:
 		ret = opb_readb(aspeed, fsi_base + addr, val);
@@ -265,14 +269,14 @@ static int aspeed_master_read(struct fsi_master *master, int link,
 		ret = opb_readl(aspeed, fsi_base + addr, val);
 		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
+		goto done;
 	}
 
 	ret = check_errors(aspeed, ret);
-	if (ret)
-		return ret;
-
-	return 0;
+done:
+	mutex_unlock(&aspeed->lock);
+	return ret;
 }
 
 static int aspeed_master_write(struct fsi_master *master, int link,
@@ -287,6 +291,8 @@ static int aspeed_master_write(struct fsi_master *master, int link,
 	addr |= id << 21;
 	addr += link * FSI_HUB_LINK_SIZE;
 
+	mutex_lock(&aspeed->lock);
+
 	switch (size) {
 	case 1:
 		ret = opb_writeb(aspeed, fsi_base + addr, *(u8 *)val);
@@ -298,14 +304,14 @@ static int aspeed_master_write(struct fsi_master *master, int link,
 		ret = opb_writel(aspeed, fsi_base + addr, *(__be32 *)val);
 		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
+		goto done;
 	}
 
 	ret = check_errors(aspeed, ret);
-	if (ret)
-		return ret;
-
-	return 0;
+done:
+	mutex_unlock(&aspeed->lock);
+	return ret;
 }
 
 static int aspeed_master_link_enable(struct fsi_master *master, int link,
@@ -320,17 +326,21 @@ static int aspeed_master_link_enable(struct fsi_master *master, int link,
 
 	reg = cpu_to_be32(0x80000000 >> bit);
 
-	if (!enable)
-		return opb_writel(aspeed, ctrl_base + FSI_MCENP0 + (4 * idx),
-				  reg);
+	mutex_lock(&aspeed->lock);
+
+	if (!enable) {
+		ret = opb_writel(aspeed, ctrl_base + FSI_MCENP0 + (4 * idx), reg);
+		goto done;
+	}
 
 	ret = opb_writel(aspeed, ctrl_base + FSI_MSENP0 + (4 * idx), reg);
 	if (ret)
-		return ret;
+		goto done;
 
 	mdelay(FSI_LINK_ENABLE_SETUP_TIME);
-
-	return 0;
+done:
+	mutex_unlock(&aspeed->lock);
+	return ret;
 }
 
 static int aspeed_master_term(struct fsi_master *master, int link, uint8_t id)
@@ -431,9 +441,11 @@ static ssize_t cfam_reset_store(struct device *dev, struct device_attribute *att
 {
 	struct fsi_master_aspeed *aspeed = dev_get_drvdata(dev);
 
+	mutex_lock(&aspeed->lock);
 	gpiod_set_value(aspeed->cfam_reset_gpio, 1);
 	usleep_range(900, 1000);
 	gpiod_set_value(aspeed->cfam_reset_gpio, 0);
+	mutex_unlock(&aspeed->lock);
 
 	return count;
 }
@@ -597,6 +609,7 @@ static int fsi_master_aspeed_probe(struct platform_device *pdev)
 
 	dev_set_drvdata(&pdev->dev, aspeed);
 
+	mutex_init(&aspeed->lock);
 	aspeed_master_init(aspeed);
 
 	rc = fsi_master_register(&aspeed->master);
-- 
2.27.0



