Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4366158B9
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbiKBC5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbiKBC53 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:57:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467D522528
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:57:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D84B0617BB
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8077BC433D6;
        Wed,  2 Nov 2022 02:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357848;
        bh=ouX0T+jsaDWCGxITiUdAFjnvDrvWyVjJ9LWdKZtHcwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WanlXdUnaoMFTaSalkcJLOa+hCzwbWvzWW9WZ5odLRQ2JDdidsxdkZV4feNpf9lbe
         zyCpVm8uAIwt6m5Vhr7D8n3lG24W0IydWUFKb5tdhbDJQrtaCRZqfxY8WQ5LB6lT0P
         FrcGyexrjrJ1rA6HFdCRIubRRdzWEqO3d2EsL5/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heiner Kallweit <hkallweit1@gmail.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 212/240] net: ethernet: ave: Fix MAC to be in charge of PHY PM
Date:   Wed,  2 Nov 2022 03:33:07 +0100
Message-Id: <20221102022116.194649009@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit e2badb4bd33abe13ddc35975bd7f7f8693955a4b ]

The phylib callback is called after MAC driver's own resume callback is
called. For AVE driver, after resuming immediately, PHY state machine is
in PHY_NOLINK because there is a time lag from link-down to link-up due to
autoneg. The result is WARN_ON() dump in mdio_bus_phy_resume().

Since ave_resume() itself calls phy_resume(), AVE driver should manage
PHY PM. To indicate that MAC driver manages PHY PM, set
phydev->mac_managed_pm to true to avoid the unnecessary phylib call and
add missing phy_init_hw() to ave_resume().

Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
Fixes: fba863b81604 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Link: https://lore.kernel.org/r/20221024072227.24769-1-hayashi.kunihiko@socionext.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/socionext/sni_ave.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index f0c8de2c6075..db80a17a7e21 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1229,6 +1229,8 @@ static int ave_init(struct net_device *ndev)
 
 	phy_support_asym_pause(phydev);
 
+	phydev->mac_managed_pm = true;
+
 	phy_attached_info(phydev);
 
 	return 0;
@@ -1757,6 +1759,10 @@ static int ave_resume(struct device *dev)
 
 	ave_global_reset(ndev);
 
+	ret = phy_init_hw(ndev->phydev);
+	if (ret)
+		return ret;
+
 	ave_ethtool_get_wol(ndev, &wol);
 	wol.wolopts = priv->wolopts;
 	__ave_ethtool_set_wol(ndev, &wol);
-- 
2.35.1



