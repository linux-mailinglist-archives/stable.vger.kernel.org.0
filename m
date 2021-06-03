Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E1B39A5BE
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 18:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhFCQcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 12:32:02 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:36781 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbhFCQcA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 12:32:00 -0400
Received: by mail-pj1-f47.google.com with SMTP id d5-20020a17090ab305b02901675357c371so5460670pjr.1
        for <stable@vger.kernel.org>; Thu, 03 Jun 2021 09:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j8Pq3DIUPv8PG0X4xGHIiD1Lq0YxYn4aCimiti8oSmA=;
        b=kNAh3Af3n45+QGiBNkTgqiX52UkgaBLvRwRVRHV3AMoiITWg9DW17xjS8V03q1IivN
         DSUcgXefANrCLSmW+CE4JXVqBI7LioTItOjfgbCHiUVYNlh/zYQBlY5doGYlVNH0qksu
         8tLgdydyPQNMfbMgx3b/TuferHNA4JXFuWPgc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j8Pq3DIUPv8PG0X4xGHIiD1Lq0YxYn4aCimiti8oSmA=;
        b=QKWm+1Jut8N0kJ7nh+P53rz25D8GGxCwUXz1+RxXQ0inyoivIOIWi+d+8E1sYev+9F
         L5VblU842PU/sIxrRwwOX0yI+pHjvsVJR0mCHKwrRF0M4qJDD2EVyaLb1Jil2ZdukOhC
         r7Bj8mKlVrn2+z1N99OyB/7lOXFzLIgUjnGXZjnFP8hEi+XxJ74x/aI7l/LNkhFl8LcV
         YzUJpy+jhVDqxmisLgeXrGz4V3py3VuNUqk7u8glZ3hjp+28Q1VFmjEQvoQH+94uRVLI
         UOw531VRGtcR+jo8J03omuRV6pphJ5VctXZ7vqAjpEEidhSafDp99jREdOjsYjhvd/38
         ljIg==
X-Gm-Message-State: AOAM532TiAdCH3bbnO1adsXDmHR8tz78HHfMWB1cS2gEwn8VbK7ETGte
        5GrMUZXR+j6EjkftGHvj4G3REHLpNiJgtQ==
X-Google-Smtp-Source: ABdhPJwvIKm7lxwJcuMdlYLEuh3UyfYKbEOvstGWZoQR25ta5BYchXKqZsx+rw+06J7Sxu3qV6q+ww==
X-Received: by 2002:a17:90a:d102:: with SMTP id l2mr12452pju.225.1622737740267;
        Thu, 03 Jun 2021 09:29:00 -0700 (PDT)
Received: from zsm-linux.mtv.corp.google.com ([2620:15c:202:201:313d:5f71:aa0c:bdea])
        by smtp.googlemail.com with ESMTPSA id x125sm2706349pfx.201.2021.06.03.09.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 09:28:59 -0700 (PDT)
From:   Zubin Mithra <zsm@chromium.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org,
        anant.thazhemadam@gmail.com, johannes.berg@intel.com
Subject: [v5.4.y,v4.19.y] nl80211: validate key indexes for cfg80211_registered_device
Date:   Thu,  3 Jun 2021 09:28:52 -0700
Message-Id: <20210603162852.1814513-1-zsm@chromium.org>
X-Mailer: git-send-email 2.32.0.rc0.204.g9fa02ecfa5-goog
MIME-Version: 1.0
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
---
* Syzkaller triggered an OOB-read with the following stacktrace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xef/0x160 lib/dump_stack.c:118
 print_address_description.constprop.0+0x17/0x311 mm/kasan/report.c:374
 __kasan_report+0x145/0x18c mm/kasan/report.c:506
 kasan_report+0x10/0x16 mm/kasan/common.c:634
 ieee80211_key_free+0xb8/0xef net/mac80211/key.c:844
 ieee80211_del_key+0x324/0x354 net/mac80211/cfg.c:532
 rdev_del_key net/wireless/rdev-ops.h:107 [inline]
 nl80211_del_key+0x636/0x758 net/wireless/nl80211.c:4081
 genl_family_rcv_msg+0xaa4/0xbb1 net/netlink/genetlink.c:629
 genl_rcv_msg+0xce/0x127 net/netlink/genetlink.c:654
 netlink_rcv_skb+0x23d/0x318 net/netlink/af_netlink.c:2478
 genl_rcv+0x24/0x31 net/netlink/genetlink.c:665
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x432/0x556 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x943/0x9a8 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:638 [inline]
 sock_sendmsg+0xd5/0x10c net/socket.c:658
 ____sys_sendmsg+0x4ea/0x641 net/socket.c:2298
 ___sys_sendmsg+0x14a/0x1a9 net/socket.c:2352
 __sys_sendmsg+0xf1/0x181 net/socket.c:2398
 do_syscall_64+0x106/0x13f arch/x86/entry/common.c:299
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

* This commit is present in 5.10.y. The crash does not occur
on 4.14.y and older.

* Tests run: syzkaller reproducer, Chrome OS tryjobs

 net/wireless/core.h    |  2 ++
 net/wireless/nl80211.c |  7 ++++---
 net/wireless/util.c    | 39 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index d83c8e009448..17621d22fb17 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -433,6 +433,8 @@ void cfg80211_sme_abandon_assoc(struct wireless_dev *wdev);
 
 /* internal helpers */
 bool cfg80211_supported_cipher_suite(struct wiphy *wiphy, u32 cipher);
+bool cfg80211_valid_key_idx(struct cfg80211_registered_device *rdev,
+			    int key_idx, bool pairwise);
 int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 				   struct key_params *params, int key_idx,
 				   bool pairwise, const u8 *mac_addr);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5bb2316befb9..7b170ed6923e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3979,9 +3979,6 @@ static int nl80211_del_key(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
-	if (key.idx < 0)
-		return -EINVAL;
-
 	if (info->attrs[NL80211_ATTR_MAC])
 		mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
@@ -3997,6 +3994,10 @@ static int nl80211_del_key(struct sk_buff *skb, struct genl_info *info)
 	    key.type != NL80211_KEYTYPE_GROUP)
 		return -EINVAL;
 
+	if (!cfg80211_valid_key_idx(rdev, key.idx,
+				    key.type == NL80211_KEYTYPE_PAIRWISE))
+		return -EINVAL;
+
 	if (!rdev->ops->del_key)
 		return -EOPNOTSUPP;
 
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 82244e2fc1f5..4eae6ad32851 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -229,11 +229,48 @@ bool cfg80211_supported_cipher_suite(struct wiphy *wiphy, u32 cipher)
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
2.20.0

