Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCFC4F2D11
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242931AbiDEJid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242704AbiDEJIS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:08:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DB275E60;
        Tue,  5 Apr 2022 01:57:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CD8461577;
        Tue,  5 Apr 2022 08:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8D6C385A0;
        Tue,  5 Apr 2022 08:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149031;
        bh=bLgjVcnUj4tcrOszUiESG7XYIWk+hFyD1xAOR+/+N1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pn+WPR+B1GoAyk0PwMbIIZMl6iy59aJ1SXxBsNtIre7/504rdehEvRbUoKa3hfcCA
         kBkr4jYGz0GbPhMu7leItBi6xUrFb/6GTWz8Wt4mawwaNp7A9vzoCN4NJk8eMiH4Yi
         FN4ZnE5FjOr+81QBI9W3i0Pj7vmSgE/v4/ZRVTHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Divya Koppera <Divya.Koppera@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0569/1017] net: phy: micrel: Fix concurrent register access
Date:   Tue,  5 Apr 2022 09:24:42 +0200
Message-Id: <20220405070411.169298291@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Divya Koppera <Divya.Koppera@microchip.com>

[ Upstream commit 4488f6b6148045424459ef1d5b153c6895ee1dbb ]

Make Extended page register accessing atomic,
to overcome unexpected output from register
reads/writes.

Fixes: 7c2dcfa295b1 ("net: phy: micrel: Add support for LAN8804 PHY")
Signed-off-by: Divya Koppera<Divya.Koppera@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 76ef4e019ca9..15fe0fa78092 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1575,11 +1575,13 @@ static int lanphy_read_page_reg(struct phy_device *phydev, int page, u32 addr)
 {
 	u32 data;
 
-	phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, page);
-	phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, addr);
-	phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL,
-		  (page | LAN_EXT_PAGE_ACCESS_CTRL_EP_FUNC));
-	data = phy_read(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA);
+	phy_lock_mdio_bus(phydev);
+	__phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, page);
+	__phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, addr);
+	__phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL,
+		    (page | LAN_EXT_PAGE_ACCESS_CTRL_EP_FUNC));
+	data = __phy_read(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA);
+	phy_unlock_mdio_bus(phydev);
 
 	return data;
 }
@@ -1587,18 +1589,18 @@ static int lanphy_read_page_reg(struct phy_device *phydev, int page, u32 addr)
 static int lanphy_write_page_reg(struct phy_device *phydev, int page, u16 addr,
 				 u16 val)
 {
-	phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, page);
-	phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, addr);
-	phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL,
-		  (page | LAN_EXT_PAGE_ACCESS_CTRL_EP_FUNC));
-
-	val = phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, val);
-	if (val) {
+	phy_lock_mdio_bus(phydev);
+	__phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, page);
+	__phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, addr);
+	__phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL,
+		    page | LAN_EXT_PAGE_ACCESS_CTRL_EP_FUNC);
+
+	val = __phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, val);
+	if (val != 0)
 		phydev_err(phydev, "Error: phy_write has returned error %d\n",
 			   val);
-		return val;
-	}
-	return 0;
+	phy_unlock_mdio_bus(phydev);
+	return val;
 }
 
 static int lan8804_config_init(struct phy_device *phydev)
-- 
2.34.1



