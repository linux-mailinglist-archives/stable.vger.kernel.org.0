Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4D165488D9
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378419AbiFMNl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379137AbiFMNjx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:39:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7E07A45F;
        Mon, 13 Jun 2022 04:28:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 990C461036;
        Mon, 13 Jun 2022 11:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDC6C34114;
        Mon, 13 Jun 2022 11:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119730;
        bh=wLl1b1j+BhIXPavSmYrCqWAoy3JDpgcE7FuuK5Gym5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zXD/ZxnlRBae/kO/iH7bVtw3CDIY7Rj3d9Mj1jJ9v3/WMrMJzOgKz/m5QGiMCvhOK
         wACODG9e1eb5HtFphCB9w4bZ/gmKR7eE5+2U9+MnGceguDeHxQGQZwUGWWJYcPX7qo
         LFyY1WSoAzOKK5OyK3M6/0dPQx8D7rtdUZwNEcVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Viorel Suman <viorel.suman@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 119/339] net: phy: at803x: disable WOL at probe
Date:   Mon, 13 Jun 2022 12:09:04 +0200
Message-Id: <20220613094930.118185904@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viorel Suman <viorel.suman@nxp.com>

[ Upstream commit d7cd5e06c9dd70a82f1461c7b5f676bc03f5cd61 ]

Before 7beecaf7d507b ("net: phy: at803x: improve the WOL feature") patch
"at803x_get_wol" implementation used AT803X_INTR_ENABLE_WOL value to set
WAKE_MAGIC flag, and now AT803X_WOL_EN value is used for the same purpose.
The problem here is that the values of these two bits are different after
hardware reset: AT803X_INTR_ENABLE_WOL=0 after hardware reset, but
AT803X_WOL_EN=1. So now, if called right after boot, "at803x_get_wol" will
set WAKE_MAGIC flag, even if WOL function is not enabled by calling
"at803x_set_wol" function. The patch disables WOL function on probe thus
the behavior is consistent.

Fixes: 7beecaf7d507b ("net: phy: at803x: improve the WOL feature")
Signed-off-by: Viorel Suman <viorel.suman@nxp.com>
Link: https://lore.kernel.org/r/20220527084935.235274-1-viorel.suman@oss.nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/at803x.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 73926006d319..6a467e7817a6 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -433,20 +433,21 @@ static void at803x_context_restore(struct phy_device *phydev,
 static int at803x_set_wol(struct phy_device *phydev,
 			  struct ethtool_wolinfo *wol)
 {
-	struct net_device *ndev = phydev->attached_dev;
-	const u8 *mac;
 	int ret, irq_enabled;
-	unsigned int i;
-	static const unsigned int offsets[] = {
-		AT803X_LOC_MAC_ADDR_32_47_OFFSET,
-		AT803X_LOC_MAC_ADDR_16_31_OFFSET,
-		AT803X_LOC_MAC_ADDR_0_15_OFFSET,
-	};
-
-	if (!ndev)
-		return -ENODEV;
 
 	if (wol->wolopts & WAKE_MAGIC) {
+		struct net_device *ndev = phydev->attached_dev;
+		const u8 *mac;
+		unsigned int i;
+		static const unsigned int offsets[] = {
+			AT803X_LOC_MAC_ADDR_32_47_OFFSET,
+			AT803X_LOC_MAC_ADDR_16_31_OFFSET,
+			AT803X_LOC_MAC_ADDR_0_15_OFFSET,
+		};
+
+		if (!ndev)
+			return -ENODEV;
+
 		mac = (const u8 *) ndev->dev_addr;
 
 		if (!is_valid_ether_addr(mac))
@@ -857,6 +858,9 @@ static int at803x_probe(struct phy_device *phydev)
 	if (phydev->drv->phy_id == ATH8031_PHY_ID) {
 		int ccr = phy_read(phydev, AT803X_REG_CHIP_CONFIG);
 		int mode_cfg;
+		struct ethtool_wolinfo wol = {
+			.wolopts = 0,
+		};
 
 		if (ccr < 0)
 			goto err;
@@ -872,6 +876,13 @@ static int at803x_probe(struct phy_device *phydev)
 			priv->is_fiber = true;
 			break;
 		}
+
+		/* Disable WOL by default */
+		ret = at803x_set_wol(phydev, &wol);
+		if (ret < 0) {
+			phydev_err(phydev, "failed to disable WOL on probe: %d\n", ret);
+			goto err;
+		}
 	}
 
 	return 0;
-- 
2.35.1



