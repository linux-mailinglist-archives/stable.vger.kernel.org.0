Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2399799E60
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 20:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731977AbfHVSBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 14:01:01 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:38124 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732288AbfHVSBB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 14:01:01 -0400
Received: from [91.156.6.193] (helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1i0rON-0003S9-6b
        for stable@vger.kernel.org; Thu, 22 Aug 2019 21:01:00 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     stable@vger.kernel.org
Date:   Thu, 22 Aug 2019 21:00:54 +0300
Message-Id: <20190822180054.22422-1-luca@coelho.fi>
X-Mailer: git-send-email 2.23.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on farmhouse.coelho.fi
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.2
Subject: [PATCH 5.2] iwlwifi: mvm: disable TX-AMSDU on older NICs
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit cfb21b11b891b08b79be07be57c40a85bb926668 upstream.

On older NICs, we occasionally see issues with A-MSDU support,
where the commands in the FIFO get confused and then we see an
assert EDC because the next command in the FIFO isn't TX.

We've tried to isolate this issue and understand where it comes
from, but haven't found any errors in building the A-MSDU in
software.

At least for now, disable A-MSDU support on older hardware so
that users can use it again without fearing the assert.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=203315.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 964c7baabede..3905770b8a1f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -474,7 +474,19 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	ieee80211_hw_set(hw, SUPPORTS_VHT_EXT_NSS_BW);
 	ieee80211_hw_set(hw, BUFF_MMPDU_TXQ);
 	ieee80211_hw_set(hw, STA_MMPDU_TXQ);
-	ieee80211_hw_set(hw, TX_AMSDU);
+	/*
+	 * On older devices, enabling TX A-MSDU occasionally leads to
+	 * something getting messed up, the command read from the FIFO
+	 * gets out of sync and isn't a TX command, so that we have an
+	 * assert EDC.
+	 *
+	 * It's not clear where the bug is, but since we didn't used to
+	 * support A-MSDU until moving the mac80211 iTXQs, just leave it
+	 * for older devices. We also don't see this issue on any newer
+	 * devices.
+	 */
+	if (mvm->cfg->device_family >= IWL_DEVICE_FAMILY_9000)
+		ieee80211_hw_set(hw, TX_AMSDU);
 	ieee80211_hw_set(hw, TX_FRAG_LIST);
 
 	if (iwl_mvm_has_tlc_offload(mvm)) {
-- 
2.23.0.rc1

