Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B254B4955
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346725AbiBNKVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:21:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347535AbiBNKVT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:21:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D147D29B;
        Mon, 14 Feb 2022 01:55:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF55FB80DCD;
        Mon, 14 Feb 2022 09:55:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10903C340E9;
        Mon, 14 Feb 2022 09:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832529;
        bh=l0PJjO+e5VJdWj/04DSb6gvQ/YyKbHI2YE4QxJza6hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ug/G4alaMp76I/s5AYBXYzXvsx6P9C1COZp0zoKXfzHXTMc5/ZUCOD3nQUMpKwMVT
         LbesKQpE4dNsvmyaV54CMbBfw9ZVw1uCT1c69NtgY+qVOc0buq1iNIBAioNtOO+bP+
         CK061/mGeRlUeyPgLQ3RRwV3U0BZ2F70nU9HAB18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Serge Semin <fancer.lancer@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.16 012/203] net: phy: marvell: Fix RGMII Tx/Rx delays setting in 88e1121-compatible PHYs
Date:   Mon, 14 Feb 2022 10:24:16 +0100
Message-Id: <20220214092510.636380201@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>

commit fe4f57bf7b585dca58f1496c4e2481ecbae18126 upstream.

It is mandatory for a software to issue a reset upon modifying RGMII
Receive Timing Control and RGMII Transmit Timing Control bit fields of MAC
Specific Control register 2 (page 2, register 21) otherwise the changes
won't be perceived by the PHY (the same is applicable for a lot of other
registers). Not setting the RGMII delays on the platforms that imply it'
being done on the PHY side will consequently cause the traffic loss. We
discovered that the denoted soft-reset is missing in the
m88e1121_config_aneg() method for the case if the RGMII delays are
modified but the MDIx polarity isn't changed or the auto-negotiation is
left enabled, thus causing the traffic loss on our platform with Marvell
Alaska 88E1510 installed. Let's fix that by issuing the soft-reset if the
delays have been actually set in the m88e1121_config_aneg_rgmii_delays()
method.

Cc: stable@vger.kernel.org
Fixes: d6ab93364734 ("net: phy: marvell: Avoid unnecessary soft reset")
Signed-off-by: Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Link: https://lore.kernel.org/r/20220205203932.26899-1-Pavel.Parkhomenko@baikalelectronics.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/marvell.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -553,9 +553,9 @@ static int m88e1121_config_aneg_rgmii_de
 	else
 		mscr = 0;
 
-	return phy_modify_paged(phydev, MII_MARVELL_MSCR_PAGE,
-				MII_88E1121_PHY_MSCR_REG,
-				MII_88E1121_PHY_MSCR_DELAY_MASK, mscr);
+	return phy_modify_paged_changed(phydev, MII_MARVELL_MSCR_PAGE,
+					MII_88E1121_PHY_MSCR_REG,
+					MII_88E1121_PHY_MSCR_DELAY_MASK, mscr);
 }
 
 static int m88e1121_config_aneg(struct phy_device *phydev)
@@ -569,11 +569,13 @@ static int m88e1121_config_aneg(struct p
 			return err;
 	}
 
+	changed = err;
+
 	err = marvell_set_polarity(phydev, phydev->mdix_ctrl);
 	if (err < 0)
 		return err;
 
-	changed = err;
+	changed |= err;
 
 	err = genphy_config_aneg(phydev);
 	if (err < 0)


