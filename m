Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E8333B629
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbhCON5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231366AbhCON4s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:56:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF4B264EF8;
        Mon, 15 Mar 2021 13:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816608;
        bh=Z0ScXEL6DEP6O0epDMFNqZSv2NhcBtfef/eKh+PBNIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Se6aeLsU6vzjRTa+EW+DfngwbPWVZTTVzNPSK7LXERpm9bbA5rXpB6bOsiMzPHdLV
         DFt15lqSNCkflZcirf+xYuBDfhrFaArzAaxY3mX5ZB9XVsIcWE1bFWVdQBXe8vpJQL
         GKgn/k3j2mB02NTThpDPpu338SNGVHo45hNADM5A=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthias Schiffer <mschiffer@universe-factory.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 010/290] net: l2tp: reduce log level of messages in receive path, add counter instead
Date:   Mon, 15 Mar 2021 14:51:43 +0100
Message-Id: <20210315135542.287773778@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Matthias Schiffer <mschiffer@universe-factory.net>

commit 3e59e8856758eb5a2dfe1f831ef53b168fd58105 upstream.

Commit 5ee759cda51b ("l2tp: use standard API for warning log messages")
changed a number of warnings about invalid packets in the receive path
so that they are always shown, instead of only when a special L2TP debug
flag is set. Even with rate limiting these warnings can easily cause
significant log spam - potentially triggered by a malicious party
sending invalid packets on purpose.

In addition these warnings were noticed by projects like Tunneldigger [1],
which uses L2TP for its data path, but implements its own control
protocol (which is sufficiently different from L2TP data packets that it
would always be passed up to userspace even with future extensions of
L2TP).

Some of the warnings were already redundant, as l2tp_stats has a counter
for these packets. This commit adds one additional counter for invalid
packets that are passed up to userspace. Packets with unknown session are
not counted as invalid, as there is nothing wrong with the format of
these packets.

With the additional counter, all of these messages are either redundant
or benign, so we reduce them to pr_debug_ratelimited().

[1] https://github.com/wlanslovenija/tunneldigger/issues/160

Fixes: 5ee759cda51b ("l2tp: use standard API for warning log messages")
Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/l2tp.h |    1 +
 net/l2tp/l2tp_core.c      |   41 ++++++++++++++++++++++-------------------
 net/l2tp/l2tp_core.h      |    1 +
 net/l2tp/l2tp_netlink.c   |    6 ++++++
 4 files changed, 30 insertions(+), 19 deletions(-)

