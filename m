Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB2931F67
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727592AbfFANRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:17:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727585AbfFANRy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:17:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73ADA25525;
        Sat,  1 Jun 2019 13:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395072;
        bh=B1J+LEftpT2eJ8CNTcSUayV3uaqVgtvofuMySmehwFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sHpNuSFmbOrn9rekG1Bxye6ZCyacrs1xTNf9ToWq/Q+2yH3VvdETLwL53F/4pqw11
         2igMUZT07ZGcb4KAO0LNC3L6PTQLvJ7/cr6iElTh1fTvrnCWybfWKuUAv8uFj8mZRo
         2IX5VH3/44iwzPs52VgK8Es6tnUm6uPKduaKCUgk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yue Hu <huyue2@yulong.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Ingo Molnar <mingo@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Laura Abbott <labbott@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.1 019/186] mm/cma.c: fix the bitmap status to show failed allocation reason
Date:   Sat,  1 Jun 2019 09:13:55 -0400
Message-Id: <20190601131653.24205-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131653.24205-1-sashal@kernel.org>
References: <20190601131653.24205-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yue Hu <huyue2@yulong.com>

[ Upstream commit 2b59e01a3aa665f751d1410b99fae9336bd424e1 ]

Currently one bit in cma bitmap represents number of pages rather than
one page, cma->count means cma size in pages. So to find available pages
via find_next_zero_bit()/find_next_bit() we should use cma size not in
pages but in bits although current free pages number is correct due to
zero value of order_per_bit. Once order_per_bit is changed the bitmap
status will be incorrect.

The size input in cma_debug_show_areas() is not correct.  It will
affect the available pages at some position to debug the failure issue.

This is an example with order_per_bit = 1

Before this change:
[    4.120060] cma: number of available pages: 1@93+4@108+7@121+7@137+7@153+7@169+7@185+7@201+3@213+3@221+3@229+3@237+3@245+3@253+3@261+3@269+3@277+3@285+3@293+3@301+3@309+3@317+3@325+19@333+15@369+512@512=> 638 free of 1024 total pages

After this change:
[    4.143234] cma: number of available pages: 2@93+8@108+14@121+14@137+14@153+14@169+14@185+14@201+6@213+6@221+6@229+6@237+6@245+6@253+6@261+6@269+6@277+6@285+6@293+6@301+6@309+6@317+6@325+38@333+30@369=> 252 free of 1024 total pages

Obviously the bitmap status before is incorrect.

Link: http://lkml.kernel.org/r/20190320060829.9144-1-zbestahu@gmail.com
Signed-off-by: Yue Hu <huyue2@yulong.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Laura Abbott <labbott@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/cma.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index 8cb95cd1193a9..5e36d7418031c 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -369,23 +369,26 @@ int __init cma_declare_contiguous(phys_addr_t base,
 #ifdef CONFIG_CMA_DEBUG
 static void cma_debug_show_areas(struct cma *cma)
 {
-	unsigned long next_zero_bit, next_set_bit;
+	unsigned long next_zero_bit, next_set_bit, nr_zero;
 	unsigned long start = 0;
-	unsigned int nr_zero, nr_total = 0;
+	unsigned long nr_part, nr_total = 0;
+	unsigned long nbits = cma_bitmap_maxno(cma);
 
 	mutex_lock(&cma->lock);
 	pr_info("number of available pages: ");
 	for (;;) {
-		next_zero_bit = find_next_zero_bit(cma->bitmap, cma->count, start);
-		if (next_zero_bit >= cma->count)
+		next_zero_bit = find_next_zero_bit(cma->bitmap, nbits, start);
+		if (next_zero_bit >= nbits)
 			break;
-		next_set_bit = find_next_bit(cma->bitmap, cma->count, next_zero_bit);
+		next_set_bit = find_next_bit(cma->bitmap, nbits, next_zero_bit);
 		nr_zero = next_set_bit - next_zero_bit;
-		pr_cont("%s%u@%lu", nr_total ? "+" : "", nr_zero, next_zero_bit);
-		nr_total += nr_zero;
+		nr_part = nr_zero << cma->order_per_bit;
+		pr_cont("%s%lu@%lu", nr_total ? "+" : "", nr_part,
+			next_zero_bit);
+		nr_total += nr_part;
 		start = next_zero_bit + nr_zero;
 	}
-	pr_cont("=> %u free of %lu total pages\n", nr_total, cma->count);
+	pr_cont("=> %lu free of %lu total pages\n", nr_total, cma->count);
 	mutex_unlock(&cma->lock);
 }
 #else
-- 
2.20.1

