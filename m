Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D47CDE68A6
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730746AbfJ0VQF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:16:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730755AbfJ0VQE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:16:04 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B0AE205C9;
        Sun, 27 Oct 2019 21:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210963;
        bh=YoEztnlNwL6HtikXn8bjI9EGUovjilf4uQ1n7AJus9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rHWmvvoDU8gNWOsvujQZQtbI5rox1sOA5+ZUsQZPOVTDXHEbgwwnHO4+mcW7GM+OJ
         /NOn48z7mLXDCuiXbZGKCcp1u85fJrItk0JV3GjR1Duw9kY+PNbsoxLp3xynwpYC8h
         i2Wd7YqN4enlBQalvja8lgz4M5/v2HEiJ0CVWdHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d44f7bbebdea49dbc84a@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 34/93] sctp: change sctp_prot .no_autobind with true
Date:   Sun, 27 Oct 2019 22:00:46 +0100
Message-Id: <20191027203257.811558591@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
References: <20191027203251.029297948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 63dfb7938b13fa2c2fbcb45f34d065769eb09414 ]

syzbot reported a memory leak:

  BUG: memory leak, unreferenced object 0xffff888120b3d380 (size 64):
  backtrace:

    [...] slab_alloc mm/slab.c:3319 [inline]
    [...] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3483
    [...] sctp_bucket_create net/sctp/socket.c:8523 [inline]
    [...] sctp_get_port_local+0x189/0x5a0 net/sctp/socket.c:8270
    [...] sctp_do_bind+0xcc/0x200 net/sctp/socket.c:402
    [...] sctp_bindx_add+0x4b/0xd0 net/sctp/socket.c:497
    [...] sctp_setsockopt_bindx+0x156/0x1b0 net/sctp/socket.c:1022
    [...] sctp_setsockopt net/sctp/socket.c:4641 [inline]
    [...] sctp_setsockopt+0xaea/0x2dc0 net/sctp/socket.c:4611
    [...] sock_common_setsockopt+0x38/0x50 net/core/sock.c:3147
    [...] __sys_setsockopt+0x10f/0x220 net/socket.c:2084
    [...] __do_sys_setsockopt net/socket.c:2100 [inline]

It was caused by when sending msgs without binding a port, in the path:
inet_sendmsg() -> inet_send_prepare() -> inet_autobind() ->
.get_port/sctp_get_port(), sp->bind_hash will be set while bp->port is
not. Later when binding another port by sctp_setsockopt_bindx(), a new
bucket will be created as bp->port is not set.

sctp's autobind is supposed to call sctp_autobind() where it does all
things including setting bp->port. Since sctp_autobind() is called in
sctp_sendmsg() if the sk is not yet bound, it should have skipped the
auto bind.

THis patch is to avoid calling inet_autobind() in inet_send_prepare()
by changing sctp_prot .no_autobind with true, also remove the unused
.get_port.

Reported-by: syzbot+d44f7bbebdea49dbc84a@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/socket.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8957,7 +8957,7 @@ struct proto sctp_prot = {
 	.backlog_rcv =	sctp_backlog_rcv,
 	.hash        =	sctp_hash,
 	.unhash      =	sctp_unhash,
-	.get_port    =	sctp_get_port,
+	.no_autobind =	true,
 	.obj_size    =  sizeof(struct sctp_sock),
 	.useroffset  =  offsetof(struct sctp_sock, subscribe),
 	.usersize    =  offsetof(struct sctp_sock, initmsg) -
@@ -8999,7 +8999,7 @@ struct proto sctpv6_prot = {
 	.backlog_rcv	= sctp_backlog_rcv,
 	.hash		= sctp_hash,
 	.unhash		= sctp_unhash,
-	.get_port	= sctp_get_port,
+	.no_autobind	= true,
 	.obj_size	= sizeof(struct sctp6_sock),
 	.useroffset	= offsetof(struct sctp6_sock, sctp.subscribe),
 	.usersize	= offsetof(struct sctp6_sock, sctp.initmsg) -


