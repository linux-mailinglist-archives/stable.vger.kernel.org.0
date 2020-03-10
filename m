Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1FD817FEB1
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgCJMlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:41:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727111AbgCJMlt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:41:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD36924691;
        Tue, 10 Mar 2020 12:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844108;
        bh=B5ZE7AgNmdSiNTWO1RE0tumqqZ5Z6rnGJgHazaelaaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UefQvhVbh6dXE66/1QSUsyEXWjiOnatA5nSQpJdwsEla3EEDdc+aT0/7QPrrdXcUW
         9uECqS5d+kNA8V79/dpP7hyanSRbw76rxkalFuc2Z0wRaz24J1FuIncD3TcoMALF7e
         GbI1hSRNTfQY0W/xOqwMD88CpQYek8ZyKJtCqIec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Jann Horn <jannh@google.com>, stable@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>,
        Ajay Kaher <akaher@vmware.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 4.4 33/72] mm: add try_get_page() helper function
Date:   Tue, 10 Mar 2020 13:38:46 +0100
Message-Id: <20200310123609.462100804@linuxfoundation.org>
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

commit 88b1a17dfc3ed7728316478fae0f5ad508f50397 upsteam.

This is the same as the traditional 'get_page()' function, but instead
of unconditionally incrementing the reference count of the page, it only
does so if the count was "safe".  It returns whether the reference count
was incremented (and is marked __must_check, since the caller obviously
has to be aware of it).

Also like 'get_page()', you can't use this function unless you already
had a reference to the page.  The intent is that you can use this
exactly like get_page(), but in situations where you want to limit the
maximum reference count.

The code currently does an unconditional WARN_ON_ONCE() if we ever hit
the reference count issues (either zero or negative), as a notification
that the conditional non-increment actually happened.

NOTE! The count access for the "safety" check is inherently racy, but
that doesn't matter since the buffer we use is basically half the range
of the reference count (ie we look at the sign of the count).

Acked-by: Matthew Wilcox <willy@infradead.org>
Cc: Jann Horn <jannh@google.com>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ 4.4.y backport notes:
  Srivatsa:
  - Adapted try_get_page() to match the get_page()
    implementation in 4.4.y, except for the refcount check.
  - Added try_get_page_foll() which will be needed
    in a subsequent patch. ]
Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
Signed-off-by: Ajay Kaher <akaher@vmware.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mm.h |   12 ++++++++++++
 mm/internal.h      |   23 +++++++++++++++++++++++
 2 files changed, 35 insertions(+)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -505,6 +505,18 @@ static inline void get_page(struct page
 	atomic_inc(&page->_count);
 }
 
+static inline __must_check bool try_get_page(struct page *page)
+{
+	if (unlikely(PageTail(page)))
+		if (likely(__get_page_tail(page)))
+			return true;
+
+	if (WARN_ON_ONCE(atomic_read(&page->_count) <= 0))
+		return false;
+	atomic_inc(&page->_count);
+	return true;
+}
+
 static inline struct page *virt_to_head_page(const void *x)
 {
 	struct page *page = virt_to_page(x);
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -112,6 +112,29 @@ static inline void get_page_foll(struct
 	}
 }
 
+static inline __must_check bool try_get_page_foll(struct page *page)
+{
+	if (unlikely(PageTail(page))) {
+		if (WARN_ON_ONCE(atomic_read(&compound_head(page)->_count) <= 0))
+			return false;
+		/*
+		 * This is safe only because
+		 * __split_huge_page_refcount() can't run under
+		 * get_page_foll() because we hold the proper PT lock.
+		 */
+		__get_page_tail_foll(page, true);
+	} else {
+		/*
+		 * Getting a normal page or the head of a compound page
+		 * requires to already have an elevated page->_count.
+		 */
+		if (WARN_ON_ONCE(atomic_read(&page->_count) <= 0))
+			return false;
+		atomic_inc(&page->_count);
+	}
+	return true;
+}
+
 extern unsigned long highest_memmap_pfn;
 
 /*


