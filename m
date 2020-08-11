Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF71241B27
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 14:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgHKMrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 08:47:21 -0400
Received: from smtp1.de.adit-jv.com ([93.241.18.167]:42046 "EHLO
        smtp1.de.adit-jv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726966AbgHKMrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 08:47:21 -0400
Received: from localhost (smtp1.de.adit-jv.com [127.0.0.1])
        by smtp1.de.adit-jv.com (Postfix) with ESMTP id B549F3C0579;
        Tue, 11 Aug 2020 14:47:18 +0200 (CEST)
Received: from smtp1.de.adit-jv.com ([127.0.0.1])
        by localhost (smtp1.de.adit-jv.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id BXIy4wo0d5QG; Tue, 11 Aug 2020 14:47:13 +0200 (CEST)
Received: from HI2EXCH01.adit-jv.com (hi2exch01.adit-jv.com [10.72.92.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp1.de.adit-jv.com (Postfix) with ESMTPS id 01C963C009D;
        Tue, 11 Aug 2020 14:47:09 +0200 (CEST)
Received: from lxhi-065.adit-jv.com (10.72.94.12) by HI2EXCH01.adit-jv.com
 (10.72.92.24) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 11 Aug
 2020 14:47:08 +0200
From:   Eugeniu Rosca <erosca@de.adit-jv.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Dongli Zhang <dongli.zhang@oracle.com>
CC:     <linux-mm@kvack.org>, <stable@vger.kernel.org>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>
Subject: [PATCH] mm: slub: fix conversion of freelist_corrupted()
Date:   Tue, 11 Aug 2020 14:46:56 +0200
Message-ID: <20200811124656.10308-1-erosca@de.adit-jv.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.72.94.12]
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 52f23478081ae0 ("mm/slub.c: fix corrupted freechain in
deactivate_slab()") suffered an update when picked up from LKML [1].

Specifically, relocating 'freelist = NULL' into 'freelist_corrupted()'
created a no-op statement. Fix it by sticking to the behavior intended
in the original patch [1]. Prefer the lowest-line-count solution.

[1] https://lore.kernel.org/linux-mm/20200331031450.12182-1-dongli.zhang@oracle.com/

Fixes: 52f23478081ae0 ("mm/slub.c: fix corrupted freechain in deactivate_slab()")
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dongli Zhang <dongli.zhang@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
---
 mm/slub.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 68c02b2eecd9..9a3e963b02a3 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -677,7 +677,6 @@ static bool freelist_corrupted(struct kmem_cache *s, struct page *page,
 	if ((s->flags & SLAB_CONSISTENCY_CHECKS) &&
 	    !check_valid_pointer(s, page, nextfree)) {
 		object_err(s, page, freelist, "Freechain corrupt");
-		freelist = NULL;
 		slab_fix(s, "Isolate corrupted freechain");
 		return true;
 	}
@@ -2184,8 +2183,10 @@ static void deactivate_slab(struct kmem_cache *s, struct page *page,
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
-- 
2.28.0

