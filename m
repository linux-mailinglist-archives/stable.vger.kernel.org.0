Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEA425E43A
	for <lists+stable@lfdr.de>; Sat,  5 Sep 2020 01:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgIDXfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 19:35:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgIDXfb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 19:35:31 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9F8620FC3;
        Fri,  4 Sep 2020 23:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599262531;
        bh=ImmSXwO0sJ2R2+sPRnb0B1ILO2z0q4evWpw/pElgZ0I=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=I8QicgUy0fedNWi7qQHYjuYF7rvQn+a6MQCdCobc2OCUa5FIqDNxxOFQSO9M7WBEo
         91UOJQXtzmCLYUPF86DXq/dEWvYbYyZ5nt0aqc0kBLtYHl6+BPzesAGfrm+PxpCsit
         cBZax/HrUEFHB5RAWdJlds7mZv/8lvRIZo0szeJ8=
Date:   Fri, 04 Sep 2020 16:35:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, dongli.zhang@oracle.com,
        erosca@de.adit-jv.com, iamjoonsoo.kim@lge.com, joe.jin@oracle.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 03/19] mm: slub: fix conversion of
 freelist_corrupted()
Message-ID: <20200904233530.zhlwFqhIl%akpm@linux-foundation.org>
In-Reply-To: <20200904163454.4db0e6ce0c4584d2653678a3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugeniu Rosca <erosca@de.adit-jv.com>
Subject: mm: slub: fix conversion of freelist_corrupted()

Commit 52f23478081ae0 ("mm/slub.c: fix corrupted freechain in
deactivate_slab()") suffered an update when picked up from LKML [1].

Specifically, relocating 'freelist = NULL' into 'freelist_corrupted()'
created a no-op statement.  Fix it by sticking to the behavior intended in
the original patch [1].  In addition, make freelist_corrupted() immune to
passing NULL instead of &freelist.

The issue has been spotted via static analysis and code review.

[1] https://lore.kernel.org/linux-mm/20200331031450.12182-1-dongli.zhang@oracle.com/

Link: https://lkml.kernel.org/r/20200824130643.10291-1-erosca@de.adit-jv.com
Fixes: 52f23478081ae0 ("mm/slub.c: fix corrupted freechain in deactivate_slab()")
Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Cc: Dongli Zhang <dongli.zhang@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/slub.c~mm-slub-fix-conversion-of-freelist_corrupted
+++ a/mm/slub.c
@@ -672,12 +672,12 @@ static void slab_fix(struct kmem_cache *
 }
 
 static bool freelist_corrupted(struct kmem_cache *s, struct page *page,
-			       void *freelist, void *nextfree)
+			       void **freelist, void *nextfree)
 {
 	if ((s->flags & SLAB_CONSISTENCY_CHECKS) &&
-	    !check_valid_pointer(s, page, nextfree)) {
-		object_err(s, page, freelist, "Freechain corrupt");
-		freelist = NULL;
+	    !check_valid_pointer(s, page, nextfree) && freelist) {
+		object_err(s, page, *freelist, "Freechain corrupt");
+		*freelist = NULL;
 		slab_fix(s, "Isolate corrupted freechain");
 		return true;
 	}
@@ -1494,7 +1494,7 @@ static inline void dec_slabs_node(struct
 							int objects) {}
 
 static bool freelist_corrupted(struct kmem_cache *s, struct page *page,
-			       void *freelist, void *nextfree)
+			       void **freelist, void *nextfree)
 {
 	return false;
 }
@@ -2184,7 +2184,7 @@ static void deactivate_slab(struct kmem_
 		 * 'freelist' is already corrupted.  So isolate all objects
 		 * starting at 'freelist'.
 		 */
-		if (freelist_corrupted(s, page, freelist, nextfree))
+		if (freelist_corrupted(s, page, &freelist, nextfree))
 			break;
 
 		do {
_
