Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471D54627A6
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 00:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236298AbhK2XIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235589AbhK2XHp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:07:45 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC858C141B11;
        Mon, 29 Nov 2021 10:32:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0F767CE0DE0;
        Mon, 29 Nov 2021 18:32:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB4CC58322;
        Mon, 29 Nov 2021 18:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210729;
        bh=aLfrPpV38MRgKTQdOGM/gYjHBbfSrb9R760XQLwbT/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f1nGIuXkgxBjBOG5VksoTGqF1M5RBt9lWVqaoVjio7mBNA0zy0Sh2W0+nFrpnFODX
         WZ/8ppvoj7gsQUCgM7NxByjF/u8tT0lH5Y9fk6eooJJfGGrKj/vaSjXQSh6yFxTt/d
         0jJfDoxEe4lFltzc/6VTGyiS+4OelygwQulTgr9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/121] net: stmmac: fix system hang caused by eee_ctrl_timer during suspend/resume
Date:   Mon, 29 Nov 2021 19:18:17 +0100
Message-Id: <20211129181713.864314963@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

[ Upstream commit 276aae377206d60b9b7b7df4586cd9f2a813f5d0 ]

commit 5f58591323bf ("net: stmmac: delete the eee_ctrl_timer after
napi disabled"), this patch tries to fix system hang caused by eee_ctrl_timer,
unfortunately, it only can resolve it for system reboot stress test. System
hang also can be reproduced easily during system suspend/resume stess test
when mount NFS on i.MX8MP EVK board.

In stmmac driver, eee feature is combined to phylink framework. When do
system suspend, phylink_stop() would queue delayed work, it invokes
stmmac_mac_link_down(), where to deactivate eee_ctrl_timer synchronizly.
In above commit, try to fix issue by deactivating eee_ctrl_timer obviously,
but it is not enough. Looking into eee_ctrl_timer expire callback
stmmac_eee_ctrl_timer(), it could enable hareware eee mode again. What is
unexpected is that LPI interrupt (MAC_Interrupt_Enable.LPIEN bit) is always
asserted. This interrupt has chance to be issued when LPI state entry/exit
from the MAC, and at that time, clock could have been already disabled.
The result is that system hang when driver try to touch register from
interrupt handler.

The reason why above commit can fix system hang issue in stmmac_release()
is that, deactivate eee_ctrl_timer not just after napi disabled, further
after irq freed.

In conclusion, hardware would generate LPI interrupt when clock has been
disabled during suspend or resume, since hardware is in eee mode and LPI
interrupt enabled.

Interrupts from MAC, MTL and DMA level are enabled and never been disabled
when system suspend, so postpone clocks management from suspend stage to
noirq suspend stage should be more safe.

Fixes: 5f58591323bf ("net: stmmac: delete the eee_ctrl_timer after napi disabled")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 14 ------
 .../ethernet/stmicro/stmmac/stmmac_platform.c | 44 +++++++++++++++++++
 2 files changed, 44 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 4a75e73f06bbd..b6a2bc020026a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5238,7 +5238,6 @@ int stmmac_suspend(struct device *dev)
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
 	u32 chan;
-	int ret;
 
 	if (!ndev || !netif_running(ndev))
 		return 0;
@@ -5280,13 +5279,6 @@ int stmmac_suspend(struct device *dev)
 
 		stmmac_mac_set(priv, priv->ioaddr, false);
 		pinctrl_pm_select_sleep_state(priv->device);
-		/* Disable clock in case of PWM is off */
-		clk_disable_unprepare(priv->plat->clk_ptp_ref);
-		ret = pm_runtime_force_suspend(dev);
-		if (ret) {
-			mutex_unlock(&priv->lock);
-			return ret;
-		}
 	}
 	mutex_unlock(&priv->lock);
 
@@ -5351,12 +5343,6 @@ int stmmac_resume(struct device *dev)
 		priv->irq_wake = 0;
 	} else {
 		pinctrl_pm_select_default_state(priv->device);
-		/* enable the clk previously disabled */
-		ret = pm_runtime_force_resume(dev);
-		if (ret)
-			return ret;
-		if (priv->plat->clk_ptp_ref)
-			clk_prepare_enable(priv->plat->clk_ptp_ref);
 		/* reset the phy so that it's ready */
 		if (priv->mii)
 			stmmac_mdio_reset(priv->mii);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 035f9aef4308f..5c9d29c42bac8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -9,6 +9,7 @@
 *******************************************************************************/
 
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/module.h>
 #include <linux/io.h>
 #include <linux/of.h>
@@ -778,9 +779,52 @@ static int __maybe_unused stmmac_runtime_resume(struct device *dev)
 	return stmmac_bus_clks_config(priv, true);
 }
 
+static int stmmac_pltfr_noirq_suspend(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	int ret;
+
+	if (!netif_running(ndev))
+		return 0;
+
+	if (!device_may_wakeup(priv->device) || !priv->plat->pmt) {
+		/* Disable clock in case of PWM is off */
+		clk_disable_unprepare(priv->plat->clk_ptp_ref);
+
+		ret = pm_runtime_force_suspend(dev);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int stmmac_pltfr_noirq_resume(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	int ret;
+
+	if (!netif_running(ndev))
+		return 0;
+
+	if (!device_may_wakeup(priv->device) || !priv->plat->pmt) {
+		/* enable the clk previously disabled */
+		ret = pm_runtime_force_resume(dev);
+		if (ret)
+			return ret;
+
+		clk_prepare_enable(priv->plat->clk_ptp_ref);
+	}
+
+	return 0;
+}
+
 const struct dev_pm_ops stmmac_pltfr_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(stmmac_pltfr_suspend, stmmac_pltfr_resume)
 	SET_RUNTIME_PM_OPS(stmmac_runtime_suspend, stmmac_runtime_resume, NULL)
+	SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(stmmac_pltfr_noirq_suspend, stmmac_pltfr_noirq_resume)
 };
 EXPORT_SYMBOL_GPL(stmmac_pltfr_pm_ops);
 
-- 
2.33.0



