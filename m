Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C20245C4E4
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347470AbhKXNw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:52:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:39964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354487AbhKXNux (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:50:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41BCE630EB;
        Wed, 24 Nov 2021 13:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759040;
        bh=cN7deWg0+IfLimnmuwtJ1eS2Hh/KZsnQyMq0wFDYYf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sPrqXaCAURlVyPE5YWt42mhOiNKJFN7+iz+p41Rx6mqkPOKG08U/33+dvTW7/3/fG
         w49V0N8VBseDYmCjl4OwH4Y4Sv+sXfoWDIdffDvcOylNZjOns3Z49H4rX2KsdVV/e1
         jyDaN23VVo6HbhGg3C4nj5k/3NMGDGEiO+0zKNb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 113/279] mac80211: fix monitor_sdata RCU/locking assertions
Date:   Wed, 24 Nov 2021 12:56:40 +0100
Message-Id: <20211124115722.683469639@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 6dd2360334f3cb3b45fc1b8194c670090474b87c ]

Since commit a05829a7222e ("cfg80211: avoid holding the RTNL when
calling the driver") we've not only been protecting the pointer
to monitor_sdata with the RTNL, but also with the wiphy->mtx. This
is relevant in a number of lockdep assertions, e.g. the one we hit
in ieee80211_set_monitor_channel(). However, we're now protecting
all the assignments/dereferences, even the one in interface iter,
with the wiphy->mtx, so switch over the lockdep assertions to that
lock.

Fixes: a05829a7222e ("cfg80211: avoid holding the RTNL when calling the driver")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20211112135143.cb8e8ceffef3.Iaa210f16f6904c8a7a24954fb3396da0ef86ec08@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c   | 12 ++++++++----
 net/mac80211/iface.c |  4 +++-
 net/mac80211/util.c  |  7 ++++---
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d69b31c20fe28..d3f62fd12f0b5 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -80,7 +80,8 @@ static int ieee80211_set_mon_options(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* also validate MU-MIMO change */
-	monitor_sdata = rtnl_dereference(local->monitor_sdata);
+	monitor_sdata = wiphy_dereference(local->hw.wiphy,
+					  local->monitor_sdata);
 
 	if (!monitor_sdata &&
 	    (params->vht_mumimo_groups || params->vht_mumimo_follow_addr))
@@ -810,7 +811,8 @@ static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
 
 	mutex_lock(&local->mtx);
 	if (local->use_chanctx) {
-		sdata = rtnl_dereference(local->monitor_sdata);
+		sdata = wiphy_dereference(local->hw.wiphy,
+					  local->monitor_sdata);
 		if (sdata) {
 			ieee80211_vif_release_channel(sdata);
 			ret = ieee80211_vif_use_channel(sdata, chandef,
@@ -2669,7 +2671,8 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 		sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 
 		if (sdata->vif.type == NL80211_IFTYPE_MONITOR) {
-			sdata = rtnl_dereference(local->monitor_sdata);
+			sdata = wiphy_dereference(local->hw.wiphy,
+						  local->monitor_sdata);
 			if (!sdata)
 				return -EOPNOTSUPP;
 		}
@@ -2729,7 +2732,8 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 	mutex_unlock(&local->iflist_mtx);
 
 	if (has_monitor) {
-		sdata = rtnl_dereference(local->monitor_sdata);
+		sdata = wiphy_dereference(local->hw.wiphy,
+					  local->monitor_sdata);
 		if (sdata) {
 			sdata->user_power_level = local->user_power_level;
 			if (txp_type != sdata->vif.bss_conf.txpower_type)
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 62c95597704b4..041859b5b71d0 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -588,7 +588,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 	 */
 	if (local->suspended) {
 		WARN_ON(local->wowlan);
-		WARN_ON(rtnl_dereference(local->monitor_sdata));
+		WARN_ON(rcu_access_pointer(local->monitor_sdata));
 		return;
 	}
 
@@ -932,6 +932,7 @@ int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
 		return 0;
 
 	ASSERT_RTNL();
+	lockdep_assert_wiphy(local->hw.wiphy);
 
 	if (local->monitor_sdata)
 		return 0;
@@ -999,6 +1000,7 @@ void ieee80211_del_virtual_monitor(struct ieee80211_local *local)
 		return;
 
 	ASSERT_RTNL();
+	lockdep_assert_wiphy(local->hw.wiphy);
 
 	mutex_lock(&local->iflist_mtx);
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 49cb96d251695..03ea4f929b997 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -796,7 +796,7 @@ static void __iterate_interfaces(struct ieee80211_local *local,
 
 	sdata = rcu_dereference_check(local->monitor_sdata,
 				      lockdep_is_held(&local->iflist_mtx) ||
-				      lockdep_rtnl_is_held());
+				      lockdep_is_held(&local->hw.wiphy->mtx));
 	if (sdata &&
 	    (iter_flags & IEEE80211_IFACE_ITER_RESUME_ALL || !active_only ||
 	     sdata->flags & IEEE80211_SDATA_IN_DRIVER))
@@ -2379,7 +2379,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 				   IEEE80211_TPT_LEDTRIG_FL_RADIO, 0);
 
 	/* add interfaces */
-	sdata = rtnl_dereference(local->monitor_sdata);
+	sdata = wiphy_dereference(local->hw.wiphy, local->monitor_sdata);
 	if (sdata) {
 		/* in HW restart it exists already */
 		WARN_ON(local->resuming);
@@ -2424,7 +2424,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 				WARN_ON(drv_add_chanctx(local, ctx));
 		mutex_unlock(&local->chanctx_mtx);
 
-		sdata = rtnl_dereference(local->monitor_sdata);
+		sdata = wiphy_dereference(local->hw.wiphy,
+					  local->monitor_sdata);
 		if (sdata && ieee80211_sdata_running(sdata))
 			ieee80211_assign_chanctx(local, sdata);
 	}
-- 
2.33.0



