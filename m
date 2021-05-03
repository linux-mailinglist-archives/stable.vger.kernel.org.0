Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E963714B5
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 14:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233637AbhECMAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 08:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:34258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233582AbhECMAM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 08:00:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22BEF61185;
        Mon,  3 May 2021 11:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620043159;
        bh=fYJ6PDrFF6+VxQu0AvFdpJhwaMAKZbm/5Zai82AILV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W+Ub//8H7kVFSi6r4x+76GaKz1TlBYpS1kmHNC37FAu43eoe3virrRlGNV7HVrhK0
         AM8XVxWN0gzpnrqvGDPhAm+oEcuBjkeAsfqvK7BW0fouLAIwsGcM/T9OevtLTOca9m
         TOLzuJB0xYUtiTBlID/th07snmeG1K3X98XWSDyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Anirudh Rayabharam <mail@anirudhrb.com>,
        "David S . Miller" <davem@davemloft.net>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 21/69] net: stmicro: handle clk_prepare() failure during init
Date:   Mon,  3 May 2021 13:56:48 +0200
Message-Id: <20210503115736.2104747-22-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anirudh Rayabharam <mail@anirudhrb.com>

In case clk_prepare() fails, capture and propagate the error code up the
stack. If regulator_enable() was called earlier, properly unwind it by
calling regulator_disable().

Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
index fc68e90acbea..fc3b0acc8f99 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
@@ -30,7 +30,7 @@ struct sunxi_priv_data {
 static int sun7i_gmac_init(struct platform_device *pdev, void *priv)
 {
 	struct sunxi_priv_data *gmac = priv;
-	int ret;
+	int ret = 0;
 
 	if (gmac->regulator) {
 		ret = regulator_enable(gmac->regulator);
@@ -50,10 +50,12 @@ static int sun7i_gmac_init(struct platform_device *pdev, void *priv)
 		gmac->clk_enabled = 1;
 	} else {
 		clk_set_rate(gmac->tx_clk, SUN7I_GMAC_MII_RATE);
-		clk_prepare(gmac->tx_clk);
+		ret = clk_prepare(gmac->tx_clk);
+		if (ret && gmac->regulator)
+			regulator_disable(gmac->regulator);
 	}
 
-	return 0;
+	return ret;
 }
 
 static void sun7i_gmac_exit(struct platform_device *pdev, void *priv)
-- 
2.31.1

