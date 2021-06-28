Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D48C3B643A
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235370AbhF1PGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:06:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234757AbhF1PDu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:03:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A60E61CDE;
        Mon, 28 Jun 2021 14:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891387;
        bh=c4tfBSDu/8Sb9YNPIcdis5klrUrezDTAxTa2z/cY31o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ILetJ6Bp7Mv66CQJMcHsBT9ORsJrrUiAhBy3+KnagNy5Ou0s1y++jnPmBkbPerZqe
         DiV6v9rB2l+RUqStVA/8pzLj9mToOpq7KhAVck9ygv/Gk8Mg1ztj+D4qURoK6qdspJ
         dAgN57CiOFIGGkVALOFWxQmFMRiABgDr+CxmOy06hwrNk95GVhCRRg7LdVEk/TzeLt
         1ACjfryc+XgqHGCBAYhxYC13TRu4ZPw1BY9/40Kib/iNQUJnOZE3wGBhrN3bV+7VAf
         5wRm7hcXC0Rudt5fcnDJaW+nlPS/f1+tpXUO7f6RK57keoVYt+6Xy/sVQPkXrQmLk9
         fb+dILgslgIiw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 11/57] net/x25: Return the correct errno code
Date:   Mon, 28 Jun 2021 10:42:10 -0400
Message-Id: <20210628144256.34524-12-sashal@kernel.org>
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

[ Upstream commit d7736958668c4facc15f421e622ffd718f5be80a ]

When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/x25/af_x25.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index a9fd95d10e84..156639be7ed0 100644
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

