Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97764ABA51
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236876AbiBGLZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378393AbiBGLPu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:15:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3BCC03FEE8;
        Mon,  7 Feb 2022 03:15:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCA0C6113B;
        Mon,  7 Feb 2022 11:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2460C004E1;
        Mon,  7 Feb 2022 11:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232530;
        bh=2OOCeYXrVO5I2xFEe1arKQB7R0jBUJ86hcpONKyUaUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sBBVUiQIBmGhpxNd1dSxkMMFxIEwbxJWPhH286x66Qhhz3D+JTOmZnxqm/ZcpO/wM
         IxsxryPQIGTtEBlTufbDLj4r6L4MIrKawdQ++zVqQR9lEdmU5gs1HNmHzQHL7VmGIH
         4D4inhjXVhBRn0sZ6iAxZX/PdBXxHJP0x56OtBA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 40/86] phylib: fix potential use-after-free
Date:   Mon,  7 Feb 2022 12:06:03 +0100
Message-Id: <20220207103758.845485398@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
References: <20220207103757.550973048@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Marek Behún <kabel@kernel.org>

[ Upstream commit cbda1b16687580d5beee38273f6241ae3725960c ]

Commit bafbdd527d56 ("phylib: Add device reset GPIO support") added call
to phy_device_reset(phydev) after the put_device() call in phy_detach().

The comment before the put_device() call says that the phydev might go
away with put_device().

Fix potential use-after-free by calling phy_device_reset() before
put_device().

Fixes: bafbdd527d56 ("phylib: Add device reset GPIO support")
Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220119162748.32418-1-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index b884b681d5c52..a03d0627efb06 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1166,6 +1166,9 @@ void phy_detach(struct phy_device *phydev)
 	    phydev->mdio.dev.driver == &genphy_driver.mdiodrv.driver)
 		device_release_driver(&phydev->mdio.dev);
 
+	/* Assert the reset signal */
+	phy_device_reset(phydev, 1);
+
 	/*
 	 * The phydev might go away on the put_device() below, so avoid
 	 * a use-after-free bug by reading the underlying bus first.
@@ -1175,9 +1178,6 @@ void phy_detach(struct phy_device *phydev)
 	put_device(&phydev->mdio.dev);
 	if (ndev_owner != bus->owner)
 		module_put(bus->owner);
-
-	/* Assert the reset signal */
-	phy_device_reset(phydev, 1);
 }
 EXPORT_SYMBOL(phy_detach);
 
-- 
2.34.1



