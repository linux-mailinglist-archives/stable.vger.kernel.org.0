Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADFD164A1DD
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbiLLNqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:46:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbiLLNqQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:46:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E1814D08
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:46:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8413961089
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38029C433D2;
        Mon, 12 Dec 2022 13:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852761;
        bh=s4GHnFx5q/GyBdsSbyTfDFOP6VaS6/pjAv27D9wTgFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BacojAAAjn84xnxjSyjibISVoW4sMMdaCCmmPYzPr+hNbudQzziQw4CDVzt5lJjdl
         3SSsNcm4j1/8RDyoXjPyTPcBkZFbcyUC1pHjuWLr9jH+fgY23qlsQ+cHnxQbirXsTF
         k1aPvFoy0Pc8yitT3hB6nkg3tv17J7zeLy5unsoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 119/157] net: mdiobus: fwnode_mdiobus_register_phy() rework error handling
Date:   Mon, 12 Dec 2022 14:17:47 +0100
Message-Id: <20221212130939.636766094@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit cfaa202a73eafaf91a3d0a86b5e5df006562f5c0 ]

Rework error handling as preparation for PSE patch. This patch should
make it easier to extend this function.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 165df24186ec ("net: mdiobus: fix double put fwnode in the error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/fwnode_mdio.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 40e745a1d185..403b07f8ec2c 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -110,8 +110,8 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	else
 		phy = phy_device_create(bus, addr, phy_id, 0, NULL);
 	if (IS_ERR(phy)) {
-		unregister_mii_timestamper(mii_ts);
-		return PTR_ERR(phy);
+		rc = PTR_ERR(phy);
+		goto clean_mii_ts;
 	}
 
 	if (is_acpi_node(child)) {
@@ -125,17 +125,13 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 		/* All data is now stored in the phy struct, so register it */
 		rc = phy_device_register(phy);
 		if (rc) {
-			phy_device_free(phy);
 			fwnode_handle_put(phy->mdio.dev.fwnode);
-			return rc;
+			goto clean_phy;
 		}
 	} else if (is_of_node(child)) {
 		rc = fwnode_mdiobus_phy_device_register(bus, phy, child, addr);
-		if (rc) {
-			unregister_mii_timestamper(mii_ts);
-			phy_device_free(phy);
-			return rc;
-		}
+		if (rc)
+			goto clean_phy;
 	}
 
 	/* phy->mii_ts may already be defined by the PHY driver. A
@@ -145,5 +141,12 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	if (mii_ts)
 		phy->mii_ts = mii_ts;
 	return 0;
+
+clean_phy:
+	phy_device_free(phy);
+clean_mii_ts:
+	unregister_mii_timestamper(mii_ts);
+
+	return rc;
 }
 EXPORT_SYMBOL(fwnode_mdiobus_register_phy);
-- 
2.35.1



