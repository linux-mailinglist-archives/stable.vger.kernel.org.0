Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65BA33BC7D
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbhCOOZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:25:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232682AbhCOOYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:24:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6224B6506D;
        Mon, 15 Mar 2021 14:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615818291;
        bh=qlgasr3+ZRpAg9iQcYqf+dX55vEfBbKD0Qm7BuwN1TI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B49mjBUJguCHsNOewLCrKgJNHP4g9IrY63bYBspU/poJSPNs+ugOkxc4HQx1C9D1f
         EVjviIy514qLBOcMbEps2xC8e3LJthrjgxrwI9Zqdp+oKpmo81fZ3APM10oPbM6HAo
         q1KzbfL4fc5wGTlm7WhlASAuciTf7Yqa3YjKnMqI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.11 300/306] mm/highmem.c: fix zero_user_segments() with start > end
Date:   Mon, 15 Mar 2021 15:24:25 +0100
Message-Id: <20210315135517.847546877@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135517.556638562@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
 <20210315135517.556638562@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

commit 184cee516f3e24019a08ac8eb5c7cf04c00933cb upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/highmem.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/mm/highmem.c
+++ b/mm/highmem.c
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


