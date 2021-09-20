Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04DAA412036
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349805AbhITRxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:53:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354098AbhITRsx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:48:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A640861BB6;
        Mon, 20 Sep 2021 17:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157877;
        bh=yIPfydS2oP2rEmzgNeetOSsUrPJdErXC2oPguSDHeYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IkMRXRtHA7tBItE2042zsoVGBGOE1nY72KvtvjNWKbDK08q05vWUNKF3+4u33n+1L
         kjrlNTKMQhTNJTf9SpybyW9hBR6Q11wtJGg3pZR+e0fTJ/leptSB2I2Mhn3Ojt50qo
         6OL7xRUweMQE7DHBfEE3ajFDaHphekFRLvyrwd5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 175/293] tipc: keep the skb in rcv queue until the whole data is read
Date:   Mon, 20 Sep 2021 18:42:17 +0200
Message-Id: <20210920163939.271337512@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
index 6aead6deaa6c..e9acbb290d71 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1716,6 +1716,7 @@ static int tipc_recvmsg(struct socket *sock, struct msghdr *m,
 	bool connected = !tipc_sk_type_connectionless(sk);
 	struct tipc_sock *tsk = tipc_sk(sk);
 	int rc, err, hlen, dlen, copy;
+	struct tipc_skb_cb *skb_cb;
 	struct sk_buff_head xmitq;
 	struct tipc_msg *hdr;
 	struct sk_buff *skb;
@@ -1739,6 +1740,7 @@ static int tipc_recvmsg(struct socket *sock, struct msghdr *m,
 		if (unlikely(rc))
 			goto exit;
 		skb = skb_peek(&sk->sk_receive_queue);
+		skb_cb = TIPC_SKB_CB(skb);
 		hdr = buf_msg(skb);
 		dlen = msg_data_sz(hdr);
 		hlen = msg_hdr_sz(hdr);
@@ -1758,18 +1760,33 @@ static int tipc_recvmsg(struct socket *sock, struct msghdr *m,
 
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
@@ -1792,9 +1809,10 @@ static int tipc_recvmsg(struct socket *sock, struct msghdr *m,
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



