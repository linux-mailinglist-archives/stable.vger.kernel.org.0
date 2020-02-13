Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A85415C31E
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729575AbgBMP2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:28:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:54360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729562AbgBMP2H (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:28:07 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD6E92168B;
        Thu, 13 Feb 2020 15:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607686;
        bh=v+c5hhTYM9SG373BOxguPENcDCjuwUc6kVSyymuD6V4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cx9RgMoUhnXuqZWDptpoyhkCCBm4XMxpOs8OY7xsUhmrBqScb3ctO5mni5WLfa1ED
         z4XuSrNeK8sWtsVMlQOl873cz2qINmD71ds4E6i5O3CdYCGqxQBZXeh3WzcRvZNQAb
         IEkvkIYrBLx9McjFRPgfQivHoY/WjAof96n7UVBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.5 022/120] iwlwifi: mvm: fix TDLS discovery with the new firmware API
Date:   Thu, 13 Feb 2020 07:20:18 -0800
Message-Id: <20200213151909.770611835@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit b5b878e36c1836c0195575132cc7c199e5a34a7b upstream.

I changed the API for asking for a session protection but
I omitted the TDLS flows. Fix that now.
Note that for the TDLS flow, we need to block until the
session protection actually starts, so add this option
to iwl_mvm_schedule_session_protection.
This patch fixes a firmware assert in the TDLS flow since
the old TIME_EVENT_CMD is not supported anymore by newer
firwmare versions.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Fixes: fe959c7b2049 ("iwlwifi: mvm: use the new session protection command")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c   |    2 
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c       |   10 ++
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c |   71 ++++++++++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.h |    4 -
 4 files changed, 72 insertions(+), 15 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3293,7 +3293,7 @@ static void iwl_mvm_mac_mgd_prepare_tx(s
 	if (fw_has_capa(&mvm->fw->ucode_capa,
 			IWL_UCODE_TLV_CAPA_SESSION_PROT_CMD))
 		iwl_mvm_schedule_session_protection(mvm, vif, 900,
-						    min_duration);
+						    min_duration, false);
 	else
 		iwl_mvm_protect_session(mvm, vif, duration,
 					min_duration, 500, false);
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
@@ -205,9 +205,15 @@ void iwl_mvm_mac_mgd_protect_tdls_discov
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	u32 duration = 2 * vif->bss_conf.dtim_period * vif->bss_conf.beacon_int;
 
-	mutex_lock(&mvm->mutex);
 	/* Protect the session to hear the TDLS setup response on the channel */
-	iwl_mvm_protect_session(mvm, vif, duration, duration, 100, true);
+	mutex_lock(&mvm->mutex);
+	if (fw_has_capa(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_CAPA_SESSION_PROT_CMD))
+		iwl_mvm_schedule_session_protection(mvm, vif, duration,
+						    duration, true);
+	else
+		iwl_mvm_protect_session(mvm, vif, duration,
+					duration, 100, true);
 	mutex_unlock(&mvm->mutex);
 }
 
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -1056,13 +1056,42 @@ int iwl_mvm_schedule_csa_period(struct i
 	return iwl_mvm_time_event_send_add(mvm, vif, te_data, &time_cmd);
 }
 
