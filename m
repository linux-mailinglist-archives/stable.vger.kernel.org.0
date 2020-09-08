Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E1826140E
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 18:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731113AbgIHQBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 12:01:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731059AbgIHQAE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:00:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53003224DF;
        Tue,  8 Sep 2020 15:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579439;
        bh=ZVS6G0he7Yx5Wf0LqIjPdrGG+io5wAJnYSIi3O3FXLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=09PI6jqgdyQtC4/iaF9R76nHc08ebRT/27Q88hTP/vXGUwI2A0+So7Y7JRz8oxId2
         6RLMybP7ETjuPGvQw75RK1wKei4TWWKD9VBEvvRr19qUDZFY9iBQTAe6/73KJQ4nFR
         ILHGbs6CmR51L9mXnmiRdofNu2bTgIP7/9fZHlZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 048/186] rxrpc: Make rxrpc_kernel_get_srtt() indicate validity
Date:   Tue,  8 Sep 2020 17:23:10 +0200
Message-Id: <20200908152243.993277131@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 1d4adfaf65746203861c72d9d78de349eb97d528 ]

Fix rxrpc_kernel_get_srtt() to indicate the validity of the returned
smoothed RTT.  If we haven't had any valid samples yet, the SRTT isn't
useful.

Fixes: c410bf01933e ("rxrpc: Fix the excessive initial retransmission timeout")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/fs_probe.c       |  4 ++--
 fs/afs/vl_probe.c       |  4 ++--
 include/net/af_rxrpc.h  |  2 +-
 net/rxrpc/peer_object.c | 16 +++++++++++++---
 4 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/afs/fs_probe.c b/fs/afs/fs_probe.c
index 5d9ef517cf816..e7e98ad63a91a 100644
--- a/fs/afs/fs_probe.c
+++ b/fs/afs/fs_probe.c
@@ -161,8 +161,8 @@ responded:
 		}
 	}
 
-	rtt_us = rxrpc_kernel_get_srtt(call->net->socket, call->rxcall);
-	if (rtt_us < server->probe.rtt) {
+	if (rxrpc_kernel_get_srtt(call->net->socket, call->rxcall, &rtt_us) &&
+	    rtt_us < server->probe.rtt) {
 		server->probe.rtt = rtt_us;
 		server->rtt = rtt_us;
 		alist->preferred = index;
diff --git a/fs/afs/vl_probe.c b/fs/afs/vl_probe.c
index e3aa013c21779..081b7e5b13f58 100644
--- a/fs/afs/vl_probe.c
+++ b/fs/afs/vl_probe.c
@@ -92,8 +92,8 @@ responded:
 		}
 	}
 
-	rtt_us = rxrpc_kernel_get_srtt(call->net->socket, call->rxcall);
-	if (rtt_us < server->probe.rtt) {
+	if (rxrpc_kernel_get_srtt(call->net->socket, call->rxcall, &rtt_us) &&
+	    rtt_us < server->probe.rtt) {
 		server->probe.rtt = rtt_us;
 		alist->preferred = index;
 		have_result = true;
diff --git a/include/net/af_rxrpc.h b/include/net/af_rxrpc.h
index 91eacbdcf33d2..f6abcc0bbd6e7 100644
--- a/include/net/af_rxrpc.h
+++ b/include/net/af_rxrpc.h
@@ -59,7 +59,7 @@ bool rxrpc_kernel_abort_call(struct socket *, struct rxrpc_call *,
 void rxrpc_kernel_end_call(struct socket *, struct rxrpc_call *);
 void rxrpc_kernel_get_peer(struct socket *, struct rxrpc_call *,
 			   struct sockaddr_rxrpc *);
-u32 rxrpc_kernel_get_srtt(struct socket *, struct rxrpc_call *);
+bool rxrpc_kernel_get_srtt(struct socket *, struct rxrpc_call *, u32 *);
 int rxrpc_kernel_charge_accept(struct socket *, rxrpc_notify_rx_t,
 			       rxrpc_user_attach_call_t, unsigned long, gfp_t,
 			       unsigned int);
diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
index ca29976bb193e..68396d0520525 100644
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -502,11 +502,21 @@ EXPORT_SYMBOL(rxrpc_kernel_get_peer);
  * rxrpc_kernel_get_srtt - Get a call's peer smoothed RTT
  * @sock: The socket on which the call is in progress.
  * @call: The call to query
+ * @_srtt: Where to store the SRTT value.
  *
- * Get the call's peer smoothed RTT.
+ * Get the call's peer smoothed RTT in uS.
  */
-u32 rxrpc_kernel_get_srtt(struct socket *sock, struct rxrpc_call *call)
+bool rxrpc_kernel_get_srtt(struct socket *sock, struct rxrpc_call *call,
+			   u32 *_srtt)
 {
-	return call->peer->srtt_us >> 3;
+	struct rxrpc_peer *peer = call->peer;
+
+	if (peer->rtt_count == 0) {
+		*_srtt = 1000000; /* 1S */
+		return false;
+	}
+
+	*_srtt = call->peer->srtt_us >> 3;
+	return true;
 }
 EXPORT_SYMBOL(rxrpc_kernel_get_srtt);
-- 
2.25.1



