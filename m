Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D31241748D
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345637AbhIXNHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:07:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:32810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346137AbhIXNEs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:04:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8F6F61284;
        Fri, 24 Sep 2021 12:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488138;
        bh=i+cUsvLJoLGE8egXUnWTs2itfyiLQ62oGumjwG8Vp84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c1U9zS2PytDnk8051ua/vz9eK+tFCcHLWzJw2nbngfF1X5XEypSlo5Y3wUnmFeml4
         OM63HJhmDvxqEH0kUzSgOtm8enaoWPPvLI9bpe10ViQ4s/uIxnrpB+sHVyEKSjkKnn
         kyKlHww06BRVzD85xFRQT2Mov9lrGGVk9NGsVWqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Xu <haoxu@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 098/100] io_uring: fix off-by-one in BUILD_BUG_ON check of __REQ_F_LAST_BIT
Date:   Fri, 24 Sep 2021 14:44:47 +0200
Message-Id: <20210924124344.770856736@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hao Xu <haoxu@linux.alibaba.com>

[ Upstream commit 32c2d33e0b7c4ea53284d5d9435dd022b582c8cf ]

Build check of __REQ_F_LAST_BIT should be larger than, not equal or larger
than. It's perfectly valid to have __REQ_F_LAST_BIT be 32, as that means
that the last valid bit is 31 which does fit in the type.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
Link: https://lore.kernel.org/r/20210907032243.114190-1-haoxu@linux.alibaba.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 43aaa3566431..754d59f734d8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10335,7 +10335,7 @@ static int __init io_uring_init(void)
 	BUILD_BUG_ON(SQE_VALID_FLAGS >= (1 << 8));
 
 	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
-	BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
+	BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof(int));
 
 	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
 				SLAB_ACCOUNT);
-- 
2.33.0



