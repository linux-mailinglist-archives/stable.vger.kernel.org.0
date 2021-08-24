Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491123F6680
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235855AbhHXRZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:25:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240792AbhHXRWw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:22:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA0B661B20;
        Tue, 24 Aug 2021 17:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824618;
        bh=STu6EmJSyr+TC5u3aTnJoqMAz3TzLT6FgZlwWHu0qQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NhjU/czhoyl/N5sjxSdF6FcmTnbMuSdLIV8rmrbxKeuzHJCCMgi9nvxT8Uypd6SO7
         KAUfubrcpnl2wnOE0Yh/J+KvjNWfkSFmSnZYGifiymfGT41qCeshIGT24vIb0wpVaK
         vILL9XDzjkVlY5SCTH7p/aJ7qA0BKv+n6y7hlFECK2l6eNuuxJ9Wulsm0XQDLsHbBK
         cxvWnSfTRwzUOAMn86rpcI+JpR/ulAia2DGwoZhJuIGGC6UjSv0oGxPsgPvWy/dY6j
         V1WwW/e0IvsTysf86xeI3i0ucf3W7Z5SCaxfLSWJlpzdg77+gTMLSdYMxXbjs7uGES
         NO/R9LfoKLt1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jouni Malinen <jouni@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 48/84] ath: Modify ath_key_delete() to not need full key entry
Date:   Tue, 24 Aug 2021 13:02:14 -0400
Message-Id: <20210824170250.710392-49-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
Cc: Pali Rohár <pali@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath.h                |  2 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |  2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |  2 +-
 drivers/net/wireless/ath/ath9k/main.c         |  5 ++-
 drivers/net/wireless/ath/key.c                | 34 +++++++++----------
 5 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 9d18105c449f..f083fb9038c3 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -197,7 +197,7 @@ struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
 bool ath_is_mybeacon(struct ath_common *common, struct ieee80211_hdr *hdr);
 
 void ath_hw_setbssidmask(struct ath_common *common);
-void ath_key_delete(struct ath_common *common, struct ieee80211_key_conf *key);
+void ath_key_delete(struct ath_common *common, u8 hw_key_idx);
 int ath_key_config(struct ath_common *common,
 			  struct ieee80211_vif *vif,
 			  struct ieee80211_sta *sta,
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 16e052d02c94..0f4836fc3b7c 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -522,7 +522,7 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		}
 		break;
 	case DISABLE_KEY:
-		ath_key_delete(common, key);
+		ath_key_delete(common, key->hw_key_idx);
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index a82ad739ab80..16a7bae62b7d 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1460,7 +1460,7 @@ static int ath9k_htc_set_key(struct ieee80211_hw *hw,
 		}
 		break;
 	case DISABLE_KEY:
-		ath_key_delete(common, key);
+		ath_key_delete(common, key->hw_key_idx);
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4b0a3f042ca3..95cc581e3761 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1546,12 +1546,11 @@ static void ath9k_del_ps_key(struct ath_softc *sc,
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
@@ -1742,7 +1741,7 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 		}
 		break;
 	case DISABLE_KEY:
-		ath_key_delete(common, key);
+		ath_key_delete(common, key->hw_key_idx);
 		if (an) {
 			for (i = 0; i < ARRAY_SIZE(an->key_idx); i++) {
 				if (an->key_idx[i] != key->hw_key_idx)
diff --git a/drivers/net/wireless/ath/key.c b/drivers/net/wireless/ath/key.c
index cb266cf3c77c..61b59a804e30 100644
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
-- 
2.30.2

