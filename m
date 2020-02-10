Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E92B1574DE
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbgBJMgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:36:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:55826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728410AbgBJMgc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:32 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3210620842;
        Mon, 10 Feb 2020 12:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338192;
        bh=oEM3+nzDqWEevdqdRzE0EAc4DVyMz1ux+ltBjgdHDZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LngIwRZspy3C5f2B2hBYP1VYMcaqi81ZPd+0AIx50R0XB1CGwz3fbwRwo/xVqVGnA
         JXn3UDHPWO6Bs6utrb9YXyGwFn0EyIiDeP60i61UY5gIk+XQ9hULjL3wTly4/DCEko
         7N8VULTsOwGz8R6XELwmdfQ9OGkeDeNc92yk7G6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 195/195] rxrpc: Fix service call disconnection
Date:   Mon, 10 Feb 2020 04:34:13 -0800
Message-Id: <20200210122324.215756193@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit b39a934ec72fa2b5a74123891f25273a38378b90 ]

The recent patch that substituted a flag on an rxrpc_call for the
connection pointer being NULL as an indication that a call was disconnected
puts the set_bit in the wrong place for service calls.  This is only a
problem if a call is implicitly terminated by a new call coming in on the
same connection channel instead of a terminating ACK packet.

In such a case, rxrpc_input_implicit_end_call() calls
__rxrpc_disconnect_call(), which is now (incorrectly) setting the
disconnection bit, meaning that when rxrpc_release_call() is later called,
it doesn't call rxrpc_disconnect_call() and so the call isn't removed from
the peer's error distribution list and the list gets corrupted.

KASAN finds the issue as an access after release on a call, but the
position at which it occurs is confusing as it appears to be related to a
different call (the call site is where the latter call is being removed
from the error distribution list and either the next or pprev pointer
points to a previously released call).

Fix this by moving the setting of the flag from __rxrpc_disconnect_call()
to rxrpc_disconnect_call() in the same place that the connection pointer
was being cleared.

Fixes: 5273a191dca6 ("rxrpc: Fix NULL pointer deref due to call->conn being cleared on disconnect")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/conn_object.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index a81e64be4a24f..c4c4450891e0f 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -174,8 +174,6 @@ void __rxrpc_disconnect_call(struct rxrpc_connection *conn,
 
 	_enter("%d,%x", conn->debug_id, call->cid);
 
-	set_bit(RXRPC_CALL_DISCONNECTED, &call->flags);
-
 	if (rcu_access_pointer(chan->call) == call) {
 		/* Save the result of the call so that we can repeat it if necessary
 		 * through the channel, whilst disposing of the actual call record.
@@ -228,6 +226,7 @@ void rxrpc_disconnect_call(struct rxrpc_call *call)
 	__rxrpc_disconnect_call(conn, call);
 	spin_unlock(&conn->channel_lock);
 
+	set_bit(RXRPC_CALL_DISCONNECTED, &call->flags);
 	conn->idle_timestamp = jiffies;
 }
 
-- 
2.20.1



