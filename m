Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C74C3CA924
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241210AbhGOTFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:05:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243368AbhGOTEU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:04:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1073E61400;
        Thu, 15 Jul 2021 18:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375593;
        bh=l4ACLrGt1wwBOJQDNWPWmPdBam83QwemWDD03QhpA30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pIeqfhkTzIbVf1GZcB5BGvS/s4CKYh3aoM6p1FNld3OWP+32ANqPHWZdfsz7b+Qrm
         FZ3m7p4dtJPO19hHqr3uTb9Mi0jbDDiAU/npot4RXz0rKD3hlujGN0IFvD+3jHFlDb
         jRbb/91vZp8poRvD2fesVkwypHdtDzeBzTyRksIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 116/242] iwlwifi: mvm: dont change band on bound PHY contexts
Date:   Thu, 15 Jul 2021 20:37:58 +0200
Message-Id: <20210715182613.536400700@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 8835a64f74c46baebfc946cd5a2c861b866ebcee ]

When we have a P2P Device active, we attempt to only change the
PHY context it uses when we get a new remain-on-channel, if the
P2P Device is the only user of the PHY context.

This is fine if we're switching within a band, but if we're
switching bands then the switch implies a removal and re-add
of the PHY context, which isn't permitted by the firmware while
it's bound to an interface.

Fix the code to skip the unbind/release/... cycle only if the
band doesn't change (or we have old devices that can switch the
band on the fly as well.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210612142637.e9ac313f70f3.I713b9d109957df7e7d9ed0861d5377ce3f8fccd3@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 24 ++++++++++++++-----
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index baf7404c137d..873d41c21a77 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3798,6 +3798,7 @@ static int iwl_mvm_roc(struct ieee80211_hw *hw,
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct cfg80211_chan_def chandef;
 	struct iwl_mvm_phy_ctxt *phy_ctxt;
+	bool band_change_removal;
 	int ret, i;
 
 	IWL_DEBUG_MAC80211(mvm, "enter (%d, %d, %d)\n", channel->hw_value,
@@ -3878,19 +3879,30 @@ static int iwl_mvm_roc(struct ieee80211_hw *hw,
 	cfg80211_chandef_create(&chandef, channel, NL80211_CHAN_NO_HT);
 
 	/*
-	 * Change the PHY context configuration as it is currently referenced
-	 * only by the P2P Device MAC
+	 * Check if the remain-on-channel is on a different band and that
+	 * requires context removal, see iwl_mvm_phy_ctxt_changed(). If
+	 * so, we'll need to release and then re-configure here, since we
+	 * must not remove a PHY context that's part of a binding.
 	 */
-	if (mvmvif->phy_ctxt->ref == 1) {
+	band_change_removal =
+		fw_has_capa(&mvm->fw->ucode_capa,
+			    IWL_UCODE_TLV_CAPA_BINDING_CDB_SUPPORT) &&
+		mvmvif->phy_ctxt->channel->band != chandef.chan->band;
+
+	if (mvmvif->phy_ctxt->ref == 1 && !band_change_removal) {
+		/*
+		 * Change the PHY context configuration as it is currently
+		 * referenced only by the P2P Device MAC (and we can modify it)
+		 */
 		ret = iwl_mvm_phy_ctxt_changed(mvm, mvmvif->phy_ctxt,
 					       &chandef, 1, 1);
 		if (ret)
 			goto out_unlock;
 	} else {
 		/*
-		 * The PHY context is shared with other MACs. Need to remove the
-		 * P2P Device from the binding, allocate an new PHY context and
-		 * create a new binding
+		 * The PHY context is shared with other MACs (or we're trying to
+		 * switch bands), so remove the P2P Device from the binding,
+		 * allocate an new PHY context and create a new binding.
 		 */
 		phy_ctxt = iwl_mvm_get_free_phy_ctxt(mvm);
 		if (!phy_ctxt) {
-- 
2.30.2



