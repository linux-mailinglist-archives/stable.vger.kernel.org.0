Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30CE38372C
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244713AbhEQPkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244525AbhEQPip (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:38:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C437161945;
        Mon, 17 May 2021 14:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262455;
        bh=Ml+rbwkOqOnHdPKJB7om6PTw+fGYm+kJ/QzE3psgn60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wTcYcaEiWvylAv/J6daj4YVsKa3h1qobNgrR9u+PdRM51Tqd3gn3edfhnJ4jlmp/T
         blRfuC6XK5ctcSkY2v0j8NgQ9AztASxUh1ACef9xSRwwKgvQ2CyuRad/CyLtSSsVcG
         fGtFZgb7co9fFlyNp6atGqtUDmPNtmA/arQbJ4Hc=
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
Subject: [PATCH 5.10 191/289] i40e: Fix PHY type identifiers for 2.5G and 5G adapters
Date:   Mon, 17 May 2021 16:01:56 +0200
Message-Id: <20210517140311.538072143@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
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
index 1e960c3c7ef0..e84054fb8213 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
@@ -1565,8 +1565,10 @@ enum i40e_aq_phy_type {
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
index adc9e4fa4789..ba109073d605 100644
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
index 13554706c180..5d48bc0c3f6c 100644
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
index c0bdc666f557..add67f7b73e8 100644
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



