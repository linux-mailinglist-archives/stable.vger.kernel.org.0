Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23118395DD9
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbhEaNv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:51:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:50924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232806AbhEaNsk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:48:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F94661626;
        Mon, 31 May 2021 13:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467874;
        bh=jlCZNKQLIK2O2LtV10Z5sDTQN/1KiBT3/FhHnfJQa0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B9HPWXXiVfXSGh/ggW/7V2TAtlYUKrD5myUvIAlJ8m71EcEdvAjWBt4qa/7GiEb73
         p/ZohnZV3eYR4ypkoLh9g8uHEem9iL/3OFTiv/86C3EGIo6OHOIMMA2U/FfE+dFr8Q
         S2eT/S7ZP4pcctxeSHqkeFlW2FpZBLu42+kM1uDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jouni Malinen <jouni@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 031/252] mac80211: do not accept/forward invalid EAPOL frames
Date:   Mon, 31 May 2021 15:11:36 +0200
Message-Id: <20210531130659.035989834@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/rx.c |   33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2541,13 +2541,13 @@ static bool ieee80211_frame_allowed(stru
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
@@ -2572,8 +2572,28 @@ static void ieee80211_deliver_skb_to_loc
 		cfg80211_rx_control_port(dev, skb, noencrypt);
 		dev_kfree_skb(skb);
 	} else {
+		struct ethhdr *ehdr = (void *)skb_mac_header(skb);
+
 		memset(skb->cb, 0, sizeof(skb->cb));
 
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
 		/* deliver to local stack */
 		if (rx->list)
 			list_add_tail(&skb->list, rx->list);
@@ -2613,6 +2633,7 @@ ieee80211_deliver_skb(struct ieee80211_r
 	if ((sdata->vif.type == NL80211_IFTYPE_AP ||
 	     sdata->vif.type == NL80211_IFTYPE_AP_VLAN) &&
 	    !(sdata->flags & IEEE80211_SDATA_DONT_BRIDGE_PACKETS) &&
+	    ehdr->h_proto != rx->sdata->control_port_protocol &&
 	    (sdata->vif.type != NL80211_IFTYPE_AP_VLAN || !sdata->u.vlan.sta)) {
 		if (is_multicast_ether_addr(ehdr->h_dest) &&
 		    ieee80211_vif_get_num_mcast_if(sdata) != 0) {


