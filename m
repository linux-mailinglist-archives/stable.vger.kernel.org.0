Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22583968E7
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 22:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbhEaUdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 16:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbhEaUdA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 16:33:00 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4DCC06138B;
        Mon, 31 May 2021 13:30:33 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lnoYR-000F87-A8; Mon, 31 May 2021 22:30:31 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Jouni Malinen <jouni@codeaurora.org>
Subject: [PATCH v4.9 09/10] mac80211: do not accept/forward invalid EAPOL frames
Date:   Mon, 31 May 2021 22:30:20 +0200
Message-Id: <20210531203021.180010-10-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531203021.180010-1-johannes@sipsolutions.net>
References: <20210531203021.180010-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit a8c4d76a8dd4fb9666fc8919a703d85fb8f44ed8 upstream.

EAPOL frames are used for authentication and key management between the
AP and each individual STA associated in the BSS. Those frames are not
supposed to be sent by one associated STA to another associated STA
(either unicast for broadcast/multicast).

Similarly, in 802.11 they're supposed to be sent to the authenticator
(AP) address.

Since it is possible for unexpected EAPOL frames to result in misbehavior
in supplicant implementations, it is better for the AP to not allow such
cases to be forwarded to other clients either directly, or indirectly if
the AP interface is part of a bridge.

Accept EAPOL (control port) frames only if they're transmitted to the
own address, or, due to interoperability concerns, to the PAE group
address.

Disable forwarding of EAPOL (or well, the configured control port
protocol) frames back to wireless medium in all cases. Previously, these
frames were accepted from fully authenticated and authorized stations
and also from unauthenticated stations for one of the cases.

Additionally, to avoid forwarding by the bridge, rewrite the PAE group
address case to the local MAC address.

Cc: stable@vger.kernel.org
Co-developed-by: Jouni Malinen <jouni@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Link: https://lore.kernel.org/r/20210511200110.cb327ed0cabe.Ib7dcffa2a31f0913d660de65ba3c8aca75b1d10f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 9e0bcffbc3ed..21d44829a645 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2276,13 +2276,13 @@ static bool ieee80211_frame_allowed(struct ieee80211_rx_data *rx, __le16 fc)
 	struct ethhdr *ehdr = (struct ethhdr *) rx->skb->data;
 
 	/*
-	 * Allow EAPOL frames to us/the PAE group address regardless
-	 * of whether the frame was encrypted or not.
+	 * Allow EAPOL frames to us/the PAE group address regardless of
+	 * whether the frame was encrypted or not, and always disallow
+	 * all other destination addresses for them.
 	 */
-	if (ehdr->h_proto == rx->sdata->control_port_protocol &&
-	    (ether_addr_equal(ehdr->h_dest, rx->sdata->vif.addr) ||
-	     ether_addr_equal(ehdr->h_dest, pae_group_addr)))
-		return true;
+	if (unlikely(ehdr->h_proto == rx->sdata->control_port_protocol))
+		return ether_addr_equal(ehdr->h_dest, rx->sdata->vif.addr) ||
+		       ether_addr_equal(ehdr->h_dest, pae_group_addr);
 
 	if (ieee80211_802_1x_port_control(rx) ||
 	    ieee80211_drop_unencrypted(rx, fc))
@@ -2322,6 +2322,7 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 	if ((sdata->vif.type == NL80211_IFTYPE_AP ||
 	     sdata->vif.type == NL80211_IFTYPE_AP_VLAN) &&
 	    !(sdata->flags & IEEE80211_SDATA_DONT_BRIDGE_PACKETS) &&
+	    ehdr->h_proto != rx->sdata->control_port_protocol &&
 	    (sdata->vif.type != NL80211_IFTYPE_AP_VLAN || !sdata->u.vlan.sta)) {
 		if (is_multicast_ether_addr(ehdr->h_dest)) {
 			/*
@@ -2374,9 +2375,30 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 #endif
 
 	if (skb) {
+		struct ethhdr *ehdr = (void *)skb_mac_header(skb);
+
 		/* deliver to local stack */
 		skb->protocol = eth_type_trans(skb, dev);
 		memset(skb->cb, 0, sizeof(skb->cb));
+
+		/*
+		 * 802.1X over 802.11 requires that the authenticator address
+		 * be used for EAPOL frames. However, 802.1X allows the use of
+		 * the PAE group address instead. If the interface is part of
+		 * a bridge and we pass the frame with the PAE group address,
+		 * then the bridge will forward it to the network (even if the
+		 * client was not associated yet), which isn't supposed to
+		 * happen.
+		 * To avoid that, rewrite the destination address to our own
+		 * address, so that the authenticator (e.g. hostapd) will see
+		 * the frame, but bridge won't forward it anywhere else. Note
+		 * that due to earlier filtering, the only other address can
+		 * be the PAE group address.
+		 */
+		if (unlikely(skb->protocol == sdata->control_port_protocol &&
+			     !ether_addr_equal(ehdr->h_dest, sdata->vif.addr)))
+			ether_addr_copy(ehdr->h_dest, sdata->vif.addr);
+
 		if (rx->napi)
 			napi_gro_receive(rx->napi, skb);
 		else
-- 
2.31.1

