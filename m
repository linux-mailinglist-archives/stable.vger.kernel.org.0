Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA585457E35
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 13:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbhKTMmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Nov 2021 07:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbhKTMmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Nov 2021 07:42:47 -0500
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00575C06173E
        for <stable@vger.kernel.org>; Sat, 20 Nov 2021 04:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1637411981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D2Zt3+lA2sYSSk7jceFNezZYAdSOoveVQg/mf+lksSc=;
        b=E9ewx4ThRJkEkzIvuj3fclf0YyNljDhDOyfnUqbGwm7Cd7bBPLyPbi6eQUyhGYqn4VtwD2
        GICXJsUhLp5TctmcwzxDWDI+F5TYXJxCGZSgPE0rGUgXSzs75XpNrIUhoVU4zVdNpgKUdt
        L5EVcS7QX7TEIXHW35OnwzKOItIlp/4=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Martin Weinelt <martin@darmstadt.freifunk.net>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 01/11] batman-adv: Keep fragments equally sized
Date:   Sat, 20 Nov 2021 13:39:29 +0100
Message-Id: <20211120123939.260723-2-sven@narfation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211120123939.260723-1-sven@narfation.org>
References: <20211120123939.260723-1-sven@narfation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 1c2bcc766be44467809f1798cd4ceacafe20a852 upstream.

The batman-adv fragmentation packets have the design problem that they
cannot be refragmented and cannot handle padding by the underlying link.
The latter often leads to problems when networks are incorrectly configured
and don't use a common MTU.

The sender could for example fragment a 1271 byte frame (plus external
ethernet header (14) and batadv unicast header (10)) to fit in a 1280 bytes
large MTU of the underlying link (max. 1294 byte frames). This would create
a 1294 bytes large frame (fragment 2) and a 55 bytes large frame
(fragment 1). The extra 54 bytes are the fragment header (20) added to each
fragment and the external ethernet header (14) for the second fragment.

Let us assume that the next hop is then not able to transport 1294 bytes to
its next hop. The 1294 byte large frame will be dropped but the 55 bytes
large fragment will still be forwarded to its destination.

Or let us assume that the underlying hardware requires that each frame has
a minimum size (e.g. 60 bytes). Then it will pad the 55 bytes frame to 60
bytes. The receiver of the 60 bytes frame will no longer be able to
correctly assemble the two frames together because it is not aware that 5
bytes of the 60 bytes frame are padding and don't belong to the reassembled
frame.

This can partly be avoided by splitting frames more equally. In this
example, the 675 and 674 bytes large fragment frames could both potentially
reach its destination without being too large or too small.

Reported-by: Martin Weinelt <martin@darmstadt.freifunk.net>
Fixes: ee75ed88879a ("batman-adv: Fragment and send skbs larger than mtu")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Acked-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
[ bp: 4.4 backported: adjust context, switch back to old return type +
  labels ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 net/batman-adv/fragmentation.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/batman-adv/fragmentation.c b/net/batman-adv/fragmentation.c
index 9751b207b01f..3aceac21b283 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -396,7 +396,7 @@ bool batadv_frag_skb_fwd(struct sk_buff *skb,
  * batadv_frag_create - create a fragment from skb
  * @skb: skb to create fragment from
  * @frag_head: header to use in new fragment
- * @mtu: size of new fragment
+ * @fragment_size: size of new fragment
  *
  * Split the passed skb into two fragments: A new one with size matching the
  * passed mtu and the old one with the rest. The new skb contains data from the
@@ -406,11 +406,11 @@ bool batadv_frag_skb_fwd(struct sk_buff *skb,
  */
 static struct sk_buff *batadv_frag_create(struct sk_buff *skb,
 					  struct batadv_frag_packet *frag_head,
-					  unsigned int mtu)
+					  unsigned int fragment_size)
 {
 	struct sk_buff *skb_fragment;
 	unsigned header_size = sizeof(*frag_head);
-	unsigned fragment_size = mtu - header_size;
+	unsigned mtu = fragment_size + header_size;
 
 	skb_fragment = netdev_alloc_skb(NULL, mtu + ETH_HLEN);
 	if (!skb_fragment)
@@ -448,7 +448,7 @@ bool batadv_frag_send_packet(struct sk_buff *skb,
 	struct sk_buff *skb_fragment;
 	unsigned mtu = neigh_node->if_incoming->net_dev->mtu;
 	unsigned header_size = sizeof(frag_header);
-	unsigned max_fragment_size, max_packet_size;
+	unsigned max_fragment_size, num_fragments;
 	bool ret = false;
 
 	/* To avoid merge and refragmentation at next-hops we never send
@@ -456,10 +456,15 @@ bool batadv_frag_send_packet(struct sk_buff *skb,
 	 */
 	mtu = min_t(unsigned, mtu, BATADV_FRAG_MAX_FRAG_SIZE);
 	max_fragment_size = mtu - header_size;
-	max_packet_size = max_fragment_size * BATADV_FRAG_MAX_FRAGMENTS;
+
+	if (skb->len == 0 || max_fragment_size == 0)
+		goto out_err;
+
+	num_fragments = (skb->len - 1) / max_fragment_size + 1;
+	max_fragment_size = (skb->len - 1) / num_fragments + 1;
 
 	/* Don't even try to fragment, if we need more than 16 fragments */
-	if (skb->len > max_packet_size)
+	if (num_fragments > BATADV_FRAG_MAX_FRAGMENTS)
 		goto out_err;
 
 	bat_priv = orig_node->bat_priv;
@@ -484,7 +489,8 @@ bool batadv_frag_send_packet(struct sk_buff *skb,
 		if (frag_header.no == BATADV_FRAG_MAX_FRAGMENTS - 1)
 			goto out_err;
 
-		skb_fragment = batadv_frag_create(skb, &frag_header, mtu);
+		skb_fragment = batadv_frag_create(skb, &frag_header,
+						  max_fragment_size);
 		if (!skb_fragment)
 			goto out_err;
 
-- 
2.30.2

