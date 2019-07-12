Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02A16675F8
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 22:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbfGLUgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 16:36:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727118AbfGLUgi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 16:36:38 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A71702146E;
        Fri, 12 Jul 2019 20:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562963798;
        bh=5WMszptJBwnHN36/61phnpjNGtxYJ/EdPNiTjC3TD34=;
        h=Date:From:To:Subject:From;
        b=gge4hIpAWqVM7JJir07AmumijiJeE7tM/g6YWwjlNz14Ls092hRxXt32p+hSOmat+
         x161a4Ju7stm2abk/PvFqLI7151e1KFIMYua52wdwi5IxZrstyFpWAQQS3t4U/x5li
         j3aHs9Cv+rp7TGs+2ziGyrqRt1edUfZQT2k6e0dc=
Date:   Fri, 12 Jul 2019 13:36:37 -0700
From:   akpm@linux-foundation.org
To:     henryburns@google.com, jwadams@google.com,
        mm-commits@vger.kernel.org, rientjes@google.com,
        rppt@linux.vnet.ibm.com, shakeelb@google.com,
        stable@vger.kernel.org, vitaly.vul@sony.com, vitalywool@gmail.com,
        wangxidong_97@163.com
Subject:  [merged]
 mm-z3foldc-lock-z3fold-page-before-__setpagemovable.patch removed from -mm
 tree
Message-ID: <20190712203637.ur7pcnFfd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/z3fold.c: lock z3fold page before  __SetPageMovable()
has been removed from the -mm tree.  Its filename was
     mm-z3foldc-lock-z3fold-page-before-__setpagemovable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Henry Burns <henryburns@google.com>
Subject: mm/z3fold.c: lock z3fold page before  __SetPageMovable()

Following zsmalloc.c's example we call trylock_page() and unlock_page().
Also make z3fold_page_migrate() assert that newpage is passed in locked,
as per the documentation.

[akpm@linux-foundation.org: fix trylock_page return value test, per Shakeel]
Link: http://lkml.kernel.org/r/20190702005122.41036-1-henryburns@google.com
Link: http://lkml.kernel.org/r/20190702233538.52793-1-henryburns@google.com
Signed-off-by: Henry Burns <henryburns@google.com>
Suggested-by: Vitaly Wool <vitalywool@gmail.com>
Acked-by: Vitaly Wool <vitalywool@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
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
+		if (trylock_page(page)) {
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

mm-z3foldc-remove-z3fold_migration-trylock.patch

