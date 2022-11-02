Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6E9615A38
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiKBD1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbiKBD1O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:27:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091FE25EB1
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:27:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A512617CB
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40932C433C1;
        Wed,  2 Nov 2022 03:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359633;
        bh=DpcoYwhQuOgS/llNGQI61G+wb9+LK2y+95yI7O48i5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TBSQgcwIjZiKu1E8wceZImFPXugOoxhembJhG5WmAqWA4W9sNrUjTE9W6iU0EycUY
         k8bIM1xkZ/Zs4+BNXA3ndrd89Dd/3/EFnj3ObWa/3Hqh2CMdV5WZzUADFYR4BWHszF
         bJemT7eVHph7LSUtcRMJvle9FQWOVrzNC5P9fgAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Raju Rangoju <Raju.Rangoju@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 38/64] amd-xgbe: fix the SFP compliance codes check for DAC cables
Date:   Wed,  2 Nov 2022 03:34:04 +0100
Message-Id: <20221102022053.049862458@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.821538553@linuxfoundation.org>
References: <20221102022051.821538553@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raju Rangoju <Raju.Rangoju@amd.com>

[ Upstream commit 09c5f6bf11ac98874339e55f4f5f79a9dbc9b375 ]

The current XGBE code assumes that offset 6 of EEPROM SFP DAC (passive)
cables is NULL. However, some cables (the 5 meter and 7 meter Molex
passive cables) have non-zero data at offset 6. Fix the logic by moving
the passive cable check above the active checks, so as not to be
improperly identified as an active cable. This will fix the issue for
any passive cable that advertises 1000Base-CX in offset 6.

Fixes: abf0a1c2b26a ("amd-xgbe: Add support for SFP+ modules")
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 0b325ae875b5..5069ae164ecf 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -1150,7 +1150,10 @@ static void xgbe_phy_sfp_parse_eeprom(struct xgbe_prv_data *pdata)
 	}
 
 	/* Determine the type of SFP */
-	if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
+	if (phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE &&
+	    xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
+		phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
+	else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
 		phy_data->sfp_base = XGBE_SFP_BASE_10000_SR;
 	else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_LR)
 		phy_data->sfp_base = XGBE_SFP_BASE_10000_LR;
@@ -1166,9 +1169,6 @@ static void xgbe_phy_sfp_parse_eeprom(struct xgbe_prv_data *pdata)
 		phy_data->sfp_base = XGBE_SFP_BASE_1000_CX;
 	else if (sfp_base[XGBE_SFP_BASE_1GBE_CC] & XGBE_SFP_BASE_1GBE_CC_T)
 		phy_data->sfp_base = XGBE_SFP_BASE_1000_T;
-	else if ((phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE) &&
-		 xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
-		phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
 
 	switch (phy_data->sfp_base) {
 	case XGBE_SFP_BASE_1000_T:
-- 
2.35.1



