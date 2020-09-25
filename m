Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439A0278806
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbgIYMwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:52:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729284AbgIYMwH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:52:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A86292075E;
        Fri, 25 Sep 2020 12:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038327;
        bh=vRaX1kQkUgf/cpQokmKvAP4ffHimb4Mc5ag5hyofK3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m12fSAW3yIM0ClK26TELoV/iTDC5fGiDkPfIoY1FVJrae6KzU8//Eo0bUaM038yvV
         /KFuBCTsPHL6OxMmOLtfw10pzk8o6qwd1+XUIFCdxLq6Xin2Q6TrpRUjnBTUK90AZ2
         icazWaRa95s5SACryAAqvgis4wqHhgO+gcKCD7UE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 28/43] tipc: fix shutdown() of connection oriented socket
Date:   Fri, 25 Sep 2020 14:48:40 +0200
Message-Id: <20200925124727.855518076@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124723.575329814@linuxfoundation.org>
References: <20200925124723.575329814@linuxfoundation.org>
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
@@ -2616,10 +2616,7 @@ static int tipc_shutdown(struct socket *
 
 	trace_tipc_sk_shutdown(sk, NULL, TIPC_DUMP_ALL, " ");
 	__tipc_shutdown(sock, TIPC_CONN_SHUTDOWN);
-	if (tipc_sk_type_connectionless(sk))
-		sk->sk_shutdown = SHUTDOWN_MASK;
-	else
-		sk->sk_shutdown = SEND_SHUTDOWN;
+	sk->sk_shutdown = SHUTDOWN_MASK;
 
 	if (sk->sk_state == TIPC_DISCONNECTING) {
 		/* Discard any unreceived messages */


