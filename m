Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A362F32C47
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbfFCJMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:12:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728597AbfFCJMM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:12:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A93227E94;
        Mon,  3 Jun 2019 09:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553130;
        bh=RokwJaxmfCRgi0uqFVxRhyqXjSgRlyTjIFQ9il/sdiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qv2b0GmleiqGd9yIJuOStdOnBzQRgfXSD8wb9kUDqUt9d/WfzqWMOvEGzyVX6pyk4
         cmE1PuLx/CZTtuOQvZDD26pf3+U6PFBu6ve3ziUx18V7BPt/AB2wDayLE7xwU+rz4d
         NDVDBFfi5kEVnvl/Subui2Xzm7QpfcNyF9C6bsXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH 5.0 32/36] net: correct zerocopy refcnt with udp MSG_MORE
Date:   Mon,  3 Jun 2019 11:09:20 +0200
Message-Id: <20190603090523.101971185@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090520.998342694@linuxfoundation.org>
References: <20190603090520.998342694@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 100f6d8e09905c59be45b6316f8f369c0be1b2d8 ]

TCP zerocopy takes a uarg reference for every skb, plus one for the
tcp_sendmsg_locked datapath temporarily, to avoid reaching refcnt zero
as it builds, sends and frees skbs inside its inner loop.

UDP and RAW zerocopy do not send inside the inner loop so do not need
the extra sock_zerocopy_get + sock_zerocopy_put pair. Commit
52900d22288ed ("udp: elide zerocopy operation in hot path") introduced
extra_uref to pass the initial reference taken in sock_zerocopy_alloc
to the first generated skb.

But, sock_zerocopy_realloc takes this extra reference at the start of
every call. With MSG_MORE, no new skb may be generated to attach the
extra_uref to, so refcnt is incorrectly 2 with only one skb.

Do not take the extra ref if uarg && !tcp, which implies MSG_MORE.
Update extra_uref accordingly.

This conditional assignment triggers a false positive may be used
uninitialized warning, so have to initialize extra_uref at define.

Changes v1->v2: fix typo in Fixes SHA1

Fixes: 52900d22288e7 ("udp: elide zerocopy operation in hot path")
Reported-by: syzbot <syzkaller@googlegroups.com>
Diagnosed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c     |    6 +++++-
 net/ipv4/ip_output.c  |    4 ++--
 net/ipv6/ip6_output.c |    4 ++--
 3 files changed, 9 insertions(+), 5 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1001,7 +1001,11 @@ struct ubuf_info *sock_zerocopy_realloc(
 			uarg->len++;
 			uarg->bytelen = bytelen;
 			atomic_set(&sk->sk_zckey, ++next);
-			sock_zerocopy_get(uarg);
+
+			/* no extra ref when appending to datagram (MSG_MORE) */
+			if (sk->sk_type == SOCK_STREAM)
+				sock_zerocopy_get(uarg);
+
 			return uarg;
 		}
 	}
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -883,7 +883,7 @@ static int __ip_append_data(struct sock
 	int csummode = CHECKSUM_NONE;
 	struct rtable *rt = (struct rtable *)cork->dst;
 	unsigned int wmem_alloc_delta = 0;
-	bool paged, extra_uref;
+	bool paged, extra_uref = false;
 	u32 tskey = 0;
 
 	skb = skb_peek_tail(queue);
@@ -923,7 +923,7 @@ static int __ip_append_data(struct sock
 		uarg = sock_zerocopy_realloc(sk, length, skb_zcopy(skb));
 		if (!uarg)
 			return -ENOBUFS;
-		extra_uref = true;
+		extra_uref = !skb;	/* only extra ref if !MSG_MORE */
 		if (rt->dst.dev->features & NETIF_F_SG &&
 		    csummode == CHECKSUM_PARTIAL) {
 			paged = true;
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1269,7 +1269,7 @@ static int __ip6_append_data(struct sock
 	int csummode = CHECKSUM_NONE;
 	unsigned int maxnonfragsize, headersize;
 	unsigned int wmem_alloc_delta = 0;
-	bool paged, extra_uref;
+	bool paged, extra_uref = false;
 
 	skb = skb_peek_tail(queue);
 	if (!skb) {
@@ -1338,7 +1338,7 @@ emsgsize:
 		uarg = sock_zerocopy_realloc(sk, length, skb_zcopy(skb));
 		if (!uarg)
 			return -ENOBUFS;
-		extra_uref = true;
+		extra_uref = !skb;	/* only extra ref if !MSG_MORE */
 		if (rt->dst.dev->features & NETIF_F_SG &&
 		    csummode == CHECKSUM_PARTIAL) {
 			paged = true;


