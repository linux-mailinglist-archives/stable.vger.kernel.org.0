Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A1040E873
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355949AbhIPRoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:44:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355373AbhIPRlY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:41:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D414D6324E;
        Thu, 16 Sep 2021 16:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811154;
        bh=Tm2faHpCHOl5c4OzcYYIMRfJQpMc9cNUrJj2eNBLEiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QUNGwYPE5OQSIbJXze+bYL7YRwsPdAL8fYmTsnmyhls9orucw2Epfo2SosA5CrHVI
         NDF+cc6SHf3P652Lvla7wQguIzYBG/ximj191BCbdrrrbsuJsltPybJAMyTLZebfPF
         1lz+QmlWa1ZrDONtLjplP1LlbtAlbGeGyFFO3fo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Wang <yun.wang@linux.alibaba.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Abaci <abaci@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.14 402/432] mm: fix panic caused by __page_handle_poison()
Date:   Thu, 16 Sep 2021 18:02:31 +0200
Message-Id: <20210916155824.456233563@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Wang <yun.wang@linux.alibaba.com>

commit f87060d345232c7d855167a43faf006e24afa999 upstream.

In commit 510d25c92ec4 ("mm/hwpoison: disable pcp for
page_handle_poison()"), __page_handle_poison() was introduced, and if we
mark:

RET_A = dissolve_free_huge_page();
RET_B = take_page_off_buddy();

then __page_handle_poison was supposed to return TRUE When RET_A == 0 &&
RET_B == TRUE

But since it failed to take care the case when RET_A is -EBUSY or -ENOMEM,
and just return the ret as a bool which actually become TRUE, it break the
original logic.

The following result is a huge page in freelist but was
referenced as poisoned, and lead into the final panic:

  kernel BUG at mm/internal.h:95!
  invalid opcode: 0000 [#1] SMP PTI
  skip...
  RIP: 0010:set_page_refcounted mm/internal.h:95 [inline]
  RIP: 0010:remove_hugetlb_page+0x23c/0x240 mm/hugetlb.c:1371
  skip...
  Call Trace:
   remove_pool_huge_page+0xe4/0x110 mm/hugetlb.c:1892
   return_unused_surplus_pages+0x8d/0x150 mm/hugetlb.c:2272
   hugetlb_acct_memory.part.91+0x524/0x690 mm/hugetlb.c:4017

This patch replaces 'bool' with 'int' to handle RET_A correctly.

Link: https://lkml.kernel.org/r/61782ac6-1e8a-4f6f-35e6-e94fce3b37f5@linux.alibaba.com
Fixes: 510d25c92ec4 ("mm/hwpoison: disable pcp for page_handle_poison()")
Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: Abaci <abaci@linux.alibaba.com>
Cc: <stable@vger.kernel.org>	[5.14+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -68,7 +68,7 @@ atomic_long_t num_poisoned_pages __read_
 
 static bool __page_handle_poison(struct page *page)
 {
-	bool ret;
+	int ret;
 
 	zone_pcp_disable(page_zone(page));
 	ret = dissolve_free_huge_page(page);
@@ -76,7 +76,7 @@ static bool __page_handle_poison(struct
 		ret = take_page_off_buddy(page);
 	zone_pcp_enable(page_zone(page));
 
-	return ret;
+	return ret > 0;
 }
 
 static bool page_handle_poison(struct page *page, bool hugepage_or_freepage, bool release)


