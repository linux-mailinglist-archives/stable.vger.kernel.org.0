Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A253B6225
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234224AbhF1OmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:42:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235622AbhF1OkN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:40:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C9A661CC6;
        Mon, 28 Jun 2021 14:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890804;
        bh=UfxYV9nwxY/Yt+DuEjCmCnLrWrw20/YstFZF/k7iKsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j/awniafnffIf6stcFHrVn7iPjzvyiee9sg7bNpJq2mpmTu52XejGryOAE4u1Cs/F
         E4zxYGOCvZFximnfENLjYeqDNGQ0H4wKWOUrhoCZD/IjbaunhcFYX5rJg/UZg9aGxS
         eClwGSxD3iQ3PqrcKPse1S3WQiSfWHm+lZa/B4JmZfUQDp+TbWDW6oTa0rO3NWInDB
         rqTf5tuv4EChrbX3W+AnPb2myUJuxJg1mxHVnqrv9XJuKYSLjvXOWMqSEipR86FyYC
         WyV72IAwWaVBkI1dFZLuuMPRiLbNvWFz+ZHFM6LZCOC1ulFDMj7X0GRRSck6Ya1K82
         XvehyfXUiqM1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 020/109] fib: Return the correct errno code
Date:   Mon, 28 Jun 2021 10:31:36 -0400
Message-Id: <20210628143305.32978-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
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
index 8916c5d9b3b3..46a13ed15c4e 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -1105,7 +1105,7 @@ static void notify_rule_change(int event, struct fib_rule *rule,
 {
 	struct net *net;
 	struct sk_buff *skb;
-	int err = -ENOBUFS;
+	int err = -ENOMEM;
 
 	net = ops->fro_net;
 	skb = nlmsg_new(fib_rule_nlmsg_size(ops, rule), GFP_KERNEL);
-- 
2.30.2

