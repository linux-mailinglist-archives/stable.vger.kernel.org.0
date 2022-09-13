Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB575B7176
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbiIMOma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234347AbiIMOlk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:41:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5E76DF96;
        Tue, 13 Sep 2022 07:22:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93872614CA;
        Tue, 13 Sep 2022 14:12:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E6AC433D6;
        Tue, 13 Sep 2022 14:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078372;
        bh=QZkttdey2IZbuHhI/iymCpT7oKPDrJqvupu9s4uBL/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5VtojKVdv4/PBcrAcyoK1h3Jdzdv9wV80r3rryetexVpPbx6KrxkwMSYjbboml/x
         bDNSeEv8UUE7pUpXC+UdtDK2k/KeJDD4sbPhTL1zZQHv+fOm36vxN92WlbTpcMhZn1
         MqpKm3pmuTYQiYvOYkrU/Qn/BTNVbUhkaPqmoIBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 114/192] Revert "net: phy: meson-gxl: improve link-up behavior"
Date:   Tue, 13 Sep 2022 16:03:40 +0200
Message-Id: <20220913140415.654612788@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 7fdc77665f3d45c9da7c6edd4beadee9790f43aa ]

This reverts commit 2c87c6f9fbddc5b84d67b2fa3f432fcac6d99d93.
Meanwhile it turned out that the following commit is the proper
workaround for the issue that 2c87c6f9fbdd tries to address.
a3a57bf07de2 ("net: stmmac: work around sporadic tx issue on link-up")
It's nor clear why the to be reverted commit helped for one user,
for others it didn't make a difference.

Fixes: 2c87c6f9fbdd ("net: phy: meson-gxl: improve link-up behavior")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/8deeeddc-6b71-129b-1918-495a12dc11e3@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/meson-gxl.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
index 73f7962a37d33..c49062ad72c6c 100644
--- a/drivers/net/phy/meson-gxl.c
+++ b/drivers/net/phy/meson-gxl.c
@@ -243,13 +243,7 @@ static irqreturn_t meson_gxl_handle_interrupt(struct phy_device *phydev)
 	    irq_status == INTSRC_ENERGY_DETECT)
 		return IRQ_HANDLED;
 
-	/* Give PHY some time before MAC starts sending data. This works
-	 * around an issue where network doesn't come up properly.
-	 */
-	if (!(irq_status & INTSRC_LINK_DOWN))
-		phy_queue_state_machine(phydev, msecs_to_jiffies(100));
-	else
-		phy_trigger_machine(phydev);
+	phy_trigger_machine(phydev);
 
 	return IRQ_HANDLED;
 }
-- 
2.35.1



