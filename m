Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC42C4B214A
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 10:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234424AbiBKJOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 04:14:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233855AbiBKJOp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 04:14:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3963102A
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 01:14:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6879CB828BA
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 09:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A49C340E9;
        Fri, 11 Feb 2022 09:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644570882;
        bh=QMkejOSBEi3VndTOsVVrKwPevqpbD87VeTfzCtbUX1w=;
        h=Subject:To:Cc:From:Date:From;
        b=MRDxDatg7sN7s/wtwbuP4Pi88REXUJUAXfVEqLijFslwsXe1bxk5DvaLqSd30A+yg
         pEOAw09mINyoT6TBIuahMHWHZy4u8mM3+a2UHhSV7/O4BICddZWaT/Toxb0lpsRgtH
         meckbh2mUqNxOb0V6zgSlI0E7x0o+aIFPLSxlz5M=
Subject: FAILED: patch "[PATCH] net: phy: marvell: Fix MDI-x polarity setting in" failed to apply to 4.9-stable tree
To:     Pavel.Parkhomenko@baikalelectronics.ru, andrew@lunn.ch,
        davem@davemloft.net, fancer.lancer@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 11 Feb 2022 10:14:39 +0100
Message-ID: <164457087916449@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From aec12836e7196e4d360b2cbf20cf7aa5139ad2ec Mon Sep 17 00:00:00 2001
From: Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
Date: Sun, 6 Feb 2022 00:49:51 +0300
Subject: [PATCH] net: phy: marvell: Fix MDI-x polarity setting in
 88e1118-compatible PHYs

When setting up autonegotiation for 88E1118R and compatible PHYs,
a software reset of PHY is issued before setting up polarity.
This is incorrect as changes of MDI Crossover Mode bits are
disruptive to the normal operation and must be followed by a
software reset to take effect. Let's patch m88e1118_config_aneg()
to fix the issue mentioned before by invoking software reset
of the PHY just after setting up MDI-x polarity.

Fixes: 605f196efbf8 ("phy: Add support for Marvell 88E1118 PHY")
Signed-off-by: Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Cc: stable@vger.kernel.org
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index fa71fb7a66b5..ab063961ac00 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1213,16 +1213,15 @@ static int m88e1118_config_aneg(struct phy_device *phydev)
 {
 	int err;
 
-	err = genphy_soft_reset(phydev);
+	err = marvell_set_polarity(phydev, phydev->mdix_ctrl);
 	if (err < 0)
 		return err;
 
-	err = marvell_set_polarity(phydev, phydev->mdix_ctrl);
+	err = genphy_config_aneg(phydev);
 	if (err < 0)
 		return err;
 
-	err = genphy_config_aneg(phydev);
-	return 0;
+	return genphy_soft_reset(phydev);
 }
 
 static int m88e1118_config_init(struct phy_device *phydev)

