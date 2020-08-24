Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275FC24F7F5
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbgHXJXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:23:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728677AbgHXIyD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:54:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AF9C204FD;
        Mon, 24 Aug 2020 08:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259242;
        bh=VoZfXgOGLej3XO2LfQDZ0kod3PKbNICX7lIisOFhpAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWiIGzE7oZ3xNNR17fs4NXA1BprhcyccB1Idr0B8RPjDbonkIm99mOJT44myWKB+M
         59UCZRt6xQRFayJi4jeASC5kXH3U7PtrcUazTnL4ugLdu76mijS9a5FMXvU28yzIYz
         FUsgHhzUB6yeHWPTbRb/2q8USzRJinm7ACwIesPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 34/50] i40e: Set RX_ONLY mode for unicast promiscuous on VLAN
Date:   Mon, 24 Aug 2020 10:31:35 +0200
Message-Id: <20200824082353.772455451@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082351.823243923@linuxfoundation.org>
References: <20200824082351.823243923@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

[ Upstream commit 4bd5e02a2ed1575c2f65bd3c557a077dd399f0e8 ]

Trusted VF with unicast promiscuous mode set, could listen to TX
traffic of other VFs.
Set unicast promiscuous mode to RX traffic, if VSI has port VLAN
configured. Rename misleading I40E_AQC_SET_VSI_PROMISC_TX bit to
I40E_AQC_SET_VSI_PROMISC_RX_ONLY. Aligned unicast promiscuous with
VLAN to the one without VLAN.

Fixes: 6c41a7606967 ("i40e: Add promiscuous on VLAN support")
Fixes: 3b1200891b7f ("i40e: When in promisc mode apply promisc mode to Tx Traffic as well")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/i40e/i40e_adminq_cmd.h |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c | 35 ++++++++++++++-----
 2 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
index 5d5f422cbae55..f82da2b47d9a5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
@@ -1175,7 +1175,7 @@ struct i40e_aqc_set_vsi_promiscuous_modes {
 #define I40E_AQC_SET_VSI_PROMISC_BROADCAST	0x04
 #define I40E_AQC_SET_VSI_DEFAULT		0x08
 #define I40E_AQC_SET_VSI_PROMISC_VLAN		0x10
-#define I40E_AQC_SET_VSI_PROMISC_TX		0x8000
+#define I40E_AQC_SET_VSI_PROMISC_RX_ONLY	0x8000
 	__le16	seid;
 #define I40E_AQC_VSI_PROM_CMD_SEID_MASK		0x3FF
 	__le16	vlan_tag;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index 111426ba5fbce..3fd2dfaf2bd53 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -1914,6 +1914,21 @@ i40e_status i40e_aq_set_phy_debug(struct i40e_hw *hw, u8 cmd_flags,
 	return status;
 }
 
+/**
+ * i40e_is_aq_api_ver_ge
+ * @aq: pointer to AdminQ info containing HW API version to compare
+ * @maj: API major value
+ * @min: API minor value
+ *
+ * Assert whether current HW API version is greater/equal than provided.
+ **/
+static bool i40e_is_aq_api_ver_ge(struct i40e_adminq_info *aq, u16 maj,
+				  u16 min)
+{
+	return (aq->api_maj_ver > maj ||
+		(aq->api_maj_ver == maj && aq->api_min_ver >= min));
+}
+
 /**
  * i40e_aq_add_vsi
  * @hw: pointer to the hw struct
@@ -2039,18 +2054,16 @@ i40e_status i40e_aq_set_vsi_unicast_promiscuous(struct i40e_hw *hw,
 
 	if (set) {
 		flags |= I40E_AQC_SET_VSI_PROMISC_UNICAST;
-		if (rx_only_promisc &&
-		    (((hw->aq.api_maj_ver == 1) && (hw->aq.api_min_ver >= 5)) ||
-		     (hw->aq.api_maj_ver > 1)))
-			flags |= I40E_AQC_SET_VSI_PROMISC_TX;
+		if (rx_only_promisc && i40e_is_aq_api_ver_ge(&hw->aq, 1, 5))
+			flags |= I40E_AQC_SET_VSI_PROMISC_RX_ONLY;
 	}
 
 	cmd->promiscuous_flags = cpu_to_le16(flags);
 
 	cmd->valid_flags = cpu_to_le16(I40E_AQC_SET_VSI_PROMISC_UNICAST);
-	if (((hw->aq.api_maj_ver >= 1) && (hw->aq.api_min_ver >= 5)) ||
-	    (hw->aq.api_maj_ver > 1))
-		cmd->valid_flags |= cpu_to_le16(I40E_AQC_SET_VSI_PROMISC_TX);
+	if (i40e_is_aq_api_ver_ge(&hw->aq, 1, 5))
+		cmd->valid_flags |=
+			cpu_to_le16(I40E_AQC_SET_VSI_PROMISC_RX_ONLY);
 
 	cmd->seid = cpu_to_le16(seid);
 	status = i40e_asq_send_command(hw, &desc, NULL, 0, cmd_details);
@@ -2147,11 +2160,17 @@ enum i40e_status_code i40e_aq_set_vsi_uc_promisc_on_vlan(struct i40e_hw *hw,
 	i40e_fill_default_direct_cmd_desc(&desc,
 					  i40e_aqc_opc_set_vsi_promiscuous_modes);
 
-	if (enable)
+	if (enable) {
 		flags |= I40E_AQC_SET_VSI_PROMISC_UNICAST;
+		if (i40e_is_aq_api_ver_ge(&hw->aq, 1, 5))
+			flags |= I40E_AQC_SET_VSI_PROMISC_RX_ONLY;
+	}
 
 	cmd->promiscuous_flags = cpu_to_le16(flags);
 	cmd->valid_flags = cpu_to_le16(I40E_AQC_SET_VSI_PROMISC_UNICAST);
+	if (i40e_is_aq_api_ver_ge(&hw->aq, 1, 5))
+		cmd->valid_flags |=
+			cpu_to_le16(I40E_AQC_SET_VSI_PROMISC_RX_ONLY);
 	cmd->seid = cpu_to_le16(seid);
 	cmd->vlan_tag = cpu_to_le16(vid | I40E_AQC_SET_VSI_VLAN_VALID);
 
-- 
2.25.1



