Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3152F469C95
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359036AbhLFPXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:23:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54704 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350413AbhLFPVk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:21:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F13A2B8111D;
        Mon,  6 Dec 2021 15:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42197C341C2;
        Mon,  6 Dec 2021 15:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803888;
        bh=tSqysFfU2+McDeBxQy4P3JHhOz7l+3c2gy+HKXtOLaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jwScAPaTRh2QV0U4SYQkyv8/XOn10yVne2HbYZI3cwnoyRlEF1bxuiJ48wpRTAnV1
         VW5ls7WtXQPikKGCsO7qlD0NM8PQ172bYQyIr+hizQAd4IB9+ngcQEFuRBRWzfhzdi
         JwcRpCWAYcDPhf7JDZ5tcyftuUeVBp37ObYyfdko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eiichi Tsukata <eiichi.tsukata@nutanix.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org
Subject: [PATCH 5.10 083/130] rxrpc: Fix rxrpc_peer leak in rxrpc_look_up_bundle()
Date:   Mon,  6 Dec 2021 15:56:40 +0100
Message-Id: <20211206145602.532745853@linuxfoundation.org>
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

commit ca77fba821351190777b236ce749d7c4d353102e upstream.

Need to call rxrpc_put_peer() for bundle candidate before kfree() as it
holds a ref to rxrpc_peer.

[DH: v2: Changed to abstract out the bundle freeing code into a function]

Fixes: 245500d853e9 ("rxrpc: Rewrite the client connection manager")
Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/20211121041608.133740-1-eiichi.tsukata@nutanix.com/ # v1
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/conn_client.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -135,16 +135,20 @@ struct rxrpc_bundle *rxrpc_get_bundle(st
 	return bundle;
 }
 
+static void rxrpc_free_bundle(struct rxrpc_bundle *bundle)
+{
+	rxrpc_put_peer(bundle->params.peer);
+	kfree(bundle);
+}
+
 void rxrpc_put_bundle(struct rxrpc_bundle *bundle)
 {
 	unsigned int d = bundle->debug_id;
 	unsigned int u = atomic_dec_return(&bundle->usage);
 
 	_debug("PUT B=%x %u", d, u);
-	if (u == 0) {
-		rxrpc_put_peer(bundle->params.peer);
-		kfree(bundle);
-	}
+	if (u == 0)
+		rxrpc_free_bundle(bundle);
 }
 
 /*
@@ -334,7 +338,7 @@ static struct rxrpc_bundle *rxrpc_look_u
 	return candidate;
 
 found_bundle_free:
-	kfree(candidate);
+	rxrpc_free_bundle(candidate);
 found_bundle:
 	rxrpc_get_bundle(bundle);
 	spin_unlock(&local->client_bundles_lock);


