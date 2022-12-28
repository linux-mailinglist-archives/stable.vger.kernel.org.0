Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A731657F60
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234281AbiL1QEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:04:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234296AbiL1QEL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:04:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B66119294
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:04:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B834AB81710
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1212FC433D2;
        Wed, 28 Dec 2022 16:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243448;
        bh=BnzgfrcnUbhBoEyrfatcrzwFuxGQoSTQsF9opmIAp+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KjD6BKlqwvlTxi7EVpSx4fZKFnKl+7ykoVePKXNaTJQtH2YOh5nslGVq69IoXQlOD
         s4uyH4HVVZbCL4kElCBTjxtFF04Or/b0diQX8BaKootl79o+Lpe7fmSxPfQVSV1jqu
         Csl9OUKw0vl7vNz1xY3rWiahzlMX+EX3FP+aKBtA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tom Lendacky <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0530/1073] net: amd-xgbe: Check only the minimum speed for active/passive cables
Date:   Wed, 28 Dec 2022 15:35:18 +0100
Message-Id: <20221228144342.441374088@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit f8ab263d4d48e6dab752029bf562f20a2ee630ed ]

There are cables that exist that can support speeds in excess of 10GbE.
The driver, however, restricts the EEPROM advertised nominal bitrate to
a specific range, which can prevent usage of cables that can support,
for example, up to 25GbE.

Rather than checking that an active or passive cable supports a specific
range, only check for a minimum supported speed.

Fixes: abf0a1c2b26a ("amd-xgbe: Add support for SFP+ modules")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index c7b0d69ee62f..1ef04326a572 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -237,10 +237,7 @@ enum xgbe_sfp_speed {
 
 #define XGBE_SFP_BASE_BR			12
 #define XGBE_SFP_BASE_BR_1GBE_MIN		0x0a
-#define XGBE_SFP_BASE_BR_1GBE_MAX		0x0d
 #define XGBE_SFP_BASE_BR_10GBE_MIN		0x64
-#define XGBE_SFP_BASE_BR_10GBE_MAX		0x68
-#define XGBE_MOLEX_SFP_BASE_BR_10GBE_MAX	0x78
 
 #define XGBE_SFP_BASE_CU_CABLE_LEN		18
 
@@ -827,29 +824,22 @@ static void xgbe_phy_sfp_phy_settings(struct xgbe_prv_data *pdata)
 static bool xgbe_phy_sfp_bit_rate(struct xgbe_sfp_eeprom *sfp_eeprom,
 				  enum xgbe_sfp_speed sfp_speed)
 {
-	u8 *sfp_base, min, max;
+	u8 *sfp_base, min;
 
 	sfp_base = sfp_eeprom->base;
 
 	switch (sfp_speed) {
 	case XGBE_SFP_SPEED_1000:
 		min = XGBE_SFP_BASE_BR_1GBE_MIN;
-		max = XGBE_SFP_BASE_BR_1GBE_MAX;
 		break;
 	case XGBE_SFP_SPEED_10000:
 		min = XGBE_SFP_BASE_BR_10GBE_MIN;
-		if (memcmp(&sfp_eeprom->base[XGBE_SFP_BASE_VENDOR_NAME],
-			   XGBE_MOLEX_VENDOR, XGBE_SFP_BASE_VENDOR_NAME_LEN) == 0)
-			max = XGBE_MOLEX_SFP_BASE_BR_10GBE_MAX;
-		else
-			max = XGBE_SFP_BASE_BR_10GBE_MAX;
 		break;
 	default:
 		return false;
 	}
 
-	return ((sfp_base[XGBE_SFP_BASE_BR] >= min) &&
-		(sfp_base[XGBE_SFP_BASE_BR] <= max));
+	return sfp_base[XGBE_SFP_BASE_BR] >= min;
 }
 
 static void xgbe_phy_free_phy_device(struct xgbe_prv_data *pdata)
-- 
2.35.1



