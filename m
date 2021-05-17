Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169D6383095
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239414AbhEQO2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:28:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239411AbhEQO0r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:26:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26F8A616EA;
        Mon, 17 May 2021 14:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260830;
        bh=WHe26+8MfrxiSeq61T2xpONFTHSwhFR7NzSNBJoEdHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OKonkmR+6F/ZtwJ5vzXowbDF8pVItP2Gqden6B85rBucL63YTKg051tR6I3pk+p/9
         0tevAZN2y8+YQ09hUxAnNINsrz9gdjao60LLUk/kYbFlwF4DlpCmCle0XXxTPpsWTW
         HOS03Q9+xA92+LCUbfJb8cQO+FYEXhx2aqTiThNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dawid Lukwinski <dawid.lukwinski@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 245/363] i40e: Fix PHY type identifiers for 2.5G and 5G adapters
Date:   Mon, 17 May 2021 16:01:51 +0200
Message-Id: <20210517140310.868418894@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

[ Upstream commit 15395ec4685bd45a43d1b54b8fd9846b87e2c621 ]

Unlike other supported adapters, 2.5G and 5G use different
PHY type identifiers for reading/writing PHY settings
and for reading link status. This commit introduces
separate PHY identifiers for these two operation types.

Fixes: 2e45d3f4677a ("i40e: Add support for X710 B/P & SFP+ cards")
Signed-off-by: Dawid Lukwinski <dawid.lukwinski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h | 6 ++++--
 drivers/net/ethernet/intel/i40e/i40e_common.c     | 4 ++--
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c    | 4 ++--
 drivers/net/ethernet/intel/i40e/i40e_type.h       | 7 ++-----
 4 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
index ce626eace692..140b677f114d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
@@ -1566,8 +1566,10 @@ enum i40e_aq_phy_type {
 	I40E_PHY_TYPE_25GBASE_LR		= 0x22,
 	I40E_PHY_TYPE_25GBASE_AOC		= 0x23,
 	I40E_PHY_TYPE_25GBASE_ACC		= 0x24,
-	I40E_PHY_TYPE_2_5GBASE_T		= 0x30,
-	I40E_PHY_TYPE_5GBASE_T			= 0x31,
+	I40E_PHY_TYPE_2_5GBASE_T		= 0x26,
+	I40E_PHY_TYPE_5GBASE_T			= 0x27,
+	I40E_PHY_TYPE_2_5GBASE_T_LINK_STATUS	= 0x30,
+	I40E_PHY_TYPE_5GBASE_T_LINK_STATUS	= 0x31,
 	I40E_PHY_TYPE_MAX,
 	I40E_PHY_TYPE_NOT_SUPPORTED_HIGH_TEMP	= 0xFD,
 	I40E_PHY_TYPE_EMPTY			= 0xFE,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index ec19e18305ec..ce35e064cf60 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -1154,8 +1154,8 @@ static enum i40e_media_type i40e_get_media_type(struct i40e_hw *hw)
 		break;
 	case I40E_PHY_TYPE_100BASE_TX:
 	case I40E_PHY_TYPE_1000BASE_T:
-	case I40E_PHY_TYPE_2_5GBASE_T:
-	case I40E_PHY_TYPE_5GBASE_T:
+	case I40E_PHY_TYPE_2_5GBASE_T_LINK_STATUS:
+	case I40E_PHY_TYPE_5GBASE_T_LINK_STATUS:
 	case I40E_PHY_TYPE_10GBASE_T:
 		media = I40E_MEDIA_TYPE_BASET;
 		break;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 6f3b7e0faa13..e8da7339137c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -841,8 +841,8 @@ static void i40e_get_settings_link_up(struct i40e_hw *hw,
 							     10000baseT_Full);
 		break;
 	case I40E_PHY_TYPE_10GBASE_T:
-	case I40E_PHY_TYPE_5GBASE_T:
-	case I40E_PHY_TYPE_2_5GBASE_T:
+	case I40E_PHY_TYPE_5GBASE_T_LINK_STATUS:
+	case I40E_PHY_TYPE_2_5GBASE_T_LINK_STATUS:
 	case I40E_PHY_TYPE_1000BASE_T:
 	case I40E_PHY_TYPE_100BASE_TX:
 		ethtool_link_ksettings_add_link_mode(ks, supported, Autoneg);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_type.h b/drivers/net/ethernet/intel/i40e/i40e_type.h
index 5c10faaca790..c81109a63e90 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_type.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_type.h
@@ -239,11 +239,8 @@ struct i40e_phy_info {
 #define I40E_CAP_PHY_TYPE_25GBASE_ACC BIT_ULL(I40E_PHY_TYPE_25GBASE_ACC + \
 					     I40E_PHY_TYPE_OFFSET)
 /* Offset for 2.5G/5G PHY Types value to bit number conversion */
-#define I40E_PHY_TYPE_OFFSET2 (-10)
-#define I40E_CAP_PHY_TYPE_2_5GBASE_T BIT_ULL(I40E_PHY_TYPE_2_5GBASE_T + \
-					     I40E_PHY_TYPE_OFFSET2)
-#define I40E_CAP_PHY_TYPE_5GBASE_T BIT_ULL(I40E_PHY_TYPE_5GBASE_T + \
-					     I40E_PHY_TYPE_OFFSET2)
+#define I40E_CAP_PHY_TYPE_2_5GBASE_T BIT_ULL(I40E_PHY_TYPE_2_5GBASE_T)
+#define I40E_CAP_PHY_TYPE_5GBASE_T BIT_ULL(I40E_PHY_TYPE_5GBASE_T)
 #define I40E_HW_CAP_MAX_GPIO			30
 /* Capabilities of a PF or a VF or the whole device */
 struct i40e_hw_capabilities {
-- 
2.30.2