--- a/include/uapi/linux/l2tp.h
+++ b/include/uapi/linux/l2tp.h
@@ -145,6 +145,7 @@ enum {
 	L2TP_ATTR_RX_ERRORS,		/* u64 */
 	L2TP_ATTR_STATS_PAD,
 	L2TP_ATTR_RX_COOKIE_DISCARDS,	/* u64 */
+	L2TP_ATTR_RX_INVALID,		/* u64 */
 	__L2TP_ATTR_STATS_MAX,
 };
 
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -649,9 +649,9 @@ void l2tp_recv_common(struct l2tp_sessio
 	/* Parse and check optional cookie */
 	if (session->peer_cookie_len > 0) {
 		if (memcmp(ptr, &session->peer_cookie[0], session->peer_cookie_len)) {
-			pr_warn_ratelimited("%s: cookie mismatch (%u/%u). Discarding.\n",
-					    tunnel->name, tunnel->tunnel_id,
-					    session->session_id);
+			pr_debug_ratelimited("%s: cookie mismatch (%u/%u). Discarding.\n",
+					     tunnel->name, tunnel->tunnel_id,
+					     session->session_id);
 			atomic_long_inc(&session->stats.rx_cookie_discards);
 			goto discard;
 		}
@@ -702,8 +702,8 @@ void l2tp_recv_common(struct l2tp_sessio
 		 * If user has configured mandatory sequence numbers, discard.
 		 */
 		if (session->recv_seq) {
-			pr_warn_ratelimited("%s: recv data has no seq numbers when required. Discarding.\n",
-					    session->name);
+			pr_debug_ratelimited("%s: recv data has no seq numbers when required. Discarding.\n",
+					     session->name);
 			atomic_long_inc(&session->stats.rx_seq_discards);
 			goto discard;
 		}
@@ -718,8 +718,8 @@ void l2tp_recv_common(struct l2tp_sessio
 			session->send_seq = 0;
 			l2tp_session_set_header_len(session, tunnel->version);
 		} else if (session->send_seq) {
-			pr_warn_ratelimited("%s: recv data has no seq numbers when required. Discarding.\n",
-					    session->name);
+			pr_debug_ratelimited("%s: recv data has no seq numbers when required. Discarding.\n",
+					     session->name);
 			atomic_long_inc(&session->stats.rx_seq_discards);
 			goto discard;
 		}
@@ -809,9 +809,9 @@ static int l2tp_udp_recv_core(struct l2t
 
 	/* Short packet? */
 	if (!pskb_may_pull(skb, L2TP_HDR_SIZE_MAX)) {
-		pr_warn_ratelimited("%s: recv short packet (len=%d)\n",
-				    tunnel->name, skb->len);
-		goto error;
+		pr_debug_ratelimited("%s: recv short packet (len=%d)\n",
+				     tunnel->name, skb->len);
+		goto invalid;
 	}
 
 	/* Point to L2TP header */
@@ -824,9 +824,9 @@ static int l2tp_udp_recv_core(struct l2t
 	/* Check protocol version */
 	version = hdrflags & L2TP_HDR_VER_MASK;
 	if (version != tunnel->version) {
-		pr_warn_ratelimited("%s: recv protocol version mismatch: got %d expected %d\n",
-				    tunnel->name, version, tunnel->version);
-		goto error;
+		pr_debug_ratelimited("%s: recv protocol version mismatch: got %d expected %d\n",
+				     tunnel->name, version, tunnel->version);
+		goto invalid;
 	}
 
 	/* Get length of L2TP packet */
@@ -834,7 +834,7 @@ static int l2tp_udp_recv_core(struct l2t
 
 	/* If type is control packet, it is handled by userspace. */
 	if (hdrflags & L2TP_HDRFLAG_T)
-		goto error;
+		goto pass;
 
 	/* Skip flags */
 	ptr += 2;
@@ -863,21 +863,24 @@ static int l2tp_udp_recv_core(struct l2t
 			l2tp_session_dec_refcount(session);
 
 		/* Not found? Pass to userspace to deal with */
-		pr_warn_ratelimited("%s: no session found (%u/%u). Passing up.\n",
-				    tunnel->name, tunnel_id, session_id);
-		goto error;
+		pr_debug_ratelimited("%s: no session found (%u/%u). Passing up.\n",
+				     tunnel->name, tunnel_id, session_id);
+		goto pass;
 	}
 
 	if (tunnel->version == L2TP_HDR_VER_3 &&
 	    l2tp_v3_ensure_opt_in_linear(session, skb, &ptr, &optr))
-		goto error;
+		goto invalid;
 
 	l2tp_recv_common(session, skb, ptr, optr, hdrflags, length);
 	l2tp_session_dec_refcount(session);
 
 	return 0;
 
-error:
+invalid:
+	atomic_long_inc(&tunnel->stats.rx_invalid);
+
+pass:
 	/* Put UDP header back */
 	__skb_push(skb, sizeof(struct udphdr));
 
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -39,6 +39,7 @@ struct l2tp_stats {
 	atomic_long_t		rx_oos_packets;
 	atomic_long_t		rx_errors;
 	atomic_long_t		rx_cookie_discards;
+	atomic_long_t		rx_invalid;
 };
 
 struct l2tp_tunnel;
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -428,6 +428,9 @@ static int l2tp_nl_tunnel_send(struct sk
 			      L2TP_ATTR_STATS_PAD) ||
 	    nla_put_u64_64bit(skb, L2TP_ATTR_RX_ERRORS,
 			      atomic_long_read(&tunnel->stats.rx_errors),
+			      L2TP_ATTR_STATS_PAD) ||
+	    nla_put_u64_64bit(skb, L2TP_ATTR_RX_INVALID,
+			      atomic_long_read(&tunnel->stats.rx_invalid),
 			      L2TP_ATTR_STATS_PAD))
 		goto nla_put_failure;
 	nla_nest_end(skb, nest);
@@ -771,6 +774,9 @@ static int l2tp_nl_session_send(struct s
 			      L2TP_ATTR_STATS_PAD) ||
 	    nla_put_u64_64bit(skb, L2TP_ATTR_RX_ERRORS,
 			      atomic_long_read(&session->stats.rx_errors),
+			      L2TP_ATTR_STATS_PAD) ||
+	    nla_put_u64_64bit(skb, L2TP_ATTR_RX_INVALID,
+			      atomic_long_read(&session->stats.rx_invalid),
 			      L2TP_ATTR_STATS_PAD))
 		goto nla_put_failure;
 	nla_nest_end(skb, nest);


