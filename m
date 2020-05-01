Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011371C13E9
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730063AbgEANeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:34:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729669AbgEANeD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:34:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD99B216FD;
        Fri,  1 May 2020 13:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340043;
        bh=44V4MZP//wPpF5aDYqpd6uzdLF+uO13EexkIAoMvYOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3NCLNIH9trs3F+RLJ4lveHmvakOAn5x5LrMPZFSVZIgKqepdNjCpJGKW7tNizWTb
         tZhg1wRRFcRj4BjmfCubz4puqoV/WRsMOzzyaSBph5w9+5Y9aBT7IWrT7fOL7Wt9pD
         BiNCJ2DTtXegWHdWtVHx9My4MkUNe8WTYgLNKLbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4.14 075/117] staging: vt6656: Fix pairwise key entry save.
Date:   Fri,  1 May 2020 15:21:51 +0200
Message-Id: <20200501131553.897491653@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
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
@@ -91,9 +91,6 @@ static int vnt_set_keymode(struct ieee80
 	case  VNT_KEY_PAIRWISE:
 		key_mode |= mode;
 		key_inx = 4;
-		/* Don't save entry for pairwise key for station mode */
-		if (priv->op_mode == NL80211_IFTYPE_STATION)
-			clear_bit(entry, &priv->key_entry_inuse);
 		break;
 	default:
 		return -EINVAL;
@@ -117,7 +114,6 @@ static int vnt_set_keymode(struct ieee80
 int vnt_set_keys(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 		 struct ieee80211_vif *vif, struct ieee80211_key_conf *key)
 {
-	struct ieee80211_bss_conf *conf = &vif->bss_conf;
 	struct vnt_private *priv = hw->priv;
 	u8 *mac_addr = NULL;
 	u8 key_dec_mode = 0;
@@ -159,16 +155,12 @@ int vnt_set_keys(struct ieee80211_hw *hw
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
@@ -827,8 +827,12 @@ static int vnt_set_key(struct ieee80211_
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


