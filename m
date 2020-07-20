Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785852264F5
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729850AbgGTPtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:49:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:45842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729893AbgGTPtk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:49:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5B442064B;
        Mon, 20 Jul 2020 15:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260180;
        bh=YL+fDmrIp0AJVr4B8vAuONxS7rpJX/UrdUgwnouQVKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JnoLjrD3FgAPnuT+kVigvGFewOIYZXvP7MzueVEdvujlBC48rXSxXYFHgKQXmqThj
         tU3oVXpky8Kt76m+2qLoQIi9NizfTUfsyHFB0xQk3iFPM0bTi6PqdNR7PS1bkA7FH9
         NBEjWOcWC2s8UelvTjQ66E9y7bFQk7pKZdH8A/9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 010/133] tcp: fix SO_RCVLOWAT possible hangs under high mem pressure
Date:   Mon, 20 Jul 2020 17:35:57 +0200
Message-Id: <20200720152804.232247109@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
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
@@ -4494,6 +4494,7 @@ static void tcp_data_queue_ofo(struct so
 
 	if (unlikely(tcp_try_rmem_schedule(sk, skb, skb->truesize))) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPOFODROP);
+		sk->sk_data_ready(sk);
 		tcp_drop(sk, skb);
 		return;
 	}
@@ -4739,6 +4740,7 @@ queue_and_out:
 			sk_forced_mem_schedule(sk, skb->truesize);
 		else if (tcp_try_rmem_schedule(sk, skb, skb->truesize)) {
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPRCVQDROP);
+			sk->sk_data_ready(sk);
 			goto drop;
 		}
 


