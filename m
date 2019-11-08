Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A52C6F438D
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 10:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731430AbfKHJi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 04:38:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:39630 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730622AbfKHJi0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 04:38:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 56815AC67;
        Fri,  8 Nov 2019 09:38:24 +0000 (UTC)
From:   Vlastimil Babka <vbabka@suse.cz>
To:     stable@vger.kernel.org
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Ajay Kaher <akaher@vmware.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jann Horn <jannh@google.com>, stable@kernel.org,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH STABLE 4.4 4/8] mm: add 'try_get_page()' helper function
Date:   Fri,  8 Nov 2019 10:38:10 +0100
Message-Id: <20191108093814.16032-5-vbabka@suse.cz>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191108093814.16032-1-vbabka@suse.cz>
References: <20191108093814.16032-1-vbabka@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 88b1a17dfc3ed7728316478fae0f5ad508f50397 upstream.

[ 4.4 backport: get_page() is more complicated due to special handling
  of tail pages via __get_page_tail(). But in all cases, eventually the
  compound head page's refcount is incremented. So try_get_page() just
  checks compound head's refcount for overflow and then simply calls
  get_page().								 ]

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
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/mm.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 997edfcb0a30..78358aeb7732 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -510,6 +510,21 @@ static inline void get_page(struct page *page)
 	atomic_inc(&page->_count);
 }
 
+static inline __must_check bool try_get_page(struct page *page)
+{
+	struct page *head = compound_head(page);
+
+	/*
+	 * get_page() increases always head page's refcount, either directly or
+	 * via __get_page_tail() for tail page, so we check that
+	 */
+	if (WARN_ON_ONCE(page_ref_count(head) <= 0))
+		return false;
+
+	get_page(page);
+	return true;
+}
+
 static inline struct page *virt_to_head_page(const void *x)
 {
 	struct page *page = virt_to_page(x);
-- 
2.23.0

