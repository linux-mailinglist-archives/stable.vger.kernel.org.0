Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3112E45C3C3
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350701AbhKXNmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:42:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:34766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350468AbhKXNkG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:40:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDC196137B;
        Wed, 24 Nov 2021 12:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758633;
        bh=Jlfirz+BwWLf5ecEDiZggdtR6MEbXDnXvmVQ5Yh6Mgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pbaT4WcxSG566K+yMv2rE80hOOdma290h+XCwzbv6iNq4/SqSwB9uS++SfzI/Aott
         M1LYHUO4JauP8zY52tKrPg5c3W8W7R0pG78v3NrHTDa2vtPxtxMf15p4lk4QEh3OIO
         C8o/6asxkR8ZO02h50lHs4A0NQ5Bt8cIQJXMEPiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meng Li <Meng.Li@windriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 133/154] net: stmmac: socfpga: add runtime suspend/resume callback for stratix10 platform
Date:   Wed, 24 Nov 2021 12:58:49 +0100
Message-Id: <20211124115706.605336723@linuxfoundation.org>
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


