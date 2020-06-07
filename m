Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A08F1F0B7A
	for <lists+stable@lfdr.de>; Sun,  7 Jun 2020 15:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgFGNiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jun 2020 09:38:01 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:33041 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726465AbgFGNiA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jun 2020 09:38:00 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 94FDF19405EF;
        Sun,  7 Jun 2020 09:37:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 07 Jun 2020 09:37:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=N3mHjv
        dJoK1dS71OW6RzJCPxwtMXXih1MqXttX5+enY=; b=kWVJUxSfx6fBf63O4VbVsO
        spUVwz++25gkh7OzUvo08qw8xJUQ6BpP3J1WYO0cXnHjA4D6MiCntWwaTl/wFtKT
        HhUaME3jo70UEMJVPtGawzYSPbs4LXbx0zmUrTl9b5joFJM3dKUP9vKroKYoi1f1
        y4RgTgS0czxilm4Hdo2q8sHcMHbUqm+L+GXWlfm434VIgSbt00L93iZe3Ev3XAXl
        eHrcwTtkQ8ZeM6UkCh1I7f1JnkW2OLc9LBco4BZeQzRaX9Ou9bclzbduQxULYsHR
        s6xAvb7NfIyHaP0FmtvBeggAg3Wvw78Um+MHhFFyAao02lKs4IHAfuhdRFSGvH8A
        ==
X-ME-Sender: <xms:t-3cXikJzznIORc-_BFwlmVxTp8rfCnAZmGY6gT2TCGt2dUYIq5zIw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudegledgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:t-3cXp3YI-cjJfBcj5yC5eynFedfFgVNdDF1poHbdBkPVjiQVolAkw>
    <xmx:t-3cXgqh_GzIJ3WvjBN4p7ZHvx-3TOlQy2AMbXwAjINhrcpfGyYW2g>
    <xmx:t-3cXmn5WsaBb1Z9dYxY7TleOKtxiiHG-925pjB88OsLyzOxzaxNFA>
    <xmx:t-3cXl8VVZmx5QCLXjcxHxByqupSpgEnChcOGboy5ivFjjOdKeudog>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 387813280060;
        Sun,  7 Jun 2020 09:37:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] net: check untrusted gso_size at kernel entry" failed to apply to 4.4-stable tree
To:     willemb@google.com, davem@davemloft.net, syzkaller@googlegroups.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 07 Jun 2020 15:37:50 +0200
Message-ID: <1591537070167121@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6dd912f82680761d8fb6b1bb274a69d4c7010988 Mon Sep 17 00:00:00 2001
From: Willem de Bruijn <willemb@google.com>
Date: Mon, 25 May 2020 15:07:40 -0400
Subject: [PATCH] net: check untrusted gso_size at kernel entry

Syzkaller again found a path to a kernel crash through bad gso input:
a packet with gso size exceeding len.

These packets are dropped in tcp_gso_segment and udp[46]_ufo_fragment.
But they may affect gso size calculations earlier in the path.

Now that we have thlen as of commit 9274124f023b ("net: stricter
validation of untrusted gso packets"), check gso_size at entry too.

Fixes: bfd5f4a3d605 ("packet: Add GSO/csum offload support.")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 6f6ade63b04c..88997022a4b5 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -31,6 +31,7 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 {
 	unsigned int gso_type = 0;
 	unsigned int thlen = 0;
+	unsigned int p_off = 0;
 	unsigned int ip_proto;
 
 	if (hdr->gso_type != VIRTIO_NET_HDR_GSO_NONE) {
@@ -68,7 +69,8 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 		if (!skb_partial_csum_set(skb, start, off))
 			return -EINVAL;
 
-		if (skb_transport_offset(skb) + thlen > skb_headlen(skb))
+		p_off = skb_transport_offset(skb) + thlen;
+		if (p_off > skb_headlen(skb))
 			return -EINVAL;
 	} else {
 		/* gso packets without NEEDS_CSUM do not set transport_offset.
@@ -92,17 +94,25 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 				return -EINVAL;
 			}
 
-			if (keys.control.thoff + thlen > skb_headlen(skb) ||
+			p_off = keys.control.thoff + thlen;
+			if (p_off > skb_headlen(skb) ||
 			    keys.basic.ip_proto != ip_proto)
 				return -EINVAL;
 
 			skb_set_transport_header(skb, keys.control.thoff);
+		} else if (gso_type) {
+			p_off = thlen;
+			if (p_off > skb_headlen(skb))
+				return -EINVAL;
 		}
 	}
 
 	if (hdr->gso_type != VIRTIO_NET_HDR_GSO_NONE) {
 		u16 gso_size = __virtio16_to_cpu(little_endian, hdr->gso_size);
 
+		if (skb->len - p_off <= gso_size)
+			return -EINVAL;
+
 		skb_shinfo(skb)->gso_size = gso_size;
 		skb_shinfo(skb)->gso_type = gso_type;
 

