Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E167661106E
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 14:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbiJ1MFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 08:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiJ1MF3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 08:05:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C9F642D4
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 05:05:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1119B829B8
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 12:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003E6C433C1;
        Fri, 28 Oct 2022 12:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666958725;
        bh=J74gDJ183VL7qTA4sqncMaRQBXf6qKr3QSKjxecx+PM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uqh1aTX6wPk9ZLxwExbupH0uf/GAofZ/zmuvKYVCJE8fB2RHyM5+TuVSpahZkfVpD
         2V8tF4URUWavyoi+RlYduF5WuANbMbiHrlurJj0FdSYK26anza8ogacEyWk/Zvbgzg
         VO47WpfYC1qmu6oF8N7P3cagUU5iHoUI9dgFjBGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Harini Katakam <harini.katakam@amd.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 28/73] net: phy: dp83867: Extend RX strap quirk for SGMII mode
Date:   Fri, 28 Oct 2022 14:03:25 +0200
Message-Id: <20221028120233.573914012@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harini Katakam <harini.katakam@amd.com>

[ Upstream commit 0c9efbd5c50c64ead434960a404c9c9a097b0403 ]

When RX strap in HW is not set to MODE 3 or 4, bit 7 and 8 in CF4
register should be set. The former is already handled in
dp83867_config_init; add the latter in SGMII specific initialization.

Fixes: 2a10154abcb7 ("net: phy: dp83867: Add TI dp83867 phy")
Signed-off-by: Harini Katakam <harini.katakam@amd.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83867.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index f86acad0aad4..c8031e297faf 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -757,6 +757,14 @@ static int dp83867_config_init(struct phy_device *phydev)
 		else
 			val &= ~DP83867_SGMII_TYPE;
 		phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_SGMIICTL, val);
+
+		/* This is a SW workaround for link instability if RX_CTRL is
+		 * not strapped to mode 3 or 4 in HW. This is required for SGMII
+		 * in addition to clearing bit 7, handled above.
+		 */
+		if (dp83867->rxctrl_strap_quirk)
+			phy_set_bits_mmd(phydev, DP83867_DEVADDR, DP83867_CFG4,
+					 BIT(8));
 	}
 
 	val = phy_read(phydev, DP83867_CFG3);
-- 
2.35.1



