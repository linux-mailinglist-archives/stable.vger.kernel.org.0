Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7925D73E8E
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389854AbfGXTjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:39:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389063AbfGXTjF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:39:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4771E20665;
        Wed, 24 Jul 2019 19:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997144;
        bh=EL4ToSx/x92AXvru+ow+tDaLdREyosaeYE6Ek7RJQjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dQD8BinecAcnxXUsJq1tIYmIUg7sfhPize1piG3k1AIU3hRc/MUrZaoTUOAGS3Et+
         M9BTIxtgMLbajavfih5RRbtJ8LcaJB+qV1/7JlcJ84MYiFfFfpqlscfrbhBbpKcvPv
         hCdPL8sTl9F0Xeq9BD6GCSCmfRtguM/A2cqoFQxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 5.2 299/413] iwlwifi: mvm: delay GTK setting in FW in AP mode
Date:   Wed, 24 Jul 2019 21:19:50 +0200
Message-Id: <20190724191757.390953151@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit c56e00a3feaee2b46b7d33875fb7f52efd30241f upstream.

In AP (and IBSS) mode, we can only set GTKs to firmware after we have
sent down the multicast station, but this we can only do after we've
enabled beaconing, etc.

However, during rfkill exit, hostapd will configure the keys before
starting the AP, and cfg80211/mac80211 accept it happily.

On earlier devices, this didn't bother us as GTK TX wasn't really
handled in firmware, we just put the key material into the TX cmd
and thus it only mattered when we actually transmitted a frame.

On newer devices, however, the firmware needs to track all of this
and that doesn't work if we add the key before the (multicast) sta
it belongs to.

To fix this, keep a list of keys to add during AP enable, and call
the function there.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |   53 +++++++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |    3 +
 2 files changed, 54 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -207,6 +207,12 @@ static const struct cfg80211_pmsr_capabi
 	},
 };
 
+static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
+			       enum set_key_cmd cmd,
+			       struct ieee80211_vif *vif,
+			       struct ieee80211_sta *sta,
+			       struct ieee80211_key_conf *key);
+
 void iwl_mvm_ref(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type)
 {
 	if (!iwl_mvm_is_d0i3_supported(mvm))
@@ -2636,7 +2642,7 @@ static int iwl_mvm_start_ap_ibss(struct
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	int ret;
+	int ret, i;
 
 	/*
 	 * iwl_mvm_mac_ctxt_add() might read directly from the device
@@ -2710,6 +2716,20 @@ static int iwl_mvm_start_ap_ibss(struct
 	/* must be set before quota calculations */
 	mvmvif->ap_ibss_active = true;
 
+	/* send all the early keys to the device now */
+	for (i = 0; i < ARRAY_SIZE(mvmvif->ap_early_keys); i++) {
+		struct ieee80211_key_conf *key = mvmvif->ap_early_keys[i];
+
+		if (!key)
+			continue;
+
+		mvmvif->ap_early_keys[i] = NULL;
+
+		ret = iwl_mvm_mac_set_key(hw, SET_KEY, vif, NULL, key);
+		if (ret)
+			goto out_quota_failed;
+	}
+
 	if (vif->type == NL80211_IFTYPE_AP && !vif->p2p) {
 		iwl_mvm_vif_set_low_latency(mvmvif, true,
 					    LOW_LATENCY_VIF_TYPE);
@@ -3479,11 +3499,12 @@ static int iwl_mvm_mac_set_key(struct ie
 			       struct ieee80211_sta *sta,
 			       struct ieee80211_key_conf *key)
 {
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	struct iwl_mvm_sta *mvmsta;
 	struct iwl_mvm_key_pn *ptk_pn;
 	int keyidx = key->keyidx;
-	int ret;
+	int ret, i;
 	u8 key_offset;
 
 	if (iwlwifi_mod_params.swcrypto) {
@@ -3556,6 +3577,22 @@ static int iwl_mvm_mac_set_key(struct ie
 				key->hw_key_idx = STA_KEY_IDX_INVALID;
 				break;
 			}
+
+			if (!mvmvif->ap_ibss_active) {
+				for (i = 0;
+				     i < ARRAY_SIZE(mvmvif->ap_early_keys);
+				     i++) {
+					if (!mvmvif->ap_early_keys[i]) {
+						mvmvif->ap_early_keys[i] = key;
+						break;
+					}
+				}
+
+				if (i >= ARRAY_SIZE(mvmvif->ap_early_keys))
+					ret = -ENOSPC;
+
+				break;
+			}
 		}
 
 		/* During FW restart, in order to restore the state as it was,
@@ -3624,6 +3661,18 @@ static int iwl_mvm_mac_set_key(struct ie
 
 		break;
 	case DISABLE_KEY:
+		ret = -ENOENT;
+		for (i = 0; i < ARRAY_SIZE(mvmvif->ap_early_keys); i++) {
+			if (mvmvif->ap_early_keys[i] == key) {
+				mvmvif->ap_early_keys[i] = NULL;
+				ret = 0;
+			}
+		}
+
+		/* found in pending list - don't do anything else */
+		if (ret == 0)
+			break;
+
 		if (key->hw_key_idx == STA_KEY_IDX_INVALID) {
 			ret = 0;
 			break;
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -501,6 +501,9 @@ struct iwl_mvm_vif {
 	netdev_features_t features;
 
 	struct iwl_probe_resp_data __rcu *probe_resp_data;
+
+	/* we can only have 2 GTK + 2 IGTK active at a time */
+	struct ieee80211_key_conf *ap_early_keys[4];
 };
 
 static inline struct iwl_mvm_vif *


