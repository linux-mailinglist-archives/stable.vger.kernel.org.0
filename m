Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF3952CB69
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 07:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbiESFMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 01:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbiESFMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 01:12:36 -0400
Received: from mo-csw-fb.securemx.jp (mo-csw-fb1114.securemx.jp [210.130.202.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1141C939F6
        for <stable@vger.kernel.org>; Wed, 18 May 2022 22:12:31 -0700 (PDT)
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1114) id 24J4qBcj004530; Thu, 19 May 2022 13:52:11 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1115) id 24J4pxDM023137; Thu, 19 May 2022 13:52:00 +0900
X-Iguazu-Qid: 2wHHu6IpoavdFTeiUV
X-Iguazu-QSIG: v=2; s=0; t=1652935919; q=2wHHu6IpoavdFTeiUV; m=7eeJqPHvg+SX9D16Qpy4VAeoj+50xj7uL3pFmGHE8Hc=
Received: from imx2-a.toshiba.co.jp (imx2-a.toshiba.co.jp [106.186.93.35])
        by relay.securemx.jp (mx-mr1111) id 24J4pvFE032220
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 May 2022 13:51:57 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     daichi1.fukui@toshiba.co.jp,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Nechama Kraus <nechamax.kraus@linux.intel.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 1/3] igc: Remove _I_PHY_ID checking
Date:   Thu, 19 May 2022 13:51:43 +0900
X-TSB-HOP2: ON
Message-Id: <20220519045145.114240-2-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220519045145.114240-1-nobuhiro1.iwamatsu@toshiba.co.jp>
References: <20220519045145.114240-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/net/ethernet/intel/igc/igc_base.c | 10 +---------
 drivers/net/ethernet/intel/igc/igc_main.c |  3 +--
 drivers/net/ethernet/intel/igc/igc_phy.c  |  6 ++----
 3 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_base.c b/drivers/net/ethernet/intel/igc/igc_base.c
index fd37d2c203af..7f3523f0d196 100644
--- a/drivers/net/ethernet/intel/igc/igc_base.c
+++ b/drivers/net/ethernet/intel/igc/igc_base.c
@@ -187,15 +187,7 @@ static s32 igc_init_phy_params_base(struct igc_hw *hw)
 
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
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 61cebb7df6bc..da39380ab205 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4189,8 +4189,7 @@ bool igc_has_link(struct igc_adapter *adapter)
 		break;
 	}
 
-	if (hw->mac.type == igc_i225 &&
-	    hw->phy.id == I225_I_PHY_ID) {
+	if (hw->mac.type == igc_i225) {
 		if (!netif_carrier_ok(adapter->netdev)) {
 			adapter->flags &= ~IGC_FLAG_NEED_LINK_UPDATE;
 		} else if (!(adapter->flags & IGC_FLAG_NEED_LINK_UPDATE)) {
diff --git a/drivers/net/ethernet/intel/igc/igc_phy.c b/drivers/net/ethernet/intel/igc/igc_phy.c
index 8de4de2e5636..3a103406eadb 100644
--- a/drivers/net/ethernet/intel/igc/igc_phy.c
+++ b/drivers/net/ethernet/intel/igc/igc_phy.c
@@ -249,8 +249,7 @@ static s32 igc_phy_setup_autoneg(struct igc_hw *hw)
 			return ret_val;
 	}
 
-	if ((phy->autoneg_mask & ADVERTISE_2500_FULL) &&
-	    hw->phy.id == I225_I_PHY_ID) {
+	if (phy->autoneg_mask & ADVERTISE_2500_FULL) {
 		/* Read the MULTI GBT AN Control Register - reg 7.32 */
 		ret_val = phy->ops.read_reg(hw, (STANDARD_AN_REG_MASK <<
 					    MMD_DEVADDR_SHIFT) |
@@ -390,8 +389,7 @@ static s32 igc_phy_setup_autoneg(struct igc_hw *hw)
 		ret_val = phy->ops.write_reg(hw, PHY_1000T_CTRL,
 					     mii_1000t_ctrl_reg);
 
-	if ((phy->autoneg_mask & ADVERTISE_2500_FULL) &&
-	    hw->phy.id == I225_I_PHY_ID)
+	if (phy->autoneg_mask & ADVERTISE_2500_FULL)
 		ret_val = phy->ops.write_reg(hw,
 					     (STANDARD_AN_REG_MASK <<
 					     MMD_DEVADDR_SHIFT) |
-- 
2.36.0


