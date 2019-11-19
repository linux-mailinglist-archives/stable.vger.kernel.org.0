Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B820A1016A6
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732260AbfKSFzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:55:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:53678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732257AbfKSFzR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:55:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C0B0208C3;
        Tue, 19 Nov 2019 05:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142917;
        bh=qX0frf5V4JFJGYGpyYcZ1RuX4317DQq5x9AahDUvJEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uGfogVgKOOUoPpLYLXDuiJc6bhmib7uHLZ1prm99QBkFokMpL4DuQSPwW+FhT1KWC
         cq0n7P50ri66QUk7eirsFkyBKQ1KFMjYN2LVTufFXswwTKnZ2JY7bcIK2xRS85hm77
         3ArvbwB+2i0pzMnCAbDWsd+PwFv0X8zYL65NZMlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 219/239] iwlwifi: mvm: Allow TKIP for AP mode
Date:   Tue, 19 Nov 2019 06:20:19 +0100
Message-Id: <20191119051339.369443621@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 6f3df8c1192c873a6ad9a76328920f6f85af90a8 ]

Support for setting keys for TKIP cipher suite was mistakenly removed
for AP mode. Fix this.

Fixes: 85aeb58cec1a ("iwlwifi: mvm: Enable security on new TX API")
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index d31d84eebc5d0..d16e2ed4419fe 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -3067,10 +3067,6 @@ static int __iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 
 	switch (keyconf->cipher) {
 	case WLAN_CIPHER_SUITE_TKIP:
-		if (vif->type == NL80211_IFTYPE_AP) {
-			ret = -EINVAL;
-			break;
-		}
 		addr = iwl_mvm_get_mac_addr(mvm, vif, sta);
 		/* get phase 1 key from mac80211 */
 		ieee80211_get_key_rx_seq(keyconf, 0, &seq);
-- 
2.20.1



