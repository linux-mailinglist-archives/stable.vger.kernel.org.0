Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1865B44175C
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbhKAJfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:35:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233633AbhKAJds (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:33:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 946AB61284;
        Mon,  1 Nov 2021 09:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758719;
        bh=NzmsJ9Vs7cWuxFj9um2+BysxKAbHt2hd7VkWsxV/v/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=spUXjI5V+b6+E5VIikBWwo39sWu9TF1ZT3zqI1t34TPKHMgKGszs5qrxWLlKXpABD
         +1tFT0RNs/YMTDCe6qYr+z98k8v7JDV+O2QqkGsxvkQA1Hd7h5UlkXKksaCMAyIsIs
         KYLPNIIc4Bf39c+7Etc7tW4mnAOu/mHJ9YQxbMiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jouni Malinen <j@w1.fi>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 29/77] cfg80211: fix management registrations locking
Date:   Mon,  1 Nov 2021 10:17:17 +0100
Message-Id: <20211101082518.054026278@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 09b1d5dc6ce1c9151777f6c4e128a59457704c97 upstream.

The management registrations locking was broken, the list was
locked for each wdev, but cfg80211_mgmt_registrations_update()
iterated it without holding all the correct spinlocks, causing
list corruption.

Rather than trying to fix it with fine-grained locking, just
move the lock to the wiphy/rdev (still need the list on each
wdev), we already need to hold the wdev lock to change it, so
there's no contention on the lock in any case. This trivially
fixes the bug since we hold one wdev's lock already, and now
will hold the lock that protects all lists.

Cc: stable@vger.kernel.org
Reported-by: Jouni Malinen <j@w1.fi>
Fixes: 6cd536fe62ef ("cfg80211: change internal management frame registration API")
Link: https://lore.kernel.org/r/20211025133111.5cf733eab0f4.I7b0abb0494ab712f74e2efcd24bb31ac33f7eee9@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/cfg80211.h |    2 --
 net/wireless/core.c    |    2 +-
 net/wireless/core.h    |    2 ++
 net/wireless/mlme.c    |   26 ++++++++++++++------------
 4 files changed, 17 insertions(+), 15 deletions(-)

--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5202,7 +5202,6 @@ struct cfg80211_cqm_config;
  *	netdev and may otherwise be used by driver read-only, will be update
  *	by cfg80211 on change_interface
  * @mgmt_registrations: list of registrations for management frames
- * @mgmt_registrations_lock: lock for the list
  * @mgmt_registrations_need_update: mgmt registrations were updated,
  *	need to propagate the update to the driver
  * @mtx: mutex used to lock data in this struct, may be used by drivers
