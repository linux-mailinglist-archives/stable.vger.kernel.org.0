Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDB79150C61
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731075AbgBCQft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:35:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730732AbgBCQft (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:35:49 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0F7D21744;
        Mon,  3 Feb 2020 16:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747748;
        bh=TU+W/o8VBQ8DIoVOwi2OrRAx7A9rVRtH45DypHh4ZZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hcgb3D1YyEIWcQfVHLYfpvG9V7iEQfxpDpg5MZfjo7RgTMy7FAABcPSDqAgeJwTIM
         TTnw3tgwf91kE5qlSCds6fLYDiyCNTV9yE3iainxyZkKIrkm0xWpGWNMcmnU/tjjoS
         BhTx1qgc7ooP/301NrkQy21NYJvcsyxL78PfUrdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Orr Mazor <Orr.Mazor@tandemg.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 52/90] cfg80211: Fix radar event during another phy CAC
Date:   Mon,  3 Feb 2020 16:19:55 +0000
Message-Id: <20200203161924.195422938@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Orr Mazor <orr.mazor@tandemg.com>

[ Upstream commit 26ec17a1dc5ecdd8d91aba63ead6f8b5ad5dea0d ]

In case a radar event of CAC_FINISHED or RADAR_DETECTED
happens during another phy is during CAC we might need
to cancel that CAC.

If we got a radar in a channel that another phy is now
doing CAC on then the CAC should be canceled there.

If, for example, 2 phys doing CAC on the same channels,
or on comptable channels, once on of them will finish his
CAC the other might need to cancel his CAC, since it is no
longer relevant.

To fix that the commit adds an callback and implement it in
mac80211 to end CAC.
This commit also adds a call to said callback if after a radar
event we see the CAC is no longer relevant

