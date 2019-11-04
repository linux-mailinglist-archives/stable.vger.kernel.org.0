Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4565EEE0A
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388404AbfKDWKq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:10:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:44012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390584AbfKDWKp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:10:45 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A8F2205C9;
        Mon,  4 Nov 2019 22:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905444;
        bh=kFVJqAmDWjyPXzyh/0UkZ7lPETI8p4Ajzx7UBi59TOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n1G0jxSxGQ6VHUPcoPxIW3OlzFIdBPA/CCZcrSo8G9Z/JMJ4myhufhPi649o0x+7o
         3QuGaaeIki5JN/YTuD8lcx/5VDBw0IUp+NdV+Vy0WYYcwod36Jtj1zvOY0y02w3QJv
         zcwuHit57piXqrRDBRDzojV1OHIpEBQr25PxizQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b9be979c55f2bea8ed30@syzkaller.appspotmail.com,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 5.3 149/163] rxrpc: rxrpc_peer needs to hold a ref on the rxrpc_local record
Date:   Mon,  4 Nov 2019 22:45:39 +0100
Message-Id: <20191104212151.103290248@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 9ebeddef58c41bd700419cdcece24cf64ce32276 upstream.

The rxrpc_peer record needs to hold a reference on the rxrpc_local record
it points as the peer is used as a base to access information in the
rxrpc_local record.

This can cause problems in __rxrpc_put_peer(), where we need the network
namespace pointer, and in rxrpc_send_keepalive(), where we need to access
the UDP socket, leading to symptoms like:

    BUG: KASAN: use-after-free in __rxrpc_put_peer net/rxrpc/peer_object.c:411
    [inline]
    BUG: KASAN: use-after-free in rxrpc_put_peer+0x685/0x6a0
    net/rxrpc/peer_object.c:435
    Read of size 8 at addr ffff888097ec0058 by task syz-executor823/24216

Fix this by taking a ref on the local record for the peer record.

Fixes: ace45bec6d77 ("rxrpc: Fix firewall route keepalive")
Fixes: 2baec2c3f854 ("rxrpc: Support network namespacing")
Reported-by: syzbot+b9be979c55f2bea8ed30@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/rxrpc/peer_object.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -216,7 +216,7 @@ struct rxrpc_peer *rxrpc_alloc_peer(stru
 	peer = kzalloc(sizeof(struct rxrpc_peer), gfp);
 	if (peer) {
 		atomic_set(&peer->usage, 1);
-		peer->local = local;
+		peer->local = rxrpc_get_local(local);
 		INIT_HLIST_HEAD(&peer->error_targets);
 		peer->service_conns = RB_ROOT;
 		seqlock_init(&peer->service_conn_lock);
@@ -307,7 +307,6 @@ void rxrpc_new_incoming_peer(struct rxrp
 	unsigned long hash_key;
 
 	hash_key = rxrpc_peer_hash_key(local, &peer->srx);
-	peer->local = local;
 	rxrpc_init_peer(rx, peer, hash_key);
 
 	spin_lock(&rxnet->peer_hash_lock);
@@ -417,6 +416,7 @@ static void __rxrpc_put_peer(struct rxrp
 	list_del_init(&peer->keepalive_link);
 	spin_unlock_bh(&rxnet->peer_hash_lock);
 
+	rxrpc_put_local(peer->local);
 	kfree_rcu(peer, rcu);
 }
 
@@ -450,6 +450,7 @@ void rxrpc_put_peer_locked(struct rxrpc_
 	if (n == 0) {
 		hash_del_rcu(&peer->hash_link);
 		list_del_init(&peer->keepalive_link);
+		rxrpc_put_local(peer->local);
 		kfree_rcu(peer, rcu);
 	}
 }


