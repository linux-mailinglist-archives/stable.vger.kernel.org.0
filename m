Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA9B1D0D8E
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388041AbgEMJyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:54:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732826AbgEMJyC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:54:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8E38205ED;
        Wed, 13 May 2020 09:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363641;
        bh=M5p3zLfAleWDXPsPPHQNNSsr2W4h5MyjY1VDgTNd4Y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wkgwf1AYX/Rsdn28SfDvfEkyXuY72BcYm0piFeFpxLBdQK5k4vh4CLer6/tdkZAub
         kzO5gm6eyitg5RjF1PFDg/v6EDRub+HBFZ+eotRwn7m1oJD7lFfMK9Eon9NnrQctLU
         fQuVjr2M32hCtsJpgd7eRHhesGHYxoGl/yAizSd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 029/118] net: stricter validation of untrusted gso packets
Date:   Wed, 13 May 2020 11:44:08 +0200
Message-Id: <20200513094420.134868117@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 9274124f023b5c56dc4326637d4f787968b03607 ]

Syzkaller again found a path to a kernel crash through bad gso input:
a packet with transport header extending beyond skb_headlen(skb).

Tighten validation at kernel entry:

- Verify that the transport header lies within the linear section.

    To avoid pulling linux/tcp.h, verify just sizeof tcphdr.
    tcp_gso_segment will call pskb_may_pull (th->doff * 4) before use.

- Match the gso_type against the ip_proto found by the flow dissector.

Fixes: bfd5f4a3d605 ("packet: Add GSO/csum offload support.")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/virtio_net.h |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -3,6 +3,8 @@
 #define _LINUX_VIRTIO_NET_H
 
 #include <linux/if_vlan.h>
+#include <uapi/linux/tcp.h>
+#include <uapi/linux/udp.h>
 #include <uapi/linux/virtio_net.h>
 
 static inline int virtio_net_hdr_set_proto(struct sk_buff *skb,
@@ -28,17 +30,25 @@ static inline int virtio_net_hdr_to_skb(
 					bool little_endian)
 {
 	unsigned int gso_type = 0;
+	unsigned int thlen = 0;
+	unsigned int ip_proto;
 
 	if (hdr->gso_type != VIRTIO_NET_HDR_GSO_NONE) {
 		switch (hdr->gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {
 		case VIRTIO_NET_HDR_GSO_TCPV4:
 			gso_type = SKB_GSO_TCPV4;
+			ip_proto = IPPROTO_TCP;
+			thlen = sizeof(struct tcphdr);
 			break;
 		case VIRTIO_NET_HDR_GSO_TCPV6:
 			gso_type = SKB_GSO_TCPV6;
+			ip_proto = IPPROTO_TCP;
+			thlen = sizeof(struct tcphdr);
 			break;
 		case VIRTIO_NET_HDR_GSO_UDP:
 			gso_type = SKB_GSO_UDP;
+			ip_proto = IPPROTO_UDP;
+			thlen = sizeof(struct udphdr);
 			break;
 		default:
 			return -EINVAL;
@@ -57,16 +67,22 @@ static inline int virtio_net_hdr_to_skb(
 
 		if (!skb_partial_csum_set(skb, start, off))
 			return -EINVAL;
+
+		if (skb_transport_offset(skb) + thlen > skb_headlen(skb))
+			return -EINVAL;
 	} else {
 		/* gso packets without NEEDS_CSUM do not set transport_offset.
 		 * probe and drop if does not match one of the above types.
 		 */
 		if (gso_type && skb->network_header) {
+			struct flow_keys_basic keys;
+
 			if (!skb->protocol)
 				virtio_net_hdr_set_proto(skb, hdr);
 retry:
-			skb_probe_transport_header(skb);
-			if (!skb_transport_header_was_set(skb)) {
+			if (!skb_flow_dissect_flow_keys_basic(NULL, skb, &keys,
+							      NULL, 0, 0, 0,
+							      0)) {
 				/* UFO does not specify ipv4 or 6: try both */
 				if (gso_type & SKB_GSO_UDP &&
 				    skb->protocol == htons(ETH_P_IP)) {
@@ -75,6 +91,12 @@ retry:
 				}
 				return -EINVAL;
 			}
+
+			if (keys.control.thoff + thlen > skb_headlen(skb) ||
+			    keys.basic.ip_proto != ip_proto)
+				return -EINVAL;
+
+			skb_set_transport_header(skb, keys.control.thoff);
 		}
 	}
 


