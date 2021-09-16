Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9985E40DF9D
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhIPQMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:12:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237066AbhIPQKc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:10:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CE146126A;
        Thu, 16 Sep 2021 16:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808508;
        bh=oXQrmImgzspKLQctNWZ27J0bJXr2dNfubqFfMuqlvks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uzBxdbTw3eNqk1/HuL3E1uuxn7aoa6cVBAB8plY51O2yQPyAECTc4zMeAQ/sunhEE
         zueTedvESlW3UKJ7pW1QHr4WQ1TwO8snqZhzudVZFzge1E9ivLuwJuYoydjp6rw+UQ
         pAk44hfNGi0WCm1h39XDraAIGTvClhyhygTiydi0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 118/306] tipc: keep the skb in rcv queue until the whole data is read
Date:   Thu, 16 Sep 2021 17:57:43 +0200
Message-Id: <20210916155758.089107332@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit f4919ff59c2828064b4156e3c3600a169909bcf4 ]

Currently, when userspace reads a datagram with a buffer that is
smaller than this datagram, the data will be truncated and only
part of it can be received by users. It doesn't seem right that
users don't know the datagram size and have to use a huge buffer
to read it to avoid the truncation.

This patch to fix it by keeping the skb in rcv queue until the
whole data is read by users. Only the last msg of the datagram
will be marked with MSG_EOR, just as TCP/SCTP does.

Note that this will work as above only when MSG_EOR is set in the
flags parameter of recvmsg(), so that it won't break any old user
applications.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/socket.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 9bd72468bc68..963047c57c27 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1887,6 +1887,7 @@ static int tipc_recvmsg(struct socket *sock, struct msghdr *m,
 	bool connected = !tipc_sk_type_connectionless(sk);
 	struct tipc_sock *tsk = tipc_sk(sk);
 	int rc, err, hlen, dlen, copy;
+	struct tipc_skb_cb *skb_cb;
 	struct sk_buff_head xmitq;
 	struct tipc_msg *hdr;
 	struct sk_buff *skb;
@@ -1910,6 +1911,7 @@ static int tipc_recvmsg(struct socket *sock, struct msghdr *m,
 		if (unlikely(rc))
 			goto exit;
 		skb = skb_peek(&sk->sk_receive_queue);
+		skb_cb = TIPC_SKB_CB(skb);
 		hdr = buf_msg(skb);
 		dlen = msg_data_sz(hdr);
 		hlen = msg_hdr_sz(hdr);
@@ -1929,18 +1931,33 @@ static int tipc_recvmsg(struct socket *sock, struct msghdr *m,
 
 	/* Capture data if non-error msg, otherwise just set return value */
 	if (likely(!err)) {
-		copy = min_t(int, dlen, buflen);
-		if (unlikely(copy != dlen))
-			m->msg_flags |= MSG_TRUNC;
-		rc = skb_copy_datagram_msg(skb, hlen, m, copy);
+		int offset = skb_cb->bytes_read;
+
+		copy = min_t(int, dlen - offset, buflen);
+		rc = skb_copy_datagram_msg(skb, hlen + offset, m, copy);
+		if (unlikely(rc))
+			goto exit;
+		if (unlikely(offset + copy < dlen)) {
+			if (flags & MSG_EOR) {
+				if (!(flags & MSG_PEEK))
+					skb_cb->bytes_read = offset + copy;
+			} else {
+				m->msg_flags |= MSG_TRUNC;
+				skb_cb->bytes_read = 0;
+			}
+		} else {
+			if (flags & MSG_EOR)
+				m->msg_flags |= MSG_EOR;
+			skb_cb->bytes_read = 0;
+		}
 	} else {
 		copy = 0;
 		rc = 0;
-		if (err != TIPC_CONN_SHUTDOWN && connected && !m->msg_control)
+		if (err != TIPC_CONN_SHUTDOWN && connected && !m->msg_control) {
 			rc = -ECONNRESET;
+			goto exit;
+		}
 	}
-	if (unlikely(rc))
-		goto exit;
 
 	/* Mark message as group event if applicable */
 	if (unlikely(grp_evt)) {
@@ -1963,9 +1980,10 @@ static int tipc_recvmsg(struct socket *sock, struct msghdr *m,
 		tipc_node_distr_xmit(sock_net(sk), &xmitq);
 	}
 
-	tsk_advance_rx_queue(sk);
+	if (!skb_cb->bytes_read)
+		tsk_advance_rx_queue(sk);
 
-	if (likely(!connected))
+	if (likely(!connected) || skb_cb->bytes_read)
 		goto exit;
 
 	/* Send connection flow control advertisement when applicable */
-- 
2.30.2



