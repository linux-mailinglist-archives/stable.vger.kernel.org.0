Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F43945BC88
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245082AbhKXMbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:31:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:42282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244323AbhKXM1D (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:27:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC6E061241;
        Wed, 24 Nov 2021 12:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756194;
        bh=1BVPdN4QLiMMBKH9SxvscAvHKv04yir39+uRLmntIwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aNDg4KSn7QUAzJ8Fe2AZOFK2zVHuKvPdDZnxj6MecGREagMFdHCHNOAzTCvOwEW8q
         iyIGvTew9XMZd4Uo/lvuEFYTlZ6mZUqiYylr8ACh5cHSfXyOUTckFXy6K4hzMubDSW
         Nz6OoMCSqId5zMYjPEky4vn0gY0lwfc0IYpfv7fo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Weinelt <martin@darmstadt.freifunk.net>,
        Sven Eckelmann <sven@narfation.org>,
        =?UTF-8?q?Linus=20L=FCssing?= <linus.luessing@c0d3.blue>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.9 198/207] batman-adv: Keep fragments equally sized
Date:   Wed, 24 Nov 2021 12:57:49 +0100
Message-Id: <20211124115710.358366672@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

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
[ bp: 4.9 backported: adjust context. ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/fragmentation.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -396,7 +396,7 @@ out:
  * batadv_frag_create - create a fragment from skb
  * @skb: skb to create fragment from
  * @frag_head: header to use in new fragment
- * @mtu: size of new fragment
+ * @fragment_size: size of new fragment
  *
  * Split the passed skb into two fragments: A new one with size matching the
  * passed mtu and the old one with the rest. The new skb contains data from the
@@ -406,11 +406,11 @@ out:
  */
 static struct sk_buff *batadv_frag_create(struct sk_buff *skb,
 					  struct batadv_frag_packet *frag_head,
-					  unsigned int mtu)
+					  unsigned int fragment_size)
 {
 	struct sk_buff *skb_fragment;
 	unsigned int header_size = sizeof(*frag_head);
-	unsigned int fragment_size = mtu - header_size;
+	unsigned int mtu = fragment_size + header_size;
 
 	skb_fragment = netdev_alloc_skb(NULL, mtu + ETH_HLEN);
 	if (!skb_fragment)
@@ -449,7 +449,7 @@ int batadv_frag_send_packet(struct sk_bu
 	struct sk_buff *skb_fragment;
 	unsigned int mtu = neigh_node->if_incoming->net_dev->mtu;
 	unsigned int header_size = sizeof(frag_header);
-	unsigned int max_fragment_size, max_packet_size;
+	unsigned int max_fragment_size, num_fragments;
 	int ret = -1;
 
 	/* To avoid merge and refragmentation at next-hops we never send
@@ -457,10 +457,15 @@ int batadv_frag_send_packet(struct sk_bu
 	 */
 	mtu = min_t(unsigned int, mtu, BATADV_FRAG_MAX_FRAG_SIZE);
 	max_fragment_size = mtu - header_size;
-	max_packet_size = max_fragment_size * BATADV_FRAG_MAX_FRAGMENTS;
+
+	if (skb->len == 0 || max_fragment_size == 0)
+		return -EINVAL;
+
+	num_fragments = (skb->len - 1) / max_fragment_size + 1;
+	max_fragment_size = (skb->len - 1) / num_fragments + 1;
 
 	/* Don't even try to fragment, if we need more than 16 fragments */
-	if (skb->len > max_packet_size)
+	if (num_fragments > BATADV_FRAG_MAX_FRAGMENTS)
 		goto out;
 
 	bat_priv = orig_node->bat_priv;
@@ -498,7 +503,8 @@ int batadv_frag_send_packet(struct sk_bu
 			goto out;
 		}
 
-		skb_fragment = batadv_frag_create(skb, &frag_header, mtu);
+		skb_fragment = batadv_frag_create(skb, &frag_header,
+						  max_fragment_size);
 		if (!skb_fragment)
 			goto out;
 


