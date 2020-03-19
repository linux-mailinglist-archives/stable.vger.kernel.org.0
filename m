Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFB318B7F7
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727564AbgCSNgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:36:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728194AbgCSNIr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:08:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 462B120936;
        Thu, 19 Mar 2020 13:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623326;
        bh=mJ9L47MrdCzrfZVD+rdRCPGhilg+RyR1RNnSX7ozW+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yz5IrafECha1J286HwVyzsJC7hCx9sRZem9DsQKmh5keC8nlanxq1guZA/p0mbwH4
         0+qS1DM35YGfKPYgajeWgHOT62LCjCHybR3iqug4eSQegLHMvNhk2myHlRPaCdrdEF
         I+uUi96kgtakkOqQnCj8rXzlDKMVfXVzTdqqnfOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        syzbot+355cab184197dbbfa384@syzkaller.appspotmail.com,
        Sven Eckelmann <sven@narfation.org>,
        Antonio Quartulli <a@unstable.cc>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 83/93] batman-adv: Only read OGM tvlv_len after buffer len check
Date:   Thu, 19 Mar 2020 14:00:27 +0100
Message-Id: <20200319123950.832859098@linuxfoundation.org>
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

commit a15d56a60760aa9dbe26343b9a0ac5228f35d445 upstream.

Multiple batadv_ogm_packet can be stored in an skbuff. The functions
batadv_iv_ogm_send_to_if()/batadv_iv_ogm_receive() use
batadv_iv_ogm_aggr_packet() to check if there is another additional
batadv_ogm_packet in the skb or not before they continue processing the
packet.

The length for such an OGM is BATADV_OGM_HLEN +
batadv_ogm_packet->tvlv_len. The check must first check that at least
BATADV_OGM_HLEN bytes are available before it accesses tvlv_len (which is
part of the header. Otherwise it might try read outside of the currently
available skbuff to get the content of tvlv_len.

Fixes: ef26157747d4 ("batman-adv: tvlv - basic infrastructure")
Reported-by: syzbot+355cab184197dbbfa384@syzkaller.appspotmail.com
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Acked-by: Antonio Quartulli <a@unstable.cc>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bat_iv_ogm.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -397,14 +397,19 @@ static u8 batadv_hop_penalty(u8 tq, cons
 	return new_tq;
 }
 
-/* is there another aggregated packet here? */
-static bool batadv_iv_ogm_aggr_packet(int buff_pos, int packet_len,
-				      __be16 tvlv_len)
+static bool
+batadv_iv_ogm_aggr_packet(int buff_pos, int packet_len,
+			  const struct batadv_ogm_packet *ogm_packet)
 {
 	int next_buff_pos = 0;
 
-	next_buff_pos += buff_pos + BATADV_OGM_HLEN;
-	next_buff_pos += ntohs(tvlv_len);
+	/* check if there is enough space for the header */
+	next_buff_pos += buff_pos + sizeof(*ogm_packet);
+	if (next_buff_pos > packet_len)
+		return false;
+
+	/* check if there is enough space for the optional TVLV */
+	next_buff_pos += ntohs(ogm_packet->tvlv_len);
 
 	return (next_buff_pos <= packet_len) &&
 	       (next_buff_pos <= BATADV_MAX_AGGREGATION_BYTES);
@@ -432,7 +437,7 @@ static void batadv_iv_ogm_send_to_if(str
 
 	/* adjust all flags and log packets */
 	while (batadv_iv_ogm_aggr_packet(buff_pos, forw_packet->packet_len,
-					 batadv_ogm_packet->tvlv_len)) {
+					 batadv_ogm_packet)) {
 		/* we might have aggregated direct link packets with an
 		 * ordinary base packet
 		 */
@@ -1751,7 +1756,7 @@ static int batadv_iv_ogm_receive(struct
 
 	/* unpack the aggregated packets and process them one by one */
 	while (batadv_iv_ogm_aggr_packet(ogm_offset, skb_headlen(skb),
-					 ogm_packet->tvlv_len)) {
+					 ogm_packet)) {
 		batadv_iv_ogm_process(skb, ogm_offset, if_incoming);
 
 		ogm_offset += BATADV_OGM_HLEN;


