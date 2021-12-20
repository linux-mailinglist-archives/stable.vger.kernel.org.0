Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA0947AF23
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236642AbhLTPJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238809AbhLTPHi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:07:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15A6C0251BF;
        Mon, 20 Dec 2021 06:53:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57E2FB80EE2;
        Mon, 20 Dec 2021 14:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82199C36AE7;
        Mon, 20 Dec 2021 14:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012028;
        bh=lwtpI/L4Y8riqbQUOCFP+fBertkKSiBn5pWUU/W/Ae0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F7TJaAwB1nlDjwCazTATPNmKUYHCE1vy6NvOQIpGI4fQU84gTuw7qMY2aQZl7f/yT
         r63enRIC+Vc2/LGAFCeikQ1CvEaJjTq7Go3HaRk/gJGQxaR3uXbDlXJybi+9jq9rlz
         H8LA5ocROu6Ms8qnHphEY9ztBtdsm2EnF0JAk2OM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/177] iwlwifi: mvm: dont crash on invalid rate w/o STA
Date:   Mon, 20 Dec 2021 15:33:24 +0100
Message-Id: <20211220143041.915605439@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit d599f714b73e4177dfdfe64fce09175568288ee9 ]

If we get to the WARN_ONCE(..., "Got a HT rate (...)", ...)
here with a NULL sta, then we crash because mvmsta is bad
and we try to dereference it. Fix that by printing -1 as the
state if no station was given.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: 6761a718263a ("iwlwifi: mvm: add explicit check for non-data frames in get Tx rate")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/iwlwifi.20211203140410.1a1541d7dcb5.I606c746e11447fe168cf046376b70b04e278c3b4@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 0a13c2bda2eed..06fbd9ab37dfe 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -268,17 +268,18 @@ static u32 iwl_mvm_get_tx_rate(struct iwl_mvm *mvm,
 	int rate_idx = -1;
 	u8 rate_plcp;
 	u32 rate_flags = 0;
-	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 
 	/* info->control is only relevant for non HW rate control */
 	if (!ieee80211_hw_check(mvm->hw, HAS_RATE_CONTROL)) {
+		struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+
 		/* HT rate doesn't make sense for a non data frame */
 		WARN_ONCE(info->control.rates[0].flags & IEEE80211_TX_RC_MCS &&
 			  !ieee80211_is_data(fc),
 			  "Got a HT rate (flags:0x%x/mcs:%d/fc:0x%x/state:%d) for a non data frame\n",
 			  info->control.rates[0].flags,
 			  info->control.rates[0].idx,
-			  le16_to_cpu(fc), mvmsta->sta_state);
+			  le16_to_cpu(fc), sta ? mvmsta->sta_state : -1);
 
 		rate_idx = info->control.rates[0].idx;
 	}
-- 
2.33.0



