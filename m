Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6D84F3544
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242891AbiDEJiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242091AbiDEJHe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:07:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AC553A5A;
        Tue,  5 Apr 2022 01:56:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF60561574;
        Tue,  5 Apr 2022 08:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D66C385A1;
        Tue,  5 Apr 2022 08:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148993;
        bh=DjFW1lrQlmsuzivQOKwibklUM5SrWybqRkEPZWtbFdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y3H6wzOijD/6SUAXkz9VFzQS3QaHZpeKkZ3VY2AsdxmvzM/p41A0WuLowwMwYq6fv
         x4H+0zsb8c97ggc+gEXFzmJmrcz3ywd5z/jg97HmVi1s7f290GTPJ8CviKILQbeK7o
         SmG5hcYPCk4OxpBH85aSBOMJ2yyeETDDzGcEKlXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0508/1017] iwlwifi: mvm: Dont call iwl_mvm_sta_from_mac80211() with NULL sta
Date:   Tue,  5 Apr 2022 09:23:41 +0200
Message-Id: <20220405070409.379668707@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index 0f96d422d6e0..bbd394a7b531 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -272,15 +272,14 @@ static u32 iwl_mvm_get_tx_rate(struct iwl_mvm *mvm,
 
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



