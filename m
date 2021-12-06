Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E1E469E04
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbhLFPeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:34:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35518 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240963AbhLFP3q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:29:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97C6AB8111E;
        Mon,  6 Dec 2021 15:26:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E242EC34900;
        Mon,  6 Dec 2021 15:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804375;
        bh=T1+AWrgFfWC/bdbtoq6AvaiABImzrEG+jCZKrudqcOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=datQMe68rx+m8YokwAnsB3uaOBz0/VpMzQimCYJasxmg0c+nmpVw5aZfTchpMb0gX
         wypTcktrNzAp7Rgdv6GTHsdTbsjkaU7kCZYmRvVf0CjFUUhLr5ntr7liLtxB2BJUKq
         ehQHPlrkrKP51N79baqnGmtqGWWQYvlv6FteJBeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eiichi Tsukata <eiichi.tsukata@nutanix.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org
Subject: [PATCH 5.15 124/207] rxrpc: Fix rxrpc_peer leak in rxrpc_look_up_bundle()
Date:   Mon,  6 Dec 2021 15:56:18 +0100
Message-Id: <20211206145614.531064723@linuxfoundation.org>
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
@@ -328,7 +332,7 @@ static struct rxrpc_bundle *rxrpc_look_u
 	return candidate;
 
 found_bundle_free:
-	kfree(candidate);
+	rxrpc_free_bundle(candidate);
 found_bundle:
 	rxrpc_get_bundle(bundle);
 	spin_unlock(&local->client_bundles_lock);


