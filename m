Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6A226AEEB3
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbjCGSO7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:14:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbjCGSOb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:14:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E359E521
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:10:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99139B819C5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:10:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24C7C4339E;
        Tue,  7 Mar 2023 18:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212599;
        bh=94UPW3n1QuanhFE7CefMY8b794EPueYDE/S7x4gE2+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p42mAaoNc4FPMXmgD/cEnqMfDglTSIGvkTusCIIPiuM5NL1rUiq6YewNWIg4Nxmdc
         tQnsNX9StP0A/chfrNiGBXqL0E7VrxEdFmDpwHZxPOAZokFRcKEFiBkrF5qjQCehRT
         tFp9wqZV+E5L0q+A0bbJMoWTEXViEI0Ugowecc2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 235/885] wifi: mac80211: move color collision detection report in a delayed work
Date:   Tue,  7 Mar 2023 17:52:49 +0100
Message-Id: <20230307170012.230031459@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 9288188438d85e22c23cfd6657ee8a801babc83c ]

Move color collision report in a dedicated delayed work and do not run
it in interrupt context in order to rate-limit the number of events
reported to userspace. Moreover grab wdev mutex in
ieee80211_color_collision_detection_work routine since it is required
by cfg80211_obss_color_collision_notify().

Tested-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Fixes: 5f9404abdf2a ("mac80211: add support for BSS color change")
Link: https://lore.kernel.org/r/3f6cf60c892ad40c1cca4a55d62b1224ef1c6ce9.1674644379.git.lorenzo@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c         | 26 +++++++++++++++++++++++++-
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/link.c        |  3 +++
 3 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 3c66e03774fbe..e8beec0a0ae1c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -4623,6 +4623,20 @@ void ieee80211_color_change_finalize_work(struct work_struct *work)
 	sdata_unlock(sdata);
 }
 
+void ieee80211_color_collision_detection_work(struct work_struct *work)
+{
+	struct delayed_work *delayed_work = to_delayed_work(work);
+	struct ieee80211_link_data *link =
+		container_of(delayed_work, struct ieee80211_link_data,
+			     color_collision_detect_work);
+	struct ieee80211_sub_if_data *sdata = link->sdata;
+
+	sdata_lock(sdata);
+	cfg80211_obss_color_collision_notify(sdata->dev, link->color_bitmap,
+					     GFP_KERNEL);
+	sdata_unlock(sdata);
+}
+
 void ieee80211_color_change_finish(struct ieee80211_vif *vif)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
@@ -4637,11 +4651,21 @@ ieeee80211_obss_color_collision_notify(struct ieee80211_vif *vif,
 				       u64 color_bitmap, gfp_t gfp)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_link_data *link = &sdata->deflink;
 
 	if (sdata->vif.bss_conf.color_change_active || sdata->vif.bss_conf.csa_active)
 		return;
 
-	cfg80211_obss_color_collision_notify(sdata->dev, color_bitmap, gfp);
+	if (delayed_work_pending(&link->color_collision_detect_work))
+		return;
+
+	link->color_bitmap = color_bitmap;
+	/* queue the color collision detection event every 500 ms in order to
+	 * avoid sending too much netlink messages to userspace.
+	 */
+	ieee80211_queue_delayed_work(&sdata->local->hw,
+				     &link->color_collision_detect_work,
+				     msecs_to_jiffies(500));
 }
 EXPORT_SYMBOL_GPL(ieeee80211_obss_color_collision_notify);
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a8862f2c64ec0..e57001e00a3d0 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -972,6 +972,8 @@ struct ieee80211_link_data {
 	struct cfg80211_chan_def csa_chandef;
 
 	struct work_struct color_change_finalize_work;
+	struct delayed_work color_collision_detect_work;
+	u64 color_bitmap;
 
 	/* context reservation -- protected with chanctx_mtx */
 	struct ieee80211_chanctx *reserved_chanctx;
@@ -1916,6 +1918,7 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 
 /* color change handling */
 void ieee80211_color_change_finalize_work(struct work_struct *work);
+void ieee80211_color_collision_detection_work(struct work_struct *work);
 
 /* interface handling */
 #define MAC80211_SUPPORTED_FEATURES_TX	(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | \
diff --git a/net/mac80211/link.c b/net/mac80211/link.c
index e309708abae8b..a1b3031fefce2 100644
--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -39,6 +39,8 @@ void ieee80211_link_init(struct ieee80211_sub_if_data *sdata,
 		  ieee80211_csa_finalize_work);
 	INIT_WORK(&link->color_change_finalize_work,
 		  ieee80211_color_change_finalize_work);
+	INIT_DELAYED_WORK(&link->color_collision_detect_work,
+			  ieee80211_color_collision_detection_work);
 	INIT_LIST_HEAD(&link->assigned_chanctx_list);
 	INIT_LIST_HEAD(&link->reserved_chanctx_list);
 	INIT_DELAYED_WORK(&link->dfs_cac_timer_work,
@@ -66,6 +68,7 @@ void ieee80211_link_stop(struct ieee80211_link_data *link)
 	if (link->sdata->vif.type == NL80211_IFTYPE_STATION)
 		ieee80211_mgd_stop_link(link);
 
+	cancel_delayed_work_sync(&link->color_collision_detect_work);
 	ieee80211_link_release_channel(link);
 }
 
-- 
2.39.2



