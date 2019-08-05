Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E937381CF4
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730595AbfHENXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:23:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730345AbfHENXc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:23:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 144D72075B;
        Mon,  5 Aug 2019 13:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011411;
        bh=fqemhpUHz98YQxmGNMTN+N12UlsgJGrB4v2R7xmi2JY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=msoeJftOH48RTAmP4tP9Xu/bPQclZK+lz5CV/NZYyJI3QNdDkQRyNlctCug/RiTru
         7hFKWdm701KtQbCQQgFqAgXqlr0GIL1nKwhxYDJd3KpOuXjWOQsHmFCp/FpmeJYHdq
         NhHoR6ayrUdBApIEn9i3naItnatYa63jBIy8VOxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
        Henry Burns <henryburns@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Jonathan Adams <jwadams@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 047/131] mm/z3fold: dont try to use buddy slots after free
Date:   Mon,  5 Aug 2019 15:02:14 +0200
Message-Id: <20190805124954.583410174@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit bb9a374dfa3a2f46581455ab66cd1d24c5e3d183 ]

As reported by Henry Burns:

Running z3fold stress testing with address sanitization showed zhdr->slots
was being used after it was freed.

  z3fold_free(z3fold_pool, handle)
    free_handle(handle)
      kmem_cache_free(pool->c_handle, zhdr->slots)
    release_z3fold_page_locked_list(kref)
      __release_z3fold_page(zhdr, true)
        zhdr_to_pool(zhdr)
          slots_to_pool(zhdr->slots)  *BOOM*

To fix this, add pointer to the pool back to z3fold_header and modify
zhdr_to_pool to return zhdr->pool.

Link: http://lkml.kernel.org/r/20190708134808.e89f3bfadd9f6ffd7eff9ba9@gmail.com
Fixes: 7c2b8baa61fe  ("mm/z3fold.c: add structure for buddy handles")
Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Reported-by: Henry Burns <henryburns@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Jonathan Adams <jwadams@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/z3fold.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/z3fold.c b/mm/z3fold.c
index dfcd69d08c1e9..304f2883cdb93 100644
--- a/mm/z3fold.c
+++ b/mm/z3fold.c
@@ -101,6 +101,7 @@ struct z3fold_buddy_slots {
  * @refcount:		reference count for the z3fold page
  * @work:		work_struct for page layout optimization
  * @slots:		pointer to the structure holding buddy slots
+ * @pool:		pointer to the containing pool
  * @cpu:		CPU which this page "belongs" to
  * @first_chunks:	the size of the first buddy in chunks, 0 if free
  * @middle_chunks:	the size of the middle buddy in chunks, 0 if free
@@ -114,6 +115,7 @@ struct z3fold_header {
 	struct kref refcount;
 	struct work_struct work;
 	struct z3fold_buddy_slots *slots;
+	struct z3fold_pool *pool;
 	short cpu;
 	unsigned short first_chunks;
 	unsigned short middle_chunks;
@@ -320,6 +322,7 @@ static struct z3fold_header *init_z3fold_page(struct page *page,
 	zhdr->start_middle = 0;
 	zhdr->cpu = -1;
 	zhdr->slots = slots;
+	zhdr->pool = pool;
 	INIT_LIST_HEAD(&zhdr->buddy);
 	INIT_WORK(&zhdr->work, compact_page_work);
 	return zhdr;
@@ -426,7 +429,7 @@ static enum buddy handle_to_buddy(unsigned long handle)
 
 static inline struct z3fold_pool *zhdr_to_pool(struct z3fold_header *zhdr)
 {
-	return slots_to_pool(zhdr->slots);
+	return zhdr->pool;
 }
 
 static void __release_z3fold_page(struct z3fold_header *zhdr, bool locked)
-- 
2.20.1



