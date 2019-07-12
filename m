Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF7E6655C
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 05:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729568AbfGLDwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 23:52:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728721AbfGLDwQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jul 2019 23:52:16 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 451EC2080A;
        Fri, 12 Jul 2019 03:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562903535;
        bh=nT6jRG+mxCO6qCuFdAs2p5kko3GTLPvtOn/AgVvi9ww=;
        h=Date:From:To:Subject:From;
        b=RhA2R3W7u/cQRWIpf6Rfi3qu6LA+JLl0iOhgzQJ+AUUQnWWmSFCrhQSfnlD1usxV2
         7twr17rIeBdsjDmSkMlzQoeTdkeb9wYV3f0VEuHc9w0X2bKZu/sjKiS19asQew1Mhu
         MJqC7GiaJc2PUPvl8lK3EPn3DVhZeRAMxdovRfAk=
Date:   Thu, 11 Jul 2019 20:52:14 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, henryburns@google.com,
        jwadams@google.com, mm-commits@vger.kernel.org,
        rientjes@google.com, rppt@linux.vnet.ibm.com, shakeelb@google.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vitaly.vul@sony.com, vitalywool@gmail.com, wangxidong_97@163.com
Subject:  [patch 004/147] mm/z3fold.c: lock z3fold page before 
 __SetPageMovable()
Message-ID: <20190712035214.K627dYZCO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
