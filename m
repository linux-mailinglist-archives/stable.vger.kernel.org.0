Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE624101549
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729601AbfKSFm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:42:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:37188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729307AbfKSFm2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:42:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 715FC21783;
        Tue, 19 Nov 2019 05:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142146;
        bh=9YlaCXaWA3dweQyNoIt/1+CUs8RUr1Fzrhp45ngREL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oFbx/34kIXkm0azgE9K2zFel3E9TI8taWWE8fczg9APueNF3okwy/v4vKDvvN2XBe
         FplWwa17TCGeLZnIYEGFnZqYp3hMUlJj/4EpXhFR/2NIkykhK7dlMzZc4/iuD+/YkL
         o2TeIWIFLo0MODW1NldMlx2lbvnQ+22mnERYexoc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 397/422] iwlwifi: mvm: use correct FIFO length
Date:   Tue, 19 Nov 2019 06:19:54 +0100
Message-Id: <20191119051424.858935021@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

[ Upstream commit 7126b6f2bbdf8e25f85e7ca6d91d49ea4ce9f6a6 ]

Current FIFO size calculation is wrong for two reasons:
- We access lmac 0 by default
- We don't take 11ax into consideration.
Fix both.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  4 ++
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   | 47 +++++++++++++------
 2 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index b3fd20502abb3..d90d58309bf0e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -85,6 +85,10 @@ const u8 iwl_mvm_ac_to_gen2_tx_fifo[] = {
 	IWL_GEN2_EDCA_TX_FIFO_VI,
 	IWL_GEN2_EDCA_TX_FIFO_BE,
 	IWL_GEN2_EDCA_TX_FIFO_BK,
+	IWL_GEN2_TRIG_TX_FIFO_VO,
+	IWL_GEN2_TRIG_TX_FIFO_VI,
+	IWL_GEN2_TRIG_TX_FIFO_BE,
+	IWL_GEN2_TRIG_TX_FIFO_BK,
 };
 
 struct iwl_mvm_mac_iface_iterator_data {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index cb2e52e7f46c9..449e3d32811a6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -778,6 +778,36 @@ iwl_mvm_tx_tso_segment(struct sk_buff *skb, unsigned int num_subframes,
 	return 0;
 }
 
+static unsigned int iwl_mvm_max_amsdu_size(struct iwl_mvm *mvm,
+					   struct ieee80211_sta *sta,
+					   unsigned int tid)
+{
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	enum nl80211_band band = mvmsta->vif->bss_conf.chandef.chan->band;
+	u8 ac = tid_to_mac80211_ac[tid];
+	unsigned int txf;
+	int lmac = IWL_LMAC_24G_INDEX;
+
+	if (iwl_mvm_is_cdb_supported(mvm) &&
+	    band == NL80211_BAND_5GHZ)
+		lmac = IWL_LMAC_5G_INDEX;
+
+	/* For HE redirect to trigger based fifos */
+	if (sta->he_cap.has_he && !WARN_ON(!iwl_mvm_has_new_tx_api(mvm)))
+		ac += 4;
+
+	txf = iwl_mvm_mac_ac_to_tx_fifo(mvm, ac);
+
+	/*
+	 * Don't send an AMSDU that will be longer than the TXF.
+	 * Add a security margin of 256 for the TX command + headers.
+	 * We also want to have the start of the next packet inside the
+	 * fifo to be able to send bursts.
+	 */
+	return min_t(unsigned int, mvmsta->max_amsdu_len,
+		     mvm->fwrt.smem_cfg.lmac[lmac].txfifo_size[txf] - 256);
+}
+
 static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 			  struct ieee80211_tx_info *info,
 			  struct ieee80211_sta *sta,
@@ -790,7 +820,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	u16 snap_ip_tcp, pad;
 	unsigned int dbg_max_amsdu_len;
 	netdev_features_t netdev_flags = NETIF_F_CSUM_MASK | NETIF_F_SG;
-	u8 tid, txf;
+	u8 tid;
 
 	snap_ip_tcp = 8 + skb_transport_header(skb) - skb_network_header(skb) +
 		tcp_hdrlen(skb);
@@ -829,20 +859,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	    !(mvmsta->amsdu_enabled & BIT(tid)))
 		return iwl_mvm_tx_tso_segment(skb, 1, netdev_flags, mpdus_skb);
 
-	max_amsdu_len = mvmsta->max_amsdu_len;
-
-	/* the Tx FIFO to which this A-MSDU will be routed */
-	txf = iwl_mvm_mac_ac_to_tx_fifo(mvm, tid_to_mac80211_ac[tid]);
-
-	/*
-	 * Don't send an AMSDU that will be longer than the TXF.
-	 * Add a security margin of 256 for the TX command + headers.
-	 * We also want to have the start of the next packet inside the
-	 * fifo to be able to send bursts.
-	 */
-	max_amsdu_len = min_t(unsigned int, max_amsdu_len,
-			      mvm->fwrt.smem_cfg.lmac[0].txfifo_size[txf] -
-			      256);
+	max_amsdu_len = iwl_mvm_max_amsdu_size(mvm, sta, tid);
 
 	if (unlikely(dbg_max_amsdu_len))
 		max_amsdu_len = min_t(unsigned int, max_amsdu_len,
-- 
2.20.1



