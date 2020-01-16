Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B92BA13FEA6
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390484AbgAPXbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:31:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:39008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391472AbgAPXbL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:31:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7646D2072E;
        Thu, 16 Jan 2020 23:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217470;
        bh=hB5BWWxIKoqnN8wYNVmuKsmyHSS/5JsQbHctyTPH+BA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tr8B2sMC3Xotg9/LaFvKyRf4vN/TH7VYtkTDaf9IjuWE0mTXdLm1eKbj1MRSmRnx7
         v8PAmjsKPdEHD1Dno2fuaBPZYZZ4wRuEStP+9q1W8iqb2hYDtP+RBua2bggd/Sgmxa
         zzxrXggs3LHrI4gdwfHx4/6pu/5YTN0dWdkbviOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jouni Malinen <jouni@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.14 12/71] mac80211: Do not send Layer 2 Update frame before authorization
Date:   Fri, 17 Jan 2020 00:18:10 +0100
Message-Id: <20200116231711.224146351@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231709.377772748@linuxfoundation.org>
References: <20200116231709.377772748@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/cfg.c      |   14 ++++----------
 net/mac80211/sta_info.c |    4 ++++
 2 files changed, 8 insertions(+), 10 deletions(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1398,7 +1398,6 @@ static int ieee80211_add_station(struct
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata;
 	int err;
-	int layer2_update;
 
 	if (params->vlan) {
 		sdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
@@ -1442,18 +1441,12 @@ static int ieee80211_add_station(struct
 	    test_sta_flag(sta, WLAN_STA_ASSOC))
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
@@ -1551,10 +1544,11 @@ static int ieee80211_change_station(stru
 		sta->sdata = vlansdata;
 		ieee80211_check_fast_xmit(sta);
 
-		if (test_sta_flag(sta, WLAN_STA_AUTHORIZED))
+		if (test_sta_flag(sta, WLAN_STA_AUTHORIZED)) {
 			ieee80211_vif_inc_num_mcast(sta->sdata);
-
-		cfg80211_send_layer2_update(sta->sdata->dev, sta->sta.addr);
+			cfg80211_send_layer2_update(sta->sdata->dev,
+						    sta->sta.addr);
+		}
 	}
 
 	err = sta_apply_parameters(local, sta, params);
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1899,6 +1899,10 @@ int sta_info_move_state(struct sta_info
 			ieee80211_check_fast_xmit(sta);
 			ieee80211_check_fast_rx(sta);
 		}
+		if (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
+		    sta->sdata->vif.type == NL80211_IFTYPE_AP)
+			cfg80211_send_layer2_update(sta->sdata->dev,
+						    sta->sta.addr);
 		break;
 	default:
 		break;


