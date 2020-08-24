Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C43324FE89
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 15:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbgHXNHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 09:07:17 -0400
Received: from smtp1.de.adit-jv.com ([93.241.18.167]:43639 "EHLO
        smtp1.de.adit-jv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbgHXNHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 09:07:17 -0400
Received: from localhost (smtp1.de.adit-jv.com [127.0.0.1])
        by smtp1.de.adit-jv.com (Postfix) with ESMTP id A30383C0579;
        Mon, 24 Aug 2020 15:07:13 +0200 (CEST)
Received: from smtp1.de.adit-jv.com ([127.0.0.1])
        by localhost (smtp1.de.adit-jv.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rS9E865DscdH; Mon, 24 Aug 2020 15:07:08 +0200 (CEST)
Received: from HI2EXCH01.adit-jv.com (hi2exch01.adit-jv.com [10.72.92.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp1.de.adit-jv.com (Postfix) with ESMTPS id 920423C0016;
        Mon, 24 Aug 2020 15:07:08 +0200 (CEST)
Received: from lxhi-065.adit-jv.com (10.72.94.3) by HI2EXCH01.adit-jv.com
 (10.72.92.24) with Microsoft SMTP Server (TLS) id 14.3.487.0; Mon, 24 Aug
 2020 15:07:08 +0200
From:   Eugeniu Rosca <erosca@de.adit-jv.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Dongli Zhang <dongli.zhang@oracle.com>
CC:     Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, <linux-mm@kvack.org>,
        <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>
Subject: [PATCH v2] mm: slub: fix conversion of freelist_corrupted()
Date:   Mon, 24 Aug 2020 15:06:43 +0200
Message-ID: <20200824130643.10291-1-erosca@de.adit-jv.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.72.94.3]
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 52f23478081ae0 ("mm/slub.c: fix corrupted freechain in
deactivate_slab()") suffered an update when picked up from LKML [1].

Specifically, relocating 'freelist = NULL' into 'freelist_corrupted()'
created a no-op statement. Fix it by sticking to the behavior intended
in the original patch [1]. In addition, make freelist_corrupted()
immune to passing NULL instead of &freelist.

The issue has been spotted via static analysis and code review.

[1] https://lore.kernel.org/linux-mm/20200331031450.12182-1-dongli.zhang@oracle.com/

Fixes: 52f23478081ae0 ("mm/slub.c: fix corrupted freechain in deactivate_slab()")
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dongli Zhang <dongli.zhang@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
---

v2:
 - Address the review finding from Dongli Zhang in:
   https://lore.kernel.org/linux-mm/f93a9f06-8608-6f28-27c0-b17f86dca55b@oracle.com/

   -------8<-------
   This is good to me.
   However, this would confuse people when CONFIG_SLUB_DEBUG is not defined.
   While reading the source code, people may be curious why to reset freelist when
   CONFIG_SLUB_DEBUG is even not defined.
   -------8<-------

v1:
 - https://lore.kernel.org/linux-mm/20200811124656.10308-1-erosca@de.adit-jv.com/

 mm/slub.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 68c02b2eecd9..d4177aecedf6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -672,12 +672,12 @@ static void slab_fix(struct kmem_cache *s, char *fmt, ...)
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
@@ -1494,7 +1494,7 @@ static inline void dec_slabs_node(struct kmem_cache *s, int node,
 							int objects) {}
 
 static bool freelist_corrupted(struct kmem_cache *s, struct page *page,
-			       void *freelist, void *nextfree)
+			       void **freelist, void *nextfree)
 {
 	return false;
 }
@@ -2184,7 +2184,7 @@ static void deactivate_slab(struct kmem_cache *s, struct page *page,
 		 * 'freelist' is already corrupted.  So isolate all objects
 		 * starting at 'freelist'.
 		 */
-		if (freelist_corrupted(s, page, freelist, nextfree))
+		if (freelist_corrupted(s, page, &freelist, nextfree))
 			break;
 
 		do {
-- 
2.28.0

