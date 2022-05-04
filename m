Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B36051A936
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356370AbiEDRRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355918AbiEDRMH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:12:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A67394BBB3;
        Wed,  4 May 2022 09:57:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D59961929;
        Wed,  4 May 2022 16:57:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8919C385A5;
        Wed,  4 May 2022 16:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683469;
        bh=uwsVagE2WLpVNfyJ8wiHvUZu5rZnzEZ8D1mBiEydAUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mAZPd/hSY23woyLL0lzo/T1dUMu2FHQYhd6h1j403s7bsBmhizWpXK8fVCGGm2az5
         fNQoLIZ17CpIe3ASVJHIUE3HmqOIMNkqmmZ/fewU7o3X4chYgC7dFlSnj7QakkEbkS
         1xYYGnWCYgE8iqcJ7aGPFJwD/ogJIl7QNCxXm1pM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Hoffmann <jan@3e8.eu>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 136/225] net: dsa: lantiq_gswip: Dont set GSWIP_MII_CFG_RMII_CLK
Date:   Wed,  4 May 2022 18:46:14 +0200
Message-Id: <20220504153122.415829502@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 71cffebf6358a7f5031f5b208bbdc1cb4db6e539 ]

Commit 4b5923249b8fa4 ("net: dsa: lantiq_gswip: Configure all remaining
GSWIP_MII_CFG bits") added all known bits in the GSWIP_MII_CFGp
register. It helped bring this register into a well-defined state so the
driver has to rely less on the bootloader to do things right.
Unfortunately it also sets the GSWIP_MII_CFG_RMII_CLK bit without any
possibility to configure it. Upon further testing it turns out that all
boards which are supported by the GSWIP driver in OpenWrt which use an
RMII PHY have a dedicated oscillator on the board which provides the
50MHz RMII reference clock.

Don't set the GSWIP_MII_CFG_RMII_CLK bit (but keep the code which always
clears it) to fix support for the Fritz!Box 7362 SL in OpenWrt. This is
a board with two Atheros AR8030 RMII PHYs. With the "RMII clock" bit set
the MAC also generates the RMII reference clock whose signal then
conflicts with the signal from the oscillator on the board. This results
in a constant cycle of the PHY detecting link up/down (and as a result
of that: the two ports using the AR8030 PHYs are not working).

At the time of writing this patch there's no known board where the MAC
(GSWIP) has to generate the RMII reference clock. If needed this can be
implemented in future by providing a device-tree flag so the
GSWIP_MII_CFG_RMII_CLK bit can be toggled per port.

Fixes: 4b5923249b8fa4 ("net: dsa: lantiq_gswip: Configure all remaining GSWIP_MII_CFG bits")
Tested-by: Jan Hoffmann <jan@3e8.eu>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
Link: https://lore.kernel.org/r/20220425152027.2220750-1-martin.blumenstingl@googlemail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/lantiq_gswip.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 8a7a8093a156..8acec33a4702 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1637,9 +1637,6 @@ static void gswip_phylink_mac_config(struct dsa_switch *ds, int port,
 		break;
 	case PHY_INTERFACE_MODE_RMII:
 		miicfg |= GSWIP_MII_CFG_MODE_RMIIM;
-
-		/* Configure the RMII clock as output: */
-		miicfg |= GSWIP_MII_CFG_RMII_CLK;
 		break;
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_RGMII_ID:
-- 
2.35.1



