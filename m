Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 729312F7A62
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730792AbhAOMst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:48:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:44118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732902AbhAOMgy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:36:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52E812256F;
        Fri, 15 Jan 2021 12:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714173;
        bh=nFnzMJKAV5r2TvBZ0EfoRRPNXPY8CHnFL4wjcVATgn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xPdkyReyjNerlSgvPtpV48tsinB4j/bx3XSIt35SAJbaP8VfzzIGR5xqlX/XMyigg
         FcbvFwycNcqRgk174W0rbmZgjJMnic69/1LxaDRNwt4I1aecqdqP/hfNqFtDV7lvQU
         HujFB2nNjWOg5UEr3nuVTvf3j2iZTDmJwhaUbtUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 017/103] net: stmmac: dwmac-sun8i: Fix probe error handling
Date:   Fri, 15 Jan 2021 13:27:10 +0100
Message-Id: <20210115122006.881731406@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 7eeecc4b1f480c7ba1932cb9a7693f8c452640f2 ]

stmmac_pltfr_remove does three things in one function, making it
inapproprate for unwinding the steps in the probe function. Currently,
a failure before the call to stmmac_dvr_probe would leak OF node
references due to missing a call to stmmac_remove_config_dt. And an
error in stmmac_dvr_probe would cause the driver to attempt to remove a
netdevice that was never added. Fix these by reordering the init and
splitting out the error handling steps.

Fixes: 9f93ac8d4085 ("net-next: stmmac: Add dwmac-sun8i")
Fixes: 40a1dcee2d18 ("net: ethernet: dwmac-sun8i: Use the correct function in exit path")
Signed-off-by: Samuel Holland <samuel@sholland.org>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c |   25 +++++++++++++---------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -1134,10 +1134,6 @@ static int sun8i_dwmac_probe(struct plat
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, &stmmac_res.mac);
-	if (IS_ERR(plat_dat))
-		return PTR_ERR(plat_dat);
-
 	gmac = devm_kzalloc(dev, sizeof(*gmac), GFP_KERNEL);
 	if (!gmac)
 		return -ENOMEM;
@@ -1201,11 +1197,15 @@ static int sun8i_dwmac_probe(struct plat
 	ret = of_get_phy_mode(dev->of_node, &interface);
 	if (ret)
 		return -EINVAL;
-	plat_dat->interface = interface;
+
+	plat_dat = stmmac_probe_config_dt(pdev, &stmmac_res.mac);
+	if (IS_ERR(plat_dat))
+		return PTR_ERR(plat_dat);
 
 	/* platform data specifying hardware features and callbacks.
 	 * hardware features were copied from Allwinner drivers.
 	 */
+	plat_dat->interface = interface;
 	plat_dat->rx_coe = STMMAC_RX_COE_TYPE2;
 	plat_dat->tx_coe = 1;
 	plat_dat->has_sun8i = true;
@@ -1216,7 +1216,7 @@ static int sun8i_dwmac_probe(struct plat
 
 	ret = sun8i_dwmac_init(pdev, plat_dat->bsp_priv);
 	if (ret)
-		return ret;
+		goto dwmac_deconfig;
 
 	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (ret)
@@ -1230,7 +1230,7 @@ static int sun8i_dwmac_probe(struct plat
 	if (gmac->variant->soc_has_internal_phy) {
 		ret = get_ephy_nodes(priv);
 		if (ret)
-			goto dwmac_exit;
+			goto dwmac_remove;
 		ret = sun8i_dwmac_register_mdio_mux(priv);
 		if (ret) {
 			dev_err(&pdev->dev, "Failed to register mux\n");
@@ -1239,15 +1239,20 @@ static int sun8i_dwmac_probe(struct plat
 	} else {
 		ret = sun8i_dwmac_reset(priv);
 		if (ret)
-			goto dwmac_exit;
+			goto dwmac_remove;
 	}
 
 	return ret;
 dwmac_mux:
 	sun8i_dwmac_unset_syscon(gmac);
+dwmac_remove:
+	stmmac_dvr_remove(&pdev->dev);
 dwmac_exit:
-	stmmac_pltfr_remove(pdev);
-return ret;
+	sun8i_dwmac_exit(pdev, gmac);
+dwmac_deconfig:
+	stmmac_remove_config_dt(pdev, plat_dat);
+
+	return ret;
 }
 
 static const struct of_device_id sun8i_dwmac_match[] = {


