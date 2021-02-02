Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9873F30CC32
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238502AbhBBTqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:46:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:43126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233256AbhBBNwy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:52:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E89864FC5;
        Tue,  2 Feb 2021 13:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273430;
        bh=kMs4H7I+ABJJmWDVm/sD++GTd6ozNNpVB/5tfqQntnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bu/uBfVX7csQtbEiJ6vhzTSRnMaUx3f11evqoWzxxsg1zldOxRO5ZoSx7+Qk/5VsS
         EMNtSfTpK/eTT5ROyEZujuBJsc9s9PXZWUSW9/WWQ3B/0c4sS+FJVwcX709iff5LAX
         OEvnVhmlkRiZMb+NUuRsxaocIKfgfovmMXfBwvBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/142] iwlwifi: pcie: set LTR on more devices
Date:   Tue,  2 Feb 2021 14:37:46 +0100
Message-Id: <20210202133001.960232317@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit ed0022da8bd9a3ba1c0e1497457be28d52afa7e1 ]

To avoid completion timeouts during device boot, set up the
LTR timeouts on more devices - similar to what we had before
for AX210.

This also corrects the AX210 workaround to be done only on
discrete (non-integrated) devices, otherwise the registers
have no effect.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: edb625208d84 ("iwlwifi: pcie: set LTR to avoid completion timeout")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20210115130252.fb819e19530b.I0396f82922db66426f52fbb70d32a29c8fd66951@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h |  6 +++
 .../intel/iwlwifi/pcie/ctxt-info-gen3.c       | 39 +++++++++++--------
 2 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index fa3f15778fc7b..579578534f9d9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -355,6 +355,12 @@
 #define RADIO_RSP_ADDR_POS		(6)
 #define RADIO_RSP_RD_CMD		(3)
 
+/* LTR control (Qu only) */
+#define HPM_MAC_LTR_CSR			0xa0348c
+#define HPM_MAC_LRT_ENABLE_ALL		0xf
+/* also uses CSR_LTR_* for values */
+#define HPM_UMAC_LTR			0xa03480
+
 /* FW monitor */
 #define MON_BUFF_SAMPLE_CTL		(0xa03c00)
 #define MON_BUFF_BASE_ADDR		(0xa03c1c)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
index eeb87cf5ee857..d719e433a59bf 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
@@ -122,6 +122,15 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
 				 const struct fw_img *fw)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	u32 ltr_val = CSR_LTR_LONG_VAL_AD_NO_SNOOP_REQ |
+		      u32_encode_bits(CSR_LTR_LONG_VAL_AD_SCALE_USEC,
+				      CSR_LTR_LONG_VAL_AD_NO_SNOOP_SCALE) |
+		      u32_encode_bits(250,
+				      CSR_LTR_LONG_VAL_AD_NO_SNOOP_VAL) |
+		      CSR_LTR_LONG_VAL_AD_SNOOP_REQ |
+		      u32_encode_bits(CSR_LTR_LONG_VAL_AD_SCALE_USEC,
+				      CSR_LTR_LONG_VAL_AD_SNOOP_SCALE) |
+		      u32_encode_bits(250, CSR_LTR_LONG_VAL_AD_SNOOP_VAL);
 	struct iwl_context_info_gen3 *ctxt_info_gen3;
 	struct iwl_prph_scratch *prph_scratch;
 	struct iwl_prph_scratch_ctrl_cfg *prph_sc_ctrl;
@@ -253,23 +262,19 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
 	iwl_set_bit(trans, CSR_CTXT_INFO_BOOT_CTRL,
 		    CSR_AUTO_FUNC_BOOT_ENA);
 
-	if (trans->trans_cfg->device_family == IWL_DEVICE_FAMILY_AX210) {
-		/*
-		 * The firmware initializes this again later (to a smaller
-		 * value), but for the boot process initialize the LTR to
-		 * ~250 usec.
-		 */
-		u32 val = CSR_LTR_LONG_VAL_AD_NO_SNOOP_REQ |
-			  u32_encode_bits(CSR_LTR_LONG_VAL_AD_SCALE_USEC,
-					  CSR_LTR_LONG_VAL_AD_NO_SNOOP_SCALE) |
-			  u32_encode_bits(250,
-					  CSR_LTR_LONG_VAL_AD_NO_SNOOP_VAL) |
-			  CSR_LTR_LONG_VAL_AD_SNOOP_REQ |
-			  u32_encode_bits(CSR_LTR_LONG_VAL_AD_SCALE_USEC,
-					  CSR_LTR_LONG_VAL_AD_SNOOP_SCALE) |
-			  u32_encode_bits(250, CSR_LTR_LONG_VAL_AD_SNOOP_VAL);
-
-		iwl_write32(trans, CSR_LTR_LONG_VAL_AD, val);
+	/*
+	 * To workaround hardware latency issues during the boot process,
+	 * initialize the LTR to ~250 usec (see ltr_val above).
+	 * The firmware initializes this again later (to a smaller value).
+	 */
+	if ((trans->trans_cfg->device_family == IWL_DEVICE_FAMILY_AX210 ||
+	     trans->trans_cfg->device_family == IWL_DEVICE_FAMILY_22000) &&
+	    !trans->trans_cfg->integrated) {
+		iwl_write32(trans, CSR_LTR_LONG_VAL_AD, ltr_val);
+	} else if (trans->trans_cfg->integrated &&
+		   trans->trans_cfg->device_family == IWL_DEVICE_FAMILY_22000) {
+		iwl_write_prph(trans, HPM_MAC_LTR_CSR, HPM_MAC_LRT_ENABLE_ALL);
+		iwl_write_prph(trans, HPM_UMAC_LTR, ltr_val);
 	}
 
 	if (trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_AX210)
-- 
2.27.0



