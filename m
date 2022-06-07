Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0BAC5405C5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234895AbiFGR3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346702AbiFGR2i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:28:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35FA115CAD;
        Tue,  7 Jun 2022 10:24:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1DA92CE2010;
        Tue,  7 Jun 2022 17:24:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22518C385A5;
        Tue,  7 Jun 2022 17:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622672;
        bh=U+x5TZWNbv03DPm0IM26sxFNwql3Md+baw7T59Dj4ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XX6IDM9HvTWcWWYVZFvf68o1FroEFgR7HSIX7AQJzs4jYuVOA5qJk73WrONHIAWJB
         LPi22O7+IWxE7jOyMSCrTy7MeoHnvXel6N1Vqu7nnxlLx/etABhEmo1INKRSzBIZ/2
         9fdL8skuLp23fd4MmoJsEaE6cQw5OfwDPZ4tBnk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 142/452] net: dsa: mt7530: 1G can also support 1000BASE-X link mode
Date:   Tue,  7 Jun 2022 18:59:59 +0200
Message-Id: <20220607164912.791607050@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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
index c355824ddb81..265620a81f9f 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1952,13 +1952,7 @@ static void mt7531_sgmii_validate(struct mt7530_priv *priv, int port,
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
@@ -2315,8 +2309,6 @@ static void
 mt7530_mac_port_validate(struct dsa_switch *ds, int port,
 			 unsigned long *supported)
 {
-	if (port == 5)
-		phylink_set(supported, 1000baseX_Full);
 }
 
 static void mt7531_mac_port_validate(struct dsa_switch *ds, int port,
@@ -2353,8 +2345,10 @@ mt753x_phylink_validate(struct dsa_switch *ds, int port,
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



