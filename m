Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCF4469DD6
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359795AbhLFPdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:33:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376933AbhLFP2v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:28:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E42BC08ED6B;
        Mon,  6 Dec 2021 07:18:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AB5161327;
        Mon,  6 Dec 2021 15:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13EB6C341C1;
        Mon,  6 Dec 2021 15:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803891;
        bh=2IqzMPuwz65FUzblmUGeYgOYGVyBQvH/aDNHAgMUgLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B/bQrJ+803pIiRS3z2K1KaUq+b84dfUrnlx1sWJpOsQUfL/fbnU/3E3QyX6MBrDBg
         Y1Awy3Y2idMPtHIMGtIv0zt+Tif82FwJjd7Ux6xVvChzABB+sZYakL5reovHmk3ce4
         FTjQmPyfi/SWPC1pI08mcoop8lu6rg2SMK/8Xd48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eiichi Tsukata <eiichi.tsukata@nutanix.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org
Subject: [PATCH 5.10 084/130] rxrpc: Fix rxrpc_local leak in rxrpc_lookup_peer()
Date:   Mon,  6 Dec 2021 15:56:41 +0100
Message-Id: <20211206145602.565491138@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eiichi Tsukata <eiichi.tsukata@nutanix.com>

commit beacff50edbd6c9659a6f15fc7f6126909fade29 upstream.

Need to call rxrpc_put_local() for peer candidate before kfree() as it
holds a ref to rxrpc_local.

[DH: v2: Changed to abstract the peer freeing code out into a function]

Fixes: 9ebeddef58c4 ("rxrpc: rxrpc_peer needs to hold a ref on the rxrpc_local record")
Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/all/20211121041608.133740-2-eiichi.tsukata@nutanix.com/ # v1
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/peer_object.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -299,6 +299,12 @@ static struct rxrpc_peer *rxrpc_create_p
 	return peer;
 }
 
+static void rxrpc_free_peer(struct rxrpc_peer *peer)
+{
+	rxrpc_put_local(peer->local);
+	kfree_rcu(peer, rcu);
+}
+
 /*
  * Set up a new incoming peer.  There shouldn't be any other matching peers
  * since we've already done a search in the list from the non-reentrant context
@@ -365,7 +371,7 @@ struct rxrpc_peer *rxrpc_lookup_peer(str
 		spin_unlock_bh(&rxnet->peer_hash_lock);
 
 		if (peer)
-			kfree(candidate);
+			rxrpc_free_peer(candidate);
 		else
 			peer = candidate;
 	}
@@ -420,8 +426,7 @@ static void __rxrpc_put_peer(struct rxrp
 	list_del_init(&peer->keepalive_link);
 	spin_unlock_bh(&rxnet->peer_hash_lock);
 
-	rxrpc_put_local(peer->local);
-	kfree_rcu(peer, rcu);
+	rxrpc_free_peer(peer);
 }
 
 /*
@@ -457,8 +462,7 @@ void rxrpc_put_peer_locked(struct rxrpc_
 	if (n == 0) {
 		hash_del_rcu(&peer->hash_link);
 		list_del_init(&peer->keepalive_link);
-		rxrpc_put_local(peer->local);
-		kfree_rcu(peer, rcu);
+		rxrpc_free_peer(peer);
 	}
 }
 


