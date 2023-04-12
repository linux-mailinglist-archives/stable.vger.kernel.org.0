Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBE66DEE8A
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbjDLImX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbjDLImK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:42:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA93C83D9
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:41:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7A7A6302F
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8EDC433D2;
        Wed, 12 Apr 2023 08:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288886;
        bh=SKUL8imNZiCgQgP1mALozW1haxGmUZgmW3q8UItzt9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VT1snO94zATyfoeHYbgOR1Hh6iR2YMIu1Utl9P7Fv0mUFnaLKXjfyI17v9Osr7Ff6
         gCsBOweRPhdB6H0qQ0pcAuN27EeQSr4vR0RiB3OouQO3Eg0cHuxAiTzhdyoJuGpvwQ
         th3tlT8y3uYWjz0TZnXQNHO4UI3SE3Wf5JFSzgP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Shahab Vahedi <shahab@synopsys.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/164] net: stmmac: check fwnode for phy device before scanning for phy
Date:   Wed, 12 Apr 2023 10:32:57 +0200
Message-Id: <20230412082839.175252569@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>

[ Upstream commit 8fbc10b995a506e173f1080dfa2764f232a65e02 ]

Some DT devices already have phy device configured in the DT/ACPI.
Current implementation scans for a phy unconditionally even though
there is a phy listed in the DT/ACPI and already attached.

We should check the fwnode if there is any phy device listed in
fwnode and decide whether to scan for a phy to attach to.

Fixes: fe2cfbc96803 ("net: stmmac: check if MAC needs to attach to a PHY")
Reported-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/lkml/20230403212434.296975-1-martin.blumenstingl@googlemail.com/
Tested-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Shahab Vahedi <shahab@synopsys.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Suggested-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Link: https://lore.kernel.org/r/20230406024541.3556305-1-michael.wei.hong.sit@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 3f35399657da2..05607c1ab3319 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1132,22 +1132,26 @@ static void stmmac_check_pcs_mode(struct stmmac_priv *priv)
 static int stmmac_init_phy(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
+	struct fwnode_handle *phy_fwnode;
 	struct fwnode_handle *fwnode;
-	bool phy_needed;
 	int ret;
 
+	if (!phylink_expects_phy(priv->phylink))
+		return 0;
+
 	fwnode = of_fwnode_handle(priv->plat->phylink_node);
 	if (!fwnode)
 		fwnode = dev_fwnode(priv->device);
 
 	if (fwnode)
-		ret = phylink_fwnode_phy_connect(priv->phylink, fwnode, 0);
+		phy_fwnode = fwnode_get_phy_node(fwnode);
+	else
+		phy_fwnode = NULL;
 
-	phy_needed = phylink_expects_phy(priv->phylink);
 	/* Some DT bindings do not set-up the PHY handle. Let's try to
 	 * manually parse it
 	 */
-	if (!fwnode || phy_needed || ret) {
+	if (!phy_fwnode || IS_ERR(phy_fwnode)) {
 		int addr = priv->plat->phy_addr;
 		struct phy_device *phydev;
 
@@ -1163,6 +1167,9 @@ static int stmmac_init_phy(struct net_device *dev)
 		}
 
 		ret = phylink_connect_phy(priv->phylink, phydev);
+	} else {
+		fwnode_handle_put(phy_fwnode);
+		ret = phylink_fwnode_phy_connect(priv->phylink, fwnode, 0);
 	}
 
 	if (!priv->plat->pmt) {
-- 
2.39.2



