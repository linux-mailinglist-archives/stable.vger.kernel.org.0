Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E611BCA03
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731522AbgD1Sox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:44:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730788AbgD1Sow (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:44:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC2102137B;
        Tue, 28 Apr 2020 18:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099491;
        bh=ZXxlLXot414EDHihifIljWOjv3p9nYRitp0q9iYYUfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bj49/1/0+dB//pSwQXAIIzjIY47DVhefsgfDWcDPsehM0n2d1EO3dqwKvEBKmYBU1
         wmNo0PIuRkga6atIShjJdAzvn/8X5+RJmiDJAr2OOEiV71xUxKNahgk30QsK6u6tb9
         sypTsYDn4dJoBbooHm/tk3mR6VGagfFLlfa+3BdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5.4 143/168] staging: vt6656: Fix pairwise key entry save.
Date:   Tue, 28 Apr 2020 20:25:17 +0200
Message-Id: <20200428182249.782846027@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 0b59f10b1d8fe8d50944f21f5d403df9303095a8 upstream.

The problem is that the group key was saved as VNT_KEY_DEFAULTKEY
was over written by the VNT_KEY_GROUP_ADDRESS index.

mac80211 could not clear the mac_addr in the default key.

The VNT_KEY_DEFAULTKEY is not necesscary so remove it and set as
VNT_KEY_GROUP_ADDRESS.

mac80211 can clear any key using vnt_mac_disable_keyentry.

Fixes: f9ef05ce13e4 ("staging: vt6656: Fix pairwise key for non station modes")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Link: https://lore.kernel.org/r/da2f7e7f-1658-1320-6eee-0f55770ca391@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6656/key.c      |   14 +++-----------
 drivers/staging/vt6656/main_usb.c |    6 +++++-
 2 files changed, 8 insertions(+), 12 deletions(-)

--- a/drivers/staging/vt6656/key.c
+++ b/drivers/staging/vt6656/key.c
@@ -83,9 +83,6 @@ static int vnt_set_keymode(struct ieee80
 	case  VNT_KEY_PAIRWISE:
 		key_mode |= mode;
 		key_inx = 4;
-		/* Don't save entry for pairwise key for station mode */
-		if (priv->op_mode == NL80211_IFTYPE_STATION)
-			clear_bit(entry, &priv->key_entry_inuse);
 		break;
 	default:
 		return -EINVAL;
@@ -109,7 +106,6 @@ static int vnt_set_keymode(struct ieee80
 int vnt_set_keys(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 		 struct ieee80211_vif *vif, struct ieee80211_key_conf *key)
 {
-	struct ieee80211_bss_conf *conf = &vif->bss_conf;
 	struct vnt_private *priv = hw->priv;
 	u8 *mac_addr = NULL;
 	u8 key_dec_mode = 0;
@@ -151,16 +147,12 @@ int vnt_set_keys(struct ieee80211_hw *hw
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 	}
 
-	if (key->flags & IEEE80211_KEY_FLAG_PAIRWISE) {
+	if (key->flags & IEEE80211_KEY_FLAG_PAIRWISE)
 		vnt_set_keymode(hw, mac_addr, key, VNT_KEY_PAIRWISE,
 				key_dec_mode, true);
-	} else {
-		vnt_set_keymode(hw, mac_addr, key, VNT_KEY_DEFAULTKEY,
+	else
+		vnt_set_keymode(hw, mac_addr, key, VNT_KEY_GROUP_ADDRESS,
 				key_dec_mode, true);
 
-		vnt_set_keymode(hw, (u8 *)conf->bssid, key,
-				VNT_KEY_GROUP_ADDRESS, key_dec_mode, true);
-	}
-
 	return 0;
 }
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -866,8 +866,12 @@ static int vnt_set_key(struct ieee80211_
 			return -EOPNOTSUPP;
 		break;
 	case DISABLE_KEY:
-		if (test_bit(key->hw_key_idx, &priv->key_entry_inuse))
+		if (test_bit(key->hw_key_idx, &priv->key_entry_inuse)) {
 			clear_bit(key->hw_key_idx, &priv->key_entry_inuse);
+
+			vnt_mac_disable_keyentry(priv, key->hw_key_idx);
+		}
+
 	default:
 		break;
 	}


