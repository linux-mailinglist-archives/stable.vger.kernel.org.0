Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C043B622B
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234608AbhF1OmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:42:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235614AbhF1OkM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:40:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F51561CC5;
        Mon, 28 Jun 2021 14:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890803;
        bh=KGMwPPX8CvWXkezFF9eeVr4BlViafBzYGTq4UIRp/Vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qg+wW/fVBjYVqPTgGtKkgekeepvgKY/+3nCfBXTkP2WmnzmrtnPMyj57YVZU5SCre
         AIWgeA/2i/kSPHmjCajW65FBfUhLn7xtgS20xmyhcK1JwDkl6tS/Z9Bw/AP8Pxo+BE
         yO53acRi3P3bcfLIGP3Trpy6gwgVUxAWwwpT0tnNGxNpgIyN7Wenhs4RexffEZqcI6
         lSU42R+MtdZQ9av2Vb4AOalu4SyVOVzLIZIDTGswliGAUljo4qUeTgthCDHjOkFRrm
         hUcAQ0pmF7dipCwuWx4uCbosg0XpV5rVJM0TFGRFJ/HYteFNtRy8sYj8IXnFAIIxa5
         RNEBZbulFE8fQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 019/109] net: Return the correct errno code
Date:   Mon, 28 Jun 2021 10:31:35 -0400
Message-Id: <20210628143305.32978-20-sashal@kernel.org>
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

[ Upstream commit 49251cd00228a3c983651f6bb2f33f6a0b8f152e ]

When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/compat.c b/net/compat.c
index 2a8c7cb5f06a..2778a236e091 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -158,7 +158,7 @@ int cmsghdr_from_user_compat_to_kern(struct msghdr *kmsg, struct sock *sk,
 	if (kcmlen > stackbuf_size)
 		kcmsg_base = kcmsg = sock_kmalloc(sk, kcmlen, GFP_KERNEL);
 	if (kcmsg == NULL)
-		return -ENOBUFS;
+		return -ENOMEM;
 
 	/* Now copy them over neatly. */
 	memset(kcmsg, 0, kcmlen);
-- 
2.30.2

