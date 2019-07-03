Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 808BD5CA80
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbfGBIEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:04:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727142AbfGBIEw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:04:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D15BD20659;
        Tue,  2 Jul 2019 08:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054691;
        bh=S96FEG0nVx2N8+vil/9FN24waHQtjkWeU2/L8gA4cXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y90CQ2itR8zojVjEvymPN9s7Zv6ygAkkUEF0hp+TtneIvFnBzHPpeqQ3mYbLBnfHR
         mD0T7qpqbvx18mJx6U1cXLCbpdq+O2Wl+SUCK46JNoCNGxLd32KCKRi0gK9oRxGt/V
         W3rhqJL/gZidvPnzyawOcTRIJkqaa1/DMyewI/LY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 37/55] net/tls: fix page double free on TX cleanup
Date:   Tue,  2 Jul 2019 10:01:45 +0200
Message-Id: <20190702080126.051692389@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

[ Upstream commit 9354544cbccf68da1b047f8fb7b47630e3c8a59d ]

With commit 94850257cf0f ("tls: Fix tls_device handling of partial records")
a new path was introduced to cleanup partial records during sk_proto_close.
This path does not handle the SW KTLS tx_list cleanup.

This is unnecessary though since the free_resources calls for both
SW and offload paths will cleanup a partial record.

The visible effect is the following warning, but this bug also causes
a page double free.

    WARNING: CPU: 7 PID: 4000 at net/core/stream.c:206 sk_stream_kill_queues+0x103/0x110
    RIP: 0010:sk_stream_kill_queues+0x103/0x110
    RSP: 0018:ffffb6df87e07bd0 EFLAGS: 00010206
    RAX: 0000000000000000 RBX: ffff8c21db4971c0 RCX: 0000000000000007
    RDX: ffffffffffffffa0 RSI: 000000000000001d RDI: ffff8c21db497270
    RBP: ffff8c21db497270 R08: ffff8c29f4748600 R09: 000000010020001a
    R10: ffffb6df87e07aa0 R11: ffffffff9a445600 R12: 0000000000000007
    R13: 0000000000000000 R14: ffff8c21f03f2900 R15: ffff8c21f03b8df0
    Call Trace:
     inet_csk_destroy_sock+0x55/0x100
     tcp_close+0x25d/0x400
     ? tcp_check_oom+0x120/0x120
     tls_sk_proto_close+0x127/0x1c0
     inet_release+0x3c/0x60
     __sock_release+0x3d/0xb0
     sock_close+0x11/0x20
     __fput+0xd8/0x210
     task_work_run+0x84/0xa0
     do_exit+0x2dc/0xb90
     ? release_sock+0x43/0x90
     do_group_exit+0x3a/0xa0
     get_signal+0x295/0x720
     do_signal+0x36/0x610
     ? SYSC_recvfrom+0x11d/0x130
     exit_to_usermode_loop+0x69/0xb0
     do_syscall_64+0x173/0x180
     entry_SYSCALL_64_after_hwframe+0x3d/0xa2
    RIP: 0033:0x7fe9b9abc10d
    RSP: 002b:00007fe9b19a1d48 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
    RAX: fffffffffffffe00 RBX: 0000000000000006 RCX: 00007fe9b9abc10d
    RDX: 0000000000000002 RSI: 0000000000000080 RDI: 00007fe948003430
    RBP: 00007fe948003410 R08: 00007fe948003430 R09: 0000000000000000
    R10: 0000000000000000 R11: 0000000000000246 R12: 00005603739d9080
    R13: 00007fe9b9ab9f90 R14: 00007fe948003430 R15: 0000000000000000

Fixes: 94850257cf0f ("tls: Fix tls_device handling of partial records")
Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tls.h  |   15 ---------------
 net/tls/tls_main.c |    3 ++-
 2 files changed, 2 insertions(+), 16 deletions(-)

--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -347,21 +347,6 @@ static inline bool tls_is_partially_sent
 	return !!ctx->partially_sent_record;
 }
 
-static inline int tls_complete_pending_work(struct sock *sk,
-					    struct tls_context *ctx,
-					    int flags, long *timeo)
-{
-	int rc = 0;
-
-	if (unlikely(sk->sk_write_pending))
-		rc = wait_on_pending_writer(sk, timeo);
-
-	if (!rc && tls_is_partially_sent_record(ctx))
-		rc = tls_push_partial_record(sk, ctx, flags);
-
-	return rc;
-}
-
 static inline bool tls_is_pending_open_record(struct tls_context *tls_ctx)
 {
 	return tls_ctx->pending_open_record_frags;
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -279,7 +279,8 @@ static void tls_sk_proto_close(struct so
 		goto skip_tx_cleanup;
 	}
 
-	if (!tls_complete_pending_work(sk, ctx, 0, &timeo))
+	if (unlikely(sk->sk_write_pending) &&
+	    !wait_on_pending_writer(sk, &timeo))
 		tls_handle_open_record(sk, 0);
 
 	/* We need these for tls_sw_fallback handling of other packets */


