Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391D2457598
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236769AbhKSRlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:41:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:42128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236773AbhKSRlJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:41:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0157E61A62;
        Fri, 19 Nov 2021 17:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343487;
        bh=pYQhjAWzW22O8P6rzF5kskM85nxasdA/IQrU+b5uMZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=13C4jUnNZAEpnYR1VOzOWFdxX7jS45abEhgHdoe+j+ttYnmf546qVohdsF7N48m0O
         mdS0lcrJM8+vlBpgnRxaF+LPSP75UccIJ9Nge5fEXTacOIjLVGWlMX+Jb/NhZzPBMj
         v77f6ZPohkICcTi1FzCK2UH5dds2o4JQAVrt0o4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Riesch <michael.riesch@wolfvision.net>,
        "David S. Miller" <davem@davemloft.net>,
        Meng Li <Meng.Li@windriver.com>
Subject: [PATCH 5.10 10/21] net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable warnings
Date:   Fri, 19 Nov 2021 18:37:45 +0100
Message-Id: <20211119171444.219756585@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211119171443.892729043@linuxfoundation.org>
References: <20211119171443.892729043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Riesch <michael.riesch@wolfvision.net>

commit 2d26f6e39afb88d32b8f39e76a51b542c3c51674 upstream.

This reverts commit 2c896fb02e7f65299646f295a007bda043e0f382
"net: stmmac: dwmac-rk: add pd_gmac support for rk3399" and fixes
unbalanced pm_runtime_enable warnings.

In the commit to be reverted, support for power management was
introduced to the Rockchip glue code. Later, power management support
was introduced to the stmmac core code, resulting in multiple
invocations of pm_runtime_{enable,disable,get_sync,put_sync}.

The multiple invocations happen in rk_gmac_powerup and
stmmac_{dvr_probe, resume} as well as in rk_gmac_powerdown and
stmmac_{dvr_remove, suspend}, respectively, which are always called
in conjunction.

Fixes: 5ec55823438e850c91c6b92aec93fb04ebde29e2 ("net: stmmac: add clocks management for gmac driver")
Signed-off-by: Michael Riesch <michael.riesch@wolfvision.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Meng Li <Meng.Li@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -21,7 +21,6 @@
 #include <linux/delay.h>
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
-#include <linux/pm_runtime.h>
 
 #include "stmmac_platform.h"
 
@@ -1336,9 +1335,6 @@ static int rk_gmac_powerup(struct rk_pri
 		return ret;
 	}
 
-	pm_runtime_enable(dev);
-	pm_runtime_get_sync(dev);
-
 	if (bsp_priv->integrated_phy)
 		rk_gmac_integrated_phy_powerup(bsp_priv);
 
@@ -1347,14 +1343,9 @@ static int rk_gmac_powerup(struct rk_pri
 
 static void rk_gmac_powerdown(struct rk_priv_data *gmac)
 {
-	struct device *dev = &gmac->pdev->dev;
-
 	if (gmac->integrated_phy)
 		rk_gmac_integrated_phy_powerdown(gmac);
 
-	pm_runtime_put_sync(dev);
-	pm_runtime_disable(dev);
-
 	phy_power_on(gmac, false);
 	gmac_clk_enable(gmac, false);
 }


