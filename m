Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C9C3B622C
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234858AbhF1OmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:42:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235611AbhF1OkM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:40:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4FDA61CC4;
        Mon, 28 Jun 2021 14:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890802;
        bh=hr2/c60Q5FWoGRk9+/fstlgyxlH/GO5PPiTTaHnAlFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U5bMKtDrd9YGn/nEKnas23SptAlv7FtA9Xy/LoZ77FUa2ssVjWm9HrLzmyJtUN+kQ
         m1kTc+vlvMKyHpflt+FV3g7MINYFolF86KgKFVUnNNOIjGlyRTSL2wQlZFmszx7yyf
         nNy1hgyE+6CRNK8ZkS769NstY6hozqsSmUXN9RSbkeN+5tjzeWfpO7uyMxD4zpEUYb
         XAu9zlZJqz5t2whplHMMpwIm0Czqu8WA1pFWYDWwQEighdTbmRmJf/ZalElR7o01US
         SMVpD4MtBi1q9aUOpYXt/RMrMu42ZbEIhQN9dNU7fDjyIgHEzbuJuAtSWO33uzDN6y
         Rp8l3HPWIQkng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 017/109] rtnetlink: Fix missing error code in rtnl_bridge_notify()
Date:   Mon, 28 Jun 2021 10:31:33 -0400
Message-Id: <20210628143305.32978-18-sashal@kernel.org>
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

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit a8db57c1d285c758adc7fb43d6e2bad2554106e1 ]

The error code is missing in this code scenario, add the error code
'-EINVAL' to the return value 'err'.

Eliminate the follow smatch warning:

net/core/rtnetlink.c:4834 rtnl_bridge_notify() warn: missing error code
'err'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 935053ee7765..7f2dda27f9e7 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4102,8 +4102,10 @@ static int rtnl_bridge_notify(struct net_device *dev)
 	if (err < 0)
 		goto errout;
 
-	if (!skb->len)
+	if (!skb->len) {
+		err = -EINVAL;
 		goto errout;
+	}
 
 	rtnl_notify(skb, net, 0, RTNLGRP_LINK, NULL, GFP_ATOMIC);
 	return 0;
-- 
2.30.2

