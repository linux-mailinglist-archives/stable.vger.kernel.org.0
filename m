Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8DD4A431D
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376449AbiAaLRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:17:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34718 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376411AbiAaLPU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:15:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30150B82A4C;
        Mon, 31 Jan 2022 11:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79376C340E8;
        Mon, 31 Jan 2022 11:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627715;
        bh=a507W/y4irl+68QJWxOJvR5ERU6MgSxRpkScSXBKGhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RPsGunC2hH5ohtiSw41ca/x33kP6EpXKDWaZ6Id9EdwWCL9a/+mRG8p0wKE5nI8CX
         zciA3xMlspCXiuwtYujc44LXMTybEfkT6UmBUTUMzOgwvgJGrsY8TFob6duDiYUYfi
         ItRtKWvZdrURDBS9c6jdhDwBB9sxYUQRHSIw2wbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Gu <guwen@linux.alibaba.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/171] net/smc: Transitional solution for clcsock race issue
Date:   Mon, 31 Jan 2022 11:56:46 +0100
Message-Id: <20220131105234.777775476@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Gu <guwen@linux.alibaba.com>

[ Upstream commit c0bf3d8a943b6f2e912b7c1de03e2ef28e76f760 ]

We encountered a crash in smc_setsockopt() and it is caused by
accessing smc->clcsock after clcsock was released.

 BUG: kernel NULL pointer dereference, address: 0000000000000020
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] PREEMPT SMP PTI
 CPU: 1 PID: 50309 Comm: nginx Kdump: loaded Tainted: G E     5.16.0-rc4+ #53
 RIP: 0010:smc_setsockopt+0x59/0x280 [smc]
 Call Trace:
  <TASK>
  __sys_setsockopt+0xfc/0x190
  __x64_sys_setsockopt+0x20/0x30
  do_syscall_64+0x34/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7f16ba83918e
  </TASK>

This patch tries to fix it by holding clcsock_release_lock and
checking whether clcsock has already been released before access.

In case that a crash of the same reason happens in smc_getsockopt()
or smc_switch_to_fallback(), this patch also checkes smc->clcsock
in them too. And the caller of smc_switch_to_fallback() will identify
whether fallback succeeds according to the return value.

Fixes: fd57770dd198 ("net/smc: wait for pending work before clcsock release_sock")
Link: https://lore.kernel.org/lkml/5dd7ffd1-28e2-24cc-9442-1defec27375e@linux.ibm.com/T/
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Acked-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 63 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 51 insertions(+), 12 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 07ff719f39077..34608369b426f 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -548,12 +548,17 @@ static void smc_stat_fallback(struct smc_sock *smc)
 	mutex_unlock(&net->smc.mutex_fback_rsn);
 }
 
-static void smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
+static int smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 {
 	wait_queue_head_t *smc_wait = sk_sleep(&smc->sk);
-	wait_queue_head_t *clc_wait = sk_sleep(smc->clcsock->sk);
+	wait_queue_head_t *clc_wait;
 	unsigned long flags;
 
+	mutex_lock(&smc->clcsock_release_lock);
+	if (!smc->clcsock) {
+		mutex_unlock(&smc->clcsock_release_lock);
+		return -EBADF;
+	}
 	smc->use_fallback = true;
 	smc->fallback_rsn = reason_code;
 	smc_stat_fallback(smc);
@@ -567,18 +572,30 @@ static void smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 		 * smc socket->wq, which should be removed
 		 * to clcsocket->wq during the fallback.
 		 */
+		clc_wait = sk_sleep(smc->clcsock->sk);
 		spin_lock_irqsave(&smc_wait->lock, flags);
 		spin_lock_nested(&clc_wait->lock, SINGLE_DEPTH_NESTING);
 		list_splice_init(&smc_wait->head, &clc_wait->head);
 		spin_unlock(&clc_wait->lock);
 		spin_unlock_irqrestore(&smc_wait->lock, flags);
 	}
