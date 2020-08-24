Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023EE25074C
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 20:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgHXSUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 14:20:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726222AbgHXSUR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 14:20:17 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAAE32075B;
        Mon, 24 Aug 2020 18:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598293217;
        bh=OSXKoI6LDeVPNLUEtQxzfzEUNUUItbErF83ADlweXiI=;
        h=Date:From:To:Subject:From;
        b=JDxyGoT+Hoa5FJm/M0vL3+hcb5oTHViB12wsNqLfr3W5nmPLYD2O9+kh+uU36qbKX
         MHOvjf7gGQWSkOeBlLg47bbf5sQqy4kQg9U+QrOIeWZr/wR63mmJSsXNJLADEjHboh
         xyNu0C9K2qBF1nv+iLpGCDyrzKqPROFUlVbmUNJo=
Date:   Mon, 24 Aug 2020 11:20:16 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, dongli.zhang@oracle.com, erosca@de.adit-jv.com,
        iamjoonsoo.kim@lge.com, joe.jin@oracle.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, stable@vger.kernel.org
Subject:  [to-be-updated]
 mm-slub-fix-conversion-of-freelist_corrupted.patch removed from -mm tree
Message-ID: <20200824182016.B7zEM5YU0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: slub: fix conversion of freelist_corrupted()
has been removed from the -mm tree.  Its filename was
     mm-slub-fix-conversion-of-freelist_corrupted.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Eugeniu Rosca <erosca@de.adit-jv.com>
Subject: mm: slub: fix conversion of freelist_corrupted()

Commit 52f23478081ae0 ("mm/slub.c: fix corrupted freechain in
deactivate_slab()") suffered an update when picked up from LKML [1].

Specifically, relocating 'freelist = NULL' into 'freelist_corrupted()'
created a no-op statement.  Fix it by sticking to the behavior intended in
the original patch [1].  Prefer the lowest-line-count solution.

The issue popped up as a result of static analysis and code review. 
Therefore, I lack any specific runtime behavior example being fixed.

[1] https://lore.kernel.org/linux-mm/20200331031450.12182-1-dongli.zhang@oracle.com/

Link: http://lkml.kernel.org/r/20200811124656.10308-1-erosca@de.adit-jv.com
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

 mm/slub.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/slub.c~mm-slub-fix-conversion-of-freelist_corrupted
+++ a/mm/slub.c
@@ -677,7 +677,6 @@ static bool freelist_corrupted(struct km
 	if ((s->flags & SLAB_CONSISTENCY_CHECKS) &&
 	    !check_valid_pointer(s, page, nextfree)) {
 		object_err(s, page, freelist, "Freechain corrupt");
-		freelist = NULL;
 		slab_fix(s, "Isolate corrupted freechain");
 		return true;
 	}
@@ -2184,8 +2183,10 @@ static void deactivate_slab(struct kmem_
 		 * 'freelist' is already corrupted.  So isolate all objects
 		 * starting at 'freelist'.
 		 */
-		if (freelist_corrupted(s, page, freelist, nextfree))
+		if (freelist_corrupted(s, page, freelist, nextfree)) {
+			freelist = NULL;
 			break;
+		}
 
 		do {
 			prior = page->freelist;
_

Patches currently in -mm which might be from erosca@de.adit-jv.com are