Signed-off-by: Orr Mazor <Orr.Mazor@tandemg.com>
Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Link: https://lore.kernel.org/r/20191222145449.15792-1-Orr.Mazor@tandemg.com
[slightly reformat/reword commit message]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h  |  5 +++++
 net/mac80211/cfg.c      | 23 +++++++++++++++++++++++
 net/wireless/rdev-ops.h | 10 ++++++++++
 net/wireless/reg.c      | 23 ++++++++++++++++++++++-
 net/wireless/trace.h    |  5 +++++
 5 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 4ab2c49423dcb..68782ba8b6e8d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3537,6 +3537,9 @@ struct cfg80211_update_owe_info {
  *
  * @start_radar_detection: Start radar detection in the driver.
  *
+ * @end_cac: End running CAC, probably because a related CAC
+ *	was finished on another phy.
+ *
  * @update_ft_ies: Provide updated Fast BSS Transition information to the
  *	driver. If the SME is in the driver/firmware, this information can be
  *	used in building Authentication and Reassociation Request frames.
@@ -3863,6 +3866,8 @@ struct cfg80211_ops {
 					 struct net_device *dev,
 					 struct cfg80211_chan_def *chandef,
 					 u32 cac_time_ms);
+	void	(*end_cac)(struct wiphy *wiphy,
+				struct net_device *dev);
 	int	(*update_ft_ies)(struct wiphy *wiphy, struct net_device *dev,
 				 struct cfg80211_update_ft_ies_params *ftie);
 	int	(*crit_proto_start)(struct wiphy *wiphy,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 70739e746c13e..0daaf7e37a211 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2954,6 +2954,28 @@ static int ieee80211_start_radar_detection(struct wiphy *wiphy,
 	return err;
 }
 
+static void ieee80211_end_cac(struct wiphy *wiphy,
+			      struct net_device *dev)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+
+	mutex_lock(&local->mtx);
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		/* it might be waiting for the local->mtx, but then
+		 * by the time it gets it, sdata->wdev.cac_started
+		 * will no longer be true
+		 */
+		cancel_delayed_work(&sdata->dfs_cac_timer_work);
+
+		if (sdata->wdev.cac_started) {
+			ieee80211_vif_release_channel(sdata);
+			sdata->wdev.cac_started = false;
+		}
+	}
+	mutex_unlock(&local->mtx);
+}
+
 static struct cfg80211_beacon_data *
 cfg80211_beacon_dup(struct cfg80211_beacon_data *beacon)
 {
@@ -4023,6 +4045,7 @@ const struct cfg80211_ops mac80211_config_ops = {
 #endif
 	.get_channel = ieee80211_cfg_get_channel,
 	.start_radar_detection = ieee80211_start_radar_detection,
+	.end_cac = ieee80211_end_cac,
 	.channel_switch = ieee80211_channel_switch,
 	.set_qos_map = ieee80211_set_qos_map,
 	.set_ap_chanwidth = ieee80211_set_ap_chanwidth,
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 3dd9515c836bc..e0d34f796d0b3 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1171,6 +1171,16 @@ rdev_start_radar_detection(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline void
+rdev_end_cac(struct cfg80211_registered_device *rdev,
+	     struct net_device *dev)
+{
+	trace_rdev_end_cac(&rdev->wiphy, dev);
+	if (rdev->ops->end_cac)
+		rdev->ops->end_cac(&rdev->wiphy, dev);
+	trace_rdev_return_void(&rdev->wiphy);
+}
+
 static inline int
 rdev_set_mcast_rate(struct cfg80211_registered_device *rdev,
 		    struct net_device *dev,
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 3c2070040277d..fff9a74891fc4 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3892,6 +3892,25 @@ bool regulatory_pre_cac_allowed(struct wiphy *wiphy)
 }
 EXPORT_SYMBOL(regulatory_pre_cac_allowed);
 
+static void cfg80211_check_and_end_cac(struct cfg80211_registered_device *rdev)
+{
+	struct wireless_dev *wdev;
+	/* If we finished CAC or received radar, we should end any
+	 * CAC running on the same channels.
+	 * the check !cfg80211_chandef_dfs_usable contain 2 options:
+	 * either all channels are available - those the CAC_FINISHED
+	 * event has effected another wdev state, or there is a channel
+	 * in unavailable state in wdev chandef - those the RADAR_DETECTED
+	 * event has effected another wdev state.
+	 * In both cases we should end the CAC on the wdev.
+	 */
+	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
+		if (wdev->cac_started &&
+		    !cfg80211_chandef_dfs_usable(&rdev->wiphy, &wdev->chandef))
+			rdev_end_cac(rdev, wdev->netdev);
+	}
+}
+
 void regulatory_propagate_dfs_state(struct wiphy *wiphy,
 				    struct cfg80211_chan_def *chandef,
 				    enum nl80211_dfs_state dfs_state,
@@ -3918,8 +3937,10 @@ void regulatory_propagate_dfs_state(struct wiphy *wiphy,
 		cfg80211_set_dfs_state(&rdev->wiphy, chandef, dfs_state);
 
 		if (event == NL80211_RADAR_DETECTED ||
-		    event == NL80211_RADAR_CAC_FINISHED)
+		    event == NL80211_RADAR_CAC_FINISHED) {
 			cfg80211_sched_dfs_chan_update(rdev);
+			cfg80211_check_and_end_cac(rdev);
+		}
 
 		nl80211_radar_notify(rdev, chandef, event, NULL, GFP_KERNEL);
 	}
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index d98ad2b3143b0..8677d7ab7d692 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -646,6 +646,11 @@ DEFINE_EVENT(wiphy_netdev_evt, rdev_flush_pmksa,
 	TP_ARGS(wiphy, netdev)
 );
 
+DEFINE_EVENT(wiphy_netdev_evt, rdev_end_cac,
+	     TP_PROTO(struct wiphy *wiphy, struct net_device *netdev),
+	     TP_ARGS(wiphy, netdev)
+);
+
 DECLARE_EVENT_CLASS(station_add_change,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u8 *mac,
 		 struct station_parameters *params),
-- 
2.20.1



