Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4422141109E
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 10:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235314AbhITIE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 04:04:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235252AbhITIER (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 04:04:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE3ED60F93;
        Mon, 20 Sep 2021 08:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632124897;
        bh=wXA+4o7U1drUmeUieY3a7dBZWK2JqRDdy6hXfcOOTZw=;
        h=Subject:To:Cc:From:Date:From;
        b=2eTzc4WuhGm/qc0RT6iJcFse86HEzXIJr7Stwar+uAkYw1dBIOUpIYIQH4to2SnFh
         RVj2+XB35DIcddl8qq8Rj3DyT8DC3YNVZHMmWJSy0NVlHXyk4kmwrFI1SftsM6dEjy
         A8STmdbih+oREK722608CBpRT+KKndFLWQazQ2YU=
Subject: FAILED: patch "[PATCH] net: stmmac: fix system hang caused by eee_ctrl_timer during" failed to apply to 4.9-stable tree
To:     qiangqing.zhang@nxp.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Sep 2021 10:01:25 +0200
Message-ID: <16321248859193@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 276aae377206d60b9b7b7df4586cd9f2a813f5d0 Mon Sep 17 00:00:00 2001
From: Joakim Zhang <qiangqing.zhang@nxp.com>
Date: Wed, 8 Sep 2021 15:43:35 +0800
Subject: [PATCH] net: stmmac: fix system hang caused by eee_ctrl_timer during
 suspend/resume

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

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index ece02b35a6ce..246f84fedbc8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7118,7 +7118,6 @@ int stmmac_suspend(struct device *dev)
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
 	u32 chan;
-	int ret;
 
 	if (!ndev || !netif_running(ndev))
 		return 0;
@@ -7150,13 +7149,6 @@ int stmmac_suspend(struct device *dev)
 	} else {
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
@@ -7242,12 +7234,6 @@ int stmmac_resume(struct device *dev)
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
index 5ca710844cc1..4885f9ad1b1e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -9,6 +9,7 @@
 *******************************************************************************/
 
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/module.h>
 #include <linux/io.h>
 #include <linux/of.h>
@@ -771,9 +772,52 @@ static int __maybe_unused stmmac_runtime_resume(struct device *dev)
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
 

