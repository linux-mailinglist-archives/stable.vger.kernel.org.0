Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC8C55E163
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235512AbiF0LbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235514AbiF0L3x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:29:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D00B6A;
        Mon, 27 Jun 2022 04:28:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83344B81123;
        Mon, 27 Jun 2022 11:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA648C3411D;
        Mon, 27 Jun 2022 11:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329312;
        bh=H3PkShMS5tf0/PpMKZejczg+nRG9ZJY4p0skfPXy2wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rkOrmDEv3sJlBZNNmswWxBbiWQZwPzRTQT4edRKga5NJQK6C2v7+AWbUK9oKazoqe
         W+1KlHGSisyjBvg4fdxj/lsYXZ0vSqaT2uWItwq4p6F241gXv54ozVkTzEbT/XEwBw
         oaMy8eatJv8eVRVXdN+0rUnnkXC35PqFf8K8MRZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Spacek <ondrej.spacek@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 18/60] phy: aquantia: Fix AN when higher speeds than 1G are not advertised
Date:   Mon, 27 Jun 2022 13:21:29 +0200
Message-Id: <20220627111928.196980705@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111927.641837068@linuxfoundation.org>
References: <20220627111927.641837068@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>

[ Upstream commit 9b7fd1670a94a57d974795acebde843a5c1a354e ]

Even when the eth port is resticted to work with speeds not higher than 1G,
and so the eth driver is requesting the phy (via phylink) to advertise up
to 1000BASET support, the aquantia phy device is still advertising for 2.5G
and 5G speeds.
Clear these advertising defaults when requested.

Cc: Ondrej Spacek <ondrej.spacek@nxp.com>
Fixes: 09c4c57f7bc41 ("net: phy: aquantia: add support for auto-negotiation configuration")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Link: https://lore.kernel.org/r/20220610084037.7625-1-claudiu.manoil@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/aquantia_main.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 975789d9349d..75d8351ee250 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -34,6 +34,8 @@
 #define MDIO_AN_VEND_PROV			0xc400
 #define MDIO_AN_VEND_PROV_1000BASET_FULL	BIT(15)
 #define MDIO_AN_VEND_PROV_1000BASET_HALF	BIT(14)
+#define MDIO_AN_VEND_PROV_5000BASET_FULL	BIT(11)
+#define MDIO_AN_VEND_PROV_2500BASET_FULL	BIT(10)
 #define MDIO_AN_VEND_PROV_DOWNSHIFT_EN		BIT(4)
 #define MDIO_AN_VEND_PROV_DOWNSHIFT_MASK	GENMASK(3, 0)
 #define MDIO_AN_VEND_PROV_DOWNSHIFT_DFLT	4
@@ -230,9 +232,20 @@ static int aqr_config_aneg(struct phy_device *phydev)
 			      phydev->advertising))
 		reg |= MDIO_AN_VEND_PROV_1000BASET_HALF;
 
+	/* Handle the case when the 2.5G and 5G speeds are not advertised */
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
+			      phydev->advertising))
+		reg |= MDIO_AN_VEND_PROV_2500BASET_FULL;
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_5000baseT_Full_BIT,
+			      phydev->advertising))
+		reg |= MDIO_AN_VEND_PROV_5000BASET_FULL;
+
 	ret = phy_modify_mmd_changed(phydev, MDIO_MMD_AN, MDIO_AN_VEND_PROV,
 				     MDIO_AN_VEND_PROV_1000BASET_HALF |
-				     MDIO_AN_VEND_PROV_1000BASET_FULL, reg);
+				     MDIO_AN_VEND_PROV_1000BASET_FULL |
+				     MDIO_AN_VEND_PROV_2500BASET_FULL |
+				     MDIO_AN_VEND_PROV_5000BASET_FULL, reg);
 	if (ret < 0)
 		return ret;
 	if (ret > 0)
-- 
2.35.1



