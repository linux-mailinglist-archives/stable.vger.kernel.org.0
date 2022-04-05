Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073EC4F34FB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbiDEIiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237960AbiDEISe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:18:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A967EB7C6F;
        Tue,  5 Apr 2022 01:07:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74AD1B81BAF;
        Tue,  5 Apr 2022 08:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0256C385A1;
        Tue,  5 Apr 2022 08:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146066;
        bh=67yb1/B6Sg6i3jl64lZRn2eNJU5+LSPF5bkVgEih44E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E9I8VZO4FXzBrl7e8PLaDPoNzH+1YoIImL6erO8geMW+HNcjyFq4lA3lbSMwUXI1b
         v/6bbY3nij1oAh2JLSLznAhDaE3iASZMz/ChzODf6SbydsO334XbMtVi0CWv43YZ6+
         ojigBYoNSoWa9eou63a6Vs/Pq0tA0FH7fgSAER4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Divya Koppera <Divya.Koppera@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0628/1126] net: phy: micrel: Fix concurrent register access
Date:   Tue,  5 Apr 2022 09:22:55 +0200
Message-Id: <20220405070426.069996732@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
 drivers/net/phy/micrel.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index a7ebcdab415b..281cebc3d00c 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1596,11 +1596,13 @@ static int lanphy_read_page_reg(struct phy_device *phydev, int page, u32 addr)
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
@@ -1608,18 +1610,18 @@ static int lanphy_read_page_reg(struct phy_device *phydev, int page, u32 addr)
 static int lanphy_write_page_reg(struct phy_device *phydev, int page, u16 addr,
 				 u16 val)
 {
-	phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, page);
-	phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, addr);
-	phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL,
-		  (page | LAN_EXT_PAGE_ACCESS_CTRL_EP_FUNC));
+	phy_lock_mdio_bus(phydev);
+	__phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, page);
+	__phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, addr);
+	__phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL,
+		    page | LAN_EXT_PAGE_ACCESS_CTRL_EP_FUNC);
 
-	val = phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, val);
-	if (val) {
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
 
 static int lan8814_config_init(struct phy_device *phydev)
-- 
2.34.1



