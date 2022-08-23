Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9275059E270
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350619AbiHWLLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351349AbiHWLIs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:08:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF88B5E7C;
        Tue, 23 Aug 2022 02:16:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF89461224;
        Tue, 23 Aug 2022 09:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D48C433D6;
        Tue, 23 Aug 2022 09:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246188;
        bh=mpEHv+2osM9qlxR5+ep/wk80+Y9tSPcDK7YRuosmWwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FbW6uDDdl0Zjyp15PjYde+7Ejp++SInzna31s1eTR4JsrxAOuZfdt7Wa4a4iJ+wpR
         /EbzSkEyTtL2hE0Xj3vAgm/wgSXYUlYgocs7lGVn6YrXJH/02Wy5oETSHDJwrX4f4z
         u0Eeletld5e9xzh8eaaElg2awb2JbY2FLv4MziUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Neftin <sasha.neftin@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Linjun Bao <meljbao@gmail.com>
Subject: [PATCH 5.4 005/389] igc: Remove _I_PHY_ID checking
Date:   Tue, 23 Aug 2022 10:21:23 +0200
Message-Id: <20220823080115.865660221@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

From: Sasha Neftin <sasha.neftin@intel.com>

commit 7c496de538eebd8212dc2a3c9a468386b264d0d4 upstream.

i225 devices have only one PHY vendor. There is no point checking
_I_PHY_ID during the link establishment and auto-negotiation process.
This patch comes to clean up these pointless checkings.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: Linjun Bao <meljbao@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/igc/igc_base.c |   10 +---------
 drivers/net/ethernet/intel/igc/igc_main.c |    3 +--
 drivers/net/ethernet/intel/igc/igc_phy.c  |    6 ++----
 3 files changed, 4 insertions(+), 15 deletions(-)

--- a/drivers/net/ethernet/intel/igc/igc_base.c
+++ b/drivers/net/ethernet/intel/igc/igc_base.c
@@ -187,15 +187,7 @@ static s32 igc_init_phy_params_base(stru
 
 	igc_check_for_copper_link(hw);
 
-	/* Verify phy id and set remaining function pointers */
-	switch (phy->id) {
-	case I225_I_PHY_ID:
-		phy->type	= igc_phy_i225;
-		break;
-	default:
-		ret_val = -IGC_ERR_PHY;
-		goto out;
-	}
+	phy->type = igc_phy_i225;
 
 out:
 	return ret_val;
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2884,8 +2884,7 @@ bool igc_has_link(struct igc_adapter *ad
 		break;
 	}
 
-	if (hw->mac.type == igc_i225 &&
-	    hw->phy.id == I225_I_PHY_ID) {
+	if (hw->mac.type == igc_i225) {
 		if (!netif_carrier_ok(adapter->netdev)) {
 			adapter->flags &= ~IGC_FLAG_NEED_LINK_UPDATE;
 		} else if (!(adapter->flags & IGC_FLAG_NEED_LINK_UPDATE)) {
--- a/drivers/net/ethernet/intel/igc/igc_phy.c
+++ b/drivers/net/ethernet/intel/igc/igc_phy.c
@@ -235,8 +235,7 @@ static s32 igc_phy_setup_autoneg(struct
 			return ret_val;
 	}
 
-	if ((phy->autoneg_mask & ADVERTISE_2500_FULL) &&
-	    hw->phy.id == I225_I_PHY_ID) {
+	if (phy->autoneg_mask & ADVERTISE_2500_FULL) {
 		/* Read the MULTI GBT AN Control Register - reg 7.32 */
 		ret_val = phy->ops.read_reg(hw, (STANDARD_AN_REG_MASK <<
 					    MMD_DEVADDR_SHIFT) |
@@ -376,8 +375,7 @@ static s32 igc_phy_setup_autoneg(struct
 		ret_val = phy->ops.write_reg(hw, PHY_1000T_CTRL,
 					     mii_1000t_ctrl_reg);
 
-	if ((phy->autoneg_mask & ADVERTISE_2500_FULL) &&
-	    hw->phy.id == I225_I_PHY_ID)
+	if (phy->autoneg_mask & ADVERTISE_2500_FULL)
 		ret_val = phy->ops.write_reg(hw,
 					     (STANDARD_AN_REG_MASK <<
 					     MMD_DEVADDR_SHIFT) |


