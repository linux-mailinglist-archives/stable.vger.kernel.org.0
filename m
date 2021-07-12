Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877343C4758
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236995AbhGLGcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:32:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236329AbhGLG35 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:29:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03FB161004;
        Mon, 12 Jul 2021 06:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071228;
        bh=XlFgMBEfnDCIm0DhoNeSAAWKiwqQ3nsWZgM0gSwZEe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=duk4GkL4Mg7cqH1nXtgdUjf/kMM3wkmoXCYSQ1vjbgBUPIUG2/FfnnEbKWkd2M/6D
         VpaiS1B73QUh7XfUAWdkQQ6EjOPaWMKM8GPctMX5qTNf7ZXI/+IqpR1e8ghDRVBUdB
         1Wbi36ClalsHmQ8U1n77qv6u8ryCyLEkn+VUPL9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 328/348] phy: ti: dm816x: Fix the error handling path in dm816x_usb_phy_probe()
Date:   Mon, 12 Jul 2021 08:11:52 +0200
Message-Id: <20210712060747.653982569@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit f7eedcb8539ddcbb6fe7791f1b4ccf43f905c72f ]

Add an error handling path in the probe to release some resources, as
already done in the remove function.

Fixes: 609adde838f4 ("phy: Add a driver for dm816x USB PHY")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/ac5136881f6bdec50be19b3bf73b3bc1b15ef1f1.1622898974.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/ti/phy-dm816x-usb.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/phy/ti/phy-dm816x-usb.c b/drivers/phy/ti/phy-dm816x-usb.c
index cbcce7cf0028..2ed5fe20d779 100644
--- a/drivers/phy/ti/phy-dm816x-usb.c
+++ b/drivers/phy/ti/phy-dm816x-usb.c
@@ -246,19 +246,28 @@ static int dm816x_usb_phy_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(phy->dev);
 	generic_phy = devm_phy_create(phy->dev, NULL, &ops);
-	if (IS_ERR(generic_phy))
-		return PTR_ERR(generic_phy);
+	if (IS_ERR(generic_phy)) {
+		error = PTR_ERR(generic_phy);
+		goto clk_unprepare;
+	}
 
 	phy_set_drvdata(generic_phy, phy);
 
 	phy_provider = devm_of_phy_provider_register(phy->dev,
 						     of_phy_simple_xlate);
-	if (IS_ERR(phy_provider))
-		return PTR_ERR(phy_provider);
+	if (IS_ERR(phy_provider)) {
+		error = PTR_ERR(phy_provider);
+		goto clk_unprepare;
+	}
 
 	usb_add_phy_dev(&phy->phy);
 
 	return 0;
+
+clk_unprepare:
+	pm_runtime_disable(phy->dev);
+	clk_unprepare(phy->refclk);
+	return error;
 }
 
 static int dm816x_usb_phy_remove(struct platform_device *pdev)
-- 
2.30.2



