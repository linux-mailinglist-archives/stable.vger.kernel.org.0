Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97EDF45BA0C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242019AbhKXMHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:07:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:33704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242215AbhKXMGb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:06:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3832610CA;
        Wed, 24 Nov 2021 12:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755402;
        bh=cWLLOxP3dDEES0t8JMT7wgN6KyqwU7yqIcNmXd8gdiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dajkGr9K52VPCt5XJ2RzaQjH75xMcuwvzJfy+nzvCgbSZlJxiq5zJoo2NEJoa+LTk
         W2agnZuCSOGp8yVPUzBRB2dSVd/QD7EK8Y4mP+2I0r2puP39Ox0nCTeoY0fP2lNh/1
         hG2VKRy8egNkLb5dwCmTkDzsYL0H9b/ZtnyW4QFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 081/162] net: stream: dont purge sk_error_queue in sk_stream_kill_queues()
Date:   Wed, 24 Nov 2021 12:56:24 +0100
Message-Id: <20211124115700.936915826@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 24bcbe1cc69fa52dc4f7b5b2456678ed464724d8 ]

sk_stream_kill_queues() can be called on close when there are
still outstanding skbs to transmit. Those skbs may try to queue
notifications to the error queue (e.g. timestamps).
If sk_stream_kill_queues() purges the queue without taking
its lock the queue may get corrupted, and skbs leaked.

This shows up as a warning about an rmem leak:

WARNING: CPU: 24 PID: 0 at net/ipv4/af_inet.c:154 inet_sock_destruct+0x...

The leak is always a multiple of 0x300 bytes (the value is in
%rax on my builds, so RAX: 0000000000000300). 0x300 is truesize of
an empty sk_buff. Indeed if we dump the socket state at the time
of the warning the sk_error_queue is often (but not always)
corrupted. The ->next pointer points back at the list head,
but not the ->prev pointer. Indeed we can find the leaked skb
by scanning the kernel memory for something that looks like
an skb with ->sk = socket in question, and ->truesize = 0x300.
The contents of ->cb[] of the skb confirms the suspicion that
it is indeed a timestamp notification (as generated in
__skb_complete_tx_timestamp()).

Removing purging of sk_error_queue should be okay, since
inet_sock_destruct() does it again once all socket refs
are gone. Eric suggests this may cause sockets that go
thru disconnect() to maintain notifications from the
previous incarnations of the socket, but that should be
okay since the race was there anyway, and disconnect()
is not exactly dependable.

Thanks to Jonathan Lemon and Omar Sandoval for help at various
stages of tracing the issue.

Fixes: cb9eff097831 ("net: new user space API for time stamping of incoming and outgoing packets")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/stream.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/core/stream.c b/net/core/stream.c
index 3089b014bb538..2c50c71cb806f 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -194,9 +194,6 @@ void sk_stream_kill_queues(struct sock *sk)
 	/* First the read buffer. */
 	__skb_queue_purge(&sk->sk_receive_queue);
 
-	/* Next, the error queue. */
-	__skb_queue_purge(&sk->sk_error_queue);
-
 	/* Next, the write queue. */
 	WARN_ON(!skb_queue_empty(&sk->sk_write_queue));
 
-- 
2.33.0