+static bool iwl_mvm_session_prot_notif(struct iwl_notif_wait_data *notif_wait,
+				       struct iwl_rx_packet *pkt, void *data)
+{
+	struct iwl_mvm *mvm =
+		container_of(notif_wait, struct iwl_mvm, notif_wait);
+	struct iwl_mvm_session_prot_notif *resp;
+	int resp_len = iwl_rx_packet_payload_len(pkt);
+
+	if (WARN_ON(pkt->hdr.cmd != SESSION_PROTECTION_NOTIF ||
+		    pkt->hdr.group_id != MAC_CONF_GROUP))
+		return true;
+
+	if (WARN_ON_ONCE(resp_len != sizeof(*resp))) {
+		IWL_ERR(mvm, "Invalid SESSION_PROTECTION_NOTIF response\n");
+		return true;
+	}
+
+	resp = (void *)pkt->data;
+
+	if (!resp->status)
+		IWL_ERR(mvm,
+			"TIME_EVENT_NOTIFICATION received but not executed\n");
+
+	return true;
+}
+
 void iwl_mvm_schedule_session_protection(struct iwl_mvm *mvm,
 					 struct ieee80211_vif *vif,
-					 u32 duration, u32 min_duration)
+					 u32 duration, u32 min_duration,
+					 bool wait_for_notif)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm_time_event_data *te_data = &mvmvif->time_event_data;
-
+	const u16 notif[] = { iwl_cmd_id(SESSION_PROTECTION_NOTIF,
+					 MAC_CONF_GROUP, 0) };
+	struct iwl_notification_wait wait_notif;
 	struct iwl_mvm_session_prot_cmd cmd = {
 		.id_and_color =
 			cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id,
@@ -1071,7 +1100,6 @@ void iwl_mvm_schedule_session_protection
 		.conf_id = cpu_to_le32(SESSION_PROTECT_CONF_ASSOC),
 		.duration_tu = cpu_to_le32(MSEC_TO_TU(duration)),
 	};
-	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -1092,14 +1120,35 @@ void iwl_mvm_schedule_session_protection
 	IWL_DEBUG_TE(mvm, "Add new session protection, duration %d TU\n",
 		     le32_to_cpu(cmd.duration_tu));
 
-	ret = iwl_mvm_send_cmd_pdu(mvm, iwl_cmd_id(SESSION_PROTECTION_CMD,
-						   MAC_CONF_GROUP, 0),
-				   0, sizeof(cmd), &cmd);
-	if (ret) {
+	if (!wait_for_notif) {
+		if (iwl_mvm_send_cmd_pdu(mvm,
+					 iwl_cmd_id(SESSION_PROTECTION_CMD,
+						    MAC_CONF_GROUP, 0),
+					 0, sizeof(cmd), &cmd)) {
+			IWL_ERR(mvm,
+				"Couldn't send the SESSION_PROTECTION_CMD\n");
+			spin_lock_bh(&mvm->time_event_lock);
+			iwl_mvm_te_clear_data(mvm, te_data);
+			spin_unlock_bh(&mvm->time_event_lock);
+		}
+
+		return;
+	}
+
+	iwl_init_notification_wait(&mvm->notif_wait, &wait_notif,
+				   notif, ARRAY_SIZE(notif),
+				   iwl_mvm_session_prot_notif, NULL);
+
+	if (iwl_mvm_send_cmd_pdu(mvm,
+				 iwl_cmd_id(SESSION_PROTECTION_CMD,
+					    MAC_CONF_GROUP, 0),
+				 0, sizeof(cmd), &cmd)) {
 		IWL_ERR(mvm,
-			"Couldn't send the SESSION_PROTECTION_CMD: %d\n", ret);
-		spin_lock_bh(&mvm->time_event_lock);
-		iwl_mvm_te_clear_data(mvm, te_data);
-		spin_unlock_bh(&mvm->time_event_lock);
+			"Couldn't send the SESSION_PROTECTION_CMD\n");
+		iwl_remove_notification(&mvm->notif_wait, &wait_notif);
+	} else if (iwl_wait_notification(&mvm->notif_wait, &wait_notif,
+					 TU_TO_JIFFIES(100))) {
+		IWL_ERR(mvm,
+			"Failed to protect session until session protection\n");
 	}
 }
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.h
@@ -250,10 +250,12 @@ iwl_mvm_te_scheduled(struct iwl_mvm_time
  * @mvm: the mvm component
  * @vif: the virtual interface for which the protection issued
  * @duration: the duration of the protection
+ * @wait_for_notif: if true, will block until the start of the protection
  */
 void iwl_mvm_schedule_session_protection(struct iwl_mvm *mvm,
 					 struct ieee80211_vif *vif,
-					 u32 duration, u32 min_duration);
+					 u32 duration, u32 min_duration,
+					 bool wait_for_notif);
 
 /**
  * iwl_mvm_rx_session_protect_notif - handles %SESSION_PROTECTION_NOTIF


