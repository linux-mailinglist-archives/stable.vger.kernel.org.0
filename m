Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A52B36FC37
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 16:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbhD3OWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 10:22:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233416AbhD3OWG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 10:22:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAC2061459;
        Fri, 30 Apr 2021 14:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619792478;
        bh=Ssvb3WhmvamNhjxly6X6czUhpWJz3WIYpbO204mFfkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GsTPMo8JlIAZ/y2nje1ll1iaJCOtDQl9bWQldQVTiyFP66vEOA7BssVOJPDo3s41J
         NTf6Uzqk4SMbtiOIsY+j05d5sgJw8WBStBwVMOHw+Xygc9fHnv46fNX+DmipwvdCNc
         pPHoWu6dCsM2VfxyFlZky7pkBYVMZ4w98Jf1xHtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harald Arnesen <harald@skogtun.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.12 4/5] cfg80211: fix locking in netlink owner interface destruction
Date:   Fri, 30 Apr 2021 16:20:59 +0200
Message-Id: <20210430141911.033571444@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210430141910.899518186@linuxfoundation.org>
References: <20210430141910.899518186@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit ea6b2098dd02789f68770fd3d5a373732207be2f upstream.

Harald Arnesen reported [1] a deadlock at reboot time, and after
he captured a stack trace a picture developed of what's going on:

The distribution he's using is using iwd (not wpa_supplicant) to
manage wireless. iwd will usually use the "socket owner" option
when it creates new interfaces, so that they're automatically
destroyed when it quits (unexpectedly or otherwise). This is also
done by wpa_supplicant, but it doesn't do it for the normal one,
only for additional ones, which is different with iwd.

Anyway, during shutdown, iwd quits while the netdev is still UP,
i.e. IFF_UP is set. This causes the stack trace that Linus so
nicely transcribed from the pictures:

cfg80211_destroy_iface_wk() takes wiphy_lock
 -> cfg80211_destroy_ifaces()
  ->ieee80211_del_iface
    ->ieeee80211_if_remove
      ->cfg80211_unregister_wdev
        ->unregister_netdevice_queue
          ->dev_close_many
            ->__dev_close_many
              ->raw_notifier_call_chain
                ->cfg80211_netdev_notifier_call
and that last call tries to take wiphy_lock again.

In commit a05829a7222e ("cfg80211: avoid holding the RTNL when
calling the driver") I had taken into account the possibility of
recursing from cfg80211 into cfg80211_netdev_notifier_call() via
the network stack, but only for NETDEV_UNREGISTER, not for what
happens here, NETDEV_GOING_DOWN and NETDEV_DOWN notifications.

Additionally, while this worked still back in commit 78f22b6a3a92
("cfg80211: allow userspace to take ownership of interfaces"), it
missed another corner case: unregistering a netdev will cause
dev_close() to be called, and thus stop wireless operations (e.g.
disconnecting), but there are some types of virtual interfaces in
wifi that don't have a netdev - for that we need an additional
call to cfg80211_leave().

So, to fix this mess, change cfg80211_destroy_ifaces() to not
require the wiphy_lock(), but instead make it acquire it, but
only after it has actually closed all the netdevs on the list,
and then call cfg80211_leave() as well before removing them
from the driver, to fix the second issue. The locking change in
this requires modifying the nl80211 call to not get the wiphy
lock passed in, but acquire it by itself after flushing any
potentially pending destruction requests.

[1] https://lore.kernel.org/r/09464e67-f3de-ac09-28a3-e27b7914ee7d@skogtun.org

Cc: stable@vger.kernel.org # 5.12
Reported-by: Harald Arnesen <harald@skogtun.org>
Fixes: 776a39b8196d ("cfg80211: call cfg80211_destroy_ifaces() with wiphy lock held")
Fixes: 78f22b6a3a92 ("cfg80211: allow userspace to take ownership of interfaces")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Tested-by: Harald Arnesen <harald@skogtun.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/core.c    |   21 +++++++++++++++++----
 net/wireless/nl80211.c |   24 +++++++++++++++++++-----
 2 files changed, 36 insertions(+), 9 deletions(-)

--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -332,14 +332,29 @@ static void cfg80211_event_work(struct w
 void cfg80211_destroy_ifaces(struct cfg80211_registered_device *rdev)
 {
 	struct wireless_dev *wdev, *tmp;
+	bool found = false;
 
 	ASSERT_RTNL();
-	lockdep_assert_wiphy(&rdev->wiphy);
 
+	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
+		if (wdev->nl_owner_dead) {
+			if (wdev->netdev)
+				dev_close(wdev->netdev);
+			found = true;
+		}
+	}
+
+	if (!found)
+		return;
+
+	wiphy_lock(&rdev->wiphy);
 	list_for_each_entry_safe(wdev, tmp, &rdev->wiphy.wdev_list, list) {
-		if (wdev->nl_owner_dead)
+		if (wdev->nl_owner_dead) {
+			cfg80211_leave(rdev, wdev);
 			rdev_del_virtual_intf(rdev, wdev);
+		}
 	}
+	wiphy_unlock(&rdev->wiphy);
 }
 
 static void cfg80211_destroy_iface_wk(struct work_struct *work)
@@ -350,9 +365,7 @@ static void cfg80211_destroy_iface_wk(st
 			    destroy_work);
 
 	rtnl_lock();
-	wiphy_lock(&rdev->wiphy);
 	cfg80211_destroy_ifaces(rdev);
-	wiphy_unlock(&rdev->wiphy);
 	rtnl_unlock();
 }
 
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3929,7 +3929,7 @@ static int nl80211_set_interface(struct
 	return err;
 }
 
-static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
+static int _nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct vif_params params;
@@ -3938,9 +3938,6 @@ static int nl80211_new_interface(struct
 	int err;
 	enum nl80211_iftype type = NL80211_IFTYPE_UNSPECIFIED;
 
-	/* to avoid failing a new interface creation due to pending removal */
-	cfg80211_destroy_ifaces(rdev);
-
 	memset(&params, 0, sizeof(params));
 
 	if (!info->attrs[NL80211_ATTR_IFNAME])
@@ -4028,6 +4025,21 @@ static int nl80211_new_interface(struct
 	return genlmsg_reply(msg, info);
 }
 
+static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	int ret;
+
+	/* to avoid failing a new interface creation due to pending removal */
+	cfg80211_destroy_ifaces(rdev);
+
+	wiphy_lock(&rdev->wiphy);
+	ret = _nl80211_new_interface(skb, info);
+	wiphy_unlock(&rdev->wiphy);
+
+	return ret;
+}
+
 static int nl80211_del_interface(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -15040,7 +15052,9 @@ static const struct genl_small_ops nl802
 		.doit = nl80211_new_interface,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WIPHY |
-				  NL80211_FLAG_NEED_RTNL,
+				  NL80211_FLAG_NEED_RTNL |
+				  /* we take the wiphy mutex later ourselves */
+				  NL80211_FLAG_NO_WIPHY_MTX,
 	},
 	{
 		.cmd = NL80211_CMD_DEL_INTERFACE,


