Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7D03B62F9
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbhF1Out (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:50:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233950AbhF1Osr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:48:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3C0261CA6;
        Mon, 28 Jun 2021 14:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891004;
        bh=PW9i5nQ9u/7zRXFaJi4+KmTo3QsTKyQlAlfxo6yFvv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FMyKlZ+ahyFLoP/PO/PTvLaigDay7i8DEa2zX16YbR7ZgOhaJzB1d9NMYpnUeismp
         sj5Iwgzj0S6o6pE61x9AEnmWqj5IHuLEorpITeufHRUQlF8gWY+OK6cxl/WqxxAwGX
         6HrbsgWywfY1H8dBHZ35AdD+K/2FutThwgRFHHUXEnMGVggiQBNPGMI3dGnQnvzfDv
         sltD82ON4hbIo7oRC2Kq3+rCJX3CzS+teY3mDay5lRNqrXY3sdCYNgcuE9UGqbk2sx
         K+tQX3Qgnz4G26Rtf6I5bvoOEcZ/RCjl1vlRdI/SZ94vNyL1MiumB+ixuM9Q69fFY9
         ZF8x+xCZ/ZAsQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 16/88] net: Return the correct errno code
Date:   Mon, 28 Jun 2021 10:35:16 -0400
Message-Id: <20210628143628.33342-17-sashal@kernel.org>
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

[ Upstream commit 49251cd00228a3c983651f6bb2f33f6a0b8f152e ]

When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/compat.c b/net/compat.c
index 45349658ed01..2ec822f4e409 100644
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

