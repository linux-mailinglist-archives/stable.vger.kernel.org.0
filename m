Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35AFA3B6479
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbhF1PIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:08:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237323AbhF1PFl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:05:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CF5961D82;
        Mon, 28 Jun 2021 14:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891418;
        bh=CbFnlNy/IEuBD0otczRC5A76VfyeGiM+rihMQ6Kad1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lGShjAV5SfejkVnNDobw3J5S2L/cbHeqh3R1w2sAahCDrd+WCPG8I28qsWBxkk9HS
         53c0aB57psucH/pNsdC+GzOn1ZD46eTwyo1VLHbYEKZjVKlgqblzpm8xgqqbM0/CJi
         k48RemozqdWi4RnpIMXGvBSiDOTOdThLPLdmN6bcrS/E2ugAQHIhVKtSoqjEYGEIeM
         Z+paljZeJnn8PZ+O3NgNC2gQ5PtMaSkt+vruLolD2CvRUXiIBC/pT/P9jVVWJywY3P
         4TzvBSIWh7f6bdc7MwWzRB/9gYO+R2f7gtOrTzPlvVkDn+54jrrjhNAi0FUFxDcJkY
         ywkKyk/z871VQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 48/57] ping: Check return value of function 'ping_queue_rcv_skb'
Date:   Mon, 28 Jun 2021 10:42:47 -0400
Message-Id: <20210628144256.34524-49-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144256.34524-1-sashal@kernel.org>
References: <20210628144256.34524-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:42+00:00
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
index a3abd136b8e7..56d89dfd8831 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -978,6 +978,7 @@ bool ping_rcv(struct sk_buff *skb)
 	struct sock *sk;
 	struct net *net = dev_net(skb->dev);
 	struct icmphdr *icmph = icmp_hdr(skb);
+	bool rc = false;
 
 	/* We assume the packet has already been checked by icmp_rcv */
 
@@ -992,14 +993,15 @@ bool ping_rcv(struct sk_buff *skb)
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