@@ -5249,7 +5248,6 @@ struct wireless_dev {
 	u32 identifier;
 
 	struct list_head mgmt_registrations;
-	spinlock_t mgmt_registrations_lock;
 	u8 mgmt_registrations_need_update:1;
 
 	struct mutex mtx;
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -501,6 +501,7 @@ use_default_name:
 	INIT_WORK(&rdev->propagate_cac_done_wk, cfg80211_propagate_cac_done_wk);
 	INIT_WORK(&rdev->mgmt_registrations_update_wk,
 		  cfg80211_mgmt_registrations_update_wk);
+	spin_lock_init(&rdev->mgmt_registrations_lock);
 
 #ifdef CONFIG_CFG80211_DEFAULT_PS
 	rdev->wiphy.flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT;
@@ -1256,7 +1257,6 @@ void cfg80211_init_wdev(struct wireless_
 	INIT_LIST_HEAD(&wdev->event_list);
 	spin_lock_init(&wdev->event_lock);
 	INIT_LIST_HEAD(&wdev->mgmt_registrations);
-	spin_lock_init(&wdev->mgmt_registrations_lock);
 	INIT_LIST_HEAD(&wdev->pmsr_list);
 	spin_lock_init(&wdev->pmsr_lock);
 	INIT_WORK(&wdev->pmsr_free_wk, cfg80211_pmsr_free_wk);
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -101,6 +101,8 @@ struct cfg80211_registered_device {
 	struct work_struct propagate_cac_done_wk;
 
 	struct work_struct mgmt_registrations_update_wk;
+	/* lock for all wdev lists */
+	spinlock_t mgmt_registrations_lock;
 
 	/* must be last because of the way we do wiphy_priv(),
 	 * and it should at least be aligned to NETDEV_ALIGN */
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -448,9 +448,9 @@ static void cfg80211_mgmt_registrations_
 
 	ASSERT_RTNL();
 
-	spin_lock_bh(&wdev->mgmt_registrations_lock);
+	spin_lock_bh(&rdev->mgmt_registrations_lock);
 	if (!wdev->mgmt_registrations_need_update) {
-		spin_unlock_bh(&wdev->mgmt_registrations_lock);
+		spin_unlock_bh(&rdev->mgmt_registrations_lock);
 		return;
 	}
 
@@ -475,7 +475,7 @@ static void cfg80211_mgmt_registrations_
 	rcu_read_unlock();
 
 	wdev->mgmt_registrations_need_update = 0;
-	spin_unlock_bh(&wdev->mgmt_registrations_lock);
+	spin_unlock_bh(&rdev->mgmt_registrations_lock);
 
 	rdev_update_mgmt_frame_registrations(rdev, wdev, &upd);
 }
@@ -499,6 +499,7 @@ int cfg80211_mlme_register_mgmt(struct w
 				int match_len, bool multicast_rx,
 				struct netlink_ext_ack *extack)
 {
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_mgmt_registration *reg, *nreg;
 	int err = 0;
 	u16 mgmt_type;
@@ -544,7 +545,7 @@ int cfg80211_mlme_register_mgmt(struct w
 	if (!nreg)
 		return -ENOMEM;
 
-	spin_lock_bh(&wdev->mgmt_registrations_lock);
+	spin_lock_bh(&rdev->mgmt_registrations_lock);
 
 	list_for_each_entry(reg, &wdev->mgmt_registrations, list) {
 		int mlen = min(match_len, reg->match_len);
@@ -579,7 +580,7 @@ int cfg80211_mlme_register_mgmt(struct w
 		list_add(&nreg->list, &wdev->mgmt_registrations);
 	}
 	wdev->mgmt_registrations_need_update = 1;
-	spin_unlock_bh(&wdev->mgmt_registrations_lock);
+	spin_unlock_bh(&rdev->mgmt_registrations_lock);
 
 	cfg80211_mgmt_registrations_update(wdev);
 
@@ -587,7 +588,7 @@ int cfg80211_mlme_register_mgmt(struct w
 
  out:
 	kfree(nreg);
-	spin_unlock_bh(&wdev->mgmt_registrations_lock);
+	spin_unlock_bh(&rdev->mgmt_registrations_lock);
 
 	return err;
 }
@@ -598,7 +599,7 @@ void cfg80211_mlme_unregister_socket(str
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct cfg80211_mgmt_registration *reg, *tmp;
 
-	spin_lock_bh(&wdev->mgmt_registrations_lock);
+	spin_lock_bh(&rdev->mgmt_registrations_lock);
 
 	list_for_each_entry_safe(reg, tmp, &wdev->mgmt_registrations, list) {
 		if (reg->nlportid != nlportid)
@@ -611,7 +612,7 @@ void cfg80211_mlme_unregister_socket(str
 		schedule_work(&rdev->mgmt_registrations_update_wk);
 	}
 
-	spin_unlock_bh(&wdev->mgmt_registrations_lock);
+	spin_unlock_bh(&rdev->mgmt_registrations_lock);
 
 	if (nlportid && rdev->crit_proto_nlportid == nlportid) {
 		rdev->crit_proto_nlportid = 0;
@@ -624,15 +625,16 @@ void cfg80211_mlme_unregister_socket(str
 
 void cfg80211_mlme_purge_registrations(struct wireless_dev *wdev)
 {
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_mgmt_registration *reg, *tmp;
 
-	spin_lock_bh(&wdev->mgmt_registrations_lock);
+	spin_lock_bh(&rdev->mgmt_registrations_lock);
 	list_for_each_entry_safe(reg, tmp, &wdev->mgmt_registrations, list) {
 		list_del(&reg->list);
 		kfree(reg);
 	}
 	wdev->mgmt_registrations_need_update = 1;
-	spin_unlock_bh(&wdev->mgmt_registrations_lock);
+	spin_unlock_bh(&rdev->mgmt_registrations_lock);
 
 	cfg80211_mgmt_registrations_update(wdev);
 }
@@ -780,7 +782,7 @@ bool cfg80211_rx_mgmt_khz(struct wireles
 	data = buf + ieee80211_hdrlen(mgmt->frame_control);
 	data_len = len - ieee80211_hdrlen(mgmt->frame_control);
 
-	spin_lock_bh(&wdev->mgmt_registrations_lock);
+	spin_lock_bh(&rdev->mgmt_registrations_lock);
 
 	list_for_each_entry(reg, &wdev->mgmt_registrations, list) {
 		if (reg->frame_type != ftype)
@@ -804,7 +806,7 @@ bool cfg80211_rx_mgmt_khz(struct wireles
 		break;
 	}
 
-	spin_unlock_bh(&wdev->mgmt_registrations_lock);
+	spin_unlock_bh(&rdev->mgmt_registrations_lock);
 
 	trace_cfg80211_return_bool(result);
 	return result;


