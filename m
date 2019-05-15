Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7908D1F173
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730518AbfEOLyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:54:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730521AbfEOLTO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:19:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F8DA2084F;
        Wed, 15 May 2019 11:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919153;
        bh=CD+3kVeGxnZBiQsOmKpXFQTDnw/usWuj2LsIib3Ubzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FoZbPcQAamxROJ+qQHwQv+yMCKUPXjMMFLFH6/Hn5PR78pOcBCu9g3WLSH0EkCC3C
         crrLy1Xwifw9P1DuTIKMD+cK8DFjdLsjaxYyeTGqyqI4ftMubBV7bsvEo8+dgpzXnE
         9R8ylL3lAEuhGj4jlpMbU3cda9TiRqhOllqvjpP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 086/115] net: fec: manage ahb clock in runtime pm
Date:   Wed, 15 May 2019 12:56:06 +0200
Message-Id: <20190515090705.580979329@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d7c3a206e6338e4ccdf030719dec028e26a521d5 ]

Some SOC like i.MX6SX clock have some limits:
- ahb clock should be disabled before ipg.
- ahb and ipg clocks are required for MAC MII bus.
So, move the ahb clock to runtime management together with
ipg clock.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 30 ++++++++++++++++-------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index ce55c8f7f33a4..ad3aabc39cc24 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1851,13 +1851,9 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 	int ret;
 
 	if (enable) {
-		ret = clk_prepare_enable(fep->clk_ahb);
-		if (ret)
-			return ret;
-
 		ret = clk_prepare_enable(fep->clk_enet_out);
 		if (ret)
-			goto failed_clk_enet_out;
+			return ret;
 
 		if (fep->clk_ptp) {
 			mutex_lock(&fep->ptp_clk_mutex);
@@ -1875,7 +1871,6 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 		if (ret)
 			goto failed_clk_ref;
 	} else {
-		clk_disable_unprepare(fep->clk_ahb);
 		clk_disable_unprepare(fep->clk_enet_out);
 		if (fep->clk_ptp) {
 			mutex_lock(&fep->ptp_clk_mutex);
@@ -1894,8 +1889,6 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 failed_clk_ptp:
 	if (fep->clk_enet_out)
 		clk_disable_unprepare(fep->clk_enet_out);
-failed_clk_enet_out:
-		clk_disable_unprepare(fep->clk_ahb);
 
 	return ret;
 }
@@ -3455,6 +3448,9 @@ fec_probe(struct platform_device *pdev)
 	ret = clk_prepare_enable(fep->clk_ipg);
 	if (ret)
 		goto failed_clk_ipg;
+	ret = clk_prepare_enable(fep->clk_ahb);
+	if (ret)
+		goto failed_clk_ahb;
 
 	fep->reg_phy = devm_regulator_get(&pdev->dev, "phy");
 	if (!IS_ERR(fep->reg_phy)) {
@@ -3546,6 +3542,9 @@ fec_probe(struct platform_device *pdev)
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 failed_regulator:
+	clk_disable_unprepare(fep->clk_ahb);
+failed_clk_ahb:
+	clk_disable_unprepare(fep->clk_ipg);
 failed_clk_ipg:
 	fec_enet_clk_enable(ndev, false);
 failed_clk:
@@ -3669,6 +3668,7 @@ static int __maybe_unused fec_runtime_suspend(struct device *dev)
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct fec_enet_private *fep = netdev_priv(ndev);
 
+	clk_disable_unprepare(fep->clk_ahb);
 	clk_disable_unprepare(fep->clk_ipg);
 
 	return 0;
@@ -3678,8 +3678,20 @@ static int __maybe_unused fec_runtime_resume(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct fec_enet_private *fep = netdev_priv(ndev);
+	int ret;
 
-	return clk_prepare_enable(fep->clk_ipg);
+	ret = clk_prepare_enable(fep->clk_ahb);
+	if (ret)
+		return ret;
+	ret = clk_prepare_enable(fep->clk_ipg);
+	if (ret)
+		goto failed_clk_ipg;
+
+	return 0;
+
+failed_clk_ipg:
+	clk_disable_unprepare(fep->clk_ahb);
+	return ret;
 }
 
 static const struct dev_pm_ops fec_pm_ops = {
-- 
2.20.1



