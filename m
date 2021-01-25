Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD75302ADC
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730867AbhAYSzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:55:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:41278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbhAYSzC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:55:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AA77224BE;
        Mon, 25 Jan 2021 18:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600861;
        bh=QPyzoAnFKy+IVHJkJOlMtUaE78rNJTGrjdCQ+WPAP18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r3nfdJp+UoMrFCaneQxMpIKBd0XEVKL3PTbz5dtNENdiaUww70fNbrJVi2ZN3I2fW
         2fzLsCt6xKjN1IWsB56KAuyYGBprYqCNL8WWyvluf1Ca9y2s2mI4mG/YqyWfLBQNSc
         Au5N57qt8QD+E0iUjKXQJb/oA1cPq2uwVE0sbss8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Juerg Haefliger <juergh@canonical.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 179/199] tcp: do not mess with cloned skbs in tcp_add_backlog()
Date:   Mon, 25 Jan 2021 19:40:01 +0100
Message-Id: <20210125183223.751786083@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit b160c28548bc0a87cbd16d5af6d3edcfd70b8c9a upstream.

Heiner Kallweit reported that some skbs were sent with
the following invalid GSO properties :
- gso_size > 0
- gso_type == 0

This was triggerring a WARN_ON_ONCE() in rtl8169_tso_csum_v2.

Juerg Haefliger was able to reproduce a similar issue using
a lan78xx NIC and a workload mixing TCP incoming traffic
and forwarded packets.

The problem is that tcp_add_backlog() is writing
over gso_segs and gso_size even if the incoming packet will not
be coalesced to the backlog tail packet.

While skb_try_coalesce() would bail out if tail packet is cloned,
this overwriting would lead to corruptions of other packets
cooked by lan78xx, sharing a common super-packet.

The strategy used by lan78xx is to use a big skb, and split
it into all received packets using skb_clone() to avoid copies.
The drawback of this strategy is that all the small skb share a common
struct skb_shared_info.

This patch rewrites TCP gso_size/gso_segs handling to only
happen on the tail skb, since skb_try_coalesce() made sure
it was not cloned.

Fixes: 4f693b55c3d2 ("tcp: implement coalescing on backlog queue")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Bisected-by: Juerg Haefliger <juergh@canonical.com>
Tested-by: Juerg Haefliger <juergh@canonical.com>
Reported-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=209423
Link: https://lore.kernel.org/r/20210119164900.766957-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/tcp_ipv4.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1755,6 +1755,7 @@ int tcp_v4_early_demux(struct sk_buff *s
 bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 {
 	u32 limit = READ_ONCE(sk->sk_rcvbuf) + READ_ONCE(sk->sk_sndbuf);
+	u32 tail_gso_size, tail_gso_segs;
 	struct skb_shared_info *shinfo;
 	const struct tcphdr *th;
 	struct tcphdr *thtail;
@@ -1762,6 +1763,7 @@ bool tcp_add_backlog(struct sock *sk, st
 	unsigned int hdrlen;
 	bool fragstolen;
 	u32 gso_segs;
+	u32 gso_size;
 	int delta;
 
 	/* In case all data was pulled from skb frags (in __pskb_pull_tail()),
@@ -1787,13 +1789,6 @@ bool tcp_add_backlog(struct sock *sk, st
 	 */
 	th = (const struct tcphdr *)skb->data;
 	hdrlen = th->doff * 4;
-	shinfo = skb_shinfo(skb);
-
-	if (!shinfo->gso_size)
-		shinfo->gso_size = skb->len - hdrlen;
-
-	if (!shinfo->gso_segs)
-		shinfo->gso_segs = 1;
 
 	tail = sk->sk_backlog.tail;
 	if (!tail)
@@ -1816,6 +1811,15 @@ bool tcp_add_backlog(struct sock *sk, st
 		goto no_coalesce;
 
 	__skb_pull(skb, hdrlen);
+
+	shinfo = skb_shinfo(skb);
+	gso_size = shinfo->gso_size ?: skb->len;
+	gso_segs = shinfo->gso_segs ?: 1;
+
+	shinfo = skb_shinfo(tail);
+	tail_gso_size = shinfo->gso_size ?: (tail->len - hdrlen);
+	tail_gso_segs = shinfo->gso_segs ?: 1;
+
 	if (skb_try_coalesce(tail, skb, &fragstolen, &delta)) {
 		TCP_SKB_CB(tail)->end_seq = TCP_SKB_CB(skb)->end_seq;
 
@@ -1842,11 +1846,8 @@ bool tcp_add_backlog(struct sock *sk, st
 		}
 
 		/* Not as strict as GRO. We only need to carry mss max value */
-		skb_shinfo(tail)->gso_size = max(shinfo->gso_size,
-						 skb_shinfo(tail)->gso_size);
-
-		gso_segs = skb_shinfo(tail)->gso_segs + shinfo->gso_segs;
-		skb_shinfo(tail)->gso_segs = min_t(u32, gso_segs, 0xFFFF);
+		shinfo->gso_size = max(gso_size, tail_gso_size);
+		shinfo->gso_segs = min_t(u32, gso_segs + tail_gso_segs, 0xFFFF);
 
 		sk->sk_backlog.len += delta;
 		__NET_INC_STATS(sock_net(sk),


