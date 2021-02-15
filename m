Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7888A31BD3B
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbhBOPms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:42:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:49648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231140AbhBOPiK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:38:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D86064EF2;
        Mon, 15 Feb 2021 15:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403255;
        bh=0E08mI+AalxikaHCYFbHxJVQdmeRgju6IU3SyRsu1GI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u1RmVLvm00DXcG2DUNq1H/oXpHR9IrdGmrieSPvQXOvHOdBijG36BjjzNKAiXhXja
         ASoJe8sCaCmK+on9jk4qoOtHwuiwH8HY+Dr0m6sXh3VFQz0iaAovmmuIsI1coBT7KJ
         CLcsHZNPhNmh0e7pDwKLT5FMOrp7Jkj8tx+GjyGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+174de899852504e4a74a@syzkaller.appspotmail.com,
        syzbot+3d1c772efafd3c38d007@syzkaller.appspotmail.com,
        David Howells <dhowells@redhat.com>,
        Hillf Danton <hdanton@sina.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 087/104] rxrpc: Fix clearance of Tx/Rx ring when releasing a call
Date:   Mon, 15 Feb 2021 16:27:40 +0100
Message-Id: <20210215152722.264884406@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 7b5eab57cac45e270a0ad624ba157c5b30b3d44d upstream.

At the end of rxrpc_release_call(), rxrpc_cleanup_ring() is called to clear
the Rx/Tx skbuff ring, but this doesn't lock the ring whilst it's accessing
it.  Unfortunately, rxrpc_resend() might be trying to retransmit a packet
concurrently with this - and whilst it does lock the ring, this isn't
protection against rxrpc_cleanup_call().

Fix this by removing the call to rxrpc_cleanup_ring() from
rxrpc_release_call().  rxrpc_cleanup_ring() will be called again anyway
from rxrpc_cleanup_call().  The earlier call is just an optimisation to
recycle skbuffs more quickly.

Alternative solutions include rxrpc_release_call() could try to cancel the
work item or wait for it to complete or rxrpc_cleanup_ring() could lock
when accessing the ring (which would require a bh lock).

This can produce a report like the following:

  BUG: KASAN: use-after-free in rxrpc_send_data_packet+0x19b4/0x1e70 net/rxrpc/output.c:372
  Read of size 4 at addr ffff888011606e04 by task kworker/0:0/5
  ...
  Workqueue: krxrpcd rxrpc_process_call
  Call Trace:
   ...
   kasan_report.cold+0x79/0xd5 mm/kasan/report.c:413
   rxrpc_send_data_packet+0x19b4/0x1e70 net/rxrpc/output.c:372
   rxrpc_resend net/rxrpc/call_event.c:266 [inline]
   rxrpc_process_call+0x1634/0x1f60 net/rxrpc/call_event.c:412
   process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
   ...

  Allocated by task 2318:
   ...
   sock_alloc_send_pskb+0x793/0x920 net/core/sock.c:2348
   rxrpc_send_data+0xb51/0x2bf0 net/rxrpc/sendmsg.c:358
   rxrpc_do_sendmsg+0xc03/0x1350 net/rxrpc/sendmsg.c:744
   rxrpc_sendmsg+0x420/0x630 net/rxrpc/af_rxrpc.c:560
   ...

  Freed by task 2318:
   ...
   kfree_skb+0x140/0x3f0 net/core/skbuff.c:704
   rxrpc_free_skb+0x11d/0x150 net/rxrpc/skbuff.c:78
   rxrpc_cleanup_ring net/rxrpc/call_object.c:485 [inline]
   rxrpc_release_call+0x5dd/0x860 net/rxrpc/call_object.c:552
   rxrpc_release_calls_on_socket+0x21c/0x300 net/rxrpc/call_object.c:579
   rxrpc_release_sock net/rxrpc/af_rxrpc.c:885 [inline]
   rxrpc_release+0x263/0x5a0 net/rxrpc/af_rxrpc.c:916
   __sock_release+0xcd/0x280 net/socket.c:597
   ...

  The buggy address belongs to the object at ffff888011606dc0
   which belongs to the cache skbuff_head_cache of size 232

Fixes: 248f219cb8bc ("rxrpc: Rewrite the data and ack handling code")
Reported-by: syzbot+174de899852504e4a74a@syzkaller.appspotmail.com
Reported-by: syzbot+3d1c772efafd3c38d007@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Hillf Danton <hdanton@sina.com>
Link: https://lore.kernel.org/r/161234207610.653119.5287360098400436976.stgit@warthog.procyon.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/call_object.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -548,8 +548,6 @@ void rxrpc_release_call(struct rxrpc_soc
 		rxrpc_disconnect_call(call);
 	if (call->security)
 		call->security->free_call_crypto(call);
-
-	rxrpc_cleanup_ring(call);
 	_leave("");
 }
 


