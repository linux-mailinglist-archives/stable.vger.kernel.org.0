Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A27C171BE2
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733158AbgB0OG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:06:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:43632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387930AbgB0OG2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:06:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E28520801;
        Thu, 27 Feb 2020 14:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812386;
        bh=IIh3/6eMhrXASqBJV3yaM2anrNKRohA6sfKmGIY7zaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mrUvsiGsGKPPp6/Us57mq1U9pm8KEwGkzt/DQ7+4d1hn/tUdk3M/mulb3Gc15wIrw
         hEVvt53f015m8RdSpfNSSwlmUGI/mIMLaWnQEs9nrLN9ogIzuf2aNnBt0NNGhK4iTf
         ITcORXTZkLWcI//wb4DbtvOgaEPJUgaPVQFbpiwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d82f3ac8d87e7ccbb2c9@syzkaller.appspotmail.com,
        syzbot+3f1fd6b8cbf8702d134e@syzkaller.appspotmail.com,
        David Howells <dhowells@redhat.com>,
        Hillf Danton <hdanton@sina.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 94/97] rxrpc: Fix call RCU cleanup using non-bh-safe locks
Date:   Thu, 27 Feb 2020 14:37:42 +0100
Message-Id: <20200227132230.025826948@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132214.553656188@linuxfoundation.org>
References: <20200227132214.553656188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 963485d436ccc2810177a7b08af22336ec2af67b upstream.

rxrpc_rcu_destroy_call(), which is called as an RCU callback to clean up a
put call, calls rxrpc_put_connection() which, deep in its bowels, takes a
number of spinlocks in a non-BH-safe way, including rxrpc_conn_id_lock and
local->client_conns_lock.  RCU callbacks, however, are normally called from
softirq context, which can cause lockdep to notice the locking
inconsistency.

To get lockdep to detect this, it's necessary to have the connection
cleaned up on the put at the end of the last of its calls, though normally
the clean up is deferred.  This can be induced, however, by starting a call
on an AF_RXRPC socket and then closing the socket without reading the
reply.

Fix this by having rxrpc_rcu_destroy_call() punt the destruction to a
workqueue if in softirq-mode and defer the destruction to process context.

Note that another way to fix this could be to add a bunch of bh-disable
annotations to the spinlocks concerned - and there might be more than just
those two - but that means spending more time with BHs disabled.

Note also that some of these places were covered by bh-disable spinlocks
belonging to the rxrpc_transport object, but these got removed without the
_bh annotation being retained on the next lock in.

Fixes: 999b69f89241 ("rxrpc: Kill the client connection bundle concept")
Reported-by: syzbot+d82f3ac8d87e7ccbb2c9@syzkaller.appspotmail.com
Reported-by: syzbot+3f1fd6b8cbf8702d134e@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/rxrpc/call_object.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -647,11 +647,11 @@ void rxrpc_put_call(struct rxrpc_call *c
 }
 
 /*
- * Final call destruction under RCU.
+ * Final call destruction - but must be done in process context.
  */
-static void rxrpc_rcu_destroy_call(struct rcu_head *rcu)
+static void rxrpc_destroy_call(struct work_struct *work)
 {
-	struct rxrpc_call *call = container_of(rcu, struct rxrpc_call, rcu);
+	struct rxrpc_call *call = container_of(work, struct rxrpc_call, processor);
 	struct rxrpc_net *rxnet = call->rxnet;
 
 	rxrpc_put_connection(call->conn);
@@ -664,6 +664,22 @@ static void rxrpc_rcu_destroy_call(struc
 }
 
 /*
+ * Final call destruction under RCU.
+ */
+static void rxrpc_rcu_destroy_call(struct rcu_head *rcu)
+{
+	struct rxrpc_call *call = container_of(rcu, struct rxrpc_call, rcu);
+
+	if (in_softirq()) {
+		INIT_WORK(&call->processor, rxrpc_destroy_call);
+		if (!rxrpc_queue_work(&call->processor))
+			BUG();
+	} else {
+		rxrpc_destroy_call(&call->processor);
+	}
+}
+
+/*
  * clean up a call
  */
 void rxrpc_cleanup_call(struct rxrpc_call *call)


