Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8386E5417FF
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378715AbiFGVHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379814AbiFGVG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:06:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AD421110C;
        Tue,  7 Jun 2022 11:50:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C699A616B6;
        Tue,  7 Jun 2022 18:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D307BC385A2;
        Tue,  7 Jun 2022 18:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627805;
        bh=TR74+tfIx5LPTfO6NYsObBj1oQozGcliwE9T2Z1bW0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u5mYNW03BS6tRjBIzJT0PR76vkfk7F4tCtW12KqLxQO4yP9jNwLIRBwT6NrHLuc7/
         1BdKjFCz9oe50/VWRWwANkdTJXNrieKb4Oa3t91oH2/ZaxdmMvDBOtZWFW9KCXs/vS
         KgLCXpiDAI79VGNno8tMELXnKS6KFMKrmIgWvNYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 098/879] net: macb: In ZynqMP initialization make SGMII phy configuration optional
Date:   Tue,  7 Jun 2022 18:53:36 +0200
Message-Id: <20220607165005.539894668@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

[ Upstream commit 29e96fe9e0ec0f0fe1dd306a4ccb7b8983eae67a ]

In the macb binding documentation "phys" is an optional property. Make
implementation in line with it. This change allows the traditional flow
in which first stage bootloader does PS-GT configuration to work along
with newer use cases in which PS-GT configuration is managed by the
phy-zynqmp driver.

It fixes below macb probe failure when macb DT node doesn't have SGMII
phys handle.
"macb ff0b0000.ethernet: error -ENODEV: failed to get PS-GTR PHY"

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Reviewed-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 61284baa0496..ed7c2c2c4401 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4594,7 +4594,7 @@ static int zynqmp_init(struct platform_device *pdev)
 
 	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII) {
 		/* Ensure PS-GTR PHY device used in SGMII mode is ready */
-		bp->sgmii_phy = devm_phy_get(&pdev->dev, "sgmii-phy");
+		bp->sgmii_phy = devm_phy_optional_get(&pdev->dev, NULL);
 
 		if (IS_ERR(bp->sgmii_phy)) {
 			ret = PTR_ERR(bp->sgmii_phy);
-- 
2.35.1



