Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C9249977B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448598AbiAXVNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:13:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60620 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446800AbiAXVJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:09:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 020D6B8105C;
        Mon, 24 Jan 2022 21:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E1EC340E5;
        Mon, 24 Jan 2022 21:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058562;
        bh=c9RpIW94tVdBjMjoQJSSrE2zBofZpQhOST2oDE4CxCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/jgYzbxLBByDiByf2kIusMDwW6IDzgZAg+rTt3mbwofZIA4Kn0ggnjElRAnGgRhG
         VM/DL8nyqfBdDGel8E6xp0mtKKmojnMtj1/YIsnTDm3tuzxKTsN83gqw1Luz9oKYB2
         +hk5CQPuZf9gd2g/AnBvU3V3mTblKju9skGHxDBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0328/1039] iwlwifi: dont pass actual WGDS revision number in table_revision
Date:   Mon, 24 Jan 2022 19:35:17 +0100
Message-Id: <20220124184136.334863728@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

[ Upstream commit ac9952f6954216be72a8bde210e1ef2c949d8ee0 ]

The FW API for PER_CHAIN_LIMIT_OFFSET_CMD is misleading.  The element
name is table_rev, but it shouldn't actually contain the table
revision number, but whether we should use the South Korea scheme or
not.

Fix the driver so that we only set this value to either 0 or 1.  It
will only be 1 (meaning South Korea) if the ACPI WGDS table revision
is 1.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Fixes: 664c011b763e ("iwlwifi: acpi: support reading and storing WGDS revision 2")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211219121514.abed3b8119c7.I1fdc2c14577523fcffdfe8fb5902c2d8efde7e09@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/fw/api/power.h  |  8 ++++----
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c    | 18 +++++++++++++-----
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/power.h b/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
index 4d671c878bb7a..23e27afe94a23 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
@@ -419,7 +419,7 @@ struct iwl_geo_tx_power_profiles_cmd_v1 {
  * struct iwl_geo_tx_power_profile_cmd_v2 - struct for PER_CHAIN_LIMIT_OFFSET_CMD cmd.
  * @ops: operations, value from &enum iwl_geo_per_chain_offset_operation
  * @table: offset profile per band.
- * @table_revision: BIOS table revision.
+ * @table_revision: 0 for not-South Korea, 1 for South Korea (the name is misleading)
  */
 struct iwl_geo_tx_power_profiles_cmd_v2 {
 	__le32 ops;
@@ -431,7 +431,7 @@ struct iwl_geo_tx_power_profiles_cmd_v2 {
  * struct iwl_geo_tx_power_profile_cmd_v3 - struct for PER_CHAIN_LIMIT_OFFSET_CMD cmd.
  * @ops: operations, value from &enum iwl_geo_per_chain_offset_operation
  * @table: offset profile per band.
- * @table_revision: BIOS table revision.
+ * @table_revision: 0 for not-South Korea, 1 for South Korea (the name is misleading)
  */
 struct iwl_geo_tx_power_profiles_cmd_v3 {
 	__le32 ops;
@@ -443,7 +443,7 @@ struct iwl_geo_tx_power_profiles_cmd_v3 {
  * struct iwl_geo_tx_power_profile_cmd_v4 - struct for PER_CHAIN_LIMIT_OFFSET_CMD cmd.
  * @ops: operations, value from &enum iwl_geo_per_chain_offset_operation
  * @table: offset profile per band.
- * @table_revision: BIOS table revision.
+ * @table_revision: 0 for not-South Korea, 1 for South Korea (the name is misleading)
  */
 struct iwl_geo_tx_power_profiles_cmd_v4 {
 	__le32 ops;
@@ -455,7 +455,7 @@ struct iwl_geo_tx_power_profiles_cmd_v4 {
  * struct iwl_geo_tx_power_profile_cmd_v5 - struct for PER_CHAIN_LIMIT_OFFSET_CMD cmd.
  * @ops: operations, value from &enum iwl_geo_per_chain_offset_operation
  * @table: offset profile per band.
- * @table_revision: BIOS table revision.
+ * @table_revision: 0 for not-South Korea, 1 for South Korea (the name is misleading)
  */
 struct iwl_geo_tx_power_profiles_cmd_v5 {
 	__le32 ops;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 863fec150e536..9eb78461f2800 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -820,6 +820,7 @@ static int iwl_mvm_sar_geo_init(struct iwl_mvm *mvm)
 	u16 len;
 	u32 n_bands;
 	u32 n_profiles;
+	u32 sk = 0;
 	int ret;
 	u8 cmd_ver = iwl_fw_lookup_cmd_ver(mvm->fw, PHY_OPS_GROUP,
 					   PER_CHAIN_LIMIT_OFFSET_CMD,
@@ -879,19 +880,26 @@ static int iwl_mvm_sar_geo_init(struct iwl_mvm *mvm)
 	if (ret)
 		return 0;
 
+	/* Only set to South Korea if the table revision is 1 */
+	if (mvm->fwrt.geo_rev == 1)
+		sk = 1;
+
 	/*
-	 * Set the revision on versions that contain it.
+	 * Set the table_revision to South Korea (1) or not (0).  The
+	 * element name is misleading, as it doesn't contain the table
+	 * revision number, but whether the South Korea variation
+	 * should be used.
 	 * This must be done after calling iwl_sar_geo_init().
 	 */
 	if (cmd_ver == 5)
-		cmd.v5.table_revision = cpu_to_le32(mvm->fwrt.geo_rev);
+		cmd.v5.table_revision = cpu_to_le32(sk);
 	else if (cmd_ver == 4)
-		cmd.v4.table_revision = cpu_to_le32(mvm->fwrt.geo_rev);
+		cmd.v4.table_revision = cpu_to_le32(sk);
 	else if (cmd_ver == 3)
-		cmd.v3.table_revision = cpu_to_le32(mvm->fwrt.geo_rev);
+		cmd.v3.table_revision = cpu_to_le32(sk);
 	else if (fw_has_api(&mvm->fwrt.fw->ucode_capa,
 			    IWL_UCODE_TLV_API_SAR_TABLE_VER))
-		cmd.v2.table_revision = cpu_to_le32(mvm->fwrt.geo_rev);
+		cmd.v2.table_revision = cpu_to_le32(sk);
 
 	return iwl_mvm_send_cmd_pdu(mvm,
 				    WIDE_ID(PHY_OPS_GROUP,
-- 
2.34.1



