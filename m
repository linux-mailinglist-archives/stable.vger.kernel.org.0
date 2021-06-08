Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9B63A0049
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235135AbhFHSlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:41:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235423AbhFHSkA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:40:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D3BB61432;
        Tue,  8 Jun 2021 18:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177260;
        bh=oq9QYBIfGAmnu47+FU5gD4+Wlr4SR9e3u9R3vc7h6Tk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OzGAX8aYEKpWVXdp8HmQ2MFWoG9JP2WR3Ig7xj43bsOXA6Cj7IykuxRlFskwl3a8N
         4N/hJDclNVMAoyXwl0sHIieEC5Cr3Mt8YGftF+iDmrvkN5OvrAiKqezcTtTcrYHvtS
         mICM/ZsTzPMScQHEs9RqUpIFqGBwzT0xNkDuB9ZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+49d4cab497c2142ee170@syzkaller.appspotmail.com,
        Johannes Berg <johannes@sipsolutions.net>,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Zubin Mithra <zsm@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 03/58] nl80211: validate key indexes for cfg80211_registered_device
Date:   Tue,  8 Jun 2021 20:26:44 +0200
Message-Id: <20210608175932.382250541@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175932.263480586@linuxfoundation.org>
References: <20210608175932.263480586@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anant Thazhemadam <anant.thazhemadam@gmail.com>

commit 2d9463083ce92636a1bdd3e30d1236e3e95d859e upstream

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
Signed-off-by: Zubin Mithra <zsm@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.h    |  2 ++
 net/wireless/nl80211.c |  7 ++++---
 net/wireless/util.c    | 39 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index f5d58652108d..5f177dad2fa8 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -404,6 +404,8 @@ void cfg80211_sme_abandon_assoc(struct wireless_dev *wdev);
 
 /* internal helpers */
 bool cfg80211_supported_cipher_suite(struct wiphy *wiphy, u32 cipher);
+bool cfg80211_valid_key_idx(struct cfg80211_registered_device *rdev,
+			    int key_idx, bool pairwise);
 int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 				   struct key_params *params, int key_idx,
 				   bool pairwise, const u8 *mac_addr);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5f0605275fa3..04c4fd376e1d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3624,9 +3624,6 @@ static int nl80211_del_key(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
-	if (key.idx < 0)
-		return -EINVAL;
-
 	if (info->attrs[NL80211_ATTR_MAC])
 		mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
@@ -3642,6 +3639,10 @@ static int nl80211_del_key(struct sk_buff *skb, struct genl_info *info)
 	    key.type != NL80211_KEYTYPE_GROUP)
 		return -EINVAL;
 
+	if (!cfg80211_valid_key_idx(rdev, key.idx,
+				    key.type == NL80211_KEYTYPE_PAIRWISE))
+		return -EINVAL;
+
 	if (!rdev->ops->del_key)
 		return -EOPNOTSUPP;
 
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 6f9cff2ee795..c4536468dfbe 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -214,11 +214,48 @@ bool cfg80211_supported_cipher_suite(struct wiphy *wiphy, u32 cipher)
 	return false;
 }
 
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
+{
+	int max_key_idx;
+
+	if (pairwise)
+		max_key_idx = 3;
+	else if (cfg80211_igtk_cipher_supported(rdev))
+		max_key_idx = 5;
+	else
+		max_key_idx = 3;
+
+	if (key_idx < 0 || key_idx > max_key_idx)
+		return false;
+
+	return true;
+}
+
 int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 				   struct key_params *params, int key_idx,
 				   bool pairwise, const u8 *mac_addr)
 {
-	if (key_idx < 0 || key_idx > 5)
+	if (!cfg80211_valid_key_idx(rdev, key_idx, pairwise))
 		return -EINVAL;
 
 	if (!pairwise && mac_addr && !(rdev->wiphy.flags & WIPHY_FLAG_IBSS_RSN))
-- 
2.30.2



