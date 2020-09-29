Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD4A27C443
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbgI2LMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:12:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729325AbgI2LMb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:12:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AF7F20848;
        Tue, 29 Sep 2020 11:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377951;
        bh=JDZ3+6YB0uGguex7VGORBz61ij0uqFHkQ3vhlh0VuwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UatfUneAoY56H3rdZO5Jc+niozuClR+LM6SZjfCtN9rbqPoSweEimhY0jx0xYj78r
         LA7cNX9V6RMRm3mDGL3ArQCKZY0PBhxNbbkD6HOPyS3p3uIh+mObATrdkq/sDqDHvG
         tODNY/TGi064F1hFJNYrnyMncVgIqMVivem6B8zM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 010/166] tipc: fix shutdown() of connection oriented socket
Date:   Tue, 29 Sep 2020 12:58:42 +0200
Message-Id: <20200929105935.710872245@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit a4b5cc9e10803ecba64a7d54c0f47e4564b4a980 ]

I confirmed that the problem fixed by commit 2a63866c8b51a3f7 ("tipc: fix
shutdown() of connectionless socket") also applies to stream socket.

----------
#include <sys/socket.h>
#include <unistd.h>
#include <sys/wait.h>

int main(int argc, char *argv[])
{
        int fds[2] = { -1, -1 };
        socketpair(PF_TIPC, SOCK_STREAM /* or SOCK_DGRAM */, 0, fds);
        if (fork() == 0)
                _exit(read(fds[0], NULL, 1));
        shutdown(fds[0], SHUT_RDWR); /* This must make read() return. */
        wait(NULL); /* To be woken up by _exit(). */
        return 0;
}
----------

Since shutdown(SHUT_RDWR) should affect all processes sharing that socket,
unconditionally setting sk->sk_shutdown to SHUTDOWN_MASK will be the right
behavior.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/socket.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -2126,10 +2126,7 @@ static int tipc_shutdown(struct socket *
 	lock_sock(sk);
 
 	__tipc_shutdown(sock, TIPC_CONN_SHUTDOWN);
-	if (tipc_sk_type_connectionless(sk))
-		sk->sk_shutdown = SHUTDOWN_MASK;
-	else
-		sk->sk_shutdown = SEND_SHUTDOWN;
+	sk->sk_shutdown = SHUTDOWN_MASK;
 
 	if (sk->sk_state == TIPC_DISCONNECTING) {
 		/* Discard any unreceived messages */


