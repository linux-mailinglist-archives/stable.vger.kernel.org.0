Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5593B250755
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 20:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgHXSVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 14:21:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726222AbgHXSVw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 14:21:52 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B11D020738;
        Mon, 24 Aug 2020 18:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598293312;
        bh=vXJYke6oBVEuvvguTiQWNS/NAOVzyH/H4wbRBkEatZY=;
        h=Date:From:To:Subject:From;
        b=gcll2O0HL6BJaG+0joJ5BHn6e2m2ta64v0L6EI1SZV8zQDfi5HrsDOH3jHLCYC5+G
         AeGGTT5KUo5+YkzBG4cfDuYIO4RFjKQEew1KJlEl9sEKcyC9YmsVPtQnc6s0/KyFbW
         ZSrCqyyyA5Qs2z6gq+BTyi12W8V6d18JO9rJoaoU=
Date:   Mon, 24 Aug 2020 11:21:51 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, dongli.zhang@oracle.com, erosca@de.adit-jv.com,
        iamjoonsoo.kim@lge.com, joe.jin@oracle.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, stable@vger.kernel.org
Subject:  + mm-slub-fix-conversion-of-freelist_corrupted.patch
 added to -mm tree
Message-ID: <20200824182151.Ugg3eyuAJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: slub: fix conversion of freelist_corrupted()
has been added to the -mm tree.  Its filename is
     mm-slub-fix-conversion-of-freelist_corrupted.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-fix-conversion-of-freelist_corrupted.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-fix-conversion-of-freelist_corrupted.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from erosca@de.adit-jv.com are

mm-slub-fix-conversion-of-freelist_corrupted.patch

