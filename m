Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11BB450C3E
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237879AbhKORf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:35:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:46726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237784AbhKOReR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:34:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68960632B6;
        Mon, 15 Nov 2021 17:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996955;
        bh=ieLN3nUBKVEQFiSnaay2xUyGJ+TwBCHGttvHlfouNjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tgdAHC7yKtrFYJru3IxvJRdtDPLj3X0bxbzA4JmryTH9JrJVTbQYh2B/T+QfFF+mt
         BcWSxTS9fGRvsDCuNY1J76+XM4HcDwq35s3Z0ylIz+gGMDQU5e3Y+4iAxzAMMz5gPv
         rjuHQBtlyh7FIOspXJPiM20a5EMlRvSKukUr0Hh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 330/355] net/smc: fix sk_refcnt underflow on linkdown and fallback
Date:   Mon, 15 Nov 2021 18:04:14 +0100
Message-Id: <20211115165324.411943977@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dust Li <dust.li@linux.alibaba.com>

[ Upstream commit e5d5aadcf3cd59949316df49c27cb21788d7efe4 ]

We got the following WARNING when running ab/nginx
test with RDMA link flapping (up-down-up).
The reason is when smc_sock fallback and at linkdown
happens simultaneously, we may got the following situation:

__smc_lgr_terminate()
 --> smc_conn_kill()
    --> smc_close_active_abort()
           smc_sock->sk_state = SMC_CLOSED
           sock_put(smc_sock)

smc_sock was set to SMC_CLOSED and sock_put() been called
when terminate the link group. But later application call
close() on the socket, then we got:

__smc_release():
    if (smc_sock->fallback)
        smc_sock->sk_state = SMC_CLOSED
        sock_put(smc_sock)

Again we set the smc_sock to CLOSED through it's already
in CLOSED state, and double put the refcnt, so the following
warning happens:

refcount_t: underflow; use-after-free.
WARNING: CPU: 5 PID: 860 at lib/refcount.c:28 refcount_warn_saturate+0x8d/0xf0
Modules linked in:
CPU: 5 PID: 860 Comm: nginx Not tainted 5.10.46+ #403
Hardware name: Alibaba Cloud Alibaba Cloud ECS, BIOS 8c24b4c 04/01/2014
RIP: 0010:refcount_warn_saturate+0x8d/0xf0
Code: 05 5c 1e b5 01 01 e8 52 25 bc ff 0f 0b c3 80 3d 4f 1e b5 01 00 75 ad 48

RSP: 0018:ffffc90000527e50 EFLAGS: 00010286
RAX: 0000000000000026 RBX: ffff8881300df2c0 RCX: 0000000000000027
RDX: 0000000000000000 RSI: ffff88813bd58040 RDI: ffff88813bd58048
RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000001
R10: ffff8881300df2c0 R11: ffffc90000527c78 R12: ffff8881300df340
R13: ffff8881300df930 R14: ffff88810b3dad80 R15: ffff8881300df4f8
FS:  00007f739de8fb80(0000) GS:ffff88813bd40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000a01b008 CR3: 0000000111b64003 CR4: 00000000003706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 smc_release+0x353/0x3f0
 __sock_release+0x3d/0xb0
 sock_close+0x11/0x20
 __fput+0x93/0x230
 task_work_run+0x65/0xa0
 exit_to_user_mode_prepare+0xf9/0x100
 syscall_exit_to_user_mode+0x27/0x190
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

This patch adds check in __smc_release() to make
sure we won't do an extra sock_put() and set the
socket to CLOSED when its already in CLOSED state.

Fixes: 51f1de79ad8e (net/smc: replace sock_put worker by socket refcounting)
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
Acked-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 2b3c13a0b2e5b..6b0f09c5b195f 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -139,14 +139,18 @@ static int __smc_release(struct smc_sock *smc)
 		sock_set_flag(sk, SOCK_DEAD);
 		sk->sk_shutdown |= SHUTDOWN_MASK;
 	} else {
-		if (sk->sk_state != SMC_LISTEN && sk->sk_state != SMC_INIT)
-			sock_put(sk); /* passive closing */
-		if (sk->sk_state == SMC_LISTEN) {
-			/* wake up clcsock accept */
-			rc = kernel_sock_shutdown(smc->clcsock, SHUT_RDWR);
+		if (sk->sk_state != SMC_CLOSED) {
+			if (sk->sk_state != SMC_LISTEN &&
+			    sk->sk_state != SMC_INIT)
+				sock_put(sk); /* passive closing */
+			if (sk->sk_state == SMC_LISTEN) {
+				/* wake up clcsock accept */
+				rc = kernel_sock_shutdown(smc->clcsock,
+							  SHUT_RDWR);
+			}
+			sk->sk_state = SMC_CLOSED;
+			sk->sk_state_change(sk);
 		}
-		sk->sk_state = SMC_CLOSED;
-		sk->sk_state_change(sk);
 		smc_restore_fallback_changes(smc);
 	}
 
-- 
2.33.0



