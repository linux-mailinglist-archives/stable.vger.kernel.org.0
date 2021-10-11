Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB874290B4
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238770AbhJKOLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:11:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243173AbhJKOJh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:09:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E251460FD7;
        Mon, 11 Oct 2021 14:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960922;
        bh=X/h6KJktkPQGD1OECIqbeADGGqqjUL3JviKokxonL70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RDRMLN7uuEG6rSEQSNMkLC4j8E53+WhKBqN2m4HgulVWmokHm5v9/6M5xWlg+8ADw
         aLHc4gzbDvX5vjDadrChnTzEh7V85fo1SDGuC7YN4KmDHShFePcwxrcI4P9SKhyQD9
         vh4k/pKfodei0kC+6MhHAp7flVMFyQY8KbGhFf8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        Punit Agrawal <punitagrawal@gmail.com>,
        Michael Riesch <michael.riesch@wolfvision.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 071/151] net: stmmac: dwmac-rk: Fix ethernet on rk3399 based devices
Date:   Mon, 11 Oct 2021 15:45:43 +0200
Message-Id: <20211011134520.146492239@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Punit Agrawal <punitagrawal@gmail.com>

[ Upstream commit aec3f415f7244b7747a7952596971adb0df2f568 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index ed817011a94a..6924a6aacbd5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -21,6 +21,7 @@
 #include <linux/delay.h>
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
+#include <linux/pm_runtime.h>
 
 #include "stmmac_platform.h"
 
@@ -1528,6 +1529,8 @@ static int rk_gmac_powerup(struct rk_priv_data *bsp_priv)
 		return ret;
 	}
 
+	pm_runtime_get_sync(dev);
+
 	if (bsp_priv->integrated_phy)
 		rk_gmac_integrated_phy_powerup(bsp_priv);
 
@@ -1539,6 +1542,8 @@ static void rk_gmac_powerdown(struct rk_priv_data *gmac)
 	if (gmac->integrated_phy)
 		rk_gmac_integrated_phy_powerdown(gmac);
 
+	pm_runtime_put_sync(&gmac->pdev->dev);
+
 	phy_power_on(gmac, false);
 	gmac_clk_enable(gmac, false);
 }
-- 
2.33.0



