Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6403113917
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 12:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbfEDK1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 06:27:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727337AbfEDK1I (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 06:27:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B595F20859;
        Sat,  4 May 2019 10:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556965627;
        bh=bu4Qr5GLcxAJI6wB3LOHDbPjo4NMJVK8ZhjryAZWb9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IxISS7eMgcICZn1UkoD2343mfDRlMwJfTdvL8h34twQAixgO/BmzVdv9+WGm8Hv2I
         8XZCitKVrci1En6vmQxOhQUUZzU0MqiMOgezq9xD4BbrwBefrtpg6uATCWSYi7+v8T
         JL6wueyMf1uM5E65QAwBZ1C3c57yJpT6VqOekY6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 11/23] rxrpc: Fix net namespace cleanup
Date:   Sat,  4 May 2019 12:25:13 +0200
Message-Id: <20190504102451.914917394@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504102451.512405835@linuxfoundation.org>
References: <20190504102451.512405835@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit b13023421b5179413421333f602850914f6a7ad8 ]

In rxrpc_destroy_all_calls(), there are two phases: (1) make sure the
->calls list is empty, emitting error messages if not, and (2) wait for the
RCU cleanup to happen on outstanding calls (ie. ->nr_calls becomes 0).

To avoid taking the call_lock, the function prechecks ->calls and if empty,
it returns to avoid taking the lock - this is wrong, however: it still
needs to go and do the second phase and wait for ->nr_calls to become 0.

Without this, the rxrpc_net struct may get deallocated before we get to the
RCU cleanup for the last calls.  This can lead to:

  Slab corruption (Not tainted): kmalloc-16k start=ffff88802b178000, len=16384
  050: 6b 6b 6b 6b 6b 6b 6b 6b 61 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkakkkkkkk

Note the "61" at offset 0x58.  This corresponds to the ->nr_calls member of
struct rxrpc_net (which is >9k in size, and thus allocated out of the 16k
slab).

Fix this by flipping the condition on the if-statement, putting the locked
section inside the if-body and dropping the return from there.  The
function will then always go on to wait for the RCU cleanup on outstanding
calls.

Fixes: 2baec2c3f854 ("rxrpc: Support network namespacing")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/call_object.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -701,30 +701,30 @@ void rxrpc_destroy_all_calls(struct rxrp
 
 	_enter("");
 
-	if (list_empty(&rxnet->calls))
-		return;
-
-	write_lock(&rxnet->call_lock);
+	if (!list_empty(&rxnet->calls)) {
+		write_lock(&rxnet->call_lock);
 
-	while (!list_empty(&rxnet->calls)) {
-		call = list_entry(rxnet->calls.next, struct rxrpc_call, link);
-		_debug("Zapping call %p", call);
-
-		rxrpc_see_call(call);
-		list_del_init(&call->link);
-
-		pr_err("Call %p still in use (%d,%s,%lx,%lx)!\n",
-		       call, atomic_read(&call->usage),
-		       rxrpc_call_states[call->state],
-		       call->flags, call->events);
+		while (!list_empty(&rxnet->calls)) {
+			call = list_entry(rxnet->calls.next,
+					  struct rxrpc_call, link);
+			_debug("Zapping call %p", call);
+
+			rxrpc_see_call(call);
+			list_del_init(&call->link);
+
+			pr_err("Call %p still in use (%d,%s,%lx,%lx)!\n",
+			       call, atomic_read(&call->usage),
+			       rxrpc_call_states[call->state],
+			       call->flags, call->events);
+
+			write_unlock(&rxnet->call_lock);
+			cond_resched();
+			write_lock(&rxnet->call_lock);
+		}
 
 		write_unlock(&rxnet->call_lock);
-		cond_resched();
-		write_lock(&rxnet->call_lock);
 	}
 
-	write_unlock(&rxnet->call_lock);
-
 	atomic_dec(&rxnet->nr_calls);
 	wait_var_event(&rxnet->nr_calls, !atomic_read(&rxnet->nr_calls));
 }


