Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D303D5DC7
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbhGZPDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:03:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235628AbhGZPDh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:03:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B13660F92;
        Mon, 26 Jul 2021 15:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314245;
        bh=X+5DlYeW3aA8+QlHKJ2yvZESQK0nDotZP68m1oTL5Hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LsVvOeEbxX75T/UsjFYH3SafKIj5Kn4dZ3zMWoT2vjUHcvgPT9cGh2IrTq/aM2xiK
         bb3LmuRL1mII6x5OVyvTC6jq8NO0ZojEAuxAcZ5GhVhLXpPKsQeEAQ/PiEZASJrfcv
         YfVTWqa6qniOupAT4rGqzRqgNt4RJktLEoyhmx24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 37/60] net: decnet: Fix sleeping inside in af_decnet
Date:   Mon, 26 Jul 2021 17:38:51 +0200
Message-Id: <20210726153826.034282111@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153824.868160836@linuxfoundation.org>
References: <20210726153824.868160836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yajun Deng <yajun.deng@linux.dev>

[ Upstream commit 5f119ba1d5771bbf46d57cff7417dcd84d3084ba ]

The release_sock() is blocking function, it would change the state
after sleeping. use wait_woken() instead.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/decnet/af_decnet.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index 9d8fcdefefc0..ee297964fcd2 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -823,7 +823,7 @@ static int dn_auto_bind(struct socket *sock)
 static int dn_confirm_accept(struct sock *sk, long *timeo, gfp_t allocation)
 {
 	struct dn_scp *scp = DN_SK(sk);
-	DEFINE_WAIT(wait);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	int err;
 
 	if (scp->state != DN_CR)
@@ -833,11 +833,11 @@ static int dn_confirm_accept(struct sock *sk, long *timeo, gfp_t allocation)
 	scp->segsize_loc = dst_metric_advmss(__sk_dst_get(sk));
 	dn_send_conn_conf(sk, allocation);
 
-	prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
+	add_wait_queue(sk_sleep(sk), &wait);
 	for(;;) {
 		release_sock(sk);
 		if (scp->state == DN_CC)
-			*timeo = schedule_timeout(*timeo);
+			*timeo = wait_woken(&wait, TASK_INTERRUPTIBLE, *timeo);
 		lock_sock(sk);
 		err = 0;
 		if (scp->state == DN_RUN)
@@ -851,9 +851,8 @@ static int dn_confirm_accept(struct sock *sk, long *timeo, gfp_t allocation)
 		err = -EAGAIN;
 		if (!*timeo)
 			break;
-		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
 	}
-	finish_wait(sk_sleep(sk), &wait);
+	remove_wait_queue(sk_sleep(sk), &wait);
 	if (err == 0) {
 		sk->sk_socket->state = SS_CONNECTED;
 	} else if (scp->state != DN_CC) {
@@ -865,7 +864,7 @@ static int dn_confirm_accept(struct sock *sk, long *timeo, gfp_t allocation)
 static int dn_wait_run(struct sock *sk, long *timeo)
 {
 	struct dn_scp *scp = DN_SK(sk);
-	DEFINE_WAIT(wait);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	int err = 0;
 
 	if (scp->state == DN_RUN)
@@ -874,11 +873,11 @@ static int dn_wait_run(struct sock *sk, long *timeo)
 	if (!*timeo)
 		return -EALREADY;
 
-	prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
+	add_wait_queue(sk_sleep(sk), &wait);
 	for(;;) {
 		release_sock(sk);
 		if (scp->state == DN_CI || scp->state == DN_CC)
-			*timeo = schedule_timeout(*timeo);
+			*timeo = wait_woken(&wait, TASK_INTERRUPTIBLE, *timeo);
 		lock_sock(sk);
 		err = 0;
 		if (scp->state == DN_RUN)
@@ -892,9 +891,8 @@ static int dn_wait_run(struct sock *sk, long *timeo)
 		err = -ETIMEDOUT;
 		if (!*timeo)
 			break;
-		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
 	}
-	finish_wait(sk_sleep(sk), &wait);
+	remove_wait_queue(sk_sleep(sk), &wait);
 out:
 	if (err == 0) {
 		sk->sk_socket->state = SS_CONNECTED;
@@ -1039,16 +1037,16 @@ static void dn_user_copy(struct sk_buff *skb, struct optdata_dn *opt)
 
 static struct sk_buff *dn_wait_for_connect(struct sock *sk, long *timeo)
 {
-	DEFINE_WAIT(wait);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	struct sk_buff *skb = NULL;
 	int err = 0;
 
-	prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
+	add_wait_queue(sk_sleep(sk), &wait);
 	for(;;) {
 		release_sock(sk);
 		skb = skb_dequeue(&sk->sk_receive_queue);
 		if (skb == NULL) {
-			*timeo = schedule_timeout(*timeo);
+			*timeo = wait_woken(&wait, TASK_INTERRUPTIBLE, *timeo);
 			skb = skb_dequeue(&sk->sk_receive_queue);
 		}
 		lock_sock(sk);
@@ -1063,9 +1061,8 @@ static struct sk_buff *dn_wait_for_connect(struct sock *sk, long *timeo)
 		err = -EAGAIN;
 		if (!*timeo)
 			break;
-		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
 	}
-	finish_wait(sk_sleep(sk), &wait);
+	remove_wait_queue(sk_sleep(sk), &wait);
 
 	return skb == NULL ? ERR_PTR(err) : skb;
 }
-- 
2.30.2



