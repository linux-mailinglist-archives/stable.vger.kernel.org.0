Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7BF63B643B
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235392AbhF1PGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:06:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235449AbhF1PEB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:04:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 204D261CE0;
        Mon, 28 Jun 2021 14:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891388;
        bh=EyAeVTxl7z/TcPRc3l9mcPi1JNy+97IFS7L7Wibe2V4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=scnm1KYVTLtHpaIc70OwI6RWpsmZOI3sm00iYuAEklOqoMXFd2F+WkbndqpVXrpO5
         WWo8jM0gJFKEuMAbJ83c/ps55temtT5jQGY+NBNJA4oFbbNRqdsWy2DAWiyB7uXm9l
         Yaz77ijeRDyfyfIw8AmbUueHAz/lHW84yaQ3gfUKLrkxnLHA1uPeL1cet0bkMeieZY
         KyB7OGaETi5XNDNM34avJav379WHxb/njcSHH2m+GNHD7niwcXAs1cA70LYVtMmRl0
         piRmUoqraySdTsxYghiJfF9fqL8HtIFpE+K4EAJhdErjOzpihIfbfPBnxsJcleWtKb
         stG44ZXMoHTfw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 12/57] net: Return the correct errno code
Date:   Mon, 28 Jun 2021 10:42:11 -0400
Message-Id: <20210628144256.34524-13-sashal@kernel.org>
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

[ Upstream commit 49251cd00228a3c983651f6bb2f33f6a0b8f152e ]

When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/compat.c b/net/compat.c
index 20c5e5f215f2..14459a87fdbc 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -159,7 +159,7 @@ int cmsghdr_from_user_compat_to_kern(struct msghdr *kmsg, struct sock *sk,
 	if (kcmlen > stackbuf_size)
 		kcmsg_base = kcmsg = sock_kmalloc(sk, kcmlen, GFP_KERNEL);
 	if (kcmsg == NULL)
-		return -ENOBUFS;
+		return -ENOMEM;
 
 	/* Now copy them over neatly. */
 	memset(kcmsg, 0, kcmlen);
-- 
2.30.2

