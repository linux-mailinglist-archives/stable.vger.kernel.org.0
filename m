Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E182D65EF
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 20:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393240AbgLJTGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 14:06:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:38740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390470AbgLJObC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:31:02 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 03/31] vlan: consolidate VLAN parsing code and limit max parsing depth
Date:   Thu, 10 Dec 2020 15:26:40 +0100
Message-Id: <20201210142602.272144390@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.099683598@linuxfoundation.org>
References: <20201210142602.099683598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

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
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/if_vlan.h | 29 ++++++++++++++++++++++-------
 include/net/inet_ecn.h  |  1 +
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 87b8c20d5b27c..af4f2a7f8e9a0 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -30,6 +30,8 @@
 #define VLAN_ETH_DATA_LEN	1500	/* Max. octets in payload	 */
 #define VLAN_ETH_FRAME_LEN	1518	/* Max. octets in frame sans FCS */
 
+#define VLAN_MAX_DEPTH	8		/* Max. number of nested VLAN tags parsed */
+
 /*
  * 	struct vlan_hdr - vlan header
  * 	@h_vlan_TCI: priority and VLAN ID
@@ -534,10 +536,10 @@ static inline int vlan_get_tag(const struct sk_buff *skb, u16 *vlan_tci)
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
@@ -552,13 +554,12 @@ static inline __be16 __vlan_get_protocol(struct sk_buff *skb, __be16 type,
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
@@ -577,11 +578,25 @@ static inline __be16 __vlan_get_protocol(struct sk_buff *skb, __be16 type,
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
diff --git a/include/net/inet_ecn.h b/include/net/inet_ecn.h
index d30e4c869438c..09ed8a48b4548 100644
--- a/include/net/inet_ecn.h
+++ b/include/net/inet_ecn.h
@@ -4,6 +4,7 @@
 
 #include <linux/ip.h>
 #include <linux/skbuff.h>
+#include <linux/if_vlan.h>
 
 #include <net/inet_sock.h>
 #include <net/dsfield.h>
-- 
2.27.0



