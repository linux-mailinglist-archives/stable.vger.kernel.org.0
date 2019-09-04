Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABEB1A8EF9
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388202AbfIDSBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:01:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387794AbfIDSBE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:01:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A148B21883;
        Wed,  4 Sep 2019 18:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620063;
        bh=7LvryOPVQ85u9ljKGUfOFG5GY5a76heXj07kDXgMsf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mVVtJDVV2CTN7A8tNqGs9Qq5POJ6PWAlFO7dchN/pDID8LSbGrsf73UjDh330KmKp
         SmgblSsuCVFGBn8zpFXFACbCQMNjm+pws93HZuVydC9Mhdxs3QuLjLMvw84Ao24Tuk
         rl4Q7gzRXhWbdATX7W2DpkoiUZhmIx0YGSbbtqas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jason Baron <jbaron@akamai.com>,
        Vladimir Rutsky <rutsky@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 58/83] tcp: make sure EPOLLOUT wont be missed
Date:   Wed,  4 Sep 2019 19:53:50 +0200
Message-Id: <20190904175308.674735011@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.488266791@linuxfoundation.org>
References: <20190904175303.488266791@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ef8d8ccdc216f797e66cb4a1372f5c4c285ce1e4 ]

As Jason Baron explained in commit 790ba4566c1a ("tcp: set SOCK_NOSPACE
under memory pressure"), it is crucial we properly set SOCK_NOSPACE
when needed.

However, Jason patch had a bug, because the 'nonblocking' status
as far as sk_stream_wait_memory() is concerned is governed
by MSG_DONTWAIT flag passed at sendmsg() time :

    long timeo = sock_sndtimeo(sk, flags & MSG_DONTWAIT);

So it is very possible that tcp sendmsg() calls sk_stream_wait_memory(),
and that sk_stream_wait_memory() returns -EAGAIN with SOCK_NOSPACE
cleared, if sk->sk_sndtimeo has been set to a small (but not zero)
value.

This patch removes the 'noblock' variable since we must always
set SOCK_NOSPACE if -EAGAIN is returned.

It also renames the do_nonblock label since we might reach this
code path even if we were in blocking mode.

Fixes: 790ba4566c1a ("tcp: set SOCK_NOSPACE under memory pressure")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jason Baron <jbaron@akamai.com>
Reported-by: Vladimir Rutsky  <rutsky@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Jason Baron <jbaron@akamai.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/stream.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -118,7 +118,6 @@ int sk_stream_wait_memory(struct sock *s
 	int err = 0;
 	long vm_wait = 0;
 	long current_timeo = *timeo_p;
-	bool noblock = (*timeo_p ? false : true);
 	DEFINE_WAIT(wait);
 
 	if (sk_stream_memory_free(sk))
@@ -131,11 +130,8 @@ int sk_stream_wait_memory(struct sock *s
 
 		if (sk->sk_err || (sk->sk_shutdown & SEND_SHUTDOWN))
 			goto do_error;
-		if (!*timeo_p) {
-			if (noblock)
-				set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
-			goto do_nonblock;
-		}
+		if (!*timeo_p)
+			goto do_eagain;
 		if (signal_pending(current))
 			goto do_interrupted;
 		sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
@@ -167,7 +163,13 @@ out:
 do_error:
 	err = -EPIPE;
 	goto out;
-do_nonblock:
+do_eagain:
+	/* Make sure that whenever EAGAIN is returned, EPOLLOUT event can
+	 * be generated later.
+	 * When TCP receives ACK packets that make room, tcp_check_space()
+	 * only calls tcp_new_space() if SOCK_NOSPACE is set.
+	 */
+	set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 	err = -EAGAIN;
 	goto out;
 do_interrupted:


