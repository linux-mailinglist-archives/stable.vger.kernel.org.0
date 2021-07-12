Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50FD73C55CE
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346605AbhGLIMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:12:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353934AbhGLIDJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A94D1619B3;
        Mon, 12 Jul 2021 07:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076737;
        bh=UmECBYGfar0mqM02Ns5rm/+U6BG3JDqP88DtRgaR5e4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKKo9hEneFs3ZmZJaXbh+SwwEp58q1OP+ZWrsif9j5PoIiAvWJat2fBcMBpoMUp/9
         ngviXrBZeS48LwvALpPc4rm+6TMI1NPWwTOK/R1dWgzYsiHLgaqe0MtRTyy8pmAYE8
         /ic5/wSbfU0HgbOLiRV6SwxM7huqddNAM9eQuysE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Colin Ian King <colin.king@canonical.com>,
        Dan Streetman <ddstreet@ieee.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Seth Jennings <sjenning@redhat.com>,
        Tian Tao <tiantao6@hisilicon.com>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 772/800] mm/zswap.c: fix two bugs in zswap_writeback_entry()
Date:   Mon, 12 Jul 2021 08:13:15 +0200
Message-Id: <20210712061048.979749149@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit 46b76f2e09dc35f70aca2f4349eb0d158f53fe93 ]

In the ZSWAP_SWAPCACHE_FAIL and ZSWAP_SWAPCACHE_EXIST case, we forgot to
call zpool_unmap_handle() when zpool can't sleep. And we might sleep in
zswap_get_swap_cache_page() while zpool can't sleep. To fix all of these,
zpool_unmap_handle() should be done before zswap_get_swap_cache_page()
when zpool can't sleep.

Link: https://lkml.kernel.org/r/20210522092242.3233191-4-linmiaohe@huawei.com
Fixes: fc6697a89f56 ("mm/zswap: add the flag can_sleep_mapped")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Tian Tao <tiantao6@hisilicon.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/zswap.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 20763267a219..706e0f98125a 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -967,6 +967,13 @@ static int zswap_writeback_entry(struct zpool *pool, unsigned long handle)
 	spin_unlock(&tree->lock);
 	BUG_ON(offset != entry->offset);
 
+	src = (u8 *)zhdr + sizeof(struct zswap_header);
+	if (!zpool_can_sleep_mapped(pool)) {
+		memcpy(tmp, src, entry->length);
+		src = tmp;
+		zpool_unmap_handle(pool, handle);
+	}
+
 	/* try to allocate swap cache page */
 	switch (zswap_get_swap_cache_page(swpentry, &page)) {
 	case ZSWAP_SWAPCACHE_FAIL: /* no memory or invalidate happened */
@@ -982,17 +989,7 @@ static int zswap_writeback_entry(struct zpool *pool, unsigned long handle)
 	case ZSWAP_SWAPCACHE_NEW: /* page is locked */
 		/* decompress */
 		acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
-
 		dlen = PAGE_SIZE;
-		src = (u8 *)zhdr + sizeof(struct zswap_header);
-
-		if (!zpool_can_sleep_mapped(pool)) {
-
-			memcpy(tmp, src, entry->length);
-			src = tmp;
-
-			zpool_unmap_handle(pool, handle);
-		}
 
 		mutex_lock(acomp_ctx->mutex);
 		sg_init_one(&input, src, entry->length);
-- 
2.30.2



