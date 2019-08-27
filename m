Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2A019E121
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfH0ID2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:03:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732238AbfH0ID2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:03:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE7D9206BA;
        Tue, 27 Aug 2019 08:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893007;
        bh=+iGOLvdZF5Oym6+p2UmvYlPOvV4U5PnhKP53laBujds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+nbnzG90WdK4KYOAbN0YSLscyXFdU14MVbwrhj6r6L29gtQbJ1cB54v9B6q0gect
         e+gCrYjHS8aWd5gOu66pXj4puTYn/TAttpxCTKAckmP6ezBIyCO6Vhwg7BZAjR0mnZ
         j3l3Vrk89R3oc/UmJxYWqYGgTrE8WvKh6zx7rLJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 061/162] enetc: Fix build error without PHYLIB
Date:   Tue, 27 Aug 2019 09:49:49 +0200
Message-Id: <20190827072740.297237020@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5f4e4203add2b860d2345312509a160f8292063b ]

If PHYLIB is not set, build enetc will fails:

drivers/net/ethernet/freescale/enetc/enetc.o: In function `enetc_open':
enetc.c: undefined reference to `phy_disconnect'
enetc.c: undefined reference to `phy_start'
drivers/net/ethernet/freescale/enetc/enetc.o: In function `enetc_close':
enetc.c: undefined reference to `phy_stop'
enetc.c: undefined reference to `phy_disconnect'
drivers/net/ethernet/freescale/enetc/enetc_ethtool.o: undefined reference to `phy_ethtool_get_link_ksettings'
drivers/net/ethernet/freescale/enetc/enetc_ethtool.o: undefined reference to `phy_ethtool_set_link_ksettings'
drivers/net/ethernet/freescale/enetc/enetc_mdio.o: In function `enetc_mdio_probe':
enetc_mdio.c: undefined reference to `mdiobus_alloc_size'
enetc_mdio.c: undefined reference to `mdiobus_free'

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/ethernet/freescale/enetc/Kconfig
index 8429f5c1d8106..8ac109e73a7bb 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -2,6 +2,7 @@
 config FSL_ENETC
 	tristate "ENETC PF driver"
 	depends on PCI && PCI_MSI && (ARCH_LAYERSCAPE || COMPILE_TEST)
+	select PHYLIB
 	help
 	  This driver supports NXP ENETC gigabit ethernet controller PCIe
 	  physical function (PF) devices, managing ENETC Ports at a privileged
-- 
2.20.1



