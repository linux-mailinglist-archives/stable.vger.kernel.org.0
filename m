Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05B85EED13
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388740AbfKDWDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:03:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:33394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389452AbfKDWDG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:03:06 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C10F205C9;
        Mon,  4 Nov 2019 22:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904985;
        bh=IpYPmy4gmiZam1d7YuHwmPD3cJ6PWCD00aouV9b9iUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c0yrNFtUxsXQatgc7gL3LCMikXzfaoQnqQvDg7gBzBA5vnsoPU7mOjDcxfOSWybg0
         nqg59GWubcygby4QrTMYhYz1d/2oBaHwPYqWyJ0DwaAm2lwrlGdsp3WLUmRKHNy+uv
         jLrNp4TPf+SVNAiIU6palRaknPf1rZu+nxHbp+B4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b9be979c55f2bea8ed30@syzkaller.appspotmail.com,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 4.19 140/149] rxrpc: Fix trace-after-put looking at the put peer record
Date:   Mon,  4 Nov 2019 22:45:33 +0100
Message-Id: <20191104212146.540148141@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 55f6c98e3674ce16038a1949c3f9ca5a9a99f289 upstream.

rxrpc_put_peer() calls trace_rxrpc_peer() after it has done the decrement
of the refcount - which looks at the debug_id in the peer record.  But
unless the refcount was reduced to zero, we no longer have the right to
look in the record and, indeed, it may be deleted by some other thread.

Fix this by getting the debug_id out before decrementing the refcount and
then passing that into the tracepoint.

This can cause the following symptoms:

    BUG: KASAN: use-after-free in __rxrpc_put_peer net/rxrpc/peer_object.c:411
    [inline]
    BUG: KASAN: use-after-free in rxrpc_put_peer+0x685/0x6a0
    net/rxrpc/peer_object.c:435
    Read of size 8 at addr ffff888097ec0058 by task syz-executor823/24216

Fixes: 1159d4b496f5 ("rxrpc: Add a tracepoint to track rxrpc_peer refcounting")
Reported-by: syzbot+b9be979c55f2bea8ed30@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/trace/events/rxrpc.h |    6 +++---
 net/rxrpc/peer_object.c      |   11 +++++++----
 2 files changed, 10 insertions(+), 7 deletions(-)

--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -527,10 +527,10 @@ TRACE_EVENT(rxrpc_local,
 	    );
 
 TRACE_EVENT(rxrpc_peer,
-	    TP_PROTO(struct rxrpc_peer *peer, enum rxrpc_peer_trace op,
+	    TP_PROTO(unsigned int peer_debug_id, enum rxrpc_peer_trace op,
 		     int usage, const void *where),
 
-	    TP_ARGS(peer, op, usage, where),
+	    TP_ARGS(peer_debug_id, op, usage, where),
 
 	    TP_STRUCT__entry(
 		    __field(unsigned int,	peer		)
@@ -540,7 +540,7 @@ TRACE_EVENT(rxrpc_peer,
 			     ),
 
 	    TP_fast_assign(
-		    __entry->peer = peer->debug_id;
+		    __entry->peer = peer_debug_id;
 		    __entry->op = op;
 		    __entry->usage = usage;
 		    __entry->where = where;
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -385,7 +385,7 @@ struct rxrpc_peer *rxrpc_get_peer(struct
 	int n;
 
 	n = atomic_inc_return(&peer->usage);
-	trace_rxrpc_peer(peer, rxrpc_peer_got, n, here);
+	trace_rxrpc_peer(peer->debug_id, rxrpc_peer_got, n, here);
 	return peer;
 }
 
@@ -399,7 +399,7 @@ struct rxrpc_peer *rxrpc_get_peer_maybe(
 	if (peer) {
 		int n = atomic_fetch_add_unless(&peer->usage, 1, 0);
 		if (n > 0)
-			trace_rxrpc_peer(peer, rxrpc_peer_got, n + 1, here);
+			trace_rxrpc_peer(peer->debug_id, rxrpc_peer_got, n + 1, here);
 		else
 			peer = NULL;
 	}
@@ -430,11 +430,13 @@ static void __rxrpc_put_peer(struct rxrp
 void rxrpc_put_peer(struct rxrpc_peer *peer)
 {
 	const void *here = __builtin_return_address(0);
+	unsigned int debug_id;
 	int n;
 
 	if (peer) {
+		debug_id = peer->debug_id;
 		n = atomic_dec_return(&peer->usage);
-		trace_rxrpc_peer(peer, rxrpc_peer_put, n, here);
+		trace_rxrpc_peer(debug_id, rxrpc_peer_put, n, here);
 		if (n == 0)
 			__rxrpc_put_peer(peer);
 	}
@@ -447,10 +449,11 @@ void rxrpc_put_peer(struct rxrpc_peer *p
 void rxrpc_put_peer_locked(struct rxrpc_peer *peer)
 {
 	const void *here = __builtin_return_address(0);
+	unsigned int debug_id = peer->debug_id;
 	int n;
 
 	n = atomic_dec_return(&peer->usage);
-	trace_rxrpc_peer(peer, rxrpc_peer_put, n, here);
+	trace_rxrpc_peer(debug_id, rxrpc_peer_put, n, here);
 	if (n == 0) {
 		hash_del_rcu(&peer->hash_link);
 		list_del_init(&peer->keepalive_link);


