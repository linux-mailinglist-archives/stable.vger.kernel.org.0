Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B90B6B1FE0
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388579AbfIMNKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:10:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388665AbfIMNKG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:10:06 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5282214D8;
        Fri, 13 Sep 2019 13:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380205;
        bh=a2w4CYDBcGWKAeQc/xMACf+a/RKVnsKjdeVupWJ8Ix8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VtA2iz2nU1EYIUjq5XD/G9OQEWAG7/0zf82lr/ScvBgvX3AGm5VNtgmL5+dfR30h7
         y7AqP0JXbe/yPxGl/eA99L0KX4/aMVlwwpObgjCuk2zaiTfY34Y/YDoVEB+gpJ8Y5e
         YR3GFhwsrG1lOLMs7OEjNqAB4U0BL9oTTJhOQ5uU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+355cab184197dbbfa384@syzkaller.appspotmail.com,
        Sven Eckelmann <sven@narfation.org>,
        Antonio Quartulli <a@unstable.cc>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.14 13/21] batman-adv: Only read OGM tvlv_len after buffer len check
Date:   Fri, 13 Sep 2019 14:07:06 +0100
Message-Id: <20190913130506.836333693@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130501.285837292@linuxfoundation.org>
References: <20190913130501.285837292@linuxfoundation.org>
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
 net/batman-adv/bat_iv_ogm.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -450,17 +450,23 @@ static u8 batadv_hop_penalty(u8 tq, cons
  * batadv_iv_ogm_aggr_packet - checks if there is another OGM attached
  * @buff_pos: current position in the skb
  * @packet_len: total length of the skb
- * @tvlv_len: tvlv length of the previously considered OGM
+ * @ogm_packet: potential OGM in buffer
  *
  * Return: true if there is enough space for another OGM, false otherwise.
  */
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
@@ -488,7 +494,7 @@ static void batadv_iv_ogm_send_to_if(str
 
 	/* adjust all flags and log packets */
 	while (batadv_iv_ogm_aggr_packet(buff_pos, forw_packet->packet_len,
-					 batadv_ogm_packet->tvlv_len)) {
+					 batadv_ogm_packet)) {
 		/* we might have aggregated direct link packets with an
 		 * ordinary base packet
 		 */
@@ -1838,7 +1844,7 @@ static int batadv_iv_ogm_receive(struct
 
 	/* unpack the aggregated packets and process them one by one */
 	while (batadv_iv_ogm_aggr_packet(ogm_offset, skb_headlen(skb),
-					 ogm_packet->tvlv_len)) {
+					 ogm_packet)) {
 		batadv_iv_ogm_process(skb, ogm_offset, if_incoming);
 
 		ogm_offset += BATADV_OGM_HLEN;


