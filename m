Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C0B450E29
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238301AbhKOSNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:13:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:46080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240090AbhKOSFf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 088B063386;
        Mon, 15 Nov 2021 17:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998127;
        bh=GXPRDjNuXpgcoFRVlD8/CTYNFU26E+nImIcXkUd4pQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pSjxvV8ThqA0acEVfZICknahEkR4O+/uq69lPuvYFqS2oE/OtpPkb4nS1oJLCnbpU
         8PER8O4Wyuwm47hR2xsnM/zsAiHPGwl3Q3Wf1/auPg5iKzI1+lCWQik+TaEJV77OCc
         E2GMeZmugbD/C6tOkX0KZ96fWoLzcxx7jWM7Te2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Maxwell <jmaxwell37@gmail.com>,
        Monir Zouaoui <Monir.Zouaoui@mail.schwarz>,
        Simon Stier <simon.stier@mail.schwarz>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 364/575] tcp: dont free a FIN sk_buff in tcp_remove_empty_skb()
Date:   Mon, 15 Nov 2021 18:01:29 +0100
Message-Id: <20211115165356.391473328@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Maxwell <jmaxwell37@gmail.com>

[ Upstream commit cf12e6f9124629b18a6182deefc0315f0a73a199 ]

v1: Implement a more general statement as recommended by Eric Dumazet. The
sequence number will be advanced, so this check will fix the FIN case and
other cases.

A customer reported sockets stuck in the CLOSING state. A Vmcore revealed that
the write_queue was not empty as determined by tcp_write_queue_empty() but the
sk_buff containing the FIN flag had been freed and the socket was zombied in
that state. Corresponding pcaps show no FIN from the Linux kernel on the wire.

Some instrumentation was added to the kernel and it was found that there is a
timing window where tcp_sendmsg() can run after tcp_send_fin().

tcp_sendmsg() will hit an error, for example:

1269 ▹       if (sk->sk_err || (sk->sk_shutdown & SEND_SHUTDOWN))↩
1270 ▹       ▹       goto do_error;↩

tcp_remove_empty_skb() will then free the FIN sk_buff as "skb->len == 0". The
TCP socket is now wedged in the FIN-WAIT-1 state because the FIN is never sent.

If the other side sends a FIN packet the socket will transition to CLOSING and
remain that way until the system is rebooted.

Fix this by checking for the FIN flag in the sk_buff and don't free it if that
is the case. Testing confirmed that fixed the issue.

Fixes: fdfc5c8594c2 ("tcp: remove empty skb from write queue in error cases")
Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
Reported-by: Monir Zouaoui <Monir.Zouaoui@mail.schwarz>
Reported-by: Simon Stier <simon.stier@mail.schwarz>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 65eb0a523e3f5..e8aca226c4ae3 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -956,7 +956,7 @@ int tcp_send_mss(struct sock *sk, int *size_goal, int flags)
  */
 static void tcp_remove_empty_skb(struct sock *sk, struct sk_buff *skb)
 {
-	if (skb && !skb->len) {
+	if (skb && TCP_SKB_CB(skb)->seq == TCP_SKB_CB(skb)->end_seq) {
 		tcp_unlink_write_queue(skb, sk);
 		if (tcp_write_queue_empty(sk))
 			tcp_chrono_stop(sk, TCP_CHRONO_BUSY);
-- 
2.33.0



