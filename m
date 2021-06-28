Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453643B61E0
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbhF1OkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:40:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234115AbhF1OhR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:37:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B94D61CB0;
        Mon, 28 Jun 2021 14:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890648;
        bh=FztCuipEk4M3a3T/YHhZhuyq52epotiigM2yOipgC8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Szm8lpchNZSCjfak6PPRAQGaxycCUdO7xJHiY9ylHk8OtY8NyEEzPUhWKbxwNuAUW
         S+H9dAME4pSlZVeGSO2xtYvtQ4G9P6euR8dh0tFESusUPPfdaWMSNpXb3vmaSJwlDY
         q7NTG0pWkUKs19HVfzn0bnHlYWwJ/h9a5fpJ2m84siL+m/zsF39xMFPwTDewAAqxLp
         prU+wgCc4J+am7rwWCE1PKSeF7Uj7YhKHRlhWQ/cvpLHEJeC55aQV5C/xeic8IYkTg
         bSbSy0NPPPW3vQrp7gcdOMBULt+xRYDqoT7GfgOIz2AOOEZTIzJl44Aj1TAnHrSRHB
         yCOgAnbg0qXmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 47/71] mm/rmap: use page_not_mapped in try_to_unmap()
Date:   Mon, 28 Jun 2021 10:29:40 -0400
Message-Id: <20210628143004.32596-48-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.129-rc1
X-KernelTest-Deadline: 2021-06-30T14:29+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/rmap.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index ccc8a780e348..cbde11c06a76 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1690,9 +1690,9 @@ static bool invalid_migration_vma(struct vm_area_struct *vma, void *arg)
 	return is_vma_temporary_stack(vma);
 }
 
-static int page_mapcount_is_zero(struct page *page)
+static int page_not_mapped(struct page *page)
 {
-	return !total_mapcount(page);
+	return !page_mapped(page);
 }
 
 /**
@@ -1710,7 +1710,7 @@ bool try_to_unmap(struct page *page, enum ttu_flags flags)
 	struct rmap_walk_control rwc = {
 		.rmap_one = try_to_unmap_one,
 		.arg = (void *)flags,
-		.done = page_mapcount_is_zero,
+		.done = page_not_mapped,
 		.anon_lock = page_lock_anon_vma_read,
 	};
 
@@ -1734,11 +1734,6 @@ bool try_to_unmap(struct page *page, enum ttu_flags flags)
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

