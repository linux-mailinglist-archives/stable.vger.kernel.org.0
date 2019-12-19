Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 758061269EC
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbfLSSm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:42:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:33574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728689AbfLSSmY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:42:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E070206D7;
        Thu, 19 Dec 2019 18:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780943;
        bh=37yc1Ll2VyvZsvS1gIM+11ozImq9oF0/2JBK7fXSbuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BeESasOIlibBiqC15iWrCsnDMhcXcIEXMewYp9l+ouLs/egktEBC0GaJZAP0eWRrz
         vHanaox6JWiFle2kc1lI5WBbZEQSyOa7xCXJbGKwjIprerrg75lKfmbK4iUC4+nKM3
         8GSWFYWiaxr+GzLsgfblAsqSG47XNAHZQ1rWtAhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 019/199] iwlwifi: mvm: Send non offchannel traffic via AP sta
Date:   Thu, 19 Dec 2019 19:31:41 +0100
Message-Id: <20191219183215.856711877@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

[ Upstream commit dc1aca22f8f38b7e2ad7b118db87404d11e68771 ]

TDLS discovery response frame is a unicast direct frame to the peer.
Since we don't have a STA for this peer, this frame goes through
iwl_tx_skb_non_sta(). As the result aux_sta and some completely
arbitrary queue would be selected for this frame, resulting in a queue
hang.  Fix that by sending such frames through AP sta instead.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 92557cd31a397..d91ab2b8d6671 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -805,6 +805,21 @@ static void iwl_mvm_mac_tx(struct ieee80211_hw *hw,
 		     !ieee80211_is_action(hdr->frame_control)))
 		sta = NULL;
 
+	/* If there is no sta, and it's not offchannel - send through AP */
+	if (info->control.vif->type == NL80211_IFTYPE_STATION &&
+	    info->hw_queue != IWL_MVM_OFFCHANNEL_QUEUE && !sta) {
+		struct iwl_mvm_vif *mvmvif =
+			iwl_mvm_vif_from_mac80211(info->control.vif);
+		u8 ap_sta_id = READ_ONCE(mvmvif->ap_sta_id);
+
+		if (ap_sta_id < IWL_MVM_STATION_COUNT) {
+			/* mac80211 holds rcu read lock */
+			sta = rcu_dereference(mvm->fw_id_to_mac_id[ap_sta_id]);
+			if (IS_ERR_OR_NULL(sta))
+				goto drop;
+		}
+	}
+
 	if (sta) {
 		if (iwl_mvm_defer_tx(mvm, sta, skb))
 			return;
-- 
2.20.1



