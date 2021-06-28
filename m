Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88613B62FC
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235508AbhF1Ouz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:50:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234079AbhF1Osv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:48:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A35A61CB0;
        Mon, 28 Jun 2021 14:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891005;
        bh=twh378NggV09c+mbgtGzr3Ox3Zd37cYIsMXiN5MHSaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L11WCiO9XfF6IT3rWIG3QIJubr3d+FUi/XY65S58KsJYFjt4Crm9FDx5+/UqZJ5EL
         MnICMv/ZirFRZz/M6Ue7p/r6fJrXiYQwaGxILYKjBTplir54T+NAWqWDK9+HnSk4cf
         1BWvW8jA+kzgFoYNf88MQvmjesvLrHm1wX5Ws/DEu1Fpdh8neRmZ57CywhbcMplg+n
         jf1jB+sFyMorxRE0ZSVM4+O1TVms+P0JVixxchnaPqoibUApy4FZZe+UZaWHS9fEn7
         I2oWVcr0vgXPccpryrQ69RzUSBsjdyzkb4CDtY8J43bwLyBp5n0Z3cqGpYknpEW3ea
         jaYHrcSn9Is0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 17/88] fib: Return the correct errno code
Date:   Mon, 28 Jun 2021 10:35:17 -0400
Message-Id: <20210628143628.33342-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
References: <20210628143628.33342-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.238-rc1
X-KernelTest-Deadline: 2021-06-30T14:36+00:00
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
index 9bb321df0869..76c3f602ee15 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -928,7 +928,7 @@ static void notify_rule_change(int event, struct fib_rule *rule,
 {
 	struct net *net;
 	struct sk_buff *skb;
-	int err = -ENOBUFS;
+	int err = -ENOMEM;
 
 	net = ops->fro_net;
 	skb = nlmsg_new(fib_rule_nlmsg_size(ops, rule), GFP_KERNEL);
-- 
2.30.2

