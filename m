Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDA2081D10
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729650AbfHENWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:22:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730614AbfHENWE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:22:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E5EF20657;
        Mon,  5 Aug 2019 13:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011324;
        bh=lZ4qH7eMqi86NFse/Iv5+y2ZDI6YfEIJiv4HFmce+Kc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zr+Vdc8Ak8nYZvYvQKpFZ3ncNBgsh8XXVuw0VgY+uSUXmvrmGMHJIrob5IOck33K5
         S+66t2mVqaI9LB8JRtOPXS67ybllr1NT0sagnPiPEsfxlJoDuFOKRjAVe+L5qWGeem
         OtFMNANVx4E+Yp/PuSIFD/jmUqJVnSvrpQ6vQ+k0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Henry Burns <henryburns@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Vitaly Vul <vitaly.vul@sony.com>,
        Vitaly Wool <vitalywool@gmail.com>,
        Jonathan Adams <jwadams@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 050/131] mm/z3fold.c: reinitialize zhdr structs after migration
Date:   Mon,  5 Aug 2019 15:02:17 +0200
Message-Id: <20190805124954.784647814@linuxfoundation.org>
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
index 304f2883cdb93..3b27094dc42e1 100644
--- a/mm/z3fold.c
+++ b/mm/z3fold.c
@@ -1360,12 +1360,22 @@ static int z3fold_page_migrate(struct address_space *mapping, struct page *newpa
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



