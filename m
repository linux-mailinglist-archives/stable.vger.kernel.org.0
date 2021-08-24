Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00FA3F658A
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240023AbhHXROE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:14:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239522AbhHXRMB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:12:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F08BD61458;
        Tue, 24 Aug 2021 17:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824474;
        bh=89j2RX1N6mkV6tZV1uRCiEyXfNlx2+Ll2i47s4fEzxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QSZTCl9ftOTJ1e/xtFekqXZZWHCU0+KeucvSzK3dRgWM78Jb639BXVat/LqFSvzVx
         IlcOxbXADNvGbtmyGNHVk0GRB8iO7cqE0j0W3U1Cu8PG4M3Vy41SSGGrMnkjLGtUZW
         q6rCtAVm54pThU05UhG8TY63SN1/jtbyX7gIcOOfQeyMQEJ/q/D9wct32GWADxjTDJ
         sz6DI8SCpZUc2G5dn5oiIW8Ijwzjo1w9tuR2jtthPMwZwHikdfYESyGUNlQe2Hayti
         xi7h7qFmn9Y/364xGQAUE+w5yFCeKLMMa+0f+Y9idm1hL2vXkpQcpxu3L+jaDScqRN
         G17BZgxpU64PA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jouni Malinen <jouni@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 06/61] ath: Modify ath_key_delete() to not need full key entry
Date:   Tue, 24 Aug 2021 13:00:11 -0400
Message-Id: <20210824170106.710221-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170106.710221-1-sashal@kernel.org>
References: <20210824170106.710221-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.143-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.143-rc1
X-KernelTest-Deadline: 2021-08-26T17:01+00:00
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
index 5e866a193ed0..d065600791c1 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -521,7 +521,7 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
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
index eae7b7e58429..c08a7202dca2 100644
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

