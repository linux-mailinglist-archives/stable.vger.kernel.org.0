Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645A02E1E15
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 16:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgLWPed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 10:34:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:44716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728818AbgLWPed (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 10:34:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E6A32335A;
        Wed, 23 Dec 2020 15:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608737647;
        bh=SBCnZ+eIEoohM9+McIZXqBpzhwBJR0HiRLkkUZYRDSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ySSIyKbzCsJGBG0rRGCdNRehk5EoZppNpQk7sWohpwcGnNdZ3FQwJKr6O8Bkw48Os
         4W30Uca409+yUT/hKvU+iXBhYjkQZvyred/ngex+58/jNGf5m6Vute2MHDNghye0wm
         jL5tyJlN2Y2K0gAxF3BKcuLbp0zF21bGsykE5zmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+49d4cab497c2142ee170@syzkaller.appspotmail.com,
        Johannes Berg <johannes@sipsolutions.net>,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 39/40] nl80211: validate key indexes for cfg80211_registered_device
Date:   Wed, 23 Dec 2020 16:33:40 +0100
Message-Id: <20201223150517.414201577@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223150515.553836647@linuxfoundation.org>
References: <20201223150515.553836647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anant Thazhemadam <anant.thazhemadam@gmail.com>

commit 2d9463083ce92636a1bdd3e30d1236e3e95d859e upstream.

syzbot discovered a bug in which an OOB access was being made because
an unsuitable key_idx value was wrongly considered to be acceptable
while deleting a key in nl80211_del_key().

Since we don't know the cipher at the time of deletion, if
cfg80211_validate_key_settings() were to be called directly in
nl80211_del_key(), even valid keys would be wrongly determined invalid,
and deletion wouldn't occur correctly.
For this reason, a new function - cfg80211_valid_key_idx(), has been
created, to determine if the key_idx value provided is valid or not.
cfg80211_valid_key_idx() is directly called in 2 places -
nl80211_del_key(), and cfg80211_validate_key_settings().

Reported-by: syzbot+49d4cab497c2142ee170@syzkaller.appspotmail.com
Tested-by: syzbot+49d4cab497c2142ee170@syzkaller.appspotmail.com
Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Link: https://lore.kernel.org/r/20201204215825.129879-1-anant.thazhemadam@gmail.com
Cc: stable@vger.kernel.org
[also disallow IGTK key IDs if no IGTK cipher is supported]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/core.h    |    2 +
 net/wireless/nl80211.c |    7 +++---
 net/wireless/util.c    |   51 +++++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 49 insertions(+), 11 deletions(-)

--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -433,6 +433,8 @@ void cfg80211_sme_abandon_assoc(struct w
 
 /* internal helpers */
 bool cfg80211_supported_cipher_suite(struct wiphy *wiphy, u32 cipher);
+bool cfg80211_valid_key_idx(struct cfg80211_registered_device *rdev,
+			    int key_idx, bool pairwise);
 int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 				   struct key_params *params, int key_idx,
 				   bool pairwise, const u8 *mac_addr);
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4260,9 +4260,6 @@ static int nl80211_del_key(struct sk_buf
 	if (err)
 		return err;
 
-	if (key.idx < 0)
-		return -EINVAL;
-
 	if (info->attrs[NL80211_ATTR_MAC])
 		mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
@@ -4278,6 +4275,10 @@ static int nl80211_del_key(struct sk_buf
 	    key.type != NL80211_KEYTYPE_GROUP)
 		return -EINVAL;
 
+	if (!cfg80211_valid_key_idx(rdev, key.idx,
+				    key.type == NL80211_KEYTYPE_PAIRWISE))
+		return -EINVAL;
+
 	if (!rdev->ops->del_key)
 		return -EOPNOTSUPP;
 
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -272,18 +272,53 @@ bool cfg80211_supported_cipher_suite(str
 	return false;
 }
 
-int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
-				   struct key_params *params, int key_idx,
-				   bool pairwise, const u8 *mac_addr)
+static bool
+cfg80211_igtk_cipher_supported(struct cfg80211_registered_device *rdev)
+{
+	struct wiphy *wiphy = &rdev->wiphy;
+	int i;
+
+	for (i = 0; i < wiphy->n_cipher_suites; i++) {
+		switch (wiphy->cipher_suites[i]) {
+		case WLAN_CIPHER_SUITE_AES_CMAC:
+		case WLAN_CIPHER_SUITE_BIP_CMAC_256:
+		case WLAN_CIPHER_SUITE_BIP_GMAC_128:
+		case WLAN_CIPHER_SUITE_BIP_GMAC_256:
+			return true;
+		}
+	}
+
+	return false;
+}
+
+bool cfg80211_valid_key_idx(struct cfg80211_registered_device *rdev,
+			    int key_idx, bool pairwise)
 {
-	int max_key_idx = 5;
+	int max_key_idx;
 
-	if (wiphy_ext_feature_isset(&rdev->wiphy,
-				    NL80211_EXT_FEATURE_BEACON_PROTECTION) ||
-	    wiphy_ext_feature_isset(&rdev->wiphy,
-				    NL80211_EXT_FEATURE_BEACON_PROTECTION_CLIENT))
+	if (pairwise)
+		max_key_idx = 3;
+	else if (wiphy_ext_feature_isset(&rdev->wiphy,
+					 NL80211_EXT_FEATURE_BEACON_PROTECTION) ||
+		 wiphy_ext_feature_isset(&rdev->wiphy,
+					 NL80211_EXT_FEATURE_BEACON_PROTECTION_CLIENT))
 		max_key_idx = 7;
+	else if (cfg80211_igtk_cipher_supported(rdev))
+		max_key_idx = 5;
+	else
+		max_key_idx = 3;
+
 	if (key_idx < 0 || key_idx > max_key_idx)
+		return false;
+
+	return true;
+}
+
+int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
+				   struct key_params *params, int key_idx,
+				   bool pairwise, const u8 *mac_addr)
+{
+	if (!cfg80211_valid_key_idx(rdev, key_idx, pairwise))
 		return -EINVAL;
 
 	if (!pairwise && mac_addr && !(rdev->wiphy.flags & WIPHY_FLAG_IBSS_RSN))


