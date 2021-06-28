Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6433D3B619D
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbhF1OhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:37:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235320AbhF1OfU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:35:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E135B61990;
        Mon, 28 Jun 2021 14:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890627;
        bh=DJbuU0iVdzvixmCgXuaMqzrfETTxUAChdi8JE4WzplY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kYiv22Oo5t/67kBuo40mXujr7Y625oCrwdVldOm+hzgQzV5L5MC2MaaX98VghD2BD
         Xtrey+pd2eh1Ls+iRXrahMlQ/VnyGbTwukqne+YTlBkFqrPAG6RAEtLnQ2MUht2tsd
         Fm9cNEve9qXN4Yo7D6aSRY0yqBaD3LuvTsPzCwRchu6CEa8dhUjVJo0vnW1Ws0rg/I
         tZ1CiCfXKCJY/oYqFQtX+oB3Dlhp+1gvWAT0HdGXW+PDlL6MuUhwRqTR9O+oKFbi+u
         cl6TXKpcu6vQGN6m+d+Z5S6u+3ZCbhTnMQzlcbxTd/8cIPIBgaYMQJQCqIhBqj8ruy
         6UhUBW87UbFZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 24/71] ping: Check return value of function 'ping_queue_rcv_skb'
Date:   Mon, 28 Jun 2021 10:29:17 -0400
Message-Id: <20210628143004.32596-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.129-rc1
X-KernelTest-Deadline: 2021-06-30T14:29+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit 9d44fa3e50cc91691896934d106c86e4027e61ca ]

Function 'ping_queue_rcv_skb' not always return success, which will
also return fail. If not check the wrong return value of it, lead to function
`ping_rcv` return success.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ping.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index df6fbefe44d4..1c3d5d3702a1 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -963,6 +963,7 @@ bool ping_rcv(struct sk_buff *skb)
 	struct sock *sk;
 	struct net *net = dev_net(skb->dev);
 	struct icmphdr *icmph = icmp_hdr(skb);
+	bool rc = false;
 
 	/* We assume the packet has already been checked by icmp_rcv */
 
@@ -977,14 +978,15 @@ bool ping_rcv(struct sk_buff *skb)
 		struct sk_buff *skb2 = skb_clone(skb, GFP_ATOMIC);
 
 		pr_debug("rcv on socket %p\n", sk);
-		if (skb2)
-			ping_queue_rcv_skb(sk, skb2);
+		if (skb2 && !ping_queue_rcv_skb(sk, skb2))
+			rc = true;
 		sock_put(sk);
-		return true;
 	}
-	pr_debug("no socket, dropping\n");
 
-	return false;
+	if (!rc)
+		pr_debug("no socket, dropping\n");
+
+	return rc;
 }
 EXPORT_SYMBOL_GPL(ping_rcv);
 
-- 
2.30.2

