Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0070040E48F
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244461AbhIPREm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:04:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347196AbhIPQ6O (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:58:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EE2260238;
        Thu, 16 Sep 2021 16:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809905;
        bh=6r3e4fFI0L1s1Y97K3IG8jSgzDA1fv8BgWIJ2Yf6GyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2KnPxA3BbH3yey+gYlC2D1cpp5sKv3FU0YZBQ++W9cmvwk7nB/sUs7xkL5w6IpKNQ
         8GNE5ycrdwKgQdLLu0dncyXeAaw51b6sNFyhPeRdDAHeZ/DU4r9oaWWKunxK02P7YD
         il7oVOHw5YsFdyur3yiZLcRos+CRYOxwUYMHWhcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 327/380] iwlwifi: mvm: Do not use full SSIDs in 6GHz scan
Date:   Thu, 16 Sep 2021 18:01:24 +0200
Message-Id: <20210916155815.172687528@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit deedf9b97cd4ef45da476c9bdd2a5f3276053956 ]

The scan request processing populated the direct SSIDs
in the FW scan request command also for 6GHz scan, which is not
needed and might result in unexpected behavior.

Fix the code to add the direct SSIDs only in case the scan
is not a 6GHz scan.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210802170640.f465937c7bbf.Ic11a1659ddda850c3ec1b1afbe9e2b9577ac1800@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 5a0696c44f6d..3627de2af344 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -2368,14 +2368,17 @@ static int iwl_mvm_scan_umac_v14(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (ret)
 		return ret;
 
-	iwl_mvm_scan_umac_fill_probe_p_v4(params, &scan_p->probe_params,
-					  &bitmap_ssid);
 	if (!params->scan_6ghz) {
+		iwl_mvm_scan_umac_fill_probe_p_v4(params, &scan_p->probe_params,
+					  &bitmap_ssid);
 		iwl_mvm_scan_umac_fill_ch_p_v6(mvm, params, vif,
-					       &scan_p->channel_params, bitmap_ssid);
+				       &scan_p->channel_params, bitmap_ssid);
 
 		return 0;
+	} else {
+		pb->preq = params->preq;
 	}
+
 	cp->flags = iwl_mvm_scan_umac_chan_flags_v2(mvm, params, vif);
 	cp->n_aps_override[0] = IWL_SCAN_ADWELL_N_APS_GO_FRIENDLY;
 	cp->n_aps_override[1] = IWL_SCAN_ADWELL_N_APS_SOCIAL_CHS;
-- 
2.30.2



