Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 183DE9E0DB
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbfH0IGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:06:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732631AbfH0IGd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:06:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6A0F206BA;
        Tue, 27 Aug 2019 08:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893192;
        bh=OIe/wroEzpaMimFv7ZOZMYrElK5ZIJxrJrRl2erMmB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i2lSH2uT4xbHVPYByoAUYuT9uRZITIWcj9UqgJVTFrpPbJEDPYNxjsiAx/vLu6bBV
         UfWgjGBQne8xGYhIluQB2MqmYwX+xGWawtFHeKdE6Y42CdBe8xcLnHvpl5m19nxjJJ
         t6JgpVKR7Cnqns9zEW+TUAAOT8zV4mFctT08iiXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 110/162] iwlwifi: mvm: disable TX-AMSDU on older NICs
Date:   Tue, 27 Aug 2019 09:50:38 +0200
Message-Id: <20190827072742.178747481@linuxfoundation.org>
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

[ Upstream commit cfb21b11b891b08b79be07be57c40a85bb926668 ]

On older NICs, we occasionally see issues with A-MSDU support,
where the commands in the FIFO get confused and then we see an
assert EDC because the next command in the FIFO isn't TX.

We've tried to isolate this issue and understand where it comes
from, but haven't found any errors in building the A-MSDU in
software.

At least for now, disable A-MSDU support on older hardware so
that users can use it again without fearing the assert.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=203315.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index edffae3741e00..a6183281ee1e1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -474,7 +474,19 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	ieee80211_hw_set(hw, SUPPORTS_VHT_EXT_NSS_BW);
 	ieee80211_hw_set(hw, BUFF_MMPDU_TXQ);
 	ieee80211_hw_set(hw, STA_MMPDU_TXQ);
-	ieee80211_hw_set(hw, TX_AMSDU);
+	/*
+	 * On older devices, enabling TX A-MSDU occasionally leads to
+	 * something getting messed up, the command read from the FIFO
+	 * gets out of sync and isn't a TX command, so that we have an
+	 * assert EDC.
+	 *
+	 * It's not clear where the bug is, but since we didn't used to
+	 * support A-MSDU until moving the mac80211 iTXQs, just leave it
+	 * for older devices. We also don't see this issue on any newer
+	 * devices.
+	 */
+	if (mvm->cfg->device_family >= IWL_DEVICE_FAMILY_9000)
+		ieee80211_hw_set(hw, TX_AMSDU);
 	ieee80211_hw_set(hw, TX_FRAG_LIST);
 
 	if (iwl_mvm_has_tlc_offload(mvm)) {
-- 
2.20.1



