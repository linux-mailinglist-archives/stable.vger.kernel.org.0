Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB814120B1
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347568AbhITR5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:57:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355520AbhITRy6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:54:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60443630EA;
        Mon, 20 Sep 2021 17:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158031;
        bh=LvF0qNSntJm1FIBmsYr0T9p/RJEzWFm9/QwaPCdfBTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nw1W1WXy557S6m6JKmU0oPhxzzi2mEZQf99Str8WBwyZ9t8PQi9xDqAyoynxwWiYd
         0JexpXcHpoxwvou+BMbaY3+VRyiiT9vOBmOntxyoEDFDyBB9wpHU2ZC3fBEaWUeRJr
         JbsUMJH11wal3cjTh6pMi7u0rVgZP0nGD1DWwP08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Hoang Le <hoang.h.le@dektech.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 263/293] tipc: increase timeout in tipc_sk_enqueue()
Date:   Mon, 20 Sep 2021 18:43:45 +0200
Message-Id: <20210920163942.394826750@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>

commit f4bb62e64c88c93060c051195d3bbba804e56945 upstream.

In tipc_sk_enqueue() we use hardcoded 2 jiffies to extract
socket buffer from generic queue to particular socket.
The 2 jiffies is too short in case there are other high priority
tasks get CPU cycles for multiple jiffies update. As result, no
buffer could be enqueued to particular socket.

To solve this, we switch to use constant timeout 20msecs.
Then, the function will be expired between 2 jiffies (CONFIG_100HZ)
and 20 jiffies (CONFIG_1000HZ).

Fixes: c637c1035534 ("tipc: resolve race problem at unicast message reception")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/socket.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -2223,7 +2223,7 @@ static int tipc_sk_backlog_rcv(struct so
 static void tipc_sk_enqueue(struct sk_buff_head *inputq, struct sock *sk,
 			    u32 dport, struct sk_buff_head *xmitq)
 {
-	unsigned long time_limit = jiffies + 2;
+	unsigned long time_limit = jiffies + usecs_to_jiffies(20000);
 	struct sk_buff *skb;
 	unsigned int lim;
 	atomic_t *dcnt;


