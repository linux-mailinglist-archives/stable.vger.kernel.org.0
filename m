Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319092B62D5
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732254AbgKQNcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:32:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:41756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732249AbgKQNcM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:32:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E16224686;
        Tue, 17 Nov 2020 13:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619932;
        bh=hpCBLHQBHyPjrGn+etD6zv0AQoAbnkgDD4Y9WB9IEGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SXGFSd5kZtIc9w2bYy9rTIms7eFpDPiASzTuJWIVNzOqgFKiGwZosu0gGyS9OQUeQ
         JTD8am3bRX7HkQ0h4GtGKQe3Xgn5GB3gkDHweV/QqcjtDmqLJdYHarGyEHfbCxxFQU
         e13lzODpdpGd4beBiGVipzk3VOGTV8K6gktihYVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 052/255] can: xilinx_can: handle failure cases of pm_runtime_get_sync
Date:   Tue, 17 Nov 2020 14:03:12 +0100
Message-Id: <20201117122141.484722815@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 79c43333bdd5a7026a5aab606b53053b643585e7 ]

Calling pm_runtime_get_sync increments the counter even in case of
failure, causing incorrect ref count. Call pm_runtime_put if
pm_runtime_get_sync fails.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Link: https://lore.kernel.org/r/20200605033239.60664-1-navid.emamdoost@gmail.com
Fixes: 4716620d1b62 ("can: xilinx: Convert to runtime_pm")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/xilinx_can.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index c1dbab8c896d5..748ff70f6a7bf 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -1391,7 +1391,7 @@ static int xcan_open(struct net_device *ndev)
 	if (ret < 0) {
 		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
 			   __func__, ret);
-		return ret;
+		goto err;
 	}
 
 	ret = request_irq(ndev->irq, xcan_interrupt, priv->irq_flags,
@@ -1475,6 +1475,7 @@ static int xcan_get_berr_counter(const struct net_device *ndev,
 	if (ret < 0) {
 		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
 			   __func__, ret);
+		pm_runtime_put(priv->dev);
 		return ret;
 	}
 
@@ -1789,7 +1790,7 @@ static int xcan_probe(struct platform_device *pdev)
 	if (ret < 0) {
 		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
 			   __func__, ret);
-		goto err_pmdisable;
+		goto err_disableclks;
 	}
 
 	if (priv->read_reg(priv, XCAN_SR_OFFSET) != XCAN_SR_CONFIG_MASK) {
@@ -1824,7 +1825,6 @@ static int xcan_probe(struct platform_device *pdev)
 
 err_disableclks:
 	pm_runtime_put(priv->dev);
-err_pmdisable:
 	pm_runtime_disable(&pdev->dev);
 err_free:
 	free_candev(ndev);
-- 
2.27.0



