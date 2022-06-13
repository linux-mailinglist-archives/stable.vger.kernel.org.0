Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C2E548766
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376273AbiFMNVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377266AbiFMNUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:20:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF5E6A03F;
        Mon, 13 Jun 2022 04:23:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE6C3B80EB7;
        Mon, 13 Jun 2022 11:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5769FC34114;
        Mon, 13 Jun 2022 11:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119380;
        bh=HAxRoji8uG/RdFQsI1RZvPTs7xTUfZBGIXUkTYvNiBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=np+gDYpBf+o1pa4GmoNUq7YfG2fOCMWlBQLGch3BL4dQwAC2+ggfBY1dtg1sA5ltE
         XAqie5yTdpRQl0QeihoMrpAPErIwtAx8CCHUKgvKaHOm3XP7J0MPpJO4LO2SC7mmTh
         MPdXwVotwV/WdGUI3Spc7D4gfNaxxVy7JJpRFOsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sit@vger.kernel.org
Subject: [PATCH 5.15 224/247] net: phy: dp83867: retrigger SGMII AN when link change
Date:   Mon, 13 Jun 2022 12:12:06 +0200
Message-Id: <20220613094929.739601502@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
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

From: Tan Tee Min <tee.min.tan@linux.intel.com>

commit c76acfb7e19dcc3a0964e0563770b1d11b8d4540 upstream.

There is a limitation in TI DP83867 PHY device where SGMII AN is only
triggered once after the device is booted up. Even after the PHY TPI is
down and up again, SGMII AN is not triggered and hence no new in-band
message from PHY to MAC side SGMII.

This could cause an issue during power up, when PHY is up prior to MAC.
At this condition, once MAC side SGMII is up, MAC side SGMII wouldn`t
receive new in-band message from TI PHY with correct link status, speed
and duplex info.

As suggested by TI, implemented a SW solution here to retrigger SGMII
Auto-Neg whenever there is a link change.

v2: Add Fixes tag in commit message.

Fixes: 2a10154abcb7 ("net: phy: dp83867: Add TI dp83867 phy")
Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: Sit, Michael Wei Hong <michael.wei.hong.sit@intel.com>
Reviewed-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220526090347.128742-1-tee.min.tan@linux.intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/dp83867.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -137,6 +137,7 @@
 #define DP83867_DOWNSHIFT_2_COUNT	2
 #define DP83867_DOWNSHIFT_4_COUNT	4
 #define DP83867_DOWNSHIFT_8_COUNT	8
+#define DP83867_SGMII_AUTONEG_EN	BIT(7)
 
 /* CFG3 bits */
 #define DP83867_CFG3_INT_OE			BIT(7)
@@ -836,6 +837,32 @@ static int dp83867_phy_reset(struct phy_
 			 DP83867_PHYCR_FORCE_LINK_GOOD, 0);
 }
 
+static void dp83867_link_change_notify(struct phy_device *phydev)
+{
+	/* There is a limitation in DP83867 PHY device where SGMII AN is
+	 * only triggered once after the device is booted up. Even after the
+	 * PHY TPI is down and up again, SGMII AN is not triggered and
+	 * hence no new in-band message from PHY to MAC side SGMII.
+	 * This could cause an issue during power up, when PHY is up prior
+	 * to MAC. At this condition, once MAC side SGMII is up, MAC side
+	 * SGMII wouldn`t receive new in-band message from TI PHY with
+	 * correct link status, speed and duplex info.
+	 * Thus, implemented a SW solution here to retrigger SGMII Auto-Neg
+	 * whenever there is a link change.
+	 */
+	if (phydev->interface == PHY_INTERFACE_MODE_SGMII) {
+		int val = 0;
+
+		val = phy_clear_bits(phydev, DP83867_CFG2,
+				     DP83867_SGMII_AUTONEG_EN);
+		if (val < 0)
+			return;
+
+		phy_set_bits(phydev, DP83867_CFG2,
+			     DP83867_SGMII_AUTONEG_EN);
+	}
+}
+
 static struct phy_driver dp83867_driver[] = {
 	{
 		.phy_id		= DP83867_PHY_ID,
@@ -860,6 +887,8 @@ static struct phy_driver dp83867_driver[
 
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
+
+		.link_change_notify = dp83867_link_change_notify,
 	},
 };
 module_phy_driver(dp83867_driver);


