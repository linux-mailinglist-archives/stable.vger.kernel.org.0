Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037604575B4
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236493AbhKSRlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:41:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:43274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236887AbhKSRlo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:41:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 919FA61A62;
        Fri, 19 Nov 2021 17:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343522;
        bh=kg1q3O4bSq7k9fmrEpWQLxxL8VNvDH9LgdqQwDsgwxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1C4j48E7PCVWFm+rdhIfmtviIZZXI5F++2+NMprZm4oDAFhEvEj6vcaKl3uMle49Q
         qLFVn3CSooj95DiNoZFNAX/Y8tq29Y4Ll0jLr49S51OJebnhuny4x8oBeO+5RbdOE4
         bzOgECgLD8OutT32m0XDNpXolSgBqLIBkZ/u4i4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Meng Li <Meng.Li@windriver.com>
Subject: [PATCH 5.10 05/21] net: stmmac: add clocks management for gmac driver
Date:   Fri, 19 Nov 2021 18:37:40 +0100
Message-Id: <20211119171444.062394939@linuxfoundation.org>
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

From: Joakim Zhang <qiangqing.zhang@nxp.com>

commit 5ec55823438e850c91c6b92aec93fb04ebde29e2 upstream.

This patch intends to add clocks management for stmmac driver:

If CONFIG_PM enabled:
1. Keep clocks disabled after driver probed.
2. Enable clocks when up the net device, and disable clocks when down
the net device.

If CONFIG_PM disabled:
Keep clocks always enabled after driver probed.

Note:
1. It is fine for ethtool, since the way of implementing ethtool_ops::begin
in stmmac is only can be accessed when interface is enabled, so the clocks
are ticked.
2. The MDIO bus has a different life cycle to the MAC, need ensure
clocks are enabled when _mdio_read/write() need clocks, because these
functions can be called while the interface it not opened.

Stable backport notes:
When run below command to remove ethernet driver on
stratix10 platform, there will be warning trace as below:

$ cd /sys/class/net/eth0/device/driver/
$ echo ff800000.ethernet > unbind

WARNING: CPU: 3 PID: 386 at drivers/clk/clk.c:810 clk_core_unprepare+0x114/0x274
Modules linked in: sch_fq_codel
CPU: 3 PID: 386 Comm: sh Tainted: G        W         5.10.74-yocto-standard #1
Hardware name: SoCFPGA Stratix 10 SoCDK (DT)
pstate: 00000005 (nzcv daif -PAN -UAO -TCO BTYPE=--)
pc : clk_core_unprepare+0x114/0x274
lr : clk_core_unprepare+0x114/0x274
sp : ffff800011bdbb10
clk_core_unprepare+0x114/0x274
 clk_unprepare+0x38/0x50
 stmmac_remove_config_dt+0x40/0x80
 stmmac_pltfr_remove+0x64/0x80
 platform_drv_remove+0x38/0x60
 ... ..
 el0_sync_handler+0x1a4/0x1b0
 el0_sync+0x180/0x1c0
This issue is introduced by introducing upstream commit 8f269102baf7
("net: stmmac: disable clocks in stmmac_remove_config_dt()")

But in latest mainline kernel, there is no this issue. Because this
patch improved clocks management for stmmac driver.
Therefore, backport it and its fixing patches to stable kernel v5.10.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: stable@vger.kernel.org
Signed-off-by: Meng Li <Meng.Li@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h          |    1 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c     |   75 ++++++++++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c     |  111 +++++++++++++-----
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c |   24 +++
 4 files changed, 174 insertions(+), 37 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -270,6 +270,7 @@ void stmmac_disable_eee_mode(struct stmm
 bool stmmac_eee_init(struct stmmac_priv *priv);
 int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt);
 int stmmac_reinit_ringparam(struct net_device *dev, u32 rx_size, u32 tx_size);
