Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4BD0189211
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgCQX2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:28:17 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53930 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727150AbgCQX2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:28:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jv7J4dIkq7R+X/Rjr5nFOC6dSbsQNjiSXaK8/wc3pZ0=;
        b=diF49X05O50nDaysWk5G1fLShw1F8iyoQIpGUyIu3VaSz0zajgTT6jGGiAHu5lkUzmJjQR
        iAbmZ7Q/v7mjBbHU0JynQBP+400RfkUburWeFs12GdO2f3H5O0/UanzhbiIDU7gFDtch7j
        X9ty2wL+YP8VOo3dkq+mFq9SFZOcpfs=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Matthias Schiffer <mschiffer@universe-factory.net>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 32/48] batman-adv: Fix skbuff rcsum on packet reroute
Date:   Wed, 18 Mar 2020 00:27:18 +0100
Message-Id: <20200317232734.6127-33-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit fc04fdb2c8a894283259f5621d31d75610701091 upstream.

batadv_check_unicast_ttvn may redirect a packet to itself or another
originator. This involves rewriting the ttvn and the destination address in
the batadv unicast header. These field were not yet pulled (with skb rcsum
update) and thus any change to them also requires a change in the receive
checksum.

Reported-by: Matthias Schiffer <mschiffer@universe-factory.net>
Fixes: a73105b8d4c7 ("batman-adv: improved client announcement mechanism")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/routing.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/batman-adv/routing.c b/net/batman-adv/routing.c
index b8ff2a17b7ef..b3e8b0e3073c 100644
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -704,6 +704,7 @@ out:
 /**
  * batadv_reroute_unicast_packet - update the unicast header for re-routing
  * @bat_priv: the bat priv with all the soft interface information
+ * @skb: unicast packet to process
  * @unicast_packet: the unicast header to be updated
  * @dst_addr: the payload destination
  * @vid: VLAN identifier
@@ -715,7 +716,7 @@ out:
  * Returns true if the packet header has been updated, false otherwise
  */
 static bool
-batadv_reroute_unicast_packet(struct batadv_priv *bat_priv,
+batadv_reroute_unicast_packet(struct batadv_priv *bat_priv, struct sk_buff *skb,
 			      struct batadv_unicast_packet *unicast_packet,
 			      u8 *dst_addr, unsigned short vid)
 {
@@ -744,8 +745,10 @@ batadv_reroute_unicast_packet(struct batadv_priv *bat_priv,
 	}
 
 	/* update the packet header */
+	skb_postpull_rcsum(skb, unicast_packet, sizeof(*unicast_packet));
 	ether_addr_copy(unicast_packet->dest, orig_addr);
 	unicast_packet->ttvn = orig_ttvn;
+	skb_postpush_rcsum(skb, unicast_packet, sizeof(*unicast_packet));
 
 	ret = true;
 out:
@@ -785,7 +788,7 @@ static int batadv_check_unicast_ttvn(struct batadv_priv *bat_priv,
 	 * the packet to
 	 */
 	if (batadv_tt_local_client_is_roaming(bat_priv, ethhdr->h_dest, vid)) {
-		if (batadv_reroute_unicast_packet(bat_priv, unicast_packet,
+		if (batadv_reroute_unicast_packet(bat_priv, skb, unicast_packet,
 						  ethhdr->h_dest, vid))
 			batadv_dbg_ratelimited(BATADV_DBG_TT,
 					       bat_priv,
@@ -831,7 +834,7 @@ static int batadv_check_unicast_ttvn(struct batadv_priv *bat_priv,
 	 * destination can possibly be updated and forwarded towards the new
 	 * target host
 	 */
-	if (batadv_reroute_unicast_packet(bat_priv, unicast_packet,
+	if (batadv_reroute_unicast_packet(bat_priv, skb, unicast_packet,
 					  ethhdr->h_dest, vid)) {
 		batadv_dbg_ratelimited(BATADV_DBG_TT, bat_priv,
 				       "Rerouting unicast packet to %pM (dst=%pM): TTVN mismatch old_ttvn=%u new_ttvn=%u\n",
@@ -854,12 +857,14 @@ static int batadv_check_unicast_ttvn(struct batadv_priv *bat_priv,
 	if (!primary_if)
 		return 0;
 
+	/* update the packet header */
+	skb_postpull_rcsum(skb, unicast_packet, sizeof(*unicast_packet));
 	ether_addr_copy(unicast_packet->dest, primary_if->net_dev->dev_addr);
+	unicast_packet->ttvn = curr_ttvn;
+	skb_postpush_rcsum(skb, unicast_packet, sizeof(*unicast_packet));
 
 	batadv_hardif_free_ref(primary_if);
 
-	unicast_packet->ttvn = curr_ttvn;
-
 	return 1;
 }
 
-- 
2.20.1

