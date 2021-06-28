Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642733B643D
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235744AbhF1PG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:06:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235057AbhF1PEB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:04:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA29861CE3;
        Mon, 28 Jun 2021 14:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891389;
        bh=neb5ROBYa47fFc5s+CGlSPmaX5MjjpwlK7QkKoslZ0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i+JrTJ6f9rom23RSp52jEiRMR6MXosBLyc7VI+fMwE3VNzUG2DQWdJqsVYjsVzeUm
         qZd0xMru9kULzmab9Uw62uqLFwMowE4i0gze5K/c2TDTXnZ0BXA5Wq+d7hfH2eP3t3
         HJB0sUZK163I8N4bApMABZruzA4qUrrSpxQlbPH1kuC4J5NFPKiN7sf1CaoaMx55Fw
         grmjwMhu9oyHP8fjbAc/dUM1YFCnzOouJZ+X7Dz2Pk8JzEc+UXMA6Kj3PT02NkMAUo
         w6PNk1amIDLWeHbZL57RCd+H3cqX9DAaIdcbMueI86Cn5ROtn14SbQ68wjHjDrA+Hd
         istflbjXLHZcw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 13/57] fib: Return the correct errno code
Date:   Mon, 28 Jun 2021 10:42:12 -0400
Message-Id: <20210628144256.34524-14-sashal@kernel.org>
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

[ Upstream commit 59607863c54e9eb3f69afc5257dfe71c38bb751e ]

When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/fib_rules.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index 2fd4aae8f285..b9cbab73d0de 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -695,7 +695,7 @@ static void notify_rule_change(int event, struct fib_rule *rule,
 {
 	struct net *net;
 	struct sk_buff *skb;
-	int err = -ENOBUFS;
+	int err = -ENOMEM;
 
 	net = ops->fro_net;
 	skb = nlmsg_new(fib_rule_nlmsg_size(ops, rule), GFP_KERNEL);
-- 
2.30.2