+int stmmac_bus_clks_config(struct stmmac_priv *priv, bool enabled);
 
 #if IS_ENABLED(CONFIG_STMMAC_SELFTESTS)
 void stmmac_selftest_run(struct net_device *dev,
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -28,6 +28,7 @@
 #include <linux/if_vlan.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 #include <linux/prefetch.h>
 #include <linux/pinctrl/consumer.h>
 #ifdef CONFIG_DEBUG_FS
@@ -113,6 +114,28 @@ static void stmmac_exit_fs(struct net_de
 
 #define STMMAC_COAL_TIMER(x) (jiffies + usecs_to_jiffies(x))
 
+int stmmac_bus_clks_config(struct stmmac_priv *priv, bool enabled)
+{
+	int ret = 0;
+
+	if (enabled) {
+		ret = clk_prepare_enable(priv->plat->stmmac_clk);
+		if (ret)
+			return ret;
+		ret = clk_prepare_enable(priv->plat->pclk);
+		if (ret) {
+			clk_disable_unprepare(priv->plat->stmmac_clk);
+			return ret;
+		}
+	} else {
+		clk_disable_unprepare(priv->plat->stmmac_clk);
+		clk_disable_unprepare(priv->plat->pclk);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(stmmac_bus_clks_config);
+
 /**
  * stmmac_verify_args - verify the driver parameters.
  * Description: it checks the driver parameters and set a default in case of
@@ -2792,6 +2815,12 @@ static int stmmac_open(struct net_device
 	u32 chan;
 	int ret;
 
+	ret = pm_runtime_get_sync(priv->device);
+	if (ret < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return ret;
+	}
+
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI &&
 	    priv->hw->xpcs == NULL) {
@@ -2800,7 +2829,7 @@ static int stmmac_open(struct net_device
 			netdev_err(priv->dev,
 				   "%s: Cannot attach to PHY (error: %d)\n",
 				   __func__, ret);
-			return ret;
+			goto init_phy_error;
 		}
 	}
 
@@ -2915,6 +2944,8 @@ init_error:
 	free_dma_desc_resources(priv);
 dma_desc_error:
 	phylink_disconnect_phy(priv->phylink);
+init_phy_error:
+	pm_runtime_put(priv->device);
 	return ret;
 }
 
@@ -2965,6 +2996,8 @@ static int stmmac_release(struct net_dev
 
 	stmmac_release_ptp(priv);
 
+	pm_runtime_put(priv->device);
+
 	return 0;
 }
 
@@ -4616,6 +4649,12 @@ static int stmmac_vlan_rx_kill_vid(struc
 	bool is_double = false;
 	int ret;
 
+	ret = pm_runtime_get_sync(priv->device);
+	if (ret < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return ret;
+	}
+
 	if (be16_to_cpu(proto) == ETH_P_8021AD)
 		is_double = true;
 
@@ -4624,10 +4663,15 @@ static int stmmac_vlan_rx_kill_vid(struc
 	if (priv->hw->num_vlan) {
 		ret = stmmac_del_hw_vlan_rx_fltr(priv, ndev, priv->hw, proto, vid);
 		if (ret)
-			return ret;
+			goto del_vlan_error;
 	}
 
-	return stmmac_vlan_update(priv, is_double);
+	ret = stmmac_vlan_update(priv, is_double);
+
+del_vlan_error:
+	pm_runtime_put(priv->device);
+
+	return ret;
 }
 
 static const struct net_device_ops stmmac_netdev_ops = {
@@ -5066,6 +5110,10 @@ int stmmac_dvr_probe(struct device *devi
 
 	stmmac_check_pcs_mode(priv);
 
+	pm_runtime_get_noresume(device);
+	pm_runtime_set_active(device);
+	pm_runtime_enable(device);
+
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI) {
 		/* MDIO bus Registration */
@@ -5103,6 +5151,11 @@ int stmmac_dvr_probe(struct device *devi
 	stmmac_init_fs(ndev);
 #endif
 
+	/* Let pm_runtime_put() disable the clocks.
+	 * If CONFIG_PM is not enabled, the clocks will stay powered.
+	 */
+	pm_runtime_put(device);
+
 	return ret;
 
 error_serdes_powerup:
@@ -5117,6 +5170,7 @@ error_mdio_register:
 	stmmac_napi_del(ndev);
 error_hw_init:
 	destroy_workqueue(priv->wq);
+	stmmac_bus_clks_config(priv, false);
 
 	return ret;
 }
@@ -5152,8 +5206,8 @@ int stmmac_dvr_remove(struct device *dev
 	phylink_destroy(priv->phylink);
 	if (priv->plat->stmmac_rst)
 		reset_control_assert(priv->plat->stmmac_rst);
-	clk_disable_unprepare(priv->plat->pclk);
-	clk_disable_unprepare(priv->plat->stmmac_clk);
+	pm_runtime_put(dev);
+	pm_runtime_disable(dev);
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI)
 		stmmac_mdio_unregister(ndev);
@@ -5176,6 +5230,7 @@ int stmmac_suspend(struct device *dev)
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
 	u32 chan;
+	int ret;
 
 	if (!ndev || !netif_running(ndev))
 		return 0;
@@ -5219,8 +5274,9 @@ int stmmac_suspend(struct device *dev)
 		pinctrl_pm_select_sleep_state(priv->device);
 		/* Disable clock in case of PWM is off */
 		clk_disable_unprepare(priv->plat->clk_ptp_ref);
-		clk_disable_unprepare(priv->plat->pclk);
-		clk_disable_unprepare(priv->plat->stmmac_clk);
+		ret = pm_runtime_force_suspend(dev);
+		if (ret)
+			return ret;
 	}
 	mutex_unlock(&priv->lock);
 
@@ -5286,8 +5342,9 @@ int stmmac_resume(struct device *dev)
 	} else {
 		pinctrl_pm_select_default_state(priv->device);
 		/* enable the clk previously disabled */
-		clk_prepare_enable(priv->plat->stmmac_clk);
-		clk_prepare_enable(priv->plat->pclk);
+		ret = pm_runtime_force_resume(dev);
+		if (ret)
+			return ret;
 		if (priv->plat->clk_ptp_ref)
 			clk_prepare_enable(priv->plat->clk_ptp_ref);
 		/* reset the phy so that it's ready */
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -15,6 +15,7 @@
 #include <linux/iopoll.h>
 #include <linux/mii.h>
 #include <linux/of_mdio.h>
+#include <linux/pm_runtime.h>
 #include <linux/phy.h>
 #include <linux/property.h>
 #include <linux/slab.h>
@@ -87,21 +88,29 @@ static int stmmac_xgmac2_mdio_read(struc
 	u32 tmp, addr, value = MII_XGMAC_BUSY;
 	int ret;
 
+	ret = pm_runtime_get_sync(priv->device);
+	if (ret < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return ret;
+	}
+
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
-			       !(tmp & MII_XGMAC_BUSY), 100, 10000))
-		return -EBUSY;
+			       !(tmp & MII_XGMAC_BUSY), 100, 10000)) {
+		ret = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	if (phyreg & MII_ADDR_C45) {
 		phyreg &= ~MII_ADDR_C45;
 
 		ret = stmmac_xgmac2_c45_format(priv, phyaddr, phyreg, &addr);
 		if (ret)
-			return ret;
+			goto err_disable_clks;
 	} else {
 		ret = stmmac_xgmac2_c22_format(priv, phyaddr, phyreg, &addr);
 		if (ret)
-			return ret;
+			goto err_disable_clks;
 
 		value |= MII_XGMAC_SADDR;
 	}
@@ -112,8 +121,10 @@ static int stmmac_xgmac2_mdio_read(struc
 
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
-			       !(tmp & MII_XGMAC_BUSY), 100, 10000))
-		return -EBUSY;
+			       !(tmp & MII_XGMAC_BUSY), 100, 10000)) {
+		ret = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	/* Set the MII address register to read */
 	writel(addr, priv->ioaddr + mii_address);
@@ -121,11 +132,18 @@ static int stmmac_xgmac2_mdio_read(struc
 
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
-			       !(tmp & MII_XGMAC_BUSY), 100, 10000))
-		return -EBUSY;
+			       !(tmp & MII_XGMAC_BUSY), 100, 10000)) {
+		ret = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	/* Read the data from the MII data register */
-	return readl(priv->ioaddr + mii_data) & GENMASK(15, 0);
+	ret = (int)readl(priv->ioaddr + mii_data) & GENMASK(15, 0);
+
+err_disable_clks:
+	pm_runtime_put(priv->device);
+
+	return ret;
 }
 
 static int stmmac_xgmac2_mdio_write(struct mii_bus *bus, int phyaddr,
@@ -138,21 +156,29 @@ static int stmmac_xgmac2_mdio_write(stru
 	u32 addr, tmp, value = MII_XGMAC_BUSY;
 	int ret;
 
+	ret = pm_runtime_get_sync(priv->device);
+	if (ret < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return ret;
+	}
+
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
-			       !(tmp & MII_XGMAC_BUSY), 100, 10000))
-		return -EBUSY;
+			       !(tmp & MII_XGMAC_BUSY), 100, 10000)) {
+		ret = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	if (phyreg & MII_ADDR_C45) {
 		phyreg &= ~MII_ADDR_C45;
 
 		ret = stmmac_xgmac2_c45_format(priv, phyaddr, phyreg, &addr);
 		if (ret)
-			return ret;
+			goto err_disable_clks;
 	} else {
 		ret = stmmac_xgmac2_c22_format(priv, phyaddr, phyreg, &addr);
 		if (ret)
-			return ret;
+			goto err_disable_clks;
 
 		value |= MII_XGMAC_SADDR;
 	}
@@ -164,16 +190,23 @@ static int stmmac_xgmac2_mdio_write(stru
 
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
-			       !(tmp & MII_XGMAC_BUSY), 100, 10000))
-		return -EBUSY;
+			       !(tmp & MII_XGMAC_BUSY), 100, 10000)) {
+		ret = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	/* Set the MII address register to write */
 	writel(addr, priv->ioaddr + mii_address);
 	writel(value, priv->ioaddr + mii_data);
 
 	/* Wait until any existing MII operation is complete */
-	return readl_poll_timeout(priv->ioaddr + mii_data, tmp,
-				  !(tmp & MII_XGMAC_BUSY), 100, 10000);
+	ret = readl_poll_timeout(priv->ioaddr + mii_data, tmp,
+				 !(tmp & MII_XGMAC_BUSY), 100, 10000);
+
+err_disable_clks:
+	pm_runtime_put(priv->device);
+
+	return ret;
 }
 
 /**
@@ -196,6 +229,12 @@ static int stmmac_mdio_read(struct mii_b
 	int data = 0;
 	u32 v;
 
+	data = pm_runtime_get_sync(priv->device);
+	if (data < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return data;
+	}
+
 	value |= (phyaddr << priv->hw->mii.addr_shift)
 		& priv->hw->mii.addr_mask;
 	value |= (phyreg << priv->hw->mii.reg_shift) & priv->hw->mii.reg_mask;
@@ -216,19 +255,26 @@ static int stmmac_mdio_read(struct mii_b
 	}
 
 	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
-			       100, 10000))
-		return -EBUSY;
+			       100, 10000)) {
+		data = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	writel(data, priv->ioaddr + mii_data);
 	writel(value, priv->ioaddr + mii_address);
 
 	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
-			       100, 10000))
-		return -EBUSY;
+			       100, 10000)) {
+		data = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	/* Read the data from the MII data register */
 	data = (int)readl(priv->ioaddr + mii_data) & MII_DATA_MASK;
 
