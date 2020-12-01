Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201802C9C69
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390444AbgLAJSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:18:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:49038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389825AbgLAJLS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:11:18 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C7C320770;
        Tue,  1 Dec 2020 09:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813831;
        bh=eVs88RSKWp5uqbHNKsrIamhB1o8vWj/QG2gnPttbGJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2PZRgsNsRJgdUu5NG96j6MwSbo0/m+lI2CbQf7FKsY3YQLZRfxMlFA7jbqb0TYSIu
         8xV81VublpVmOxF/nHnim2sA8wqoIYyE1s2xnyd1sWucNbPslFbaEO4QsjlFSS092b
         SAqg3SG8k3eUm39Mv/NCWar8Z5mbmulvROgykTgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 073/152] iwlwifi: mvm: use the HOT_SPOT_CMD to cancel an AUX ROC
Date:   Tue,  1 Dec 2020 09:53:08 +0100
Message-Id: <20201201084721.485144594@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit fb8d1b6e97980057b7ebed444b8950e57f268a67 ]

The ROC that runs on the AUX ROC (meaning an ROC on the STA vif),
was added with the HOT_SPOT_CMD firmware command and must be
cancelled with that same command.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Fixes: fe959c7b2049 ("iwlwifi: mvm: use the new session protection command")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20201107104557.a317376154da.I44fa3637373ba4bd421cdff2cabc761bffc0735f@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 1babc4bb5194b..da52c1e433a29 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -985,10 +985,13 @@ void iwl_mvm_stop_roc(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 			IWL_UCODE_TLV_CAPA_SESSION_PROT_CMD)) {
 		mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
-		iwl_mvm_cancel_session_protection(mvm, mvmvif);
-
-		if (vif->type == NL80211_IFTYPE_P2P_DEVICE)
+		if (vif->type == NL80211_IFTYPE_P2P_DEVICE) {
+			iwl_mvm_cancel_session_protection(mvm, mvmvif);
 			set_bit(IWL_MVM_STATUS_NEED_FLUSH_P2P, &mvm->status);
+		} else {
+			iwl_mvm_remove_aux_roc_te(mvm, mvmvif,
+						  &mvmvif->time_event_data);
+		}
 
 		iwl_mvm_roc_finished(mvm);
 
-- 
2.27.0



