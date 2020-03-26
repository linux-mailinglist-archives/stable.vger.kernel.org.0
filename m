Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB694194203
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 15:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgCZOvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 10:51:50 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:48756 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgCZOvt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 10:51:49 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jHTrH-00BYfo-Gx; Thu, 26 Mar 2020 15:51:47 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Jouni Malinen <jouni@codeaurora.org>, stable@vger.kernel.org
Subject: [PATCH 1/2] mac80211: Check port authorization in the ieee80211_tx_dequeue() case
Date:   Thu, 26 Mar 2020 15:51:34 +0100
Message-Id: <20200326155133.ced84317ea29.I34d4c47cd8cc8a4042b38a76f16a601fbcbfd9b3@changeid>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jouni Malinen <jouni@codeaurora.org>

mac80211 used to check port authorization in the Data frame enqueue case
when going through start_xmit(). However, that authorization status may
change while the frame is waiting in a queue. Add a similar check in the
dequeue case to avoid sending previously accepted frames after
authorization change. This provides additional protection against
potential leaking of frames after a station has been disconnected and
the keys for it are being removed.

Cc: stable@vger.kernel.org
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 7dbfb9e3cd84..455eb8e6a459 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3604,8 +3604,25 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	tx.skb = skb;
 	tx.sdata = vif_to_sdata(info->control.vif);
 
-	if (txq->sta)
+	if (txq->sta) {
 		tx.sta = container_of(txq->sta, struct sta_info, sta);
+		/*
+		 * Drop unicast frames to unauthorised stations unless they are
+		 * EAPOL frames from the local station.
+		 */
+		if (unlikely(!ieee80211_vif_is_mesh(&tx.sdata->vif) &&
+			     tx.sdata->vif.type != NL80211_IFTYPE_OCB &&
+			     !is_multicast_ether_addr(hdr->addr1) &&
+			     !test_sta_flag(tx.sta, WLAN_STA_AUTHORIZED) &&
+			     (!(info->control.flags &
+				IEEE80211_TX_CTRL_PORT_CTRL_PROTO) ||
+			      !ether_addr_equal(tx.sdata->vif.addr,
+						hdr->addr2)))) {
+			I802_DEBUG_INC(local->tx_handlers_drop_unauth_port);
+			ieee80211_free_txskb(&local->hw, skb);
+			goto begin;
+		}
+	}
 
 	/*
 	 * The key can be removed while the packet was queued, so need to call
-- 
2.25.1

