Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 805DA566D12
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236454AbiGEMU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235076AbiGEMQ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:16:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD471BE9B;
        Tue,  5 Jul 2022 05:12:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22B7B619AF;
        Tue,  5 Jul 2022 12:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A380C341C8;
        Tue,  5 Jul 2022 12:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023119;
        bh=DLmVq64ijXGPUQWlCgQoxcagw9iIf3gK9IgQk8qCHrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FbzZ1BajUeONfbe94ALR+hfAnwYeZsjYxxMguMAqR8Jd8+9xALearuKw18oIrLfN9
         21j8tl7Nqzw7WitihKvwgrFkNdJzOhKZsOGDRYQ1O2wKhTx6307bN7HIjxDZkckQa6
         7EYPD8cwHhEcHqt3Jzxx+XY0V8EO70TNb7gMkUz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 45/98] net: phy: ax88772a: fix lost pause advertisement configuration
Date:   Tue,  5 Jul 2022 13:58:03 +0200
Message-Id: <20220705115618.866567600@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit fa152f626b24ec2ca3489100d8c5c0a0bce4e2ef upstream.

In case of asix_ax88772a_link_change_notify() workaround, we run soft
reset which will automatically clear MII_ADVERTISE configuration. The
PHYlib framework do not know about changed configuration state of the
PHY, so we need use phy_init_hw() to reinit PHY configuration.

Fixes: dde258469257 ("net: usb/phy: asix: add support for ax88772A/C PHYs")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220628114349.3929928-1-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/ax88796b.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/ax88796b.c b/drivers/net/phy/ax88796b.c
index 457896337505..0f1e617a26c9 100644
--- a/drivers/net/phy/ax88796b.c
+++ b/drivers/net/phy/ax88796b.c
@@ -88,8 +88,10 @@ static void asix_ax88772a_link_change_notify(struct phy_device *phydev)
 	/* Reset PHY, otherwise MII_LPA will provide outdated information.
 	 * This issue is reproducible only with some link partner PHYs
 	 */
-	if (phydev->state == PHY_NOLINK && phydev->drv->soft_reset)
-		phydev->drv->soft_reset(phydev);
+	if (phydev->state == PHY_NOLINK) {
+		phy_init_hw(phydev);
+		phy_start_aneg(phydev);
+	}
 }
 
 static struct phy_driver asix_driver[] = {
-- 
2.37.0



