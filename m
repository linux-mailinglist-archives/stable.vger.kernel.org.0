Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE13226A23
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731767AbgGTP4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:56:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731764AbgGTP4M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:56:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28A7D22CAF;
        Mon, 20 Jul 2020 15:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260571;
        bh=Lc8vSDDxqXR0iGuXVyaPfK/4+2pH/3AQLhXm0sg8lk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1HdRyMDmD2RBbABE7DS0G6sHuvy1nWJi78dsjNaLjm/nIJJKCeztrJenroR6ZBjQ3
         7vHVJg4LiYMLP9zBkiIFZMPKYjdwTGGpEINN+yCHvNfHWsCyfd6s2uwy1LsZ/qC+g3
         qcHbhFAx1oZaYTENVl/jjE3AfOj8xJyuGhzjwEJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 017/215] tcp: fix SO_RCVLOWAT possible hangs under high mem pressure
Date:   Mon, 20 Jul 2020 17:34:59 +0200
Message-Id: <20200720152820.982861036@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ba3bb0e76ccd464bb66665a1941fabe55dadb3ba ]

Whenever tcp_try_rmem_schedule() returns an error, we are under
trouble and should make sure to wakeup readers so that they
can drain socket queues and eventually make room.

Fixes: 03f45c883c6f ("tcp: avoid extra wakeups for SO_RCVLOWAT users")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4564,6 +4564,7 @@ static void tcp_data_queue_ofo(struct so
 
 	if (unlikely(tcp_try_rmem_schedule(sk, skb, skb->truesize))) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPOFODROP);
+		sk->sk_data_ready(sk);
 		tcp_drop(sk, skb);
 		return;
 	}
@@ -4807,6 +4808,7 @@ queue_and_out:
 			sk_forced_mem_schedule(sk, skb->truesize);
 		else if (tcp_try_rmem_schedule(sk, skb, skb->truesize)) {
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPRCVQDROP);
+			sk->sk_data_ready(sk);
 			goto drop;
 		}
 


