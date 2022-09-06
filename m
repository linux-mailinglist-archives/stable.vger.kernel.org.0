Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B90515AECFA
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239734AbiIFOFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241525AbiIFOEp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:04:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899156E8BD;
        Tue,  6 Sep 2022 06:45:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38410B81632;
        Tue,  6 Sep 2022 13:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9A9C433D6;
        Tue,  6 Sep 2022 13:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471824;
        bh=791EB7ACDZ4+Pt/Y8rEBGdliYCVHEM8g32knVTTvI8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yuPOtA+sA06W+heVXwB9wpJBpV+znx0nTIbIQ7HXsh1QeC5tCF9pkgaihjj9blbjX
         yTXgrVvo7izpvzNs0lxvhKRiMfY/bXbx7YZCONTGRqrnUDRHys8k6TbRCdlRyBjTNC
         nA3Eff7pqeUlOF4FU4ynXrmwy7C/piJKTgdZCTDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 034/155] net: smsc911x: Stop and start PHY during suspend and resume
Date:   Tue,  6 Sep 2022 15:29:42 +0200
Message-Id: <20220906132830.874268456@linuxfoundation.org>
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

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 3ce9f2bef75528936c78a7053301f5725f622f3a ]

Commit 744d23c71af3 ("net: phy: Warn about incorrect
mdio_bus_phy_resume() state") unveiled that the smsc911x driver was not
properly stopping and restarting the PHY during suspend/resume. Correct
that by indicating that the MAC is in charge of PHY PM operations and
ensure that all MDIO bus activity is quiescent during suspend.

Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Fixes: fba863b81604 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
Fixes: 2aa70f864955 ("net: smsc911x: Quieten netif during suspend")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220825023951.3220-1-f.fainelli@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/smsc/smsc911x.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index 3bf20211cceb4..3829c2805b16c 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -1037,6 +1037,8 @@ static int smsc911x_mii_probe(struct net_device *dev)
 		return ret;
 	}
 
+	/* Indicate that the MAC is responsible for managing PHY PM */
+	phydev->mac_managed_pm = true;
 	phy_attached_info(phydev);
 
 	phy_set_max_speed(phydev, SPEED_100);
@@ -2587,6 +2589,8 @@ static int smsc911x_suspend(struct device *dev)
 	if (netif_running(ndev)) {
 		netif_stop_queue(ndev);
 		netif_device_detach(ndev);
+		if (!device_may_wakeup(dev))
+			phy_stop(ndev->phydev);
 	}
 
 	/* enable wake on LAN, energy detection and the external PME
@@ -2628,6 +2632,8 @@ static int smsc911x_resume(struct device *dev)
 	if (netif_running(ndev)) {
 		netif_device_attach(ndev);
 		netif_start_queue(ndev);
+		if (!device_may_wakeup(dev))
+			phy_start(ndev->phydev);
 	}
 
 	return 0;
-- 
2.35.1



