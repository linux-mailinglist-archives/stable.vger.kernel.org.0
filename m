Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2445FE06
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 23:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbfGDVFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 17:05:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726871AbfGDVFK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Jul 2019 17:05:10 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71AED2083B;
        Thu,  4 Jul 2019 21:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562274309;
        bh=yu9B0AzDgVeiLYNOAZZc6ZaS+PcFrgOU2zr4iWz1H6g=;
        h=Date:From:To:Subject:From;
        b=UlLrJzzfWfwV0JlhCu3Rk1IbAeQKF0UIZf4udrAnR0RrA1vOp4xW36nCRPc8tQOt8
         irRQDC6eaf3tKf12CUGLrWmXwyPTxQK+p2k3hvf/hUf8SXxbiPWboqsdl2NbvYDa3e
         NH5Hqz3NvOzVk5B0HOYIqtq/NTZr9xGxfght84Mc=
Date:   Thu, 04 Jul 2019 14:05:09 -0700
From:   akpm@linux-foundation.org
To:     henryburns@google.com, jwadams@google.com,
        mm-commits@vger.kernel.org, rientjes@google.com,
        rppt@linux.vnet.ibm.com, shakeelb@google.com,
        stable@vger.kernel.org, vitaly.vul@sony.com, vitalywool@gmail.com,
        wangxidong_97@163.com
Subject:  [to-be-updated]
 mm-z3foldc-lock-z3fold-page-before-__setpagemovable.patch removed from -mm
 tree
Message-ID: <20190704210509.4eWMdJyL7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/z3fold.c: lock z3fold page before __SetPageMovable()
has been removed from the -mm tree.  Its filename was
     mm-z3foldc-lock-z3fold-page-before-__setpagemovable.patch

This patch was dropped because an updated version will be merged

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

