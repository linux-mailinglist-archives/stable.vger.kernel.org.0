Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23F945FE07
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 23:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfGDVGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 17:06:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726871AbfGDVGm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Jul 2019 17:06:42 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6DEA2083B;
        Thu,  4 Jul 2019 21:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562274401;
        bh=o+N3CI7KJOBDO+1n4wgvw863hZvmW0KJ9xJo98wVkk8=;
        h=Date:From:To:Subject:From;
        b=dxrY0JZkcUGnCsMNhy0Mdtqth6fEsWfokwRmV4JpgOjL3n2Zd3oGQXmd85jvu80XK
         WwQS7QbWQ/vzgQ/cDVG6miyNfil5Vms7OBdItif6mqMyZQxsnEPtDVO4XYw6SqTFuj
         1VGNJbzWYPcHr0HhM3EQQXiLRD5gJrfFlx0G8fWw=
Date:   Thu, 04 Jul 2019 14:06:40 -0700
From:   akpm@linux-foundation.org
To:     henryburns@google.com, jwadams@google.com,
        mm-commits@vger.kernel.org, rientjes@google.com,
        rppt@linux.vnet.ibm.com, shakeelb@google.com,
        stable@vger.kernel.org, vitaly.vul@sony.com, vitalywool@gmail.com,
        wangxidong_97@163.com
Subject:  +
 mm-z3foldc-lock-z3fold-page-before-__setpagemovable.patch added to -mm tree
Message-ID: <20190704210640._1tth6_R-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/z3fold.c: lock z3fold page before  __SetPageMovable()
has been added to the -mm tree.  Its filename is
     mm-z3foldc-lock-z3fold-page-before-__setpagemovable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-z3foldc-lock-z3fold-page-before-__setpagemovable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-z3foldc-lock-z3fold-page-before-__setpagemovable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Henry Burns <henryburns@google.com>
Subject: mm/z3fold.c: lock z3fold page before  __SetPageMovable()

Following zsmalloc.c's example we call trylock_page() and unlock_page().
Also make z3fold_page_migrate() assert that newpage is passed in locked,
as per the documentation.

Link: http://lkml.kernel.org/r/20190702005122.41036-1-henryburns@google.com
Link: http://lkml.kernel.org/r/20190702233538.52793-1-henryburns@google.com
Signed-off-by: Henry Burns <henryburns@google.com>
Suggested-by: Vitaly Wool <vitalywool@gmail.com>
Acked-by: Vitaly Wool <vitalywool@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vitaly Vul <vitaly.vul@sony.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Xidong Wang <wangxidong_97@163.com>
Cc: Jonathan Adams <jwadams@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/z3fold.c~mm-z3foldc-lock-z3fold-page-before-__setpagemovable
+++ a/mm/z3fold.c
@@ -924,7 +924,16 @@ retry:
 		set_bit(PAGE_HEADLESS, &page->private);
 		goto headless;
 	}
-	__SetPageMovable(page, pool->inode->i_mapping);
+	if (can_sleep) {
+		lock_page(page);
+		__SetPageMovable(page, pool->inode->i_mapping);
+		unlock_page(page);
+	} else {
+		if (!trylock_page(page)) {
+			__SetPageMovable(page, pool->inode->i_mapping);
+			unlock_page(page);
+		}
+	}
 	z3fold_page_lock(zhdr);
 
 found:
@@ -1331,6 +1340,7 @@ static int z3fold_page_migrate(struct ad
 
 	VM_BUG_ON_PAGE(!PageMovable(page), page);
 	VM_BUG_ON_PAGE(!PageIsolated(page), page);
+	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
 
 	zhdr = page_address(page);
 	pool = zhdr_to_pool(zhdr);
_

Patches currently in -mm which might be from henryburns@google.com are

mm-z3foldc-lock-z3fold-page-before-__setpagemovable.patch
mm-z3fold-fix-z3fold_buddy_slots-use-after-free.patch

