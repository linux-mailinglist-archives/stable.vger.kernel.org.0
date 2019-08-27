Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 258D19E136
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731970AbfH0IC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:02:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731967AbfH0IC1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:02:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C54E20828;
        Tue, 27 Aug 2019 08:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892946;
        bh=cIrO675xPH74UzDk1oUvKTEGphiAOzFgbTUid6zytAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SfXzhnx+nVUnG3DQKVjcPAjov/jRehPRMsv95dFvNe3TTIBETA9GpIwBWbWnzhVva
         QADRobuGAiPeKnZ9MvtLmJiOVF2IY/aSGcMjMJJqWtVrZ9S9IR+K3tqRcs0uL2BVj+
         CqHoZUzCawokp1brRn1xe2Z4VdE91WlSUv2GTNhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 070/162] enetc: Select PHYLIB while CONFIG_FSL_ENETC_VF is set
Date:   Tue, 27 Aug 2019 09:49:58 +0200
Message-Id: <20190827072740.576111235@linuxfoundation.org>
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

[ Upstream commit 2802d2cf24b1ca7ea4c54dde266ded6a16020eb5 ]

Like FSL_ENETC, when CONFIG_FSL_ENETC_VF is set,
we should select PHYLIB, otherwise building still fails:

drivers/net/ethernet/freescale/enetc/enetc.o: In function `enetc_open':
enetc.c:(.text+0x2744): undefined reference to `phy_start'
enetc.c:(.text+0x282c): undefined reference to `phy_disconnect'
drivers/net/ethernet/freescale/enetc/enetc.o: In function `enetc_close':
enetc.c:(.text+0x28f8): undefined reference to `phy_stop'
enetc.c:(.text+0x2904): undefined reference to `phy_disconnect'
drivers/net/ethernet/freescale/enetc/enetc_ethtool.o:(.rodata+0x3f8): undefined reference to `phy_ethtool_get_link_ksettings'
drivers/net/ethernet/freescale/enetc/enetc_ethtool.o:(.rodata+0x400): undefined reference to `phy_ethtool_set_link_ksettings'

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/ethernet/freescale/enetc/Kconfig
index 8ac109e73a7bb..a268e74b1834e 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -13,6 +13,7 @@ config FSL_ENETC
 config FSL_ENETC_VF
 	tristate "ENETC VF driver"
 	depends on PCI && PCI_MSI && (ARCH_LAYERSCAPE || COMPILE_TEST)
+	select PHYLIB
 	help
 	  This driver supports NXP ENETC gigabit ethernet controller PCIe
 	  virtual function (VF) devices enabled by the ENETC PF driver.
-- 
2.20.1



