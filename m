Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 377663DD8DB
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235494AbhHBNzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:55:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:33610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235842AbhHBNya (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:54:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4080961057;
        Mon,  2 Aug 2021 13:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912371;
        bh=R/b5e4s0RKsY3mkApTXu9HMAV96fG8mcWUlIbWhkwOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eJCsn1xbQglBZl0euOFSA/xPzadKTYHf+BQbzKuH8ZteZWt4n+BgbAE/CPZmm7c3d
         fzf6dk84+yyIKVPx4iiN3dO/CrheGleSipTs4kM0p0d2a3e9xPu9x5wq3UNwv+kDfD
         pgBU4xi9+J7wjKU9gz+UwSB23G6yoIL1y7oW8PIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 30/67] mac80211: fix enabling 4-address mode on a sta vif after assoc
Date:   Mon,  2 Aug 2021 15:44:53 +0200
Message-Id: <20210802134340.041317289@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
References: <20210802134339.023067817@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit a5d3cbdb09ff1f52cbe040932e06c8b9915c6dad ]

Notify the driver about the 4-address mode change and also send a nulldata
packet to the AP to notify it about the change

Fixes: 1ff4e8f2dec8 ("mac80211: notify the driver when a sta uses 4-address mode")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20210702050111.47546-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c         | 19 +++++++++++++++++++
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/mlme.c        |  4 ++--
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 6a96deded763..e429dbb10df7 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -152,6 +152,8 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 				  struct vif_params *params)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
 	int ret;
 
 	ret = ieee80211_if_change_type(sdata, type);
@@ -162,7 +164,24 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 		RCU_INIT_POINTER(sdata->u.vlan.sta, NULL);
 		ieee80211_check_fast_rx_iface(sdata);
 	} else if (type == NL80211_IFTYPE_STATION && params->use_4addr >= 0) {
+		struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+
+		if (params->use_4addr == ifmgd->use_4addr)
+			return 0;
+
 		sdata->u.mgd.use_4addr = params->use_4addr;
+		if (!ifmgd->associated)
+			return 0;
+
+		mutex_lock(&local->sta_mtx);
+		sta = sta_info_get(sdata, ifmgd->bssid);
+		if (sta)
+			drv_sta_set_4addr(local, sdata, &sta->sta,
+					  params->use_4addr);
+		mutex_unlock(&local->sta_mtx);
+
+		if (params->use_4addr)
+			ieee80211_send_4addr_nullfunc(local, sdata);
 	}
 
 	if (sdata->vif.type == NL80211_IFTYPE_MONITOR) {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a83f0c2fcdf7..7f2be08b72a5 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2051,6 +2051,8 @@ void ieee80211_dynamic_ps_timer(struct timer_list *t);
 void ieee80211_send_nullfunc(struct ieee80211_local *local,
 			     struct ieee80211_sub_if_data *sdata,
 			     bool powersave);
+void ieee80211_send_4addr_nullfunc(struct ieee80211_local *local,
+				   struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_tx_notify(struct ieee80211_sub_if_data *sdata,
 			     struct ieee80211_hdr *hdr, bool ack, u16 tx_time);
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 142bb28199c4..32bc30ec50ec 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1115,8 +1115,8 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 	ieee80211_tx_skb(sdata, skb);
 }
 
-static void ieee80211_send_4addr_nullfunc(struct ieee80211_local *local,
-					  struct ieee80211_sub_if_data *sdata)
+void ieee80211_send_4addr_nullfunc(struct ieee80211_local *local,
+				   struct ieee80211_sub_if_data *sdata)
 {
 	struct sk_buff *skb;
 	struct ieee80211_hdr *nullfunc;
-- 
2.30.2



