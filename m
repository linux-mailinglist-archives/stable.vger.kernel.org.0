Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627A33B622D
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234881AbhF1OmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:42:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235608AbhF1OkM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:40:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8501961CBD;
        Mon, 28 Jun 2021 14:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890803;
        bh=IL/Vz4f4SrTgU1DV5ryAUiCb28bM+1h3wnNOHLKW1ZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NXTXHaF8j3fs+NSA/Z4bA+XXUFVNJHbwDL1P0eGDEwE4wfeGZe1qOVFnsecuREpUE
         RKgwmRq7KzCA+VqSHVq25oes8OenKdFFUoQiGyxO5FBYvqy7gE5LzK25/Mi6XDHdmt
         mQ7oCetr2Af7Bk6xOMHsgFif6dvXcmae/kobr7bUG1GDXF79ON0WnapW27b4q8NEXP
         J06Wr4Wh18PBvh2bmQ3X8SOAEgn7PEhpU4sa2QkHbtCfF74UdYXfWFvPhTjQyv/i0i
         wfjZgV1c/hqvA42/CX8Mcn850c43xDojWvPsLwoEA4Le4YHBHKTxfkCCaEHilO5OGZ
         PRXZyXkI+Eo2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 018/109] net/x25: Return the correct errno code
Date:   Mon, 28 Jun 2021 10:31:34 -0400
Message-Id: <20210628143305.32978-19-sashal@kernel.org>
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

[ Upstream commit d7736958668c4facc15f421e622ffd718f5be80a ]

When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/x25/af_x25.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index f43d037ea852..f87002792836 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -551,7 +551,7 @@ static int x25_create(struct net *net, struct socket *sock, int protocol,
 	if (protocol)
 		goto out;
 
-	rc = -ENOBUFS;
+	rc = -ENOMEM;
 	if ((sk = x25_alloc_socket(net, kern)) == NULL)
 		goto out;
 
-- 
2.30.2

