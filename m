Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515AA59D7C7
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242000AbiHWJrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352489AbiHWJq3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:46:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763909080D;
        Tue, 23 Aug 2022 01:43:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F93361377;
        Tue, 23 Aug 2022 08:43:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DDD5C433D6;
        Tue, 23 Aug 2022 08:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244219;
        bh=MKtkNLnOpsU+iTzTYMESxp1iv6KPokCGsvYIOzSz0VY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iuSnnJ9ana6Bf9BjQ0Hv7b1WxSZCZCchijVrFoihWazp9Y2+1itKBjZPHS0pq/d71
         +tojy+f0Ft3WJUdMfeGxM9/hQijg+0GBLIkkRfvBcMt8+M/uQdRjTXsu01BChgOTQW
         fbSXC+Z3nFiBZVbgLqbVEPLT7wG4TaI2EiXlhkpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 058/244] net: phy: Warn about incorrect mdio_bus_phy_resume() state
Date:   Tue, 23 Aug 2022 10:23:37 +0200
Message-Id: <20220823080101.009863270@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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

commit 744d23c71af39c7dc77ac7c3cac87ae86a181a85 upstream.

Calling mdio_bus_phy_resume() with neither the PHY state machine set to
PHY_HALTED nor phydev->mac_managed_pm set to true is a good indication
that we can produce a race condition looking like this:

CPU0						CPU1
bcmgenet_resume
 -> phy_resume
   -> phy_init_hw
 -> phy_start
   -> phy_resume
                                                phy_start_aneg()
mdio_bus_phy_resume
 -> phy_resume
    -> phy_write(..., BMCR_RESET)
     -> usleep()                                  -> phy_read()

with the phy_resume() function triggering a PHY behavior that might have
to be worked around with (see bf8bfc4336f7 ("net: phy: broadcom: Fix
brcm_fet_config_init()") for instance) that ultimately leads to an error
reading from the PHY.

Fixes: fba863b81604 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220801233403.258871-1-f.fainelli@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy_device.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -315,6 +315,12 @@ static __maybe_unused int mdio_bus_phy_r
 
 	phydev->suspended_by_mdio_bus = 0;
 
+	/* If we managed to get here with the PHY state machine in a state other
+	 * than PHY_HALTED this is an indication that something went wrong and
+	 * we should most likely be using MAC managed PM and we are not.
+	 */
+	WARN_ON(phydev->state != PHY_HALTED && !phydev->mac_managed_pm);
+
 	ret = phy_init_hw(phydev);
 	if (ret < 0)
 		return ret;


