Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414CC2B630C
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732190AbgKQNea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:34:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:44986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732184AbgKQNea (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:34:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A4122467A;
        Tue, 17 Nov 2020 13:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620070;
        bh=BYzD6UaKc4s5o3gN7OudfqlHsDG5FIyVSpOhmvsP2wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iTS+jWSxkCVOnw/sUB2KMROBvoBnHZRDeqQbUDVrnfe2056TuqO9Z5hMGUAkExjq2
         dkir7jFoA+1C/atk3Icrw3e/QFdUh7iAhHN2FJSVN3anpZb1oNK656zBGOPWlnLIvC
         Q/LmgFB0xX12PYc6jQDdLV5UV7s+Ho535cVMQVyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 098/255] cfg80211: initialize wdev data earlier
Date:   Tue, 17 Nov 2020 14:03:58 +0100
Message-Id: <20201117122143.727393391@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 9bdaf3b91efd229dd272b228e13df10310c80d19 ]

There's a race condition in the netdev registration in that
NETDEV_REGISTER actually happens after the netdev is available,
and so if we initialize things only there, we might get called
with an uninitialized wdev through nl80211 - not using a wdev
but using a netdev interface index.

I found this while looking into a syzbot report, but it doesn't
really seem to be related, and unfortunately there's no repro
for it (yet). I can't (yet) explain how it managed to get into
cfg80211_release_pmsr() from nl80211_netlink_notify() without
the wdev having been initialized, as the latter only iterates
the wdevs that are linked into the rdev, which even without the
change here happened after init.

However, looking at this, it seems fairly clear that the init
needs to be done earlier, otherwise we might even re-init on a
netns move, when data might still be pending.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20201009135821.fdcbba3aad65.Ie9201d91dbcb7da32318812effdc1561aeaf4cdc@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.c    | 57 +++++++++++++++++++++++-------------------
 net/wireless/core.h    |  5 ++--
 net/wireless/nl80211.c |  3 ++-
 3 files changed, 36 insertions(+), 29 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 354b0ccbdc240..e025493171262 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1248,8 +1248,7 @@ void cfg80211_stop_iface(struct wiphy *wiphy, struct wireless_dev *wdev,
 }
 EXPORT_SYMBOL(cfg80211_stop_iface);
 
-void cfg80211_init_wdev(struct cfg80211_registered_device *rdev,
-			struct wireless_dev *wdev)
+void cfg80211_init_wdev(struct wireless_dev *wdev)
 {
 	mutex_init(&wdev->mtx);
 	INIT_LIST_HEAD(&wdev->event_list);
@@ -1260,6 +1259,30 @@ void cfg80211_init_wdev(struct cfg80211_registered_device *rdev,
 	spin_lock_init(&wdev->pmsr_lock);
 	INIT_WORK(&wdev->pmsr_free_wk, cfg80211_pmsr_free_wk);
 
+#ifdef CONFIG_CFG80211_WEXT
+	wdev->wext.default_key = -1;
+	wdev->wext.default_mgmt_key = -1;
+	wdev->wext.connect.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
+#endif
+
+	if (wdev->wiphy->flags & WIPHY_FLAG_PS_ON_BY_DEFAULT)
+		wdev->ps = true;
+	else
+		wdev->ps = false;
+	/* allow mac80211 to determine the timeout */
+	wdev->ps_timeout = -1;
+
+	if ((wdev->iftype == NL80211_IFTYPE_STATION ||
+	     wdev->iftype == NL80211_IFTYPE_P2P_CLIENT ||
+	     wdev->iftype == NL80211_IFTYPE_ADHOC) && !wdev->use_4addr)
+		wdev->netdev->priv_flags |= IFF_DONT_BRIDGE;
+
+	INIT_WORK(&wdev->disconnect_wk, cfg80211_autodisconnect_wk);
+}
+
+void cfg80211_register_wdev(struct cfg80211_registered_device *rdev,
+			    struct wireless_dev *wdev)
+{
 	/*
 	 * We get here also when the interface changes network namespaces,
 	 * as it's registered into the new one, but we don't want it to
@@ -1293,6 +1316,11 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 	switch (state) {
 	case NETDEV_POST_INIT:
 		SET_NETDEV_DEVTYPE(dev, &wiphy_type);
+		wdev->netdev = dev;
+		/* can only change netns with wiphy */
+		dev->features |= NETIF_F_NETNS_LOCAL;
+
+		cfg80211_init_wdev(wdev);
 		break;
 	case NETDEV_REGISTER:
 		/*
@@ -1300,35 +1328,12 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		 * called within code protected by it when interfaces
 		 * are added with nl80211.
 		 */
-		/* can only change netns with wiphy */
-		dev->features |= NETIF_F_NETNS_LOCAL;
-
 		if (sysfs_create_link(&dev->dev.kobj, &rdev->wiphy.dev.kobj,
 				      "phy80211")) {
 			pr_err("failed to add phy80211 symlink to netdev!\n");
 		}
-		wdev->netdev = dev;
-#ifdef CONFIG_CFG80211_WEXT
-		wdev->wext.default_key = -1;
-		wdev->wext.default_mgmt_key = -1;
-		wdev->wext.connect.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
-#endif
-
-		if (wdev->wiphy->flags & WIPHY_FLAG_PS_ON_BY_DEFAULT)
-			wdev->ps = true;
-		else
-			wdev->ps = false;
-		/* allow mac80211 to determine the timeout */
-		wdev->ps_timeout = -1;
-
-		if ((wdev->iftype == NL80211_IFTYPE_STATION ||
-		     wdev->iftype == NL80211_IFTYPE_P2P_CLIENT ||
-		     wdev->iftype == NL80211_IFTYPE_ADHOC) && !wdev->use_4addr)
-			dev->priv_flags |= IFF_DONT_BRIDGE;
-
-		INIT_WORK(&wdev->disconnect_wk, cfg80211_autodisconnect_wk);
 
-		cfg80211_init_wdev(rdev, wdev);
+		cfg80211_register_wdev(rdev, wdev);
 		break;
 	case NETDEV_GOING_DOWN:
 		cfg80211_leave(rdev, wdev);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 67b0389fca4dc..8cd4a9793298e 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -208,8 +208,9 @@ struct wiphy *wiphy_idx_to_wiphy(int wiphy_idx);
 int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 			  struct net *net);
 
-void cfg80211_init_wdev(struct cfg80211_registered_device *rdev,
-			struct wireless_dev *wdev);
+void cfg80211_init_wdev(struct wireless_dev *wdev);
+void cfg80211_register_wdev(struct cfg80211_registered_device *rdev,
+			    struct wireless_dev *wdev);
 
 static inline void wdev_lock(struct wireless_dev *wdev)
 	__acquires(wdev)
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e14307f2bddcc..8eb43c47e582a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3801,7 +3801,8 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 		 * P2P Device and NAN do not have a netdev, so don't go
 		 * through the netdev notifier and must be added here
 		 */
-		cfg80211_init_wdev(rdev, wdev);
+		cfg80211_init_wdev(wdev);
+		cfg80211_register_wdev(rdev, wdev);
 		break;
 	default:
 		break;
-- 
2.27.0



