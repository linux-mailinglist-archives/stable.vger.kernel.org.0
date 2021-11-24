Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B4B45C391
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348289AbhKXNks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:40:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:33718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353007AbhKXNir (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:38:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B6E8617E5;
        Wed, 24 Nov 2021 12:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758584;
        bh=A/iPSYYNvU4GKF5Bd17Q+I5mQpN+x5d4con1NK7xMFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dc+phTbiEa1Ab+hYpgLZFXtD8sPMrFiJwTVZqvvDyZw3Ytb/nFycd+3tW5FVYad7P
         GWiu3EDmsDmFdawX1lXIUj2E++BnSEONzWANXP449KHjF5v01P6n0Y+x6McqXsHD9o
         wTxI/jTToHgTWqmFCBEh4oRhc938S894bQRRjMpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        Punit Agrawal <punitagrawal@gmail.com>,
        Michael Riesch <michael.riesch@wolfvision.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 118/154] net: stmmac: dwmac-rk: Fix ethernet on rk3399 based devices
Date:   Wed, 24 Nov 2021 12:58:34 +0100
Message-Id: <20211124115706.097197178@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Punit Agrawal <punitagrawal@gmail.com>

commit aec3f415f7244b7747a7952596971adb0df2f568 upstream.

Commit 2d26f6e39afb ("net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable warnings")
while getting rid of a runtime PM warning ended up breaking ethernet
on rk3399 based devices. By dropping an extra reference to the device,
the commit ends up enabling suspend / resume of the ethernet device -
which appears to be broken.

While the issue with runtime pm is being investigated, partially
revert commit 2d26f6e39afb to restore the network on rk3399.

Fixes: 2d26f6e39afb ("net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable warnings")
Suggested-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Punit Agrawal <punitagrawal@gmail.com>
Cc: Michael Riesch <michael.riesch@wolfvision.net>
Tested-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20210929135049.3426058-1-punitagrawal@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -21,6 +21,7 @@
 #include <linux/delay.h>
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
+#include <linux/pm_runtime.h>
 
 #include "stmmac_platform.h"
 
@@ -1335,6 +1336,8 @@ static int rk_gmac_powerup(struct rk_pri
 		return ret;
 	}
 
+	pm_runtime_get_sync(dev);
+
 	if (bsp_priv->integrated_phy)
 		rk_gmac_integrated_phy_powerup(bsp_priv);
 
@@ -1346,6 +1349,8 @@ static void rk_gmac_powerdown(struct rk_
 	if (gmac->integrated_phy)
 		rk_gmac_integrated_phy_powerdown(gmac);
 
+	pm_runtime_put_sync(&gmac->pdev->dev);
+
 	phy_power_on(gmac, false);
 	gmac_clk_enable(gmac, false);
 }


