Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B082593C5
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730628AbgIAPas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:30:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728903AbgIAPap (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:30:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F09C207D3;
        Tue,  1 Sep 2020 15:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974244;
        bh=WdnpDlkzTQsxN4919At8IGyxFiDcqFVjfe6E6UOUb4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zl0xKS1tKwe2wODF9uR94n6h83xocOd3L11Emzvx5Ek3R05/pqny+1jrpsEc5fVk5
         gXWOYzP0nm0bUNrQW9vP8ZoW1JLi6Rvk95o8VP3HJpPKDT+fp443oGoAUKVT6Udnla
         6YZe4MYFaP0kJG2+dYtyOYO4+fbSoxnnesIThVgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 102/214] block: Fix page_is_mergeable() for compound pages
Date:   Tue,  1 Sep 2020 17:09:42 +0200
Message-Id: <20200901150957.887959537@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit d81665198b83e55a28339d1f3e4890ed8a434556 ]

If we pass in an offset which is larger than PAGE_SIZE, then
page_is_mergeable() thinks it's not mergeable with the previous bio_vec,
leading to a large number of bio_vecs being used.  Use a slightly more
obvious test that the two pages are compatible with each other.

Fixes: 52d52d1c98a9 ("block: only allow contiguous page structs in a bio_vec")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 94d697217887a..87505a93bcff6 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -683,8 +683,8 @@ static inline bool page_is_mergeable(const struct bio_vec *bv,
 		struct page *page, unsigned int len, unsigned int off,
 		bool *same_page)
 {
-	phys_addr_t vec_end_addr = page_to_phys(bv->bv_page) +
-		bv->bv_offset + bv->bv_len - 1;
+	size_t bv_end = bv->bv_offset + bv->bv_len;
+	phys_addr_t vec_end_addr = page_to_phys(bv->bv_page) + bv_end - 1;
 	phys_addr_t page_addr = page_to_phys(page);
 
 	if (vec_end_addr + 1 != page_addr + off)
@@ -693,9 +693,9 @@ static inline bool page_is_mergeable(const struct bio_vec *bv,
 		return false;
 
 	*same_page = ((vec_end_addr & PAGE_MASK) == page_addr);
-	if (!*same_page && pfn_to_page(PFN_DOWN(vec_end_addr)) + 1 != page)
-		return false;
-	return true;
+	if (*same_page)
+		return true;
+	return (bv->bv_page + bv_end / PAGE_SIZE) == (page + off / PAGE_SIZE);
 }
 
 static bool bio_try_merge_pc_page(struct request_queue *q, struct bio *bio,
-- 
2.25.1



