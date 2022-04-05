Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A804F3773
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352975AbiDELN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349057AbiDEJtD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20050A94EC;
        Tue,  5 Apr 2022 02:39:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C721AB818F3;
        Tue,  5 Apr 2022 09:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FF6C385A2;
        Tue,  5 Apr 2022 09:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151564;
        bh=WuRlOwtrRvuEhnjGzamlA5fZhPSxTgvN2dXTvL/ROmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CIH4+l+QUQbQFXC8Ud9+pKBnKzIYvfPrEKuVxbd9cEsgrMHUghT6k0rZ15WCTvk+I
         Yr2tph9yxgNBOI0gF7Nz+8HPonbFaBMaAjqnC4H/jFWPmIreN4PkqagREc64WHbCYK
         xgrlMb33oQ4jB1opz7a+4wDuqx6BlXWeRBtJn61g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 462/913] iwlwifi: mvm: Dont call iwl_mvm_sta_from_mac80211() with NULL sta
Date:   Tue,  5 Apr 2022 09:25:24 +0200
Message-Id: <20220405070353.697190655@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 30d17c12b0895e15ce22ebc1f52a4ff02df6dbc6 ]

The recent fix for NULL sta in iwl_mvm_get_tx_rate() still has a call
of iwl_mvm_sta_from_mac80211() that may be called with NULL sta.
Although this practically only points to the address and the actual
access doesn't happen due to the conditional evaluation at a later
point, it looks a bit flaky.

This patch drops the temporary variable above and evaluates
iwm_mvm_sta_from_mac80211() directly for avoiding confusions.

Fixes: d599f714b73e ("iwlwifi: mvm: don't crash on invalid rate w/o STA")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20220121114024.10454-1-tiwai@suse.de
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 06fbd9ab37df..b5368cb57ca8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -271,15 +271,14 @@ static u32 iwl_mvm_get_tx_rate(struct iwl_mvm *mvm,
 
 	/* info->control is only relevant for non HW rate control */
 	if (!ieee80211_hw_check(mvm->hw, HAS_RATE_CONTROL)) {
-		struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
-
 		/* HT rate doesn't make sense for a non data frame */
 		WARN_ONCE(info->control.rates[0].flags & IEEE80211_TX_RC_MCS &&
 			  !ieee80211_is_data(fc),
 			  "Got a HT rate (flags:0x%x/mcs:%d/fc:0x%x/state:%d) for a non data frame\n",
 			  info->control.rates[0].flags,
 			  info->control.rates[0].idx,
-			  le16_to_cpu(fc), sta ? mvmsta->sta_state : -1);
+			  le16_to_cpu(fc),
+			  sta ? iwl_mvm_sta_from_mac80211(sta)->sta_state : -1);
 
 		rate_idx = info->control.rates[0].idx;
 	}
-- 
2.34.1



