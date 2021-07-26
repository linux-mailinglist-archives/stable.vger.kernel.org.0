Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6793D614C
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbhGZPad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:30:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237482AbhGZP3Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E90660C40;
        Mon, 26 Jul 2021 16:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315681;
        bh=Tl8kfP7Snlqt4eC1Y/lP9/jTsY7IYPwK2Y3EradGK+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nA/AJ/Xo487DX7/0bqJE5349AU62Z1egZGlTEsccL7vX4Iq7ZAMlk940caMi3IUwZ
         x3F0+0qRn5Ry8UiQFCVGcrkgVqNuGWxtDSV7n7O9ep8p2wsgyCxQj1wJiRQG1PjxoB
         esUfAEDT7ThJhPtbnTBSRTqQdRKOxW0z7JrKm4Fg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 024/223] stmmac: platform: Fix signedness bug in stmmac_probe_config_dt()
Date:   Mon, 26 Jul 2021 17:36:56 +0200
Message-Id: <20210726153847.038645348@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
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
index a696ada013eb..cad9e466353f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -399,6 +399,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 	struct device_node *np = pdev->dev.of_node;
 	struct plat_stmmacenet_data *plat;
 	struct stmmac_dma_cfg *dma_cfg;
+	int phy_mode;
 	void *ret;
 	int rc;
 
@@ -414,10 +415,11 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 		eth_zero_addr(mac);
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



