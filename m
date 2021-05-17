Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4CE382E35
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237728AbhEQOFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237696AbhEQOEy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 10:04:54 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E6AC06138D;
        Mon, 17 May 2021 07:03:32 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lidqA-00AMO0-Ln; Mon, 17 May 2021 16:03:26 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>, stable@vger.kernel.org,
        syzbot+452ea4fbbef700ff0a56@syzkaller.appspotmail.com
Subject: [PATCH] mac80211: fix deadlock in AP/VLAN handling
Date:   Mon, 17 May 2021 16:03:23 +0200
Message-Id: <20210517160322.9b8f356c0222.I392cb0e2fa5a1a94cf2e637555d702c7e512c1ff@changeid>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Syzbot reports that when you have AP_VLAN interfaces that are up
and close the AP interface they belong to, we get a deadlock. No
surprise - since we dev_close() them with the wiphy mutex held,
which goes back into the netdev notifier in cfg80211 and tries to
acquire the wiphy mutex there.

To fix this, we need to do two things:
 1) prevent changing iftype while AP_VLANs are up, we can't
    easily fix this case since cfg80211 already calls us with
    the wiphy mutex held, but change_interface() is relatively
    rare in drivers anyway, so changing iftype isn't used much
    (and userspace has to fall back to down/change/up anyway)
 2) pull the dev_close() loop over VLANs out of the wiphy mutex
    section in the normal stop case

Cc: stable@vger.kernel.org
Reported-by: syzbot+452ea4fbbef700ff0a56@syzkaller.appspotmail.com
Fixes: a05829a7222e ("cfg80211: avoid holding the RTNL when calling the driver")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 2e2f73a4aa73..137fa4c50e07 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -476,14 +476,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 				   GFP_KERNEL);
 	}
 
-	/* APs need special treatment */
 	if (sdata->vif.type == NL80211_IFTYPE_AP) {
-		struct ieee80211_sub_if_data *vlan, *tmpsdata;
-
-		/* down all dependent devices, that is VLANs */
-		list_for_each_entry_safe(vlan, tmpsdata, &sdata->u.ap.vlans,
-					 u.vlan.list)
-			dev_close(vlan->dev);
 		WARN_ON(!list_empty(&sdata->u.ap.vlans));
 	} else if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
 		/* remove all packets in parent bc_buf pointing to this dev */
@@ -641,6 +634,15 @@ static int ieee80211_stop(struct net_device *dev)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
+	/* close all dependent VLAN interfaces before locking wiphy */
+	if (sdata->vif.type == NL80211_IFTYPE_AP) {
+		struct ieee80211_sub_if_data *vlan, *tmpsdata;
+
+		list_for_each_entry_safe(vlan, tmpsdata, &sdata->u.ap.vlans,
+					 u.vlan.list)
+			dev_close(vlan->dev);
+	}
+
 	wiphy_lock(sdata->local->hw.wiphy);
 	ieee80211_do_stop(sdata, true);
 	wiphy_unlock(sdata->local->hw.wiphy);
@@ -1591,6 +1593,9 @@ static int ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
 
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP:
+		if (!list_empty(&sdata->u.ap.vlans))
+			return -EBUSY;
+		break;
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_OCB:
-- 
2.31.1

