Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3373E541312
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357790AbiFGTzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358639AbiFGTws (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:52:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA82836314;
        Tue,  7 Jun 2022 11:21:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99F59B822C0;
        Tue,  7 Jun 2022 18:21:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08763C385A2;
        Tue,  7 Jun 2022 18:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626107;
        bh=Lr9mmWKLE+i3CPWkhRlz6ZwTIFte+zXZD1eploCumPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0h0oByHBd2eqjLyXWeDXxRp1L+QJEZ3pS6dTEueg4I9TMfotrO2Hp3f7vl13l4S1W
         GHGjl1XqY7MqedH8kpXrSZHmOXJi5MpvWU8yDe7JXizt4NjrDk1IwO8AiU6FDzKpXy
         dUh94ItmyLZQ/zHIS0BOmno0EmS7vCBX6jx4OvXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 261/772] net: dsa: mt7530: 1G can also support 1000BASE-X link mode
Date:   Tue,  7 Jun 2022 18:57:33 +0200
Message-Id: <20220607164956.713394731@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit 66f862563ed68717dfd84e808ca12705ed275ced ]

When using an external PHY connected using RGMII to mt7531 port 5, the
PHY can be used to used support 1000BASE-X connections. Moreover, if
1000BASE-T is supported, then we should allow 1000BASE-X as well, since
which are supported is a property of the PHY.

Therefore, it makes no sense to exclude this from the linkmodes when
1000BASE-T is supported.

Fixes: c288575f7810 ("net: dsa: mt7530: Add the support of MT7531 switch")
Tested-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index fcdd022b2498..487b4717c096 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2535,13 +2535,7 @@ static void mt7531_sgmii_validate(struct mt7530_priv *priv, int port,
 	/* Port5 supports ethier RGMII or SGMII.
 	 * Port6 supports SGMII only.
 	 */
-	switch (port) {
-	case 5:
-		if (mt7531_is_rgmii_port(priv, port))
-			break;
-		fallthrough;
-	case 6:
-		phylink_set(supported, 1000baseX_Full);
+	if (port == 6) {
 		phylink_set(supported, 2500baseX_Full);
 		phylink_set(supported, 2500baseT_Full);
 	}
@@ -2909,8 +2903,6 @@ static void
 mt7530_mac_port_validate(struct dsa_switch *ds, int port,
 			 unsigned long *supported)
 {
-	if (port == 5)
-		phylink_set(supported, 1000baseX_Full);
 }
 
 static void mt7531_mac_port_validate(struct dsa_switch *ds, int port,
@@ -2947,8 +2939,10 @@ mt753x_phylink_validate(struct dsa_switch *ds, int port,
 	}
 
 	/* This switch only supports 1G full-duplex. */
-	if (state->interface != PHY_INTERFACE_MODE_MII)
+	if (state->interface != PHY_INTERFACE_MODE_MII) {
 		phylink_set(mask, 1000baseT_Full);
+		phylink_set(mask, 1000baseX_Full);
+	}
 
 	priv->info->mac_port_validate(ds, port, mask);
 
-- 
2.35.1



