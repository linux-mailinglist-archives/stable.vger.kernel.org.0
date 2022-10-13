Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57CA35FE2C1
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 21:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbiJMTgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 15:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiJMTgJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 15:36:09 -0400
X-Greylist: delayed 1800 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 13 Oct 2022 12:36:07 PDT
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39DB16F429
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 12:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mJS0d4bptxbGn9ITAyYbtCQFlxXnLiDrC0JZCWh0t1E=; b=PDB5ENLc/os2/u33CgWw3JBzQc
        NWalXTaYmc7GyixvQ6c2Dy6rcADuUjDz8tJws5FknizZ6+9Aj0sWdwQhPlFdzo8UhSJEliInnQvj8
        wthI3TGpikp29oe7/bzd2m57LRSDdyoz4MsJZhDi0z2dDujfUGYY8YmeDF5vosjHf6k4=;
Received: from p200300daa7301d0028e1e1004b08c350.dip0.t-ipconnect.de ([2003:da:a730:1d00:28e1:e100:4b08:c350] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1oj2kV-00CXRx-88; Thu, 13 Oct 2022 20:16:03 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     stable@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH 5.15 5/6] mac80211: fix memory leaks with element parsing
Date:   Thu, 13 Oct 2022 20:16:00 +0200
Message-Id: <20221013181601.5712-5-nbd@nbd.name>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221013181601.5712-1-nbd@nbd.name>
References: <20221013181601.5712-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 8223ac199a3849257e86ec27865dc63f034b1cf1 upstream.

My previous commit 5d24828d05f3 ("mac80211: always allocate
struct ieee802_11_elems") had a few bugs and leaked the new
allocated struct in a few error cases, fix that.

Fixes: 5d24828d05f3 ("mac80211: always allocate struct ieee802_11_elems")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20211001211108.9839928e42e0.Ib81ca187d3d3af7ed1bfeac2e00d08a4637c8025@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-rx.c |  3 ++-
 net/mac80211/ibss.c   | 10 +++++-----
 net/mac80211/mlme.c   | 36 ++++++++++++++++++------------------
 3 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index ffa4f31f6c2b..0d2bab9d351c 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -499,13 +499,14 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 		elems = ieee802_11_parse_elems(mgmt->u.action.u.addba_req.variable,
 					       ies_len, true, mgmt->bssid, NULL);
 		if (!elems || elems->parse_error)
-			return;
+			goto free;
 	}
 
 	__ieee80211_start_rx_ba_session(sta, dialog_token, timeout,
 					start_seq_num, ba_policy, tid,
 					buf_size, true, false,
 					elems ? elems->addba_ext_ie : NULL);
+free:
 	kfree(elems);
 }
 
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 4b721b48f86a..48e0260f3424 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1663,11 +1663,11 @@ void ieee80211_ibss_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 				mgmt->u.action.u.chan_switch.variable,
 				ies_len, true, mgmt->bssid, NULL);
 
-			if (!elems || elems->parse_error)
-				break;
-
-			ieee80211_rx_mgmt_spectrum_mgmt(sdata, mgmt, skb->len,
-							rx_status, elems);
+			if (elems && !elems->parse_error)
+				ieee80211_rx_mgmt_spectrum_mgmt(sdata, mgmt,
+								skb->len,
+								rx_status,
+								elems);
 			kfree(elems);
 			break;
 		}
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 45efa1d1c550..cc6d38a2e6d5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3374,8 +3374,10 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 			bss_ies = kmemdup(ies, sizeof(*ies) + ies->len,
 					  GFP_ATOMIC);
 		rcu_read_unlock();
-		if (!bss_ies)
-			return false;
+		if (!bss_ies) {
+			ret = false;
+			goto out;
+		}
 
 		bss_elems = ieee802_11_parse_elems(bss_ies->data, bss_ies->len,
 						   false, mgmt->bssid,
@@ -4358,13 +4360,11 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 					mgmt->u.action.u.chan_switch.variable,
 					ies_len, true, mgmt->bssid, NULL);
 
-			if (!elems || elems->parse_error)
-				break;
-
-			ieee80211_sta_process_chanswitch(sdata,
-						 rx_status->mactime,
-						 rx_status->device_timestamp,
-						 elems, false);
+			if (elems && !elems->parse_error)
+				ieee80211_sta_process_chanswitch(sdata,
+								 rx_status->mactime,
+								 rx_status->device_timestamp,
+								 elems, false);
 			kfree(elems);
 		} else if (mgmt->u.action.category == WLAN_CATEGORY_PUBLIC) {
 			struct ieee802_11_elems *elems;
@@ -4384,17 +4384,17 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 					mgmt->u.action.u.ext_chan_switch.variable,
 					ies_len, true, mgmt->bssid, NULL);
 
-			if (!elems || elems->parse_error)
-				break;
+			if (elems && !elems->parse_error) {
+				/* for the handling code pretend it was an IE */
+				elems->ext_chansw_ie =
+					&mgmt->u.action.u.ext_chan_switch.data;
 
-			/* for the handling code pretend this was also an IE */
-			elems->ext_chansw_ie =
-				&mgmt->u.action.u.ext_chan_switch.data;
+				ieee80211_sta_process_chanswitch(sdata,
+								 rx_status->mactime,
+								 rx_status->device_timestamp,
+								 elems, false);
+			}
 
-			ieee80211_sta_process_chanswitch(sdata,
-						 rx_status->mactime,
-						 rx_status->device_timestamp,
-						 elems, false);
 			kfree(elems);
 		}
 		break;
-- 
2.36.1

