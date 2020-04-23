Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7E11B6926
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgDWXUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:20:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48628 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726062AbgDWXGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:33 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-0004ZO-0P; Fri, 24 Apr 2020 00:06:24 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvH-00E6ej-Im; Fri, 24 Apr 2020 00:06:23 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Johannes Berg" <johannes@sipsolutions.net>,
        "Jouni Malinen" <jouni@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Date:   Fri, 24 Apr 2020 00:03:55 +0100
Message-ID: <lsq.1587683028.2181668@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 008/245] mac80211: Do not send Layer 2 Update frame
 before authorization
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Malinen <jouni@codeaurora.org>

commit 3e493173b7841259a08c5c8e5cbe90adb349da7e upstream.

The Layer 2 Update frame is used to update bridges when a station roams
to another AP even if that STA does not transmit any frames after the
reassociation. This behavior was described in IEEE Std 802.11F-2003 as
something that would happen based on MLME-ASSOCIATE.indication, i.e.,
before completing 4-way handshake. However, this IEEE trial-use
recommended practice document was published before RSN (IEEE Std
802.11i-2004) and as such, did not consider RSN use cases. Furthermore,
IEEE Std 802.11F-2003 was withdrawn in 2006 and as such, has not been
maintained amd should not be used anymore.

Sending out the Layer 2 Update frame immediately after association is
fine for open networks (and also when using SAE, FT protocol, or FILS
authentication when the station is actually authenticated by the time
association completes). However, it is not appropriate for cases where
RSN is used with PSK or EAP authentication since the station is actually
fully authenticated only once the 4-way handshake completes after
authentication and attackers might be able to use the unauthenticated
triggering of Layer 2 Update frame transmission to disrupt bridge
behavior.

Fix this by postponing transmission of the Layer 2 Update frame from
station entry addition to the point when the station entry is marked
authorized. Similarly, send out the VLAN binding update only if the STA
entry has already been authorized.

Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/mac80211/cfg.c      | 11 +++--------
 net/mac80211/sta_info.c |  4 ++++
 2 files changed, 7 insertions(+), 8 deletions(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1436,7 +1436,6 @@ static int ieee80211_add_station(struct
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata;
 	int err;
-	int layer2_update;
 
 	if (params->vlan) {
 		sdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
@@ -1481,18 +1480,12 @@ static int ieee80211_add_station(struct
 	if (!test_sta_flag(sta, WLAN_STA_TDLS_PEER))
 		rate_control_rate_init(sta);
 
-	layer2_update = sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
-		sdata->vif.type == NL80211_IFTYPE_AP;
-
 	err = sta_info_insert_rcu(sta);
 	if (err) {
 		rcu_read_unlock();
 		return err;
 	}
 
-	if (layer2_update)
-		cfg80211_send_layer2_update(sta->sdata->dev, sta->sta.addr);
-
 	rcu_read_unlock();
 
 	return 0;
@@ -1596,7 +1589,9 @@ static int ieee80211_change_station(stru
 				atomic_inc(&sta->sdata->bss->num_mcast_sta);
 		}
 
-		cfg80211_send_layer2_update(sta->sdata->dev, sta->sta.addr);
+		if (sta->sta_state == IEEE80211_STA_AUTHORIZED)
+			cfg80211_send_layer2_update(sta->sdata->dev,
+						    sta->sta.addr);
 	}
 
 	err = sta_apply_parameters(local, sta, params);
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1666,6 +1666,10 @@ int sta_info_move_state(struct sta_info
 				atomic_inc(&sta->sdata->bss->num_mcast_sta);
 			set_bit(WLAN_STA_AUTHORIZED, &sta->_flags);
 		}
+		if (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
+		    sta->sdata->vif.type == NL80211_IFTYPE_AP)
+			cfg80211_send_layer2_update(sta->sdata->dev,
+						    sta->sta.addr);
 		break;
 	default:
 		break;