+err_disable_clks:
+	pm_runtime_put(priv->device);
+
 	return data;
 }
 
@@ -247,10 +293,16 @@ static int stmmac_mdio_write(struct mii_
 	struct stmmac_priv *priv = netdev_priv(ndev);
 	unsigned int mii_address = priv->hw->mii.addr;
 	unsigned int mii_data = priv->hw->mii.data;
+	int ret, data = phydata;
 	u32 value = MII_BUSY;
-	int data = phydata;
 	u32 v;
 
+	ret = pm_runtime_get_sync(priv->device);
+	if (ret < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return ret;
+	}
+
 	value |= (phyaddr << priv->hw->mii.addr_shift)
 		& priv->hw->mii.addr_mask;
 	value |= (phyreg << priv->hw->mii.reg_shift) & priv->hw->mii.reg_mask;
@@ -275,16 +327,23 @@ static int stmmac_mdio_write(struct mii_
 
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
-			       100, 10000))
-		return -EBUSY;
+			       100, 10000)) {
+		ret = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	/* Set the MII address register to write */
 	writel(data, priv->ioaddr + mii_data);
 	writel(value, priv->ioaddr + mii_address);
 
 	/* Wait until any existing MII operation is complete */
-	return readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
-				  100, 10000);
+	ret = readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
+				 100, 10000);
+
+err_disable_clks:
+	pm_runtime_put(priv->device);
+
+	return ret;
 }
 
 /**
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -760,10 +760,30 @@ static int stmmac_pltfr_resume(struct de
 
 	return stmmac_resume(dev);
 }
+
+static int stmmac_runtime_suspend(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+
+	stmmac_bus_clks_config(priv, false);
+
+	return 0;
+}
+
+static int stmmac_runtime_resume(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+
+	return stmmac_bus_clks_config(priv, true);
+}
 #endif /* CONFIG_PM_SLEEP */
 
-SIMPLE_DEV_PM_OPS(stmmac_pltfr_pm_ops, stmmac_pltfr_suspend,
-				       stmmac_pltfr_resume);
+const struct dev_pm_ops stmmac_pltfr_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(stmmac_pltfr_suspend, stmmac_pltfr_resume)
+	SET_RUNTIME_PM_OPS(stmmac_runtime_suspend, stmmac_runtime_resume, NULL)
+};
 EXPORT_SYMBOL_GPL(stmmac_pltfr_pm_ops);
 
 MODULE_DESCRIPTION("STMMAC 10/100/1000 Ethernet platform support");


