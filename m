Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998623B6439
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235352AbhF1PGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:06:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234753AbhF1PDu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:03:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8029661CDA;
        Mon, 28 Jun 2021 14:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891387;
        bh=HVjKU5j5ADRcQuZap9hsVaBsfM9OKQPMVLRn/zeOQCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tMyRhppONMnAJEHPd/Vox9Yfdx1sRfmuPiYdlneT1BXUqJu/uGf8SpeKPD4PHjNwX
         ZYDq0EY7FJ6rwXB6VWydDWQuB4dAgqrs7uKDC8ULC2v99bpZA9iTz0Hekl/djTEVu3
         27FFz8hmyz1e/9aoSmA2NXkLaUe+/+VgD1dd8JkwYfBXEn/M7jrIVXr/87OaKH6+kM
         nRuyZOBx27SahX0o+hOc/gzXjpfUvgk22/zRQPmg3atqAP6j05EVwaAX+fFF96BC+4
         MDNA9lOgNwAzstfCBiAuM8cmUne9cLDd7bIrq8vqeZ/NFqhTAWTsD1MTlGZClp9lNG
         uFuZX1Ebk6EDA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 10/57] rtnetlink: Fix missing error code in rtnl_bridge_notify()
Date:   Mon, 28 Jun 2021 10:42:09 -0400
Message-Id: <20210628144256.34524-11-sashal@kernel.org>
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
index e2a0aed52983..11d2da8abd73 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3240,8 +3240,10 @@ static int rtnl_bridge_notify(struct net_device *dev)
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

