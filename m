Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1987417F7BA
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgCJMlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:41:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgCJMlq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:41:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 699BA24698;
        Tue, 10 Mar 2020 12:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844105;
        bh=TtPVw9B+lbDiUyUsy+nb7x90oko5644fx7SkOVULfOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J0ClrTZAUxshiQ372AdQL7+0odpxmKC8jRcx7JkaUFSno+rQmsg8VMGTp+4KizgMH
         9W6FmYln7UGjqnKidOZ58pu/f/Au7Wx4nrPl/lE8G6CUTiTph94QqOP+Bh5iOBCfnl
         TJmpFi7H8tKoL3/ia2WeytQTA2QsHNH6kdFUGjKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Jann Horn <jannh@google.com>, stable@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>,
        Ajay Kaher <akaher@vmware.com>
Subject: [PATCH 4.4 32/72] mm: make page ref count overflow check tighter and more explicit
Date:   Tue, 10 Mar 2020 13:38:45 +0100
Message-Id: <20200310123609.246382874@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123601.053680753@linuxfoundation.org>
References: <20200310123601.053680753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit f958d7b528b1b40c44cfda5eabe2d82760d868c3 upsteam.

We have a VM_BUG_ON() to check that the page reference count doesn't
underflow (or get close to overflow) by checking the sign of the count.

That's all fine, but we actually want to allow people to use a "get page
ref unless it's already very high" helper function, and we want that one
to use the sign of the page ref (without triggering this VM_BUG_ON).

Change the VM_BUG_ON to only check for small underflows (or _very_ close
to overflowing), and ignore overflows which have strayed into negative
territory.

Acked-by: Matthew Wilcox <willy@infradead.org>
Cc: Jann Horn <jannh@google.com>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ 4.4.y backport notes:
  Ajay: Open-coded atomic refcount access due to missing
  page_ref_count() helper in 4.4.y
  Srivatsa: Added overflow check to get_page_foll() and related code. ]
Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
Signed-off-by: Ajay Kaher <akaher@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mm.h |    6 +++++-
 mm/internal.h      |    5 +++--
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -488,6 +488,10 @@ static inline void get_huge_page_tail(st
 
 extern bool __get_page_tail(struct page *page);
 
+/* 127: arbitrary random number, small enough to assemble well */
+#define page_ref_zero_or_close_to_overflow(page) \
+	((unsigned int) atomic_read(&page->_count) + 127u <= 127u)
+
 static inline void get_page(struct page *page)
 {
 	if (unlikely(PageTail(page)))
@@ -497,7 +501,7 @@ static inline void get_page(struct page
 	 * Getting a normal page or the head of a compound page
 	 * requires to already have an elevated page->_count.
 	 */
-	VM_BUG_ON_PAGE(atomic_read(&page->_count) <= 0, page);
+	VM_BUG_ON_PAGE(page_ref_zero_or_close_to_overflow(page), page);
 	atomic_inc(&page->_count);
 }
 
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -81,7 +81,8 @@ static inline void __get_page_tail_foll(
 	 * speculative page access (like in
 	 * page_cache_get_speculative()) on tail pages.
 	 */
-	VM_BUG_ON_PAGE(atomic_read(&compound_head(page)->_count) <= 0, page);
+	VM_BUG_ON_PAGE(page_ref_zero_or_close_to_overflow(compound_head(page)),
+		       page);
 	if (get_page_head)
 		atomic_inc(&compound_head(page)->_count);
 	get_huge_page_tail(page);
@@ -106,7 +107,7 @@ static inline void get_page_foll(struct
 		 * Getting a normal page or the head of a compound page
 		 * requires to already have an elevated page->_count.
 		 */
-		VM_BUG_ON_PAGE(atomic_read(&page->_count) <= 0, page);
+		VM_BUG_ON_PAGE(page_ref_zero_or_close_to_overflow(page), page);
 		atomic_inc(&page->_count);
 	}
 }


