Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407123C4BAD
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239795AbhGLG6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:58:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239662AbhGLG6J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:58:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2575961004;
        Mon, 12 Jul 2021 06:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072911;
        bh=TdbwWf8n7PchFOwJ9TV/tdbvKG9kcmqkVMKqSn9mlf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nx4DG3rJXPFAB/Q/Y12AB0tryGy9gNcKo1IeSKXbmlm3yOar7m/qyhcb9DzyoWreR
         y2jANEPEzeFnDGEEspTwEuOVC2mIuUwUR6JJGxTQRD7ireKZS5MMKduwnW11doBlWj
         06Uk++A4DNafrrbibbPxvx2Kk4UNuSy+Eab/VHRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.12 062/700] mac80211: remove iwlwifi specific workaround that broke sta NDP tx
Date:   Mon, 12 Jul 2021 08:02:25 +0200
Message-Id: <20210712060933.494375101@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

commit e41eb3e408de27982a5f8f50b2dd8002bed96908 upstream.

Sending nulldata packets is important for sw AP link probing and detecting
4-address mode links. The checks that dropped these packets were apparently
added to work around an iwlwifi firmware bug with multi-TID aggregation.

Fixes: 41cbb0f5a295 ("mac80211: add support for HE")
Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20210619101517.90806-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c |    3 +++
 net/mac80211/mlme.c                         |    9 ---------
 2 files changed, 3 insertions(+), 9 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1032,6 +1032,9 @@ static int iwl_mvm_tx_mpdu(struct iwl_mv
 	if (WARN_ON_ONCE(mvmsta->sta_id == IWL_MVM_INVALID_STA))
 		return -1;
 
+	if (unlikely(ieee80211_is_any_nullfunc(fc)) && sta->he_cap.has_he)
+		return -1;
+
 	if (unlikely(ieee80211_is_probe_resp(fc)))
 		iwl_mvm_probe_resp_set_noa(mvm, skb);
 
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1094,11 +1094,6 @@ void ieee80211_send_nullfunc(struct ieee
 	struct ieee80211_hdr_3addr *nullfunc;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
-	/* Don't send NDPs when STA is connected HE */
-	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
-	    !(ifmgd->flags & IEEE80211_STA_DISABLE_HE))
-		return;
-
 	skb = ieee80211_nullfunc_get(&local->hw, &sdata->vif,
 		!ieee80211_hw_check(&local->hw, DOESNT_SUPPORT_QOS_NDP));
 	if (!skb)
@@ -1130,10 +1125,6 @@ static void ieee80211_send_4addr_nullfun
 	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION))
 		return;
 
-	/* Don't send NDPs when connected HE */
-	if (!(sdata->u.mgd.flags & IEEE80211_STA_DISABLE_HE))
-		return;
-
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom + 30);
 	if (!skb)
 		return;


