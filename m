Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD7B55D9F0
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 02:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbfGCA6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 20:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727066AbfGCA6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 20:58:05 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDA26218BC;
        Tue,  2 Jul 2019 21:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562102415;
        bh=wk2coQWrWL1yM28XO9ORJlu6TQV5gKfIcIJ1NbIXuGw=;
        h=Date:From:To:Subject:From;
        b=k0K13oFOgrFlsXH9Ly9U7ZlG0a8U9n7c91S1uUC5m2FNHipEWJFGYS88vRxeSmmcT
         UGqWW0UDqVLXzf40IkoPt8Z98E4HeoK86kBQQFvRg7GeaotqZT9roRczwxF2k2a890
         5jLfSg2+/H08s7VzOC3e6Vb9GU1ccxuNwBZvHkfc=
Date:   Tue, 02 Jul 2019 14:20:12 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wangxidong_97@163.com,
        vitalywool@gmail.com, vitaly.vul@sony.com, stable@vger.kernel.org,
        shakeelb@google.com, rppt@linux.vnet.ibm.com, rientjes@google.com,
        jwadams@google.com, henryburns@google.com
Subject:  + mm-z3foldc-lock-z3fold-page-before-__setpagemovable.patch
 added to -mm tree
Message-ID: <20190702212012.WPPnc%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/z3fold.c: lock z3fold page before __SetPageMovable()
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
Subject: mm/z3fold.c: lock z3fold page before __SetPageMovable()

__SetPageMovable() expects its page to be locked, but z3fold.c doesn't
lock the page.  This triggers the VM_BUG_ON_PAGE(!PageLocked(page), page)
in __SetPageMovable().

Following zsmalloc.c's example we call trylock_page() and unlock_page(). 
Also make z3fold_page_migrate() assert that newpage is passed in locked,
as per the documentation.

Link: http://lkml.kernel.org/r/20190702005122.41036-1-henryburns@google.com
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

 mm/z3fold.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/z3fold.c~mm-z3foldc-lock-z3fold-page-before-__setpagemovable
+++ a/mm/z3fold.c
@@ -919,7 +919,10 @@ retry:
 		set_bit(PAGE_HEADLESS, &page->private);
 		goto headless;
 	}
-	__SetPageMovable(page, pool->inode->i_mapping);
+	if (!WARN_ON(!trylock_page(page))) {
+		__SetPageMovable(page, pool->inode->i_mapping);
+		unlock_page(page);
+	}
 	z3fold_page_lock(zhdr);
 
 found:
@@ -1326,6 +1329,7 @@ static int z3fold_page_migrate(struct ad
 
 	VM_BUG_ON_PAGE(!PageMovable(page), page);
 	VM_BUG_ON_PAGE(!PageIsolated(page), page);
+	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
 
 	zhdr = page_address(page);
 	pool = zhdr_to_pool(zhdr);
_

Patches currently in -mm which might be from henryburns@google.com are

mm-z3fold-fix-z3fold_buddy_slots-use-after-free.patch
mm-z3foldc-lock-z3fold-page-before-__setpagemovable.patch

