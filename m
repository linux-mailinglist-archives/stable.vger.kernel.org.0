Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F30AA774A6
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 00:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbfGZWsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 18:48:16 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:38476 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbfGZWsQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 18:48:16 -0400
Received: by mail-vk1-f202.google.com with SMTP id u202so23631290vku.5
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 15:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ugYwzqnv6FobgASB/IV2QGrorIeaEWGKXnYtHi2Zf0I=;
        b=t93ANIwehynL05QpzsPZQsNzsYxLbN+DEc+mU/gC8S3QoOdwTg6FWn2YHKT6g/JEBV
         +plV+4WjbYjE9Iw7uZ1VG0BDJ+16Y9xWYd9v1LIt6vDngPyZg0/hmMjTS2I9YEl9jicA
         31jSLX5XQ9oBkwYmBtzOxenRKIsCwx4PNL90gPuNXhPk5XJ3rUEY55ZCDSl1dislK+H0
         g6Wfn1ehtdFKdIlTR020Dp7vd8oiLIwlhadCFIXKZS3z+9hQC3ZJf+K+w2i2gEvpCJ31
         DBHOPYqz9sCbWxdhFNbi+HS5+FiuDxaZBwOgrnmhPGa7Xuj/2HX8s72wsXj3lo0fpkwD
         hnag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ugYwzqnv6FobgASB/IV2QGrorIeaEWGKXnYtHi2Zf0I=;
        b=XZuMkUrH850yDjj9KDuUIRO/jr5MujV5Vks7cfftEiWh95nPP4TBevKQ/iCzLzMUhs
         9gyeX2974RuLJwZ/KA/rotjqS+oABG9TKZwCscyZzdsYPzswT/fsRDsd7h+jmrBBpPLs
         8OCnWYTsfMMOJ4O97VBgBUqorBCWzdUTLyDEmDnB5zxP2qaZcJW2te/LxhaHV/DciUuI
         ZGxT8NCvJIwa6R1NTfLC/cKabWANG08v9U/eAJkhZEjQfRaT//xETWH8Eh2pNim90JYl
         SpI9zwcu47swIYfRGl/JqC20XSUtgoibaBvHCFjaeUumE5eCNhrmn7OWVWn0Vb48+dz7
         Y7fg==
X-Gm-Message-State: APjAAAV9osOzsmiGEZduW7Wgksn8Nq/W/3nAng0lPXJ9IAfvHSoyPrkh
        Jq7MBHPzU3BnlB2aSb99vMpWgPQ9+xLpUIY9
X-Google-Smtp-Source: APXvYqwkSvswxUgvR5c6fCqlODLxRregW3zUnnkYsv9AKzH6EnFwtFPMVKnEpmizdeK6j5ngy/2lUoNmIaVHBLtU
X-Received: by 2002:a1f:6e8e:: with SMTP id j136mr2583640vkc.80.1564181295126;
 Fri, 26 Jul 2019 15:48:15 -0700 (PDT)
Date:   Fri, 26 Jul 2019 15:48:09 -0700
Message-Id: <20190726224810.79660-1-henryburns@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.709.g102302147b-goog
Subject: [PATCH] mm/z3fold.c: Fix z3fold_destroy_pool() ordering
From:   Henry Burns <henryburns@google.com>
To:     Vitaly Vul <vitaly.vul@sony.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Jonathan Adams <jwadams@google.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Henry Burns <henryburns@google.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The constraint from the zpool use of z3fold_destroy_pool() is there are no
outstanding handles to memory (so no active allocations), but it is possible
for there to be outstanding work on either of the two wqs in the pool.

If there is work queued on pool->compact_workqueue when it is called,
z3fold_destroy_pool() will do:

   z3fold_destroy_pool()
     destroy_workqueue(pool->release_wq)
     destroy_workqueue(pool->compact_wq)
       drain_workqueue(pool->compact_wq)
         do_compact_page(zhdr)
           kref_put(&zhdr->refcount)
             __release_z3fold_page(zhdr, ...)
               queue_work_on(pool->release_wq, &pool->work) *BOOM*

So compact_wq needs to be destroyed before release_wq.

Fixes: 5d03a6613957 ("mm/z3fold.c: use kref to prevent page free/compact race")

Signed-off-by: Henry Burns <henryburns@google.com>
Cc: <stable@vger.kernel.org>
---
 mm/z3fold.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/z3fold.c b/mm/z3fold.c
index 1a029a7432ee..43de92f52961 100644
--- a/mm/z3fold.c
+++ b/mm/z3fold.c
@@ -818,8 +818,15 @@ static void z3fold_destroy_pool(struct z3fold_pool *pool)
 {
 	kmem_cache_destroy(pool->c_handle);
 	z3fold_unregister_migration(pool);
-	destroy_workqueue(pool->release_wq);
+
+	/*
+	 * We need to destroy pool->compact_wq before pool->release_wq,
+	 * as any pending work on pool->compact_wq will call
+	 * queue_work(pool->release_wq, &pool->work).
+	 */
+
 	destroy_workqueue(pool->compact_wq);
+	destroy_workqueue(pool->release_wq);
 	kfree(pool);
 }
 
-- 
2.22.0.709.g102302147b-goog

