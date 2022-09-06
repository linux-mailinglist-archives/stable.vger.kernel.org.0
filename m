Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 422445AECA0
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240940AbiIFOLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240628AbiIFOIB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:08:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9087F85FD8;
        Tue,  6 Sep 2022 06:45:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 349816155D;
        Tue,  6 Sep 2022 13:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC0CC433D7;
        Tue,  6 Sep 2022 13:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471884;
        bh=wb7UPJN4NYPb1TO690B9c40Rfzbvv/Y4FMpbqVIGKyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DIOnYuicbL2/li4yEM9FBnePM5m42EcL7iTTNAeBSZOrk3EGlz199ow1dyC899rtg
         vDJSgCaVh6Gn1cMq3Wzcrfpce6OfZ0fsRbF8FERjtmm1gv7GHneUNpdsORS0XKsnuc
         vNgZIP6ps+Au4XYi9B/gWKWgHzOz3GKvPH3g2yyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 041/155] net: phy: micrel: Make the GPIO to be non-exclusive
Date:   Tue,  6 Sep 2022 15:29:49 +0200
Message-Id: <20220906132831.142924443@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 4a4ce82212ef014d70f486a427005b2b5bab8e34 ]

The same GPIO line can be shared by multiple phys for the coma mode pin.
If that is the case then, all the other phys that share the same line
will failed to be probed because the access to the gpio line is not
non-exclusive.
Fix this by making access to the gpio line to be nonexclusive using flag
GPIOD_FLAGS_BIT_NONEXCLUSIVE. This allows all the other PHYs to be
probed.

Fixes: 738871b09250ee ("net: phy: micrel: add coma mode GPIO")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Link: https://lore.kernel.org/r/20220830064055.2340403-1-horatiu.vultur@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 22139901f01c7..34483a4bd688a 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -2838,12 +2838,18 @@ static int lan8814_config_init(struct phy_device *phydev)
 	return 0;
 }
 
+/* It is expected that there will not be any 'lan8814_take_coma_mode'
+ * function called in suspend. Because the GPIO line can be shared, so if one of
+ * the phys goes back in coma mode, then all the other PHYs will go, which is
+ * wrong.
+ */
 static int lan8814_release_coma_mode(struct phy_device *phydev)
 {
 	struct gpio_desc *gpiod;
 
 	gpiod = devm_gpiod_get_optional(&phydev->mdio.dev, "coma-mode",
-					GPIOD_OUT_HIGH_OPEN_DRAIN);
+					GPIOD_OUT_HIGH_OPEN_DRAIN |
+					GPIOD_FLAGS_BIT_NONEXCLUSIVE);
 	if (IS_ERR(gpiod))
 		return PTR_ERR(gpiod);
 
-- 
2.35.1



