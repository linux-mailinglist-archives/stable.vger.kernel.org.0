Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D1E266186
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 16:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbgIKOvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 10:51:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgIKNCU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 09:02:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EB1622243;
        Fri, 11 Sep 2020 12:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829052;
        bh=msF5bf0BUlSzBRo/Fv0SbhSCTalssUiDIJoh9XsA56g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GYhfyos27EKkXpSwhMU9liHyRCOpWrJBTHwILYEIP+fAkFnKn6mRWhjBd8kozw0cp
         3e3c1PzUncUJgTaXEDqnYLR7+Rx5Ncyy3xq+8prjrz4EYGqrRtfGNY4V+eM0Jum0kX
         qQfTzvBvDOMfwI3xj6NPtErGDGWhYspzc9BU2r00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eugeniu Rosca <erosca@de.adit-jv.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        Joe Jin <joe.jin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 48/71] mm: slub: fix conversion of freelist_corrupted()
Date:   Fri, 11 Sep 2020 14:46:32 +0200
Message-Id: <20200911122507.315341477@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122504.928931589@linuxfoundation.org>
References: <20200911122504.928931589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugeniu Rosca <erosca@de.adit-jv.com>

commit dc07a728d49cf025f5da2c31add438d839d076c0 upstream.

Commit 52f23478081ae0 ("mm/slub.c: fix corrupted freechain in
deactivate_slab()") suffered an update when picked up from LKML [1].

Specifically, relocating 'freelist = NULL' into 'freelist_corrupted()'
created a no-op statement.  Fix it by sticking to the behavior intended
in the original patch [1].  In addition, make freelist_corrupted()
immune to passing NULL instead of &freelist.

The issue has been spotted via static analysis and code review.

[1] https://lore.kernel.org/linux-mm/20200331031450.12182-1-dongli.zhang@oracle.com/

Fixes: 52f23478081ae0 ("mm/slub.c: fix corrupted freechain in deactivate_slab()")
Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Dongli Zhang <dongli.zhang@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20200824130643.10291-1-erosca@de.adit-jv.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/slub.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -625,12 +625,12 @@ static void slab_fix(struct kmem_cache *
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
@@ -1320,7 +1320,7 @@ static inline void dec_slabs_node(struct
 							int objects) {}
 
 static bool freelist_corrupted(struct kmem_cache *s, struct page *page,
-			       void *freelist, void *nextfree)
+			       void **freelist, void *nextfree)
 {
 	return false;
 }
@@ -2040,7 +2040,7 @@ static void deactivate_slab(struct kmem_
 		 * 'freelist' is already corrupted.  So isolate all objects
 		 * starting at 'freelist'.
 		 */
-		if (freelist_corrupted(s, page, freelist, nextfree))
+		if (freelist_corrupted(s, page, &freelist, nextfree))
 			break;
 
 		do {


