Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F921AF507
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 23:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgDRVBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 17:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726459AbgDRVBz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Apr 2020 17:01:55 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DC5C061A0C;
        Sat, 18 Apr 2020 14:01:53 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id r26so6870669wmh.0;
        Sat, 18 Apr 2020 14:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Tew4LyoxzA+8ILWEXdL0lFb7J9u5PLFyT03YNQBKChg=;
        b=F8r8Z8+lxpoNLyuAFsfsg/0P0LI6N6cu6MGEi+HuAs5pInsvLfGjMGBnY39BE2sfl6
         W3uks9BewWlC/Wa812eMmggSnb+xLWPWOOkD0DAJQLd9/xd21lX14Twl5MgJUd2kmWMT
         zV+JU0dH4WujxA3EZRQU9Vr8w6RQhVGoFL0xz9htv9w4ME4johhT6u+116e7ZaEytr+Z
         OAqG2TlScZDItFPEnmvtTxXLp+jkFuA7BbAw8xDUKgIE56zX9A2g4RB2Y9OHRgQM0GFz
         T2QY7vQgkMXMyRAruvF98+Agv2xSD3KA/52l1Kxft9mB53a/+RuwED4SJG3YNiNaS76X
         CfQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Tew4LyoxzA+8ILWEXdL0lFb7J9u5PLFyT03YNQBKChg=;
        b=IUkBjnaI4ng0DS6JdFXKzH1Chs+UO/pfqAEu7AAFb4ZEuNNXYs343APeDWHtl0sb+a
         9rDWo2D4MckUmo7LKKM4VGNIEAp0eltc0xvfqofAqv6Y1yE8qKlfJ7GpK/SDWrAqeQoJ
         gqvziq44DYhJqN56W3rGCpr4YpTzSEMF7ULrbhJP8HlIsS9DvLqyE+0M+wM+eFo1kqfF
         m1vmhWue+QcfciHnW3Jqk+foszBhxWLH48bvYvOXYxlx21cLiuj91ws/SB24Lywdv5Oc
         OAk+ygqiNs6kOUhozg9iRyXMcgeiZ/Z14oxDl6a5q5dwxZPfkDF7yM/meNY+zwrqN+49
         wExA==
X-Gm-Message-State: AGi0PuaZLO0VlXHvA1i6HJUGznQYdjpB4zPy78YkX/daCzloJ+MONT30
        ESDYPLTq1ICrCyxSzaYDMerw+FDb
X-Google-Smtp-Source: APiQypLFblHzAOCz0/khHHmy6cToLYeZ5WeBveLHvJcfFrR5yZ9CgZGiiMJOSVDVvvmc8m7wruks1w==
X-Received: by 2002:a1c:6787:: with SMTP id b129mr10170101wmc.165.1587243712068;
        Sat, 18 Apr 2020 14:01:52 -0700 (PDT)
Received: from [192.168.43.18] (188.29.165.57.threembb.co.uk. [188.29.165.57])
        by smtp.gmail.com with ESMTPSA id 17sm12834027wmo.2.2020.04.18.14.01.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 14:01:51 -0700 (PDT)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        linux-wireless@vger.kernel.org,
        Oscar Carter <oscar.carter@gmx.com>, stable@vger.kernel.org
From:   Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH] staging: vt6656: Fix pairwise key entry save.
Message-ID: <da2f7e7f-1658-1320-6eee-0f55770ca391@gmail.com>
Date:   Sat, 18 Apr 2020 22:01:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The problem is that the group key was saved as VNT_KEY_DEFAULTKEY
was over written by the VNT_KEY_GROUP_ADDRESS index.

mac80211 could not clear the mac_addr in the default key.

The VNT_KEY_DEFAULTKEY is not necesscary so remove it and set as
VNT_KEY_GROUP_ADDRESS.

mac80211 can clear any key using vnt_mac_disable_keyentry.
 
Fixes: f9ef05ce13e4 ("staging: vt6656: Fix pairwise key for non station modes")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/key.c      | 14 +++-----------
 drivers/staging/vt6656/main_usb.c |  6 +++++-
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/vt6656/key.c b/drivers/staging/vt6656/key.c
index 41b73f9670e2..ac3b188984d0 100644
--- a/drivers/staging/vt6656/key.c
+++ b/drivers/staging/vt6656/key.c
@@ -83,9 +83,6 @@ static int vnt_set_keymode(struct ieee80211_hw *hw, u8 *mac_addr,
 	case  VNT_KEY_PAIRWISE:
 		key_mode |= mode;
 		key_inx = 4;
-		/* Don't save entry for pairwise key for station mode */
-		if (priv->op_mode == NL80211_IFTYPE_STATION)
-			clear_bit(entry, &priv->key_entry_inuse);
 		break;
 	default:
 		return -EINVAL;
@@ -109,7 +106,6 @@ static int vnt_set_keymode(struct ieee80211_hw *hw, u8 *mac_addr,
 int vnt_set_keys(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 		 struct ieee80211_vif *vif, struct ieee80211_key_conf *key)
 {
-	struct ieee80211_bss_conf *conf = &vif->bss_conf;
 	struct vnt_private *priv = hw->priv;
 	u8 *mac_addr = NULL;
 	u8 key_dec_mode = 0;
@@ -154,16 +150,12 @@ int vnt_set_keys(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 		return -EOPNOTSUPP;
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
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 85d4133315b1..b9e809ccd264 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -847,8 +847,12 @@ static int vnt_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	case SET_KEY:
 		return vnt_set_keys(hw, sta, vif, key);
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
-- 
2.25.1
