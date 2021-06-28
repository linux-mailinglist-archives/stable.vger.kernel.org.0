Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132F33B62FA
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbhF1Ouu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:50:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233925AbhF1Osr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:48:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F22CB61CA5;
        Mon, 28 Jun 2021 14:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891003;
        bh=+p6Ru1HAnt4vdsR80m3zPO30bLQzBT3Pqydpwqgfn60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BnuNTFUx+DhONKm7V6NrPm9FeFNI/HdPtT77Msgbd2a4+X+wYiF9YA7o8PyhzY7Bj
         4ss/61h89HHLd/tRjNxmSiTx8Vc4SAq6ROhaCRfjophDEs661zUYW1wFUMwQlksuZC
         ilwGnCkUbQGC9oOt7JpVAA0Yt4NKDPVlv+qu4mnCrdaXlEVw0Vnc3naF2nijvED0HN
         hGhvpZ4+TAJBnz2mvz/SEe7plqtXUl9GRBRsYEVKNT1sbDCyHzcG+D77BKyz6rGpNf
         ErXLlzfkO3+Zg7tLvQN9v7HAHrZsvqR4SnySVtg1dmV+1S/sRxQOJKz3KaqFxaHJ3H
         6epFBbYRPkqSA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 15/88] net/x25: Return the correct errno code
Date:   Mon, 28 Jun 2021 10:35:15 -0400
Message-Id: <20210628143628.33342-16-sashal@kernel.org>
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

[ Upstream commit d7736958668c4facc15f421e622ffd718f5be80a ]

When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/x25/af_x25.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 987e5f8cafbe..fd0a6c6c77b6 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -550,7 +550,7 @@ static int x25_create(struct net *net, struct socket *sock, int protocol,
 	if (protocol)
 		goto out;
 
-	rc = -ENOBUFS;
+	rc = -ENOMEM;
 	if ((sk = x25_alloc_socket(net, kern)) == NULL)
 		goto out;
 
-- 
2.30.2

