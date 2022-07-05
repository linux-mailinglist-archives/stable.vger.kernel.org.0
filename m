Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDE6566DA4
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235903AbiGEM0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236315AbiGEMYp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:24:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EB91F60B;
        Tue,  5 Jul 2022 05:17:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 437CA619A6;
        Tue,  5 Jul 2022 12:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED8EC341C7;
        Tue,  5 Jul 2022 12:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023435;
        bh=lPtAx4yoSuF525SvttvK23JLuvl2j0I/XA747UUluUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z/jXmMYnQCTnqU60hcR6TXdDWTeF/d0ZPjZH9faiD2TGKnI2nNVHX3fhVqmfAhl48
         uQ0AwUNtVpGpbWR1lPvvZdC+Ykx4q2ruqdcMySOxNFlqY9oGCFcSXB/eHaMe3nVp8T
         Co/WNWv+q9Ien6wrf8laRSxYjcEag3xBEeAmlbO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.18 059/102] net: phy: ax88772a: fix lost pause advertisement configuration
Date:   Tue,  5 Jul 2022 13:58:25 +0200
Message-Id: <20220705115620.081969368@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
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
 drivers/net/phy/ax88796b.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/phy/ax88796b.c
+++ b/drivers/net/phy/ax88796b.c
@@ -88,8 +88,10 @@ static void asix_ax88772a_link_change_no
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


