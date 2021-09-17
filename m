Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31F240EF7A
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 04:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243106AbhIQCgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 22:36:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243114AbhIQCf4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 22:35:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EA086113A;
        Fri, 17 Sep 2021 02:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846072;
        bh=MEh+dJd/rHAdePV95GEi18ZaUpI6OSvMzpvxm2XHSjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=amXITWFb3GLxSddItATCiGlGBLE7aTxbdZL9aIKQf8CGeXwdeU9y4Wy6tkmyaie0S
         ibfeJwPOO/5sZGJ6zvPQWo6K92lQDVqUgjVmpB96OBbUobNsUwAX2qOptId83kLD+M
         nTU7oO4V6JJ60gHCgNu6CZpsUrgxRVm+/HfiLYmLfxZ+xUIQBAGxducmlDzk8Pczg7
         +b+IQCCGvq8tvV2Pfxj0Zxc3reevFIGuRRlr0sVL5M5fYjFQSLDsJ9M4xSbU8pg01K
         cFu774wHwb8fTrvdRwC1eAx8YbnQ4cUb9NouXYXH2H+uLOFH3XMZeVEDrAT6bg0/tn
         DU/RHg0s/860A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.14 21/21] io_uring: fix off-by-one in BUILD_BUG_ON check of __REQ_F_LAST_BIT
Date:   Thu, 16 Sep 2021 22:33:15 -0400
Message-Id: <20210917023315.816225-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210917023315.816225-1-sashal@kernel.org>
References: <20210917023315.816225-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index a2e20a6fbfed..305c9923283a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10306,7 +10306,7 @@ static int __init io_uring_init(void)
 	BUILD_BUG_ON(SQE_VALID_FLAGS >= (1 << 8));
 
 	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
-	BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
+	BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof(int));
 
 	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
 				SLAB_ACCOUNT);
-- 
2.30.2

