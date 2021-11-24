Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97AA045C651
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351829AbhKXOGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:06:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:51224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350511AbhKXOEs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:04:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36369633F5;
        Wed, 24 Nov 2021 13:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759499;
        bh=Jlfirz+BwWLf5ecEDiZggdtR6MEbXDnXvmVQ5Yh6Mgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XBYkfCl7ALBWJAgJ3UR/9KbKNm+r4WNy9gODFzjsgYhViyedlJ3k7RKmrn+Tj1l10
         xprGUXsT2nEKmTvxMMTZ+izB9vewqASC4itxOXB6Y0ePaZT6krqgT/lmVTvPokx0MZ
         ab8qqxCqiRGvwhmVyZ1yVWtqRWJ41kVjAlTMkkhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meng Li <Meng.Li@windriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 230/279] net: stmmac: socfpga: add runtime suspend/resume callback for stratix10 platform
Date:   Wed, 24 Nov 2021 12:58:37 +0100
Message-Id: <20211124115726.691947445@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Meng Li <meng.li@windriver.com>

commit 9119570039481d56350af1c636f040fb300b8cf3 upstream.

According to upstream commit 5ec55823438e("net: stmmac:
add clocks management for gmac driver"), it improve clocks
management for stmmac driver. So, it is necessary to implement
the runtime callback in dwmac-socfpga driver because it doesn't
use the common stmmac_pltfr_pm_ops instance. Otherwise, clocks
are not disabled when system enters suspend status.

Fixes: 5ec55823438e ("net: stmmac: add clocks management for gmac driver")
Cc: stable@vger.kernel.org
Signed-off-by: Meng Li <Meng.Li@windriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c |   24 ++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -485,8 +485,28 @@ static int socfpga_dwmac_resume(struct d
 }
 #endif /* CONFIG_PM_SLEEP */
 
-static SIMPLE_DEV_PM_OPS(socfpga_dwmac_pm_ops, stmmac_suspend,
-					       socfpga_dwmac_resume);
+static int __maybe_unused socfpga_dwmac_runtime_suspend(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+
+	stmmac_bus_clks_config(priv, false);
+
+	return 0;
+}
+
+static int __maybe_unused socfpga_dwmac_runtime_resume(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+
+	return stmmac_bus_clks_config(priv, true);
+}
+
+static const struct dev_pm_ops socfpga_dwmac_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(stmmac_suspend, socfpga_dwmac_resume)
+	SET_RUNTIME_PM_OPS(socfpga_dwmac_runtime_suspend, socfpga_dwmac_runtime_resume, NULL)
+};
 
 static const struct socfpga_dwmac_ops socfpga_gen5_ops = {
 	.set_phy_mode = socfpga_gen5_set_phy_mode,


