Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEEBD6D490C
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbjDCOen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbjDCOem (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:34:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC83CC1B
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:34:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C731F61E47
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:33:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3BEDC4339B;
        Mon,  3 Apr 2023 14:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532432;
        bh=CjN35DnqgDDv5rnDHMGj8/n93IwxRypP2ELTE0UlnHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RmtnUeKOCb93+s7+R2JqCboe0gDp7vvsByHgasSnnWFtmTFWPnSUQCq90Em+hANUz
         h85nUvY0l5of60zVknMlOmZ5w4gqlRQk9u73wOfqDvLqIo1HhHUSNWzUuAok8ejAS3
         xLjrQT3RO7HLNB77SmGak0xJLcHJ8UB/oFHcja20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heiner Kallweit <hkallweit1@gmail.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Simon Horman <simon.horman@corigine.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 51/99] smsc911x: avoid PHY being resumed when interface is not up
Date:   Mon,  3 Apr 2023 16:09:14 +0200
Message-Id: <20230403140405.246226499@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit f22c993f31fa9615df46e49cd768b713d39a852f ]

SMSC911x doesn't need mdiobus suspend/resume, that's why it sets
'mac_managed_pm'. However, setting it needs to be moved from init to
probe, so mdiobus PM functions will really never be called (e.g. when
the interface is not up yet during suspend/resume).

Fixes: 3ce9f2bef755 ("net: smsc911x: Stop and start PHY during suspend and resume")
Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230327083138.6044-1-wsa+renesas@sang-engineering.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/smsc/smsc911x.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index 63b99dd8ca51c..b330dcbe949df 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -1037,8 +1037,6 @@ static int smsc911x_mii_probe(struct net_device *dev)
 		return ret;
 	}
 
-	/* Indicate that the MAC is responsible for managing PHY PM */
-	phydev->mac_managed_pm = true;
 	phy_attached_info(phydev);
 
 	phy_set_max_speed(phydev, SPEED_100);
@@ -1066,6 +1064,7 @@ static int smsc911x_mii_init(struct platform_device *pdev,
 			     struct net_device *dev)
 {
 	struct smsc911x_data *pdata = netdev_priv(dev);
+	struct phy_device *phydev;
 	int err = -ENXIO;
 
 	pdata->mii_bus = mdiobus_alloc();
@@ -1108,6 +1107,10 @@ static int smsc911x_mii_init(struct platform_device *pdev,
 		goto err_out_free_bus_2;
 	}
 
+	phydev = phy_find_first(pdata->mii_bus);
+	if (phydev)
+		phydev->mac_managed_pm = true;
+
 	return 0;
 
 err_out_free_bus_2:
-- 
2.39.2



