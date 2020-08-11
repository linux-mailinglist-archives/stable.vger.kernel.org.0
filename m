Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07102242162
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 22:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgHKUtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 16:49:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:35216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726114AbgHKUte (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Aug 2020 16:49:34 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A39CF20756;
        Tue, 11 Aug 2020 20:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597178974;
        bh=1YJVJAslRkQGqc29rsD0qf7TOzk0H9zufBKwZBIywos=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gUFUkqNWzcHoam6PvnljeCPbzsJnVYsN+OVxibPFjc8NkTmXUS4MSkpQPE3FxChqR
         fp761Z7ZU1xDId2r1sDZ0oQZjZGxknfz9GlKu4e+JTIdvl2OAvxt2fF5dzMz8jyRWO
         Mlfr0KNW6xwsZkwV24i7Fls1BxeBfx8T5YrZjUN8=
Date:   Tue, 11 Aug 2020 13:49:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     cl@linux.com, dongli.zhang@oracle.com, erosca@de.adit-jv.com,
        iamjoonsoo.kim@lge.com, joe.jin@oracle.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, stable@vger.kernel.org
Subject:  + mm-slub-fix-conversion-of-freelist_corrupted.patch
 added to -mm tree
Message-ID: <20200811204933.HCUm2YkCp%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
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
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-fix-conversion-of-freelist_corrupted.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-fix-conversion-of-freelist_corrupted.patch

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
the original patch [1].  Prefer the lowest-line-count solution.

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

mm-slub-fix-conversion-of-freelist_corrupted.patch

