Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2BF4407F
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388801AbfFMQG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:06:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731317AbfFMIp6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:45:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C51542147A;
        Thu, 13 Jun 2019 08:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415557;
        bh=pJW52esM92U84TMqLjTKEO7XT5R2VA6jVxzcPJt29aI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WF5KkBvtkPC8sm7EgQFoDBG6viie407OZCKCzaXOM5II509mW2ARjZVihACY6hjbu
         M+t3qKWYlL6yNum7xT0nx2NV7viMvsbmADOQnxPakE2Vx5NwsUPSdsWBAD8nJ5Z8+Z
         OOyS/dydVvlQIKsGvTPWVZ0C1Ndkvsl8zo7TuwgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yue Hu <huyue2@yulong.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Ingo Molnar <mingo@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Laura Abbott <labbott@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 020/155] mm/cma.c: fix the bitmap status to show failed allocation reason
Date:   Thu, 13 Jun 2019 10:32:12 +0200
Message-Id: <20190613075653.890605925@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 8cb95cd1193a..5e36d7418031 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -369,23 +369,26 @@ err:
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



