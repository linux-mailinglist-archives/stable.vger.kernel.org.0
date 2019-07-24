Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 275E57398C
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390160AbfGXTlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:41:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390138AbfGXTlR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:41:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0544622BEA;
        Wed, 24 Jul 2019 19:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997276;
        bh=m/TcuuKzU220TiJSgXTGr3A15gmnjrA9g4FvnmRYxz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2V4ridoekXOhTGSKjsvYAwZJGDpX7cZplLs4hH85a2U8ugo6g4jrio25vqVU0AANH
         8pb5WHHGL758h5QVBsLQhsMRt2WlNAbkwkCWEASjl8Dz3qpCcZVWg0CBpU9GIaLcqx
         Jc0bEGMWyi3M2cevXbIJ6y5O1hzWVu1VFV85v6X0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Henry Burns <henryburns@google.com>,
        Vitaly Wool <vitalywool@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Vitaly Vul <vitaly.vul@sony.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Xidong Wang <wangxidong_97@163.com>,
        Jonathan Adams <jwadams@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.2 379/413] mm/z3fold.c: lock z3fold page before __SetPageMovable()
Date:   Wed, 24 Jul 2019 21:21:10 +0200
Message-Id: <20190724191802.255562204@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Henry Burns <henryburns@google.com>

commit 810481a246089117d98e3373a3cb735c3efc1f90 upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/z3fold.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/z3fold.c
+++ b/mm/z3fold.c
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


