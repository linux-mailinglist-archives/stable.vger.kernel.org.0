Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC48411B2D
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242177AbhITQ4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:56:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245516AbhITQy0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:54:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D852161373;
        Mon, 20 Sep 2021 16:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156628;
        bh=1Mzq7GtmPOJs714ldYG4glrDb6q62kmt8paZjPd0OvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Uc6mCN3rXcupY1LJtO6uJ3F+Ft2G251jCuThL01ZbT72LCuWp3uxEiQet/4ie9m1
         PJcbyjBvK8joAhFF73w+2ZDOFAqlWth2N7nSiybqMZYYhCOrjc7QtIe6RExrkiGvtr
         03u5Yp+e/w6FIPAhFjt0za0tiock8Zn05cQRmJ90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jouni Malinen <jouni@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.9 013/175] ath: Modify ath_key_delete() to not need full key entry
Date:   Mon, 20 Sep 2021 18:41:02 +0200
Message-Id: <20210920163918.502776595@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jouni Malinen <jouni@codeaurora.org>

commit 144cd24dbc36650a51f7fe3bf1424a1432f1f480 upstream.

tkip_keymap can be used internally to avoid the reference to key->cipher
and with this, only the key index value itself is needed. This allows
ath_key_delete() call to be postponed to be handled after the upper
layer STA and key entry have already been removed. This is needed to
make ath9k key cache management safer.

Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201214172118.18100-5-jouni@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath.h                |    2 -
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |    2 -
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    2 -
 drivers/net/wireless/ath/ath9k/main.c         |    5 +--
 drivers/net/wireless/ath/key.c                |   34 +++++++++++++-------------
 5 files changed, 22 insertions(+), 23 deletions(-)

--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -199,7 +199,7 @@ struct sk_buff *ath_rxbuf_alloc(struct a
 bool ath_is_mybeacon(struct ath_common *common, struct ieee80211_hdr *hdr);
 
 void ath_hw_setbssidmask(struct ath_common *common);
-void ath_key_delete(struct ath_common *common, struct ieee80211_key_conf *key);
+void ath_key_delete(struct ath_common *common, u8 hw_key_idx);
 int ath_key_config(struct ath_common *common,
 			  struct ieee80211_vif *vif,
 			  struct ieee80211_sta *sta,
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -522,7 +522,7 @@ ath5k_set_key(struct ieee80211_hw *hw, e
 		}
 		break;
 	case DISABLE_KEY:
-		ath_key_delete(common, key);
+		ath_key_delete(common, key->hw_key_idx);
 		break;
 	default:
 		ret = -EINVAL;
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1460,7 +1460,7 @@ static int ath9k_htc_set_key(struct ieee
 		}
 		break;
 	case DISABLE_KEY:
-		ath_key_delete(common, key);
+		ath_key_delete(common, key->hw_key_idx);
 		break;
 	default:
 		ret = -EINVAL;
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1544,12 +1544,11 @@ static void ath9k_del_ps_key(struct ath_
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_node *an = (struct ath_node *) sta->drv_priv;
-	struct ieee80211_key_conf ps_key = { .hw_key_idx = an->ps_key };
 
 	if (!an->ps_key)
 	    return;
 
-	ath_key_delete(common, &ps_key);
+	ath_key_delete(common, an->ps_key);
 	an->ps_key = 0;
 	an->key_idx[0] = 0;
 }
@@ -1740,7 +1739,7 @@ static int ath9k_set_key(struct ieee8021
 		}
 		break;
 	case DISABLE_KEY:
-		ath_key_delete(common, key);
+		ath_key_delete(common, key->hw_key_idx);
 		if (an) {
 			for (i = 0; i < ARRAY_SIZE(an->key_idx); i++) {
 				if (an->key_idx[i] != key->hw_key_idx)
--- a/drivers/net/wireless/ath/key.c
+++ b/drivers/net/wireless/ath/key.c
@@ -581,38 +581,38 @@ EXPORT_SYMBOL(ath_key_config);
 /*
  * Delete Key.
  */
-void ath_key_delete(struct ath_common *common, struct ieee80211_key_conf *key)
+void ath_key_delete(struct ath_common *common, u8 hw_key_idx)
 {
 	/* Leave CCMP and TKIP (main key) configured to avoid disabling
 	 * encryption for potentially pending frames already in a TXQ with the
 	 * keyix pointing to this key entry. Instead, only clear the MAC address
 	 * to prevent RX processing from using this key cache entry.
 	 */
-	if (test_bit(key->hw_key_idx, common->ccmp_keymap) ||
-	    test_bit(key->hw_key_idx, common->tkip_keymap))
-		ath_hw_keysetmac(common, key->hw_key_idx, NULL);
+	if (test_bit(hw_key_idx, common->ccmp_keymap) ||
+	    test_bit(hw_key_idx, common->tkip_keymap))
+		ath_hw_keysetmac(common, hw_key_idx, NULL);
 	else
-		ath_hw_keyreset(common, key->hw_key_idx);
-	if (key->hw_key_idx < IEEE80211_WEP_NKID)
+		ath_hw_keyreset(common, hw_key_idx);
+	if (hw_key_idx < IEEE80211_WEP_NKID)
 		return;
 
-	clear_bit(key->hw_key_idx, common->keymap);
-	clear_bit(key->hw_key_idx, common->ccmp_keymap);
-	if (key->cipher != WLAN_CIPHER_SUITE_TKIP)
+	clear_bit(hw_key_idx, common->keymap);
+	clear_bit(hw_key_idx, common->ccmp_keymap);
+	if (!test_bit(hw_key_idx, common->tkip_keymap))
 		return;
 
-	clear_bit(key->hw_key_idx + 64, common->keymap);
+	clear_bit(hw_key_idx + 64, common->keymap);
 
-	clear_bit(key->hw_key_idx, common->tkip_keymap);
-	clear_bit(key->hw_key_idx + 64, common->tkip_keymap);
+	clear_bit(hw_key_idx, common->tkip_keymap);
+	clear_bit(hw_key_idx + 64, common->tkip_keymap);
 
 	if (!(common->crypt_caps & ATH_CRYPT_CAP_MIC_COMBINED)) {
-		ath_hw_keyreset(common, key->hw_key_idx + 32);
-		clear_bit(key->hw_key_idx + 32, common->keymap);
-		clear_bit(key->hw_key_idx + 64 + 32, common->keymap);
+		ath_hw_keyreset(common, hw_key_idx + 32);
+		clear_bit(hw_key_idx + 32, common->keymap);
+		clear_bit(hw_key_idx + 64 + 32, common->keymap);
 
-		clear_bit(key->hw_key_idx + 32, common->tkip_keymap);
-		clear_bit(key->hw_key_idx + 64 + 32, common->tkip_keymap);
+		clear_bit(hw_key_idx + 32, common->tkip_keymap);
+		clear_bit(hw_key_idx + 64 + 32, common->tkip_keymap);
 	}
 }
 EXPORT_SYMBOL(ath_key_delete);


