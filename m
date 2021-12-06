Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9441469BAD
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356759AbhLFPSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:18:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48820 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358034AbhLFPQZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:16:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBC20B810F1;
        Mon,  6 Dec 2021 15:12:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4752C341C2;
        Mon,  6 Dec 2021 15:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803574;
        bh=rUS+rCInb2rt+CdpgZSpzW+F9rzeq1letG6D9IcOosc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hqLXJj/iLlZhLTKzwUbCy4p6Sim7v5ivrgCUXKNMnOar8yyonoxEXZ2b0zif+/pwK
         nXw63ZrXR4horvzAtj2ntIE36EkJ2ZObvl9HJNvL7rUnQqbBdC1SN/5On1B8fSnJTQ
         lFhzVDuBdrN9CSdoLEM5mnjDNjuHETf1Li43IYTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eiichi Tsukata <eiichi.tsukata@nutanix.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org
Subject: [PATCH 5.4 42/70] rxrpc: Fix rxrpc_local leak in rxrpc_lookup_peer()
Date:   Mon,  6 Dec 2021 15:56:46 +0100
Message-Id: <20211206145553.391929442@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145551.909846023@linuxfoundation.org>
References: <20211206145551.909846023@linuxfoundation.org>
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
@@ -297,6 +297,12 @@ static struct rxrpc_peer *rxrpc_create_p
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
@@ -363,7 +369,7 @@ struct rxrpc_peer *rxrpc_lookup_peer(str
 		spin_unlock_bh(&rxnet->peer_hash_lock);
 
 		if (peer)
-			kfree(candidate);
+			rxrpc_free_peer(candidate);
 		else
 			peer = candidate;
 	}
@@ -418,8 +424,7 @@ static void __rxrpc_put_peer(struct rxrp
 	list_del_init(&peer->keepalive_link);
 	spin_unlock_bh(&rxnet->peer_hash_lock);
 
-	rxrpc_put_local(peer->local);
-	kfree_rcu(peer, rcu);
+	rxrpc_free_peer(peer);
 }
 
 /*
@@ -455,8 +460,7 @@ void rxrpc_put_peer_locked(struct rxrpc_
 	if (n == 0) {
 		hash_del_rcu(&peer->hash_link);
 		list_del_init(&peer->keepalive_link);
-		rxrpc_put_local(peer->local);
-		kfree_rcu(peer, rcu);
+		rxrpc_free_peer(peer);
 	}
 }
 


