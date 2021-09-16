Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80EB40E86D
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355605AbhIPRof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:44:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355363AbhIPRlX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:41:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71B4161279;
        Thu, 16 Sep 2021 16:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811146;
        bh=FiR+bE2Z4ZUmXu1ak+QX5VP857fG5g/58S/VRZgUAoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQoqFmOU1470+f3h3x3IkxuWQ5Jxh3D9sizkwuiI9+OlYR+4wayKdY7rDWNw4VOw6
         dvDVjP68IZiaBCv9nXDS12IyognpmTq6VOUBdUS99iOPTO/8tjq5edeHUZGPY16gjA
         JzwWX0eEPDAaJvFtNupulkQfmKF+RNVPaPRmHf3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 373/432] iwlwifi: mvm: dont schedule the roc_done_wk if it is already running
Date:   Thu, 16 Sep 2021 18:02:02 +0200
Message-Id: <20210916155823.442513573@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit a76b57311b1a247e31b055872d021c38707dc3a8 ]

When P2P roc is removed, the IWL_MVM_STATUS_NEED_FLUSH_P2P bit is set
to indicate to iwl_mvm_roc_done_wk() that the removed roc is a P2P
one, so it will flush the broadcast station and not the aux station.

However, since setting this bit and scheduling the worker is done
in roc ended flow as well as in case the roc is removed, there is
a race where the worker has already started running (but did not
test this bit yet) and then it is scheduled again. In this case,
the first run of the worker will clear this bit, and thus the second
run will find it already cleared and will try to flush and remove
the aux station by mistake.

Fix it by scheduling the worker only if this bit is not yet set. In
case this bit is already set, the worker is either running or
scheduled, so there is no need to re-schedule it.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210819183728.8c147659b331.If5924375e9bfd46214ab8ab81cb9d0f5c82fbcbc@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/intel/iwlwifi/mvm/time-event.c   | 31 ++++++++++++-------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index d3307a11fcac..24b658a3098a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -246,6 +246,18 @@ static void iwl_mvm_te_check_trigger(struct iwl_mvm *mvm,
 	}
 }
 
+static void iwl_mvm_p2p_roc_finished(struct iwl_mvm *mvm)
+{
+	/*
+	 * If the IWL_MVM_STATUS_NEED_FLUSH_P2P is already set, then the
+	 * roc_done_wk is already scheduled or running, so don't schedule it
+	 * again to avoid a race where the roc_done_wk clears this bit after
+	 * it is set here, affecting the next run of the roc_done_wk.
+	 */
+	if (!test_and_set_bit(IWL_MVM_STATUS_NEED_FLUSH_P2P, &mvm->status))
+		iwl_mvm_roc_finished(mvm);
+}
+
 /*
  * Handles a FW notification for an event that is known to the driver.
  *
@@ -297,8 +309,7 @@ static void iwl_mvm_te_handle_notif(struct iwl_mvm *mvm,
 		switch (te_data->vif->type) {
 		case NL80211_IFTYPE_P2P_DEVICE:
 			ieee80211_remain_on_channel_expired(mvm->hw);
-			set_bit(IWL_MVM_STATUS_NEED_FLUSH_P2P, &mvm->status);
-			iwl_mvm_roc_finished(mvm);
+			iwl_mvm_p2p_roc_finished(mvm);
 			break;
 		case NL80211_IFTYPE_STATION:
 			/*
@@ -674,8 +685,7 @@ static bool __iwl_mvm_remove_time_event(struct iwl_mvm *mvm,
 			/* Session protection is still ongoing. Cancel it */
 			iwl_mvm_cancel_session_protection(mvm, mvmvif, id);
 			if (iftype == NL80211_IFTYPE_P2P_DEVICE) {
-				set_bit(IWL_MVM_STATUS_NEED_FLUSH_P2P, &mvm->status);
-				iwl_mvm_roc_finished(mvm);
+				iwl_mvm_p2p_roc_finished(mvm);
 			}
 		}
 		return false;
@@ -842,8 +852,7 @@ void iwl_mvm_rx_session_protect_notif(struct iwl_mvm *mvm,
 		/* End TE, notify mac80211 */
 		mvmvif->time_event_data.id = SESSION_PROTECT_CONF_MAX_ID;
 		ieee80211_remain_on_channel_expired(mvm->hw);
-		set_bit(IWL_MVM_STATUS_NEED_FLUSH_P2P, &mvm->status);
-		iwl_mvm_roc_finished(mvm);
+		iwl_mvm_p2p_roc_finished(mvm);
 	} else if (le32_to_cpu(notif->start)) {
 		if (WARN_ON(mvmvif->time_event_data.id !=
 				le32_to_cpu(notif->conf_id)))
@@ -1004,14 +1013,13 @@ void iwl_mvm_stop_roc(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		if (vif->type == NL80211_IFTYPE_P2P_DEVICE) {
 			iwl_mvm_cancel_session_protection(mvm, mvmvif,
 							  mvmvif->time_event_data.id);
-			set_bit(IWL_MVM_STATUS_NEED_FLUSH_P2P, &mvm->status);
+			iwl_mvm_p2p_roc_finished(mvm);
 		} else {
 			iwl_mvm_remove_aux_roc_te(mvm, mvmvif,
 						  &mvmvif->time_event_data);
+			iwl_mvm_roc_finished(mvm);
 		}
 
-		iwl_mvm_roc_finished(mvm);
-
 		return;
 	}
 
@@ -1025,12 +1033,11 @@ void iwl_mvm_stop_roc(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	if (te_data->vif->type == NL80211_IFTYPE_P2P_DEVICE) {
 		iwl_mvm_remove_time_event(mvm, mvmvif, te_data);
-		set_bit(IWL_MVM_STATUS_NEED_FLUSH_P2P, &mvm->status);
+		iwl_mvm_p2p_roc_finished(mvm);
 	} else {
 		iwl_mvm_remove_aux_roc_te(mvm, mvmvif, te_data);
+		iwl_mvm_roc_finished(mvm);
 	}
-
-	iwl_mvm_roc_finished(mvm);
 }
 
 void iwl_mvm_remove_csa_period(struct iwl_mvm *mvm,
-- 
2.30.2



