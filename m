Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E578A395CB8
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbhEaNgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:36:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232261AbhEaNdW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:33:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4055961439;
        Mon, 31 May 2021 13:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467464;
        bh=/LAiBxxPS3dyAKvwHJ6hjFBxCZ4+5UXQ2QLuztF1k/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zQv6nDA1MOHSLmx5GxwJEPSvvSQJb6VsdQfdlUDTVBgn6F2pjzj0B/7zdNgYcU25K
         xM4SFULLt3scKPZWSL8MRUnJMI+Wqxr1kml/Z8p4dgkg91eKOrU+HvmaH9KeuP7oZ6
         CAaySdvQY2qeDndSIr85PiYAztpZsMXlQmJhhOGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Tung Nguyen <tung.q.nguyen@dektech.com.au>,
        Hoang Le <hoang.h.le@dektech.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 068/116] Revert "net:tipc: Fix a double free in tipc_sk_mcast_rcv"
Date:   Mon, 31 May 2021 15:14:04 +0200
Message-Id: <20210531130642.458439263@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>

commit 75016891357a628d2b8acc09e2b9b2576c18d318 upstream.

This reverts commit 6bf24dc0cc0cc43b29ba344b66d78590e687e046.
Above fix is not correct and caused memory leak issue.

Fixes: 6bf24dc0cc0c ("net:tipc: Fix a double free in tipc_sk_mcast_rcv")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Acked-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/socket.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1187,7 +1187,10 @@ void tipc_sk_mcast_rcv(struct net *net,
 		spin_lock_bh(&inputq->lock);
 		if (skb_peek(arrvq) == skb) {
 			skb_queue_splice_tail_init(&tmpq, inputq);
-			__skb_dequeue(arrvq);
+			/* Decrease the skb's refcnt as increasing in the
+			 * function tipc_skb_peek
+			 */
+			kfree_skb(__skb_dequeue(arrvq));
 		}
 		spin_unlock_bh(&inputq->lock);
 		__skb_queue_purge(&tmpq);