+	mutex_unlock(&smc->clcsock_release_lock);
+	return 0;
 }
 
 /* fall back during connect */
 static int smc_connect_fallback(struct smc_sock *smc, int reason_code)
 {
-	smc_switch_to_fallback(smc, reason_code);
+	struct net *net = sock_net(&smc->sk);
+	int rc = 0;
+
+	rc = smc_switch_to_fallback(smc, reason_code);
+	if (rc) { /* fallback fails */
+		this_cpu_inc(net->smc.smc_stats->clnt_hshake_err_cnt);
+		if (smc->sk.sk_state == SMC_INIT)
+			sock_put(&smc->sk); /* passive closing */
+		return rc;
+	}
 	smc_copy_sock_settings_to_clc(smc);
 	smc->connect_nonblock = 0;
 	if (smc->sk.sk_state == SMC_INIT)
@@ -1384,11 +1401,12 @@ static void smc_listen_decline(struct smc_sock *new_smc, int reason_code,
 {
 	/* RDMA setup failed, switch back to TCP */
 	smc_conn_abort(new_smc, local_first);
-	if (reason_code < 0) { /* error, no fallback possible */
+	if (reason_code < 0 ||
+	    smc_switch_to_fallback(new_smc, reason_code)) {
+		/* error, no fallback possible */
 		smc_listen_out_err(new_smc);
 		return;
 	}
-	smc_switch_to_fallback(new_smc, reason_code);
 	if (reason_code && reason_code != SMC_CLC_DECL_PEERDECL) {
 		if (smc_clc_send_decline(new_smc, reason_code, version) < 0) {
 			smc_listen_out_err(new_smc);
@@ -1761,8 +1779,11 @@ static void smc_listen_work(struct work_struct *work)
 
 	/* check if peer is smc capable */
 	if (!tcp_sk(newclcsock->sk)->syn_smc) {
-		smc_switch_to_fallback(new_smc, SMC_CLC_DECL_PEERNOSMC);
-		smc_listen_out_connected(new_smc);
+		rc = smc_switch_to_fallback(new_smc, SMC_CLC_DECL_PEERNOSMC);
+		if (rc)
+			smc_listen_out_err(new_smc);
+		else
+			smc_listen_out_connected(new_smc);
 		return;
 	}
 
@@ -2048,7 +2069,9 @@ static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 
 	if (msg->msg_flags & MSG_FASTOPEN) {
 		if (sk->sk_state == SMC_INIT && !smc->connect_nonblock) {
-			smc_switch_to_fallback(smc, SMC_CLC_DECL_OPTUNSUPP);
+			rc = smc_switch_to_fallback(smc, SMC_CLC_DECL_OPTUNSUPP);
+			if (rc)
+				goto out;
 		} else {
 			rc = -EINVAL;
 			goto out;
@@ -2241,6 +2264,11 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 	/* generic setsockopts reaching us here always apply to the
 	 * CLC socket
 	 */
+	mutex_lock(&smc->clcsock_release_lock);
+	if (!smc->clcsock) {
+		mutex_unlock(&smc->clcsock_release_lock);
+		return -EBADF;
+	}
 	if (unlikely(!smc->clcsock->ops->setsockopt))
 		rc = -EOPNOTSUPP;
 	else
@@ -2250,6 +2278,7 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 		sk->sk_err = smc->clcsock->sk->sk_err;
 		sk_error_report(sk);
 	}
+	mutex_unlock(&smc->clcsock_release_lock);
 
 	if (optlen < sizeof(int))
 		return -EINVAL;
@@ -2266,7 +2295,7 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 	case TCP_FASTOPEN_NO_COOKIE:
 		/* option not supported by SMC */
 		if (sk->sk_state == SMC_INIT && !smc->connect_nonblock) {
-			smc_switch_to_fallback(smc, SMC_CLC_DECL_OPTUNSUPP);
+			rc = smc_switch_to_fallback(smc, SMC_CLC_DECL_OPTUNSUPP);
 		} else {
 			rc = -EINVAL;
 		}
@@ -2309,13 +2338,23 @@ static int smc_getsockopt(struct socket *sock, int level, int optname,
 			  char __user *optval, int __user *optlen)
 {
 	struct smc_sock *smc;
+	int rc;
 
 	smc = smc_sk(sock->sk);
+	mutex_lock(&smc->clcsock_release_lock);
+	if (!smc->clcsock) {
+		mutex_unlock(&smc->clcsock_release_lock);
+		return -EBADF;
+	}
 	/* socket options apply to the CLC socket */
-	if (unlikely(!smc->clcsock->ops->getsockopt))
+	if (unlikely(!smc->clcsock->ops->getsockopt)) {
+		mutex_unlock(&smc->clcsock_release_lock);
 		return -EOPNOTSUPP;
-	return smc->clcsock->ops->getsockopt(smc->clcsock, level, optname,
-					     optval, optlen);
+	}
+	rc = smc->clcsock->ops->getsockopt(smc->clcsock, level, optname,
+					   optval, optlen);
+	mutex_unlock(&smc->clcsock_release_lock);
+	return rc;
 }
 
 static int smc_ioctl(struct socket *sock, unsigned int cmd,
-- 
2.34.1



