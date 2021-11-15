Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21E9450EA6
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240797AbhKOSRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:17:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:49946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240692AbhKOSLr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:11:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 544AB632A6;
        Mon, 15 Nov 2021 17:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998470;
        bh=2hDB47qVFPDxQokYgFMXvhZ6VWD/CiAnsL5QYSMOK68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YeQnzDwAWYp+txbZaxz+XcmrZ9Wpuppl/RE36GF1gEE5MYkU4WhR6K9mXIbCDYa8O
         qeBMcVgX8DFZkXZz59PABiLJoRsS0ursrrd5pu+iJabTumyAyd4A4zLLBi1S0hr7xb
         Ln80YcON2WI2RvHPdsa3wwR1k9JRjijI7YEi83uY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Henry Burns <henryburns@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 521/575] mm/zsmalloc.c: close race window between zs_pool_dec_isolated() and zs_unregister_migration()
Date:   Mon, 15 Nov 2021 18:04:06 +0100
Message-Id: <20211115165401.689856857@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit afe8605ca45424629fdddfd85984b442c763dc47 ]

There is one possible race window between zs_pool_dec_isolated() and
zs_unregister_migration() because wait_for_isolated_drain() checks the
isolated count without holding class->lock and there is no order inside
zs_pool_dec_isolated().  Thus the below race window could be possible:

  zs_pool_dec_isolated		zs_unregister_migration
    check pool->destroying != 0
				  pool->destroying = true;
				  smp_mb();
				  wait_for_isolated_drain()
				    wait for pool->isolated_pages == 0
    atomic_long_dec(&pool->isolated_pages);
    atomic_long_read(&pool->isolated_pages) == 0

Since we observe the pool->destroying (false) before atomic_long_dec()
for pool->isolated_pages, waking pool->migration_wait up is missed.

Fix this by ensure checking pool->destroying happens after the
atomic_long_dec(&pool->isolated_pages).

Link: https://lkml.kernel.org/r/20210708115027.7557-1-linmiaohe@huawei.com
Fixes: 701d678599d0 ("mm/zsmalloc.c: fix race condition in zs_destroy_pool")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Henry Burns <henryburns@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/zsmalloc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 7a0b79b0a6899..73cd50735df29 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1835,10 +1835,11 @@ static inline void zs_pool_dec_isolated(struct zs_pool *pool)
 	VM_BUG_ON(atomic_long_read(&pool->isolated_pages) <= 0);
 	atomic_long_dec(&pool->isolated_pages);
 	/*
-	 * There's no possibility of racing, since wait_for_isolated_drain()
-	 * checks the isolated count under &class->lock after enqueuing
-	 * on migration_wait.
+	 * Checking pool->destroying must happen after atomic_long_dec()
+	 * for pool->isolated_pages above. Paired with the smp_mb() in
+	 * zs_unregister_migration().
 	 */
+	smp_mb__after_atomic();
 	if (atomic_long_read(&pool->isolated_pages) == 0 && pool->destroying)
 		wake_up_all(&pool->migration_wait);
 }
-- 
2.33.0



