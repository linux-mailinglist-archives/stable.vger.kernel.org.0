Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918673D5E70
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236240AbhGZPHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:07:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235741AbhGZPHH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:07:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FC7860F5B;
        Mon, 26 Jul 2021 15:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314456;
        bh=8W3MQEXv5ja46UKhd9Owgo9FOe8CvUjdBtShLR7GG/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C2aZK8oEqrGsEKBD6zzaeHTZ6cPgpdV+KoYOZZPvflrsaMtWEFr2NOppFid+4BM0q
         dx/iMpy8o0bpmUgJqv7nJerx1pC0uMZ/cIhwJDwxoQBhopvIKq6VWcnz0K2HEv/J3I
         F6nO/JMopepc2gvPUNW+stRyzBIudeibXMcTSdhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 52/82] net: decnet: Fix sleeping inside in af_decnet
Date:   Mon, 26 Jul 2021 17:38:52 +0200
Message-Id: <20210726153829.871541052@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153828.144714469@linuxfoundation.org>
References: <20210726153828.144714469@linuxfoundation.org>
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
index 8dbfcd388633..9c7b8ff4556a 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -824,7 +824,7 @@ static int dn_auto_bind(struct socket *sock)
 static int dn_confirm_accept(struct sock *sk, long *timeo, gfp_t allocation)
 {
 	struct dn_scp *scp = DN_SK(sk);
-	DEFINE_WAIT(wait);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	int err;
 
 	if (scp->state != DN_CR)
@@ -834,11 +834,11 @@ static int dn_confirm_accept(struct sock *sk, long *timeo, gfp_t allocation)
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
@@ -852,9 +852,8 @@ static int dn_confirm_accept(struct sock *sk, long *timeo, gfp_t allocation)
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
@@ -866,7 +865,7 @@ static int dn_confirm_accept(struct sock *sk, long *timeo, gfp_t allocation)
 static int dn_wait_run(struct sock *sk, long *timeo)
 {
 	struct dn_scp *scp = DN_SK(sk);
-	DEFINE_WAIT(wait);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	int err = 0;
 
 	if (scp->state == DN_RUN)
@@ -875,11 +874,11 @@ static int dn_wait_run(struct sock *sk, long *timeo)
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
@@ -893,9 +892,8 @@ static int dn_wait_run(struct sock *sk, long *timeo)
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
@@ -1040,16 +1038,16 @@ static void dn_user_copy(struct sk_buff *skb, struct optdata_dn *opt)
 
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
@@ -1064,9 +1062,8 @@ static struct sk_buff *dn_wait_for_connect(struct sock *sk, long *timeo)
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



