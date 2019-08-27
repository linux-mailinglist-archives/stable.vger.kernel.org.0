Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A00D9E146
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731078AbfH0ICU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:02:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731908AbfH0ICT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:02:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F08420828;
        Tue, 27 Aug 2019 08:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892937;
        bh=sy0/m07PKMTkCdmcinVLBxpf0qhjiUFZE268cm2ABUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1aUjc5E3Nd/U3ph5gRRFIxEUF7I3H8xroHQ1b1q4/dCtMP1fowp8vhHoY5uqBPciL
         josIXwRXJwCWRdwrgrzUYUQlDqhQ/uJpLhquqEQdjRSKorSrpeQQpdo3xnGQyXT9fe
         oeoBtayyl0UO2U0mqe/BHzE8mUJ3uUo7dkoS87wU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 059/162] iwlwifi: fix locking in delayed GTK setting
Date:   Tue, 27 Aug 2019 09:49:47 +0200
Message-Id: <20190827072740.233875735@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6569e7d36773956298ec1d5f4e6a2487913d2752 ]

This code clearly never could have worked, since it locks
while already locked. Add an unlocked __iwl_mvm_mac_set_key()
variant that doesn't do locking to fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 39 ++++++++++++-------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 964c7baabede3..edffae3741e00 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -207,11 +207,11 @@ static const struct cfg80211_pmsr_capabilities iwl_mvm_pmsr_capa = {
 	},
 };
 
-static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
-			       enum set_key_cmd cmd,
-			       struct ieee80211_vif *vif,
-			       struct ieee80211_sta *sta,
-			       struct ieee80211_key_conf *key);
+static int __iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
+				 enum set_key_cmd cmd,
+				 struct ieee80211_vif *vif,
+				 struct ieee80211_sta *sta,
+				 struct ieee80211_key_conf *key);
 
 void iwl_mvm_ref(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type)
 {
@@ -2725,7 +2725,7 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 
 		mvmvif->ap_early_keys[i] = NULL;
 
-		ret = iwl_mvm_mac_set_key(hw, SET_KEY, vif, NULL, key);
+		ret = __iwl_mvm_mac_set_key(hw, SET_KEY, vif, NULL, key);
 		if (ret)
 			goto out_quota_failed;
 	}
@@ -3493,11 +3493,11 @@ static int iwl_mvm_mac_sched_scan_stop(struct ieee80211_hw *hw,
 	return ret;
 }
 
-static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
-			       enum set_key_cmd cmd,
-			       struct ieee80211_vif *vif,
-			       struct ieee80211_sta *sta,
-			       struct ieee80211_key_conf *key)
+static int __iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
+				 enum set_key_cmd cmd,
+				 struct ieee80211_vif *vif,
+				 struct ieee80211_sta *sta,
+				 struct ieee80211_key_conf *key)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
@@ -3552,8 +3552,6 @@ static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
 			return -EOPNOTSUPP;
 	}
 
-	mutex_lock(&mvm->mutex);
-
 	switch (cmd) {
 	case SET_KEY:
 		if ((vif->type == NL80211_IFTYPE_ADHOC ||
@@ -3699,7 +3697,22 @@ static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
 		ret = -EINVAL;
 	}
 
+	return ret;
+}
+
+static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
+			       enum set_key_cmd cmd,
+			       struct ieee80211_vif *vif,
+			       struct ieee80211_sta *sta,
+			       struct ieee80211_key_conf *key)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	int ret;
+
+	mutex_lock(&mvm->mutex);
+	ret = __iwl_mvm_mac_set_key(hw, cmd, vif, sta, key);
 	mutex_unlock(&mvm->mutex);
+
 	return ret;
 }
 
-- 
2.20.1



