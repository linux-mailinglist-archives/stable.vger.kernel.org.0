Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02AA654806E
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 09:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238168AbiFMH1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 03:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239119AbiFMH1b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 03:27:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A081619FA5
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 00:27:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4742260FA4
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 07:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D1FC34114;
        Mon, 13 Jun 2022 07:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655105249;
        bh=S/Efq1Fk0Svd3uR/392KHwgsbafaHF+wFhG9n0vtBB8=;
        h=Subject:To:Cc:From:Date:From;
        b=GQgN2is5+v2/tyZZg5RbWuAvULIfzg/MBhp4A/cOPWN946afil+ANTR0d8F5ykL+I
         wDwT4Vn8czE/9soIUtVhZSpTRnwCySffc3dbwVwU6hyg71n+/nP9/+2Tri1wDTljOQ
         feG2U1xvbwA2L3STXvTjvYD6VLvoRxDgU6etcHfk=
Subject: FAILED: patch "[PATCH] net: phy: dp83867: retrigger SGMII AN when link change" failed to apply to 5.4-stable tree
To:     tee.min.tan@linux.intel.com, andrew@lunn.ch, kuba@kernel.org,
        michael.wei.hong.sit@intel.com, stable@vger.kernel.org,
        weifeng.voon@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Jun 2022 09:27:26 +0200
Message-ID: <1655105246246179@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c76acfb7e19dcc3a0964e0563770b1d11b8d4540 Mon Sep 17 00:00:00 2001
From: Tan Tee Min <tee.min.tan@linux.intel.com>
Date: Thu, 26 May 2022 17:03:47 +0800
Subject: [PATCH] net: phy: dp83867: retrigger SGMII AN when link change

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

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 8561f2d4443b..13dafe7a29bd 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -137,6 +137,7 @@
 #define DP83867_DOWNSHIFT_2_COUNT	2
 #define DP83867_DOWNSHIFT_4_COUNT	4
 #define DP83867_DOWNSHIFT_8_COUNT	8
+#define DP83867_SGMII_AUTONEG_EN	BIT(7)
 
 /* CFG3 bits */
 #define DP83867_CFG3_INT_OE			BIT(7)
@@ -855,6 +856,32 @@ static int dp83867_phy_reset(struct phy_device *phydev)
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
@@ -879,6 +906,8 @@ static struct phy_driver dp83867_driver[] = {
 
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
+
+		.link_change_notify = dp83867_link_change_notify,
 	},
 };
 module_phy_driver(dp83867_driver);

