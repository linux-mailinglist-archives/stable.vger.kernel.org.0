Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590BA3DD889
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234948AbhHBNxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:53:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:33500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234639AbhHBNvk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:51:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99E9E61108;
        Mon,  2 Aug 2021 13:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912276;
        bh=H5v5wfb2zFopAgaoROblUXmSz2SQUzUggOjBYxEAH5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yQ4JVvUAnx5ZU9G5epuTPpJhlCl5RNPOZEtOYTNAmfXclA08mEhyI1Qx8m5HhaXDs
         PVe1ht3qhF8RF4lJBz321h8jq7z7Ou2iclnu4DiseB74gTfyFkCjnFeeJcrRf3cDxl
         B2Qv7Ps08jHoa7hW0FRl2eQ4Be7daX59Qx9fDr7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Hoang Le <hoang.h.le@dektech.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 26/40] tipc: fix sleeping in tipc accept routine
Date:   Mon,  2 Aug 2021 15:45:06 +0200
Message-Id: <20210802134336.227510777@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134335.408294521@linuxfoundation.org>
References: <20210802134335.408294521@linuxfoundation.org>
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
index cdade990fe44..a5922ce9109c 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -2501,7 +2501,7 @@ static int tipc_listen(struct socket *sock, int len)
 static int tipc_wait_for_accept(struct socket *sock, long timeo)
 {
 	struct sock *sk = sock->sk;
-	DEFINE_WAIT(wait);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	int err;
 
 	/* True wake-one mechanism for incoming connections: only
@@ -2510,12 +2510,12 @@ static int tipc_wait_for_accept(struct socket *sock, long timeo)
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
@@ -2527,7 +2527,6 @@ static int tipc_wait_for_accept(struct socket *sock, long timeo)
 		if (signal_pending(current))
 			break;
 	}
-	finish_wait(sk_sleep(sk), &wait);
 	return err;
 }
 
-- 
2.30.2



