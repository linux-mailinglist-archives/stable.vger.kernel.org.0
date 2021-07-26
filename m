Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E9E3D600C
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237028AbhGZPU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:20:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237032AbhGZPU0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:20:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A613460F6E;
        Mon, 26 Jul 2021 16:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315255;
        bh=ficlE3bySRIK+At82NMxpFsU7S9QRyOWETvSEAkAnU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1tsluXFoI8g9qAdj4/sf+l79iq7cj20OO7kGpz0nMNhEBhoc2EBfvVJ8cnPwcCITd
         MFdOCrXcyqRLNdZYUYCY78J3l72qTHlxDQvA9w4P6uqq3ODRuKZZJykPdoaQTJFTEG
         vGNZ0edyFZn0796Cb0pR9WoVNYdYty4wwuUtJEI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/167] stmmac: platform: Fix signedness bug in stmmac_probe_config_dt()
Date:   Mon, 26 Jul 2021 17:37:37 +0200
Message-Id: <20210726153840.173231051@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit eca81f09145d765c21dd8fb1ba5d874ca255c32c ]

The "plat->phy_interface" variable is an enum and in this context GCC
will treat it as an unsigned int so the error handling is never
triggered.

Fixes: b9f0b2f634c0 ("net: stmmac: platform: fix probe for ACPI devices")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index ff95400594fc..53be8fc1d125 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -399,6 +399,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 	struct device_node *np = pdev->dev.of_node;
 	struct plat_stmmacenet_data *plat;
 	struct stmmac_dma_cfg *dma_cfg;
+	int phy_mode;
 	int rc;
 
 	plat = devm_kzalloc(&pdev->dev, sizeof(*plat), GFP_KERNEL);
@@ -413,10 +414,11 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 		*mac = NULL;
 	}
 
-	plat->phy_interface = device_get_phy_mode(&pdev->dev);
-	if (plat->phy_interface < 0)
-		return ERR_PTR(plat->phy_interface);
+	phy_mode = device_get_phy_mode(&pdev->dev);
+	if (phy_mode < 0)
+		return ERR_PTR(phy_mode);
 
+	plat->phy_interface = phy_mode;
 	plat->interface = stmmac_of_get_mac_mode(np);
 	if (plat->interface < 0)
 		plat->interface = plat->phy_interface;
-- 
2.30.2



