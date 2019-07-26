Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD54767F5
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387613AbfGZNlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:41:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727806AbfGZNlD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:41:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C63222CB9;
        Fri, 26 Jul 2019 13:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148462;
        bh=Qt2/1Z3/byDB4IlQk0hOeMb7GKWf8oM+Z2eeZc24UfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OjjpPW7v1GN99vV9Ddsmo5b1CPZ2sil7k8KzGs2GZNcuzZBAlUvo90lUqvgiHWdug
         9frEFwg7ZguJGpVByRf6CNC5xSp70ex1NqD7AfNzTy/abdPwaJ1Wo2uJ4R/4S48orj
         o0D5y6ephx5b73+ihstS3t5CBeGDYaa876ddYqMA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Henry Burns <henryburns@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Vitaly Vul <vitaly.vul@sony.com>,
        Vitaly Wool <vitalywool@gmail.com>,
        Jonathan Adams <jwadams@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.2 53/85] mm/z3fold.c: reinitialize zhdr structs after migration
Date:   Fri, 26 Jul 2019 09:39:03 -0400
Message-Id: <20190726133936.11177-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Henry Burns <henryburns@google.com>

[ Upstream commit c92d2f38563db20c20c8db2f98fa1349290477d5 ]

z3fold_page_migration() calls memcpy(new_zhdr, zhdr, PAGE_SIZE).
However, zhdr contains fields that can't be directly coppied over (ex:
list_head, a circular linked list).  We only need to initialize the
linked lists in new_zhdr, as z3fold_isolate_page() already ensures that
these lists are empty

Additionally it is possible that zhdr->work has been placed in a
workqueue.  In this case we shouldn't migrate the page, as zhdr->work
references zhdr as opposed to new_zhdr.

Link: http://lkml.kernel.org/r/20190716000520.230595-1-henryburns@google.com
Fixes: 1f862989b04ade61d3 ("mm/z3fold.c: support page migration")
Signed-off-by: Henry Burns <henryburns@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Vitaly Vul <vitaly.vul@sony.com>
Cc: Vitaly Wool <vitalywool@gmail.com>
Cc: Jonathan Adams <jwadams@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/z3fold.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/z3fold.c b/mm/z3fold.c
index e1686bf6d689..7e764b0d8c8a 100644
--- a/mm/z3fold.c
+++ b/mm/z3fold.c
@@ -1350,12 +1350,22 @@ static int z3fold_page_migrate(struct address_space *mapping, struct page *newpa
 		unlock_page(page);
 		return -EBUSY;
 	}
+	if (work_pending(&zhdr->work)) {
+		z3fold_page_unlock(zhdr);
+		return -EAGAIN;
+	}
 	new_zhdr = page_address(newpage);
 	memcpy(new_zhdr, zhdr, PAGE_SIZE);
 	newpage->private = page->private;
 	page->private = 0;
 	z3fold_page_unlock(zhdr);
 	spin_lock_init(&new_zhdr->page_lock);
+	INIT_WORK(&new_zhdr->work, compact_page_work);
+	/*
+	 * z3fold_page_isolate() ensures that new_zhdr->buddy is empty,
+	 * so we only have to reinitialize it.
+	 */
+	INIT_LIST_HEAD(&new_zhdr->buddy);
 	new_mapping = page_mapping(page);
 	__ClearPageMovable(page);
 	ClearPagePrivate(page);
-- 
2.20.1

