Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9769218B804
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgCSNIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:08:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727347AbgCSNIE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:08:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC61D212CC;
        Thu, 19 Mar 2020 13:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623284;
        bh=Cp+SLVCAg4c/eX0FNwPEPztrEvszoFpfDRqmJlRSRDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pe5YXhMCKrovaav4dsd2UN57kZxfP03I16QWJA3wbekd0LEa0JJ9LtV5/KtjwOdXq
         lUFJR1rlkJ4i72OO6jz3tql4/Mi46gg+xtsvTNRtrhFgw6VKZLxOUnzc9+KAAssoDb
         +DWqlPP7ds4cfrZFrbl7ZoLQNRer7odFAxNJicwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Schiffer <mschiffer@universe-factory.net>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 69/93] batman-adv: Fix skbuff rcsum on packet reroute
Date:   Thu, 19 Mar 2020 14:00:13 +0100
Message-Id: <20200319123946.936300142@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123924.795019515@linuxfoundation.org>
References: <20200319123924.795019515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/routing.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

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
@@ -744,8 +745,10 @@ batadv_reroute_unicast_packet(struct bat
 	}
 
 	/* update the packet header */
+	skb_postpull_rcsum(skb, unicast_packet, sizeof(*unicast_packet));
 	ether_addr_copy(unicast_packet->dest, orig_addr);
 	unicast_packet->ttvn = orig_ttvn;
+	skb_postpush_rcsum(skb, unicast_packet, sizeof(*unicast_packet));
 
 	ret = true;
 out:
@@ -785,7 +788,7 @@ static int batadv_check_unicast_ttvn(str
 	 * the packet to
 	 */
 	if (batadv_tt_local_client_is_roaming(bat_priv, ethhdr->h_dest, vid)) {
-		if (batadv_reroute_unicast_packet(bat_priv, unicast_packet,
+		if (batadv_reroute_unicast_packet(bat_priv, skb, unicast_packet,
 						  ethhdr->h_dest, vid))
 			batadv_dbg_ratelimited(BATADV_DBG_TT,
 					       bat_priv,
@@ -831,7 +834,7 @@ static int batadv_check_unicast_ttvn(str
 	 * destination can possibly be updated and forwarded towards the new
 	 * target host
 	 */
-	if (batadv_reroute_unicast_packet(bat_priv, unicast_packet,
+	if (batadv_reroute_unicast_packet(bat_priv, skb, unicast_packet,
 					  ethhdr->h_dest, vid)) {
 		batadv_dbg_ratelimited(BATADV_DBG_TT, bat_priv,
 				       "Rerouting unicast packet to %pM (dst=%pM): TTVN mismatch old_ttvn=%u new_ttvn=%u\n",
@@ -854,12 +857,14 @@ static int batadv_check_unicast_ttvn(str
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
 


