Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82FA349999D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378432AbiAXVge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:36:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47454 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452950AbiAXV12 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:27:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AF28614D8;
        Mon, 24 Jan 2022 21:27:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0476C340E4;
        Mon, 24 Jan 2022 21:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059645;
        bh=TmhTFttc8Wf3beYe9Qj83vMhnXvOXEgoEjdWci6e82c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xufJA65QG6bAAcwp4gNkJeEe1rBp85oHkoGLMzwWQrfZWtFaIfuZE5YTMA1MkUps8
         aa4iV6mxAgZJBY9N1x9jkCF8TBOrljliXOLRjnw3uF5cSZDxvFOWsibLZQBN0EZhIc
         Enn+hS99RpT6HYymrZEbTT26zDia3494/Ex+2pg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0684/1039] iwlwifi: mvm: fix AUX ROC removal
Date:   Mon, 24 Jan 2022 19:41:13 +0100
Message-Id: <20220124184148.345357324@linuxfoundation.org>
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

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit f0337cb48f3bf5f0bbccc985d8a0a8c4aa4934b7 ]

When IWL_UCODE_TLV_CAPA_SESSION_PROT_CMD is set, removing a time event
always tries to cancel session protection. However, AUX ROC does
not use session protection so it was never removed. As a result,
if the driver tries to allocate another AUX ROC event right after
cancelling the first one, it will fail with a warning.
In addition, the time event data passed to iwl_mvm_remove_aux_roc_te()
is incorrect. Fix it.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211219132536.915e1f69f062.Id837e917f1c2beaca7c1eb33333d622548918a76@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index b8c645b9880fc..ab06dcda1462a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -696,11 +696,14 @@ static bool __iwl_mvm_remove_time_event(struct iwl_mvm *mvm,
 	iwl_mvm_te_clear_data(mvm, te_data);
 	spin_unlock_bh(&mvm->time_event_lock);
 
-	/* When session protection is supported, the te_data->id field
+	/* When session protection is used, the te_data->id field
 	 * is reused to save session protection's configuration.
+	 * For AUX ROC, HOT_SPOT_CMD is used and the te_data->id field is set
+	 * to HOT_SPOT_CMD.
 	 */
 	if (fw_has_capa(&mvm->fw->ucode_capa,
-			IWL_UCODE_TLV_CAPA_SESSION_PROT_CMD)) {
+			IWL_UCODE_TLV_CAPA_SESSION_PROT_CMD) &&
+	    id != HOT_SPOT_CMD) {
 		if (mvmvif && id < SESSION_PROTECT_CONF_MAX_ID) {
 			/* Session protection is still ongoing. Cancel it */
 			iwl_mvm_cancel_session_protection(mvm, mvmvif, id);
@@ -1036,7 +1039,7 @@ void iwl_mvm_stop_roc(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 			iwl_mvm_p2p_roc_finished(mvm);
 		} else {
 			iwl_mvm_remove_aux_roc_te(mvm, mvmvif,
-						  &mvmvif->time_event_data);
+						  &mvmvif->hs_time_event_data);
 			iwl_mvm_roc_finished(mvm);
 		}
 
-- 
2.34.1



