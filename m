Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D87101F15A
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730585AbfEOLwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:52:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730579AbfEOLUZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:20:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AD68206BF;
        Wed, 15 May 2019 11:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919225;
        bh=4ZbxCPwzT9lomfvW44kev6fAu1cC/k039QsMKC2tNKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RHiUcIl6imVZaPqVs8p/yQ6g7fjEydLwaPHnfJMkIkPJBgBHQ+yA6P8WnF3/Dv3M7
         Xdal+TyuyYovo3Mnpo2GoPoIXO5m5zuzylFtLyZpZ2vzERodUphI+5g0u9WkPQ5704
         +kjVwEkMmCGxjM2w3Uj+KYJ/NXrVulXNLvNlAXx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Parthasarathy Bhuvaragan <parthasarathy.bhuvaragan@gmail.com>,
        Jon Maloy <jon.maloy@ericsson.se>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 111/115] tipc: fix hanging clients using poll with EPOLLOUT flag
Date:   Wed, 15 May 2019 12:56:31 +0200
Message-Id: <20190515090707.123915856@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parthasarathy Bhuvaragan <parthasarathy.bhuvaragan@gmail.com>

[ Upstream commit ff946833b70e0c7f93de9a3f5b329b5ae2287b38 ]

commit 517d7c79bdb398 ("tipc: fix hanging poll() for stream sockets")
introduced a regression for clients using non-blocking sockets.
After the commit, we send EPOLLOUT event to the client even in
TIPC_CONNECTING state. This causes the subsequent send() to fail
with ENOTCONN, as the socket is still not in TIPC_ESTABLISHED state.

In this commit, we:
- improve the fix for hanging poll() by replacing sk_data_ready()
  with sk_state_change() to wake up all clients.
- revert the faulty updates introduced by commit 517d7c79bdb398
  ("tipc: fix hanging poll() for stream sockets").

Fixes: 517d7c79bdb398 ("tipc: fix hanging poll() for stream sockets")
Signed-off-by: Parthasarathy Bhuvaragan <parthasarathy.bhuvaragan@gmail.com>
Acked-by: Jon Maloy <jon.maloy@ericsson.se>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/socket.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -709,11 +709,11 @@ static unsigned int tipc_poll(struct fil
 
 	switch (sk->sk_state) {
 	case TIPC_ESTABLISHED:
-	case TIPC_CONNECTING:
 		if (!tsk->cong_link_cnt && !tsk_conn_cong(tsk))
 			mask |= POLLOUT;
 		/* fall thru' */
 	case TIPC_LISTEN:
+	case TIPC_CONNECTING:
 		if (!skb_queue_empty(&sk->sk_receive_queue))
 			mask |= (POLLIN | POLLRDNORM);
 		break;
@@ -1588,7 +1588,7 @@ static bool filter_connect(struct tipc_s
 			return true;
 
 		/* If empty 'ACK-' message, wake up sleeping connect() */
-		sk->sk_data_ready(sk);
+		sk->sk_state_change(sk);
 
 		/* 'ACK-' message is neither accepted nor rejected: */
 		msg_set_dest_droppable(hdr, 1);


