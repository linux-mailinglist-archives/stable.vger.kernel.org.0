Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB43C3DD9F0
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234837AbhHBOFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:05:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236245AbhHBOEK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:04:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94A0161241;
        Mon,  2 Aug 2021 13:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912662;
        bh=1ECOeEm5+ZulX3LMp2E2ixHb3VJjQGwVB6lw/yfh8D8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JlC7MnhG1l66hACw7RC0OKfZuWcRWXZFvnVkTsGZb2mK24L11vx8N0hUCQ17kdHmn
         0uZNmGcDvGSl8IklL/3el/gLt7cRj+j9bgEq7m3Q3+VZIpg04wyDi5ZuSBUsLNlswt
         NgrTmbU/xx1jy8AnhvH8wZ6qqZ5TSecbCRQrO5Q4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Hoang Le <hoang.h.le@dektech.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 050/104] tipc: fix sleeping in tipc accept routine
Date:   Mon,  2 Aug 2021 15:44:47 +0200
Message-Id: <20210802134345.675663180@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>

[ Upstream commit d237a7f11719ff9320721be5818352e48071aab6 ]

The release_sock() is blocking function, it would change the state
after sleeping. In order to evaluate the stated condition outside
the socket lock context, switch to use wait_woken() instead.

Fixes: 6398e23cdb1d8 ("tipc: standardize accept routine")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/socket.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index c52b0d00887b..9bdc5147a65a 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -2671,7 +2671,7 @@ static int tipc_listen(struct socket *sock, int len)
 static int tipc_wait_for_accept(struct socket *sock, long timeo)
 {
 	struct sock *sk = sock->sk;
-	DEFINE_WAIT(wait);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	int err;
 
 	/* True wake-one mechanism for incoming connections: only
@@ -2680,12 +2680,12 @@ static int tipc_wait_for_accept(struct socket *sock, long timeo)
 	 * anymore, the common case will execute the loop only once.
 	*/
 	for (;;) {
-		prepare_to_wait_exclusive(sk_sleep(sk), &wait,
-					  TASK_INTERRUPTIBLE);
 		if (timeo && skb_queue_empty(&sk->sk_receive_queue)) {
+			add_wait_queue(sk_sleep(sk), &wait);
 			release_sock(sk);
-			timeo = schedule_timeout(timeo);
+			timeo = wait_woken(&wait, TASK_INTERRUPTIBLE, timeo);
 			lock_sock(sk);
+			remove_wait_queue(sk_sleep(sk), &wait);
 		}
 		err = 0;
 		if (!skb_queue_empty(&sk->sk_receive_queue))
@@ -2697,7 +2697,6 @@ static int tipc_wait_for_accept(struct socket *sock, long timeo)
 		if (signal_pending(current))
 			break;
 	}
-	finish_wait(sk_sleep(sk), &wait);
 	return err;
 }
 
-- 
2.30.2



