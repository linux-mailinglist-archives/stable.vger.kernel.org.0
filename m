Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A49F6147A87
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730070AbgAXJe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:34:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:32848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727233AbgAXJeZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:34:25 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CFA2214AF;
        Fri, 24 Jan 2020 09:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858465;
        bh=YGwjOd/P8NlKg7ZxYmwvlapmnUeP8PeEMfBc1PgOdXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l1RiW6r/SILO0mJ+p91Wkx43le6Whac2z+tWTZexinCvigkGboY8X9A3t+IigxsbB
         JQS9sTKv8tPuOA1bZPATKCjPnW5XaZYpyVZAz0Fep5hilT0HoOCQvG3DHKwIoReSO1
         GuBSGe4uc+13oP1bN11qu6QjfXnLkdx6Xlv1LQZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hoang Le <hoang.h.le@dektech.com.au>,
        Tung Nguyen <tung.q.nguyen@dektech.com.au>,
        Ying Xue <ying.xue@windriver.com>,
        Jon Maloy <jon.maloy@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 025/102] tipc: fix potential memory leak in __tipc_sendmsg()
Date:   Fri, 24 Jan 2020 10:30:26 +0100
Message-Id: <20200124092809.967127381@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tung Nguyen <tung.q.nguyen@dektech.com.au>

commit 2fe97a578d7bad3116a89dc8a6692a51e6fc1d9c upstream.

When initiating a connection message to a server side, the connection
message is cloned and added to the socket write queue. However, if the
cloning is failed, only the socket write queue is purged. It causes
memory leak because the original connection message is not freed.

This commit fixes it by purging the list of connection message when
it cannot be cloned.

Fixes: 6787927475e5 ("tipc: buffer overflow handling in listener socket")
Reported-by: Hoang Le <hoang.h.le@dektech.com.au>
Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/tipc/socket.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1396,8 +1396,10 @@ static int __tipc_sendmsg(struct socket
 	rc = tipc_msg_build(hdr, m, 0, dlen, mtu, &pkts);
 	if (unlikely(rc != dlen))
 		return rc;
-	if (unlikely(syn && !tipc_msg_skb_clone(&pkts, &sk->sk_write_queue)))
+	if (unlikely(syn && !tipc_msg_skb_clone(&pkts, &sk->sk_write_queue))) {
+		__skb_queue_purge(&pkts);
 		return -ENOMEM;
+	}
 
 	trace_tipc_sk_sendmsg(sk, skb_peek(&pkts), TIPC_DUMP_SK_SNDQ, " ");
 	rc = tipc_node_xmit(net, &pkts, dnode, tsk->portid);


