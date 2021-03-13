Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61CA6339BE4
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 06:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhCMFHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 00:07:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:41830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231383AbhCMFHi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Mar 2021 00:07:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCE0564F8F;
        Sat, 13 Mar 2021 05:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615612058;
        bh=1xtT7t78qCwdLMG7y+oZc57boXEC044DLpWX8MhTK+4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0Njt4SepH/A9hR6DIzwUrtRz/Z5vWuXfOXenus1f0huSeAUKu1C3EwYd/voXu0roV
         jEJILq2nNOnBZoU7fW/XoFobECjPaV02H3oG220ARdw1SQYQaf8RlVC1Izk7x419m6
         yugi4FdpbeT/Y71O81sbAe7INqVpcOkccMwQWCvA=
Date:   Fri, 12 Mar 2021 21:07:37 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hirofumi@mail.parknet.co.jp,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 11/29] mm/highmem.c: fix zero_user_segments() with
 start > end
Message-ID: <20210313050737.mOQhR0vUf%akpm@linux-foundation.org>
In-Reply-To: <20210312210632.9b7d62973d72a56fb13c7a03@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: mm/highmem.c: fix zero_user_segments() with start > end

zero_user_segments() is used from __block_write_begin_int(), for example
like the following

	zero_user_segments(page, 4096, 1024, 512, 918)

But new the zero_user_segments() implementation for for HIGHMEM +
TRANSPARENT_HUGEPAGE doesn't handle "start > end" case correctly, and hits
BUG_ON().  (we can fix __block_write_begin_int() instead though, it is the
old and multiple usage)

Also it calls kmap_atomic() unnecessarily while start == end == 0.

Link: https://lkml.kernel.org/r/87v9ab60r4.fsf@mail.parknet.co.jp
Fixes: 0060ef3b4e6d ("mm: support THPs in zero_user_segments")
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/mm/highmem.c~fix-zero_user_segments-with-start-end
+++ a/mm/highmem.c
@@ -368,20 +368,24 @@ void zero_user_segments(struct page *pag
 
 	BUG_ON(end1 > page_size(page) || end2 > page_size(page));
 
+	if (start1 >= end1)
+		start1 = end1 = 0;
+	if (start2 >= end2)
+		start2 = end2 = 0;
+
 	for (i = 0; i < compound_nr(page); i++) {
 		void *kaddr = NULL;
 
-		if (start1 < PAGE_SIZE || start2 < PAGE_SIZE)
-			kaddr = kmap_atomic(page + i);
-
 		if (start1 >= PAGE_SIZE) {
 			start1 -= PAGE_SIZE;
 			end1 -= PAGE_SIZE;
 		} else {
 			unsigned this_end = min_t(unsigned, end1, PAGE_SIZE);
 
-			if (end1 > start1)
+			if (end1 > start1) {
+				kaddr = kmap_atomic(page + i);
 				memset(kaddr + start1, 0, this_end - start1);
+			}
 			end1 -= this_end;
 			start1 = 0;
 		}
@@ -392,8 +396,11 @@ void zero_user_segments(struct page *pag
 		} else {
 			unsigned this_end = min_t(unsigned, end2, PAGE_SIZE);
 
-			if (end2 > start2)
+			if (end2 > start2) {
+				if (!kaddr)
+					kaddr = kmap_atomic(page + i);
 				memset(kaddr + start2, 0, this_end - start2);
+			}
 			end2 -= this_end;
 			start2 = 0;
 		}
_
