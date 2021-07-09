Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C84A3C244B
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbhGINWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:22:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232147AbhGINWB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:22:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C73B613C7;
        Fri,  9 Jul 2021 13:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836754;
        bh=XGane4wHFqjFbg02efSxrhHuNBdFgRinSrEjzZWHbaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N0n2mm8+8jL1WpBRQrqTjbkBy3zngFSbo2DVCo+KLB5wItEL27agSgLCzsFt5VuVV
         euVZPY8wyA8ke3CY806ytuK1ke1jbfse9RZ9Po/XCDn8ytFDaGMEJCT5FdrFy2dSRM
         SmrOd7LQ6s19y0E63vXhHiSEtR3VLq3rbqcyORRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 04/25] mm/rmap: use page_not_mapped in try_to_unmap()
Date:   Fri,  9 Jul 2021 15:18:35 +0200
Message-Id: <20210709131630.520622822@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131627.928131764@linuxfoundation.org>
References: <20210709131627.928131764@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit b7e188ec98b1644ff70a6d3624ea16aadc39f5e0 ]

page_mapcount_is_zero() calculates accurately how many mappings a hugepage
has in order to check against 0 only.  This is a waste of cpu time.  We
can do this via page_not_mapped() to save some possible atomic_read
cycles.  Remove the function page_mapcount_is_zero() as it's not used
anymore and move page_not_mapped() above try_to_unmap() to avoid
identifier undeclared compilation error.

Link: https://lkml.kernel.org/r/20210130084904.35307-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/rmap.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index e2506b6adb6a..e6a556fec9d1 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1624,9 +1624,9 @@ static bool invalid_migration_vma(struct vm_area_struct *vma, void *arg)
 	return is_vma_temporary_stack(vma);
 }
 
-static int page_mapcount_is_zero(struct page *page)
+static int page_not_mapped(struct page *page)
 {
-	return !total_mapcount(page);
+	return !page_mapped(page);
 }
 
 /**
@@ -1644,7 +1644,7 @@ bool try_to_unmap(struct page *page, enum ttu_flags flags)
 	struct rmap_walk_control rwc = {
 		.rmap_one = try_to_unmap_one,
 		.arg = (void *)flags,
-		.done = page_mapcount_is_zero,
+		.done = page_not_mapped,
 		.anon_lock = page_lock_anon_vma_read,
 	};
 
@@ -1668,11 +1668,6 @@ bool try_to_unmap(struct page *page, enum ttu_flags flags)
 	return !page_mapcount(page) ? true : false;
 }
 
-static int page_not_mapped(struct page *page)
-{
-	return !page_mapped(page);
-}
-
 /**
  * try_to_munlock - try to munlock a page
  * @page: the page to be munlocked
-- 
2.30.2



