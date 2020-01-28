Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D711614B692
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgA1OF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:05:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:52966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728254AbgA1OFY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:05:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 590F124691;
        Tue, 28 Jan 2020 14:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220322;
        bh=GJg9d1r4pYUfl27AEWO0u5jB0pOqYWZhP3ZhkRWf2ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lsv0WtS+z6cdmVnj6Ku5Arsa80eWY/FUNDGddrmsIrFdVXUzyBlcus37bDAW5CnoE
         lnJfiT6oUdw6J2J+gHfdFmlR6/nu0TJsa9K8Ri0rcsXCmf+R5jt6LYZOgiL7v31o7m
         nVLjyr9R+J1bVF66mgV+O2L/DdUV8MeFvCj8YLVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 5.4 081/104] iwlwifi: mvm: fix potential SKB leak on TXQ TX
Date:   Tue, 28 Jan 2020 15:00:42 +0100
Message-Id: <20200128135828.374903351@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit df2378ab0f2a9dd4cf4501268af1902cc4ebacd8 upstream.

When we transmit after TXQ dequeue, we aren't paying attention to
the return value of the transmit functions, leading to a potential
SKB leak.

Refactor the code a bit (and rename ..._tx to ..._tx_sta) to check
for this happening.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: cfbc6c4c5b91 ("iwlwifi: mvm: support mac80211 TXQs model")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |   28 ++++++++++++----------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |    4 +--
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       |    4 +--
 3 files changed, 20 insertions(+), 16 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -742,6 +742,20 @@ int iwl_mvm_mac_setup_register(struct iw
 	return ret;
 }
 
+static void iwl_mvm_tx_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
+			   struct ieee80211_sta *sta)
+{
+	if (likely(sta)) {
+		if (likely(iwl_mvm_tx_skb_sta(mvm, skb, sta) == 0))
+			return;
+	} else {
+		if (likely(iwl_mvm_tx_skb_non_sta(mvm, skb) == 0))
+			return;
+	}
+
+	ieee80211_free_txskb(mvm->hw, skb);
+}
+
 static void iwl_mvm_mac_tx(struct ieee80211_hw *hw,
 			   struct ieee80211_tx_control *control,
 			   struct sk_buff *skb)
@@ -785,14 +799,7 @@ static void iwl_mvm_mac_tx(struct ieee80
 		}
 	}
 
-	if (sta) {
-		if (iwl_mvm_tx_skb(mvm, skb, sta))
-			goto drop;
-		return;
-	}
-
-	if (iwl_mvm_tx_skb_non_sta(mvm, skb))
-		goto drop;
+	iwl_mvm_tx_skb(mvm, skb, sta);
 	return;
  drop:
 	ieee80211_free_txskb(hw, skb);
@@ -842,10 +849,7 @@ void iwl_mvm_mac_itxq_xmit(struct ieee80
 				break;
 			}
 
-			if (!txq->sta)
-				iwl_mvm_tx_skb_non_sta(mvm, skb);
-			else
-				iwl_mvm_tx_skb(mvm, skb, txq->sta);
+			iwl_mvm_tx_skb(mvm, skb, txq->sta);
 		}
 	} while (atomic_dec_return(&mvmtxq->tx_request));
 	rcu_read_unlock();
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1508,8 +1508,8 @@ int __must_check iwl_mvm_send_cmd_status
 int __must_check iwl_mvm_send_cmd_pdu_status(struct iwl_mvm *mvm, u32 id,
 					     u16 len, const void *data,
 					     u32 *status);
-int iwl_mvm_tx_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
-		   struct ieee80211_sta *sta);
+int iwl_mvm_tx_skb_sta(struct iwl_mvm *mvm, struct sk_buff *skb,
+		       struct ieee80211_sta *sta);
 int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb);
 void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 			struct iwl_tx_cmd *tx_cmd,
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1203,8 +1203,8 @@ drop:
 	return -1;
 }
 
-int iwl_mvm_tx_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
-		   struct ieee80211_sta *sta)
+int iwl_mvm_tx_skb_sta(struct iwl_mvm *mvm, struct sk_buff *skb,
+		       struct ieee80211_sta *sta)
 {
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct ieee80211_tx_info info;


