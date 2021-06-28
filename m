Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B603B63A4
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235396AbhF1O6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:58:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236970AbhF1O4a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:56:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8443261C89;
        Mon, 28 Jun 2021 14:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891217;
        bh=uMD0UneqO4c1jI3mfk7OC/s+eMI+GCawyKuTXprHWYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bl28yal05kMTiChlhj+XqyitVCHIjAAr2yLKSrQFLs6Dz4LyYFOYaZ0MDfX/fqdI5
         9g9zzFC1T1DVkiu+bWOvC0GtZLtrqXIURvV90vNGDjjnEmPDESyN9wLhnkRD0cIi92
         lpfuh0bBfptTw63561xr7xT7oDeOb92Q5nv6ucaTNt8HuBvrVq2PavNYqtJI3K7mEn
         RV4zPYM3rQEZX5ZCUYMjF/3SdgTXmVv+qigXEViKu75iGTeimE04scv+Hz+0s1DyZE
         vkggaWjIpyiwbyStCxWaOkVei0cjgfT1btGsMpU0Bpt3kphWAB/eQczqm5iBp43ung
         x6oiAevTAn6ww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 14/71] fib: Return the correct errno code
Date:   Mon, 28 Jun 2021 10:39:06 -0400
Message-Id: <20210628144003.34260-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144003.34260-1-sashal@kernel.org>
References: <20210628144003.34260-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:39+00:00
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
index 9f172906cc88..cc6e7ca0aff5 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -767,7 +767,7 @@ static void notify_rule_change(int event, struct fib_rule *rule,
 {
 	struct net *net;
 	struct sk_buff *skb;
-	int err = -ENOBUFS;
+	int err = -ENOMEM;
 
 	net = ops->fro_net;
 	skb = nlmsg_new(fib_rule_nlmsg_size(ops, rule), GFP_KERNEL);
-- 
2.30.2

