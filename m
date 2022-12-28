Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E118657A90
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbiL1PNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbiL1PMr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:12:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D155F13F40
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:12:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D73E6155A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78EACC433D2;
        Wed, 28 Dec 2022 15:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240337;
        bh=WprUurxFYo57t/bA68yT8Rkc5W3dn4f10I5hL4GgaHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KTpn8TOxeUypJ55eXwUqZLAEqcX1OidtX94NK7Rfc8jdI6MMoxLwte3u6mvGfwDkb
         HT4KZUA0RZZcTtjJj+BXT9E26/TipI3ZA1cntTUIe7JwoOhQGuBCV04of8nvWPGagu
         /KI7XJ8ffyXv4s8j8wtTbBwNDu85oAKH4pYQGPJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tom Lendacky <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 338/731] net: amd-xgbe: Fix logic around active and passive cables
Date:   Wed, 28 Dec 2022 15:37:25 +0100
Message-Id: <20221228144306.365120861@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

[ Upstream commit 4998006c73afe44e2f639d55bd331c6c26eb039f ]

SFP+ active and passive cables are copper cables with fixed SFP+ end
connectors. Due to a misinterpretation of this, SFP+ active cables could
end up not being recognized, causing the driver to fail to establish a
connection.

Introduce a new enum in SFP+ cable types, XGBE_SFP_CABLE_FIBER, that is
the default cable type, and handle active and passive cables when they are
specifically detected.

Fixes: abf0a1c2b26a ("amd-xgbe: Add support for SFP+ modules")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index a7166cd1179f..a9a734454973 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -189,6 +189,7 @@ enum xgbe_sfp_cable {
 	XGBE_SFP_CABLE_UNKNOWN = 0,
 	XGBE_SFP_CABLE_ACTIVE,
 	XGBE_SFP_CABLE_PASSIVE,
+	XGBE_SFP_CABLE_FIBER,
 };
 
 enum xgbe_sfp_base {
@@ -1149,16 +1150,18 @@ static void xgbe_phy_sfp_parse_eeprom(struct xgbe_prv_data *pdata)
 	phy_data->sfp_tx_fault = xgbe_phy_check_sfp_tx_fault(phy_data);
 	phy_data->sfp_rx_los = xgbe_phy_check_sfp_rx_los(phy_data);
 
-	/* Assume ACTIVE cable unless told it is PASSIVE */
+	/* Assume FIBER cable unless told otherwise */
 	if (sfp_base[XGBE_SFP_BASE_CABLE] & XGBE_SFP_BASE_CABLE_PASSIVE) {
 		phy_data->sfp_cable = XGBE_SFP_CABLE_PASSIVE;
 		phy_data->sfp_cable_len = sfp_base[XGBE_SFP_BASE_CU_CABLE_LEN];
-	} else {
+	} else if (sfp_base[XGBE_SFP_BASE_CABLE] & XGBE_SFP_BASE_CABLE_ACTIVE) {
 		phy_data->sfp_cable = XGBE_SFP_CABLE_ACTIVE;
+	} else {
+		phy_data->sfp_cable = XGBE_SFP_CABLE_FIBER;
 	}
 
 	/* Determine the type of SFP */
-	if (phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE &&
+	if (phy_data->sfp_cable != XGBE_SFP_CABLE_FIBER &&
 	    xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
 		phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
 	else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
-- 
2.35.1



