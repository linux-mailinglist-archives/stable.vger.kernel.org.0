Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD3B469ED1
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391050AbhLFPoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390431AbhLFPmY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91659C0A885C;
        Mon,  6 Dec 2021 07:26:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F465B81138;
        Mon,  6 Dec 2021 15:26:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44B1C34902;
        Mon,  6 Dec 2021 15:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804378;
        bh=2IqzMPuwz65FUzblmUGeYgOYGVyBQvH/aDNHAgMUgLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XNiOEt0UWW8Wjtj3xSx6ht1AH7PXc+aaFzdCAcnk76JSN7SudB5A1wGXt5xNVJlMo
         iqZpxyAti1kmh0nrTe6GmK/JhXEGrI5QTslaa3RvSb/+ljktVQ7Ct84fdbraE5GRtM
         LzcLSH4Yz5JTOQigYHEGzmvmjUOhx5VUzZx7+3Hc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eiichi Tsukata <eiichi.tsukata@nutanix.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org
Subject: [PATCH 5.15 125/207] rxrpc: Fix rxrpc_local leak in rxrpc_lookup_peer()
Date:   Mon,  6 Dec 2021 15:56:19 +0100
Message-Id: <20211206145614.570394070@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
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
 


