Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB5445BC07
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244106AbhKXMZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:25:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:36602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243571AbhKXMXD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:23:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF9C7610FB;
        Wed, 24 Nov 2021 12:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756039;
        bh=piXX3gWPNpYFsdBBmwN9e8w0U+qxHyb0K69J3h53m34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UVUN/ahQCqmjVNs0GQWPe02bRf4o4EBc4bUbc2OXjGrYqVGRwOytowYn3lj3UlL2g
         0uIOmrEqgFyxCQf5OHUOADdQSkHasyKTNSoSb7dMjs+ZIWFm3E8AUy7DQ2FAgSnvHq
         h0cXLd0kmvnoUm89Y54JbyF+w8ulavUAeCMxPPAY=
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
Subject: [PATCH 4.9 148/207] mm/zsmalloc.c: close race window between zs_pool_dec_isolated() and zs_unregister_migration()
Date:   Wed, 24 Nov 2021 12:56:59 +0100
Message-Id: <20211124115708.807769572@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
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
index 2b7bfd97587a0..b5c1cd4ba2a15 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1962,10 +1962,11 @@ static inline void zs_pool_dec_isolated(struct zs_pool *pool)
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



