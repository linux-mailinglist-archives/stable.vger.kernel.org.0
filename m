Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 690E15D935
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 02:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfGCAh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 20:37:56 -0400
Received: from mail-oi1-f201.google.com ([209.85.167.201]:55795 "EHLO
        mail-oi1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbfGCAhz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 20:37:55 -0400
Received: by mail-oi1-f201.google.com with SMTP id r7so306105oie.22
        for <stable@vger.kernel.org>; Tue, 02 Jul 2019 17:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=MklO/nCO3vTONhpU2/Xc+PDQxZ8geoXuw22CpQ4sZO8=;
        b=qKiWSMCySfNKdrYjXhmrf6cfPbbz+oWEXvqnz1cpm0Z7vknJMNKnxJ+lQlVEm0E3hG
         RB9MJVn2xxeW/3haHy4B43l9sOPJSz9tekq/KPZSWh1be1FAzolI0qebmS2oJK4IXslI
         E1L/+HV1EWoRH9KnyHD4xeVzCWprAVojb7MrOxidOZ8BROzux7QmYFoYmx/+uLK1SX2D
         58G/T2wFKuZgk4DoXdfPCyK4TGp42G+xC48rMy1I7hzqFMoEyzh+cb+CIkDARyYfI1h1
         T5urZELFI4Fv+PnARlvjBvJrNSrFCRqIrsztsO3BARX88+dqkQv2cu5IH+wuoQj1vloo
         wACA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=MklO/nCO3vTONhpU2/Xc+PDQxZ8geoXuw22CpQ4sZO8=;
        b=Rrj2CarQlgXp68t36JESb9PblLBE+9EH0l2h28bHga8GL3R2GgGpkDsa4F1k4P9V+f
         k7CBMedYT85xoTViBrmoiOStG78rC1Lje1idBzcmuYnWuuD1HxtPkRGSTMxVso0LRw2c
         r/rn1sCXSOBvD8uMvmFjOtmbz7ylx1yW4A9N/Rjj3rE1LDBkPZ5KWUu2xjrvpJwFWDof
         a+f034/r7km3WFiOodqu/Sro/D+lFGjZn2Au2CRpp34qzGsq3xlpMWD1L2vEl3qEmNLU
         iw48RH3WwGTGzucqs0AZ34XdsXh8PZ0UJqKJGFpEMJHfTR5eS6MBNksh4O7dFt5Kw+/t
         WbHg==
X-Gm-Message-State: APjAAAW7EAWxRACSr5Y9U0H3qdhHPEwLHcxLZoXRRNjoSNSCkRYoh2uu
        QbNV/HA2J8y1YmXbraz6+OaSEYtOUGO8UHMB
X-Google-Smtp-Source: APXvYqwxWC5LdWcl2/XKPgh1zut3SpHgJ3FIJ714nB1MgOY6lhh76l/rN5P/M8Kednj/Tx9T/ZAwDQyC84jyWjts
X-Received: by 2002:a65:6106:: with SMTP id z6mr20033643pgu.250.1562110550143;
 Tue, 02 Jul 2019 16:35:50 -0700 (PDT)
Date:   Tue,  2 Jul 2019 16:35:38 -0700
Message-Id: <20190702233538.52793-1-henryburns@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH v3] mm/z3fold.c: Lock z3fold page before  __SetPageMovable()
From:   Henry Burns <henryburns@google.com>
To:     Vitaly Wool <vitalywool@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Vitaly Vul <vitaly.vul@sony.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Xidong Wang <wangxidong_97@163.com>,
        Shakeel Butt <shakeelb@google.com>,
        Jonathan Adams <jwadams@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Henry Burns <henryburns@google.com>,
        David Rientjes <rientjes@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
 Changelog since v2:
 - Removed the WARN_ON entirely, as it is an expected code path.

 Changelog since v1:
 - Added an if statement around WARN_ON(trylock_page(page)) to avoid
   unlocking a page locked by a someone else.

 mm/z3fold.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/z3fold.c b/mm/z3fold.c
index e174d1549734..eeb3fe7f5ca3 100644
--- a/mm/z3fold.c
+++ b/mm/z3fold.c
@@ -918,7 +918,16 @@ static int z3fold_alloc(struct z3fold_pool *pool, size_t size, gfp_t gfp,
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
@@ -1325,6 +1334,7 @@ static int z3fold_page_migrate(struct address_space *mapping, struct page *newpa
 
 	VM_BUG_ON_PAGE(!PageMovable(page), page);
 	VM_BUG_ON_PAGE(!PageIsolated(page), page);
+	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
 
 	zhdr = page_address(page);
 	pool = zhdr_to_pool(zhdr);
-- 
2.22.0.410.gd8fdbe21b5-goog

