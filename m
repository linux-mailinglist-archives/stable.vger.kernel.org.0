Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4EB1EF5A
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732662AbfEOLcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:32:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733104AbfEOLcy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:32:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C7A12053B;
        Wed, 15 May 2019 11:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919973;
        bh=xp4ffMEViRd0ybbgsw1QY405bLOW6ZF9LkIzt1kKPcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YATSnNpaVisj005RSnsCay2bT6OBW+0uAfQfNW7Vile+PPCOJO9fgHImv2qtRz0MM
         vOsXS0SbsxFu42nB+0VecStu9FBdEvuW28jXZ6sJr5RAEFmKvqJJqHMjVyQu51KrEu
         VHqNHLw4aUp7eYm6gs1CpCoK83InNsUMRwIfwCDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Parthasarathy Bhuvaragan <parthasarathy.bhuvaragan@gmail.com>,
        Jon Maloy <jon.maloy@ericsson.se>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 26/46] tipc: fix hanging clients using poll with EPOLLOUT flag
Date:   Wed, 15 May 2019 12:56:50 +0200
Message-Id: <20190515090625.299804305@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090616.670410738@linuxfoundation.org>
References: <20190515090616.670410738@linuxfoundation.org>
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
@@ -734,11 +734,11 @@ static __poll_t tipc_poll(struct file *f
 
 	switch (sk->sk_state) {
 	case TIPC_ESTABLISHED:
-	case TIPC_CONNECTING:
 		if (!tsk->cong_link_cnt && !tsk_conn_cong(tsk))
 			revents |= EPOLLOUT;
 		/* fall through */
 	case TIPC_LISTEN:
+	case TIPC_CONNECTING:
 		if (!skb_queue_empty(&sk->sk_receive_queue))
 			revents |= EPOLLIN | EPOLLRDNORM;
 		break;
@@ -2041,7 +2041,7 @@ static bool tipc_sk_filter_connect(struc
 			if (msg_data_sz(hdr))
 				return true;
 			/* Empty ACK-, - wake up sleeping connect() and drop */
-			sk->sk_data_ready(sk);
+			sk->sk_state_change(sk);
 			msg_set_dest_droppable(hdr, 1);
 			return false;
 		}


