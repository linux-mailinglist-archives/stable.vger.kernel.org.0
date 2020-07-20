Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9A8D226A50
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732495AbgGTQdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:33:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730686AbgGTP40 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:56:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE37220734;
        Mon, 20 Jul 2020 15:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260585;
        bh=gIRhl9opOJU5+qKIqIvykBBfc5EZJL8zkNp35h42d90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wDPbpC/m8e63vzmfvA9o4y38GWR9AA9Wt16sIM1REfo9E4hJz7UilqjaMMblHk/rC
         eQsPtq8gPx4T/klkQTUQjx4hEZ56Lm9fi/ZrT0+abna3d2sIE30SMOS6hjNSeK0zMD
         NHK1rHkEv+vkv2x4H1j/bWSY6sYA4U+uo+0R9eAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 021/215] vlan: consolidate VLAN parsing code and limit max parsing depth
Date:   Mon, 20 Jul 2020 17:35:03 +0200
Message-Id: <20200720152821.187209204@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Toke Høiland-Jørgensen" <toke@redhat.com>

[ Upstream commit 469aceddfa3ed16e17ee30533fae45e90f62efd8 ]

Toshiaki pointed out that we now have two very similar functions to extract
the L3 protocol number in the presence of VLAN tags. And Daniel pointed out
that the unbounded parsing loop makes it possible for maliciously crafted
packets to loop through potentially hundreds of tags.

Fix both of these issues by consolidating the two parsing functions and
limiting the VLAN tag parsing to a max depth of 8 tags. As part of this,
switch over __vlan_get_protocol() to use skb_header_pointer() instead of
pskb_may_pull(), to avoid the possible side effects of the latter and keep
the skb pointer 'const' through all the parsing functions.

v2:
- Use limit of 8 tags instead of 32 (matching XMIT_RECURSION_LIMIT)

Reported-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
Reported-by: Daniel Borkmann <daniel@iogearbox.net>
Fixes: d7bf2ebebc2b ("sched: consistently handle layer3 header accesses in the presence of VLANs")
Signed-off-by: Toke HÃ¸iland-JÃ¸rgensen <toke@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/if_vlan.h |   57 ++++++++++++++++++------------------------------
 1 file changed, 22 insertions(+), 35 deletions(-)

--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -25,6 +25,8 @@
 #define VLAN_ETH_DATA_LEN	1500	/* Max. octets in payload	 */
 #define VLAN_ETH_FRAME_LEN	1518	/* Max. octets in frame sans FCS */
 
+#define VLAN_MAX_DEPTH	8		/* Max. number of nested VLAN tags parsed */
+
 /*
  * 	struct vlan_hdr - vlan header
  * 	@h_vlan_TCI: priority and VLAN ID
@@ -308,34 +310,6 @@ static inline bool eth_type_vlan(__be16
 	}
 }
 
-/* A getter for the SKB protocol field which will handle VLAN tags consistently
- * whether VLAN acceleration is enabled or not.
- */
-static inline __be16 skb_protocol(const struct sk_buff *skb, bool skip_vlan)
-{
-	unsigned int offset = skb_mac_offset(skb) + sizeof(struct ethhdr);
-	__be16 proto = skb->protocol;
-
-	if (!skip_vlan)
-		/* VLAN acceleration strips the VLAN header from the skb and
-		 * moves it to skb->vlan_proto
-		 */
-		return skb_vlan_tag_present(skb) ? skb->vlan_proto : proto;
-
-	while (eth_type_vlan(proto)) {
-		struct vlan_hdr vhdr, *vh;
-
-		vh = skb_header_pointer(skb, offset, sizeof(vhdr), &vhdr);
-		if (!vh)
-			break;
-
-		proto = vh->h_vlan_encapsulated_proto;
-		offset += sizeof(vhdr);
-	}
-
-	return proto;
-}
-
 static inline bool vlan_hw_offload_capable(netdev_features_t features,
 					   __be16 proto)
 {
@@ -605,10 +579,10 @@ static inline int vlan_get_tag(const str
  * Returns the EtherType of the packet, regardless of whether it is
  * vlan encapsulated (normal or hardware accelerated) or not.
  */
-static inline __be16 __vlan_get_protocol(struct sk_buff *skb, __be16 type,
+static inline __be16 __vlan_get_protocol(const struct sk_buff *skb, __be16 type,
 					 int *depth)
 {
-	unsigned int vlan_depth = skb->mac_len;
+	unsigned int vlan_depth = skb->mac_len, parse_depth = VLAN_MAX_DEPTH;
 
 	/* if type is 802.1Q/AD then the header should already be
 	 * present at mac_len - VLAN_HLEN (if mac_len > 0), or at
@@ -623,13 +597,12 @@ static inline __be16 __vlan_get_protocol
 			vlan_depth = ETH_HLEN;
 		}
 		do {
-			struct vlan_hdr *vh;
+			struct vlan_hdr vhdr, *vh;
 
-			if (unlikely(!pskb_may_pull(skb,
-						    vlan_depth + VLAN_HLEN)))
+			vh = skb_header_pointer(skb, vlan_depth, sizeof(vhdr), &vhdr);
+			if (unlikely(!vh || !--parse_depth))
 				return 0;
 
-			vh = (struct vlan_hdr *)(skb->data + vlan_depth);
 			type = vh->h_vlan_encapsulated_proto;
 			vlan_depth += VLAN_HLEN;
 		} while (eth_type_vlan(type));
@@ -648,11 +621,25 @@ static inline __be16 __vlan_get_protocol
  * Returns the EtherType of the packet, regardless of whether it is
  * vlan encapsulated (normal or hardware accelerated) or not.
  */
-static inline __be16 vlan_get_protocol(struct sk_buff *skb)
+static inline __be16 vlan_get_protocol(const struct sk_buff *skb)
 {
 	return __vlan_get_protocol(skb, skb->protocol, NULL);
 }
 
+/* A getter for the SKB protocol field which will handle VLAN tags consistently
+ * whether VLAN acceleration is enabled or not.
+ */
+static inline __be16 skb_protocol(const struct sk_buff *skb, bool skip_vlan)
+{
+	if (!skip_vlan)
+		/* VLAN acceleration strips the VLAN header from the skb and
+		 * moves it to skb->vlan_proto
+		 */
+		return skb_vlan_tag_present(skb) ? skb->vlan_proto : skb->protocol;
+
+	return vlan_get_protocol(skb);
+}
+
 static inline void vlan_set_encap_proto(struct sk_buff *skb,
 					struct vlan_hdr *vhdr)
 {


