Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3CC774A8
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 00:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfGZWsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 18:48:22 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:48334 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbfGZWsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 18:48:22 -0400
Received: by mail-pf1-f202.google.com with SMTP id u21so34122107pfn.15
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 15:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xXWX2VUvhlaSP3eFpOp6jubimcyekuwmKjKZ/Jue+2A=;
        b=UtD5zDDr3YWz08bCCB2rTH85HPonmpnywBjnkC+40TBxVdPSBkrdoJlfpcs3WjPJFz
         qzKCOlMiIkiyh0GnDIb4ufsrPNJH+6YElA+I+DAmT3BhzA7Cmm9gp250MTYPkN6Ojpgj
         Xt8gaKcUKddO+Jht4XR0TQYI5xAqZq8OzHw6rPl5iRysirTvroBgDGP+nZ3xPEukFUbY
         4RkcC8U3MNMoZOja3xOtQkm3b+qq+805SQozYU12Va/qJHk42NnDgNt2CvtQTCBqGNSh
         XMLSKVnibq91UNt6XUzmWQDgQtOKqKqP11a2Zd8Jm4pqJFsK7gP9Xwf9UHSkCsRGA7TD
         5gPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xXWX2VUvhlaSP3eFpOp6jubimcyekuwmKjKZ/Jue+2A=;
        b=J0zXAZ9AuuycPJtzjqmuSq1I+/3WyLU19lJqWcRhY61Gj9kJW1UnwHl7ifk//nk8VH
         +IPZqNnvRZTZh7fmlLCcDWBlGOViOJH/uTBQnIFMkPyn+M9HeLgiM6dKDT3oJCvOu+4+
         UXsyAavWmtUwEUx27CWk/hTjOvF2lYuffEUItkolTAc1ZMk6H618Zm36KrJKNlVDoBSu
         Uiw/kcAoanOqGI2wbqNp5G0W0ECLRrmVh+Uz+Lbw9VEK1n4d0ly6MDNwBfSQEaewBX2F
         74N7NrdD8HVpWihD1iBJuQADaLgvkJbECqGGbXz7L2NscDeBPtu4bqMHmA3KCBMAKJQM
         Cyzw==
X-Gm-Message-State: APjAAAVLyp2IRf0ZcKSnOsjXqgGufRe+IquA/m70oiQ3y1aA/eTmRmz0
        C5VAfsENumeopvptaMb2nxhc/uANnQ0D+u48
X-Google-Smtp-Source: APXvYqwgia3+whqx87wT3bznlRIKzs5psESC65iyZd4wex6/4W5aVuLVvjvBesKSfs8+uxfSH8qVoS5Vsfbb2O1C
X-Received: by 2002:a65:49cc:: with SMTP id t12mr87423288pgs.83.1564181301373;
 Fri, 26 Jul 2019 15:48:21 -0700 (PDT)
Date:   Fri, 26 Jul 2019 15:48:10 -0700
In-Reply-To: <20190726224810.79660-1-henryburns@google.com>
Message-Id: <20190726224810.79660-2-henryburns@google.com>
Mime-Version: 1.0
References: <20190726224810.79660-1-henryburns@google.com>
X-Mailer: git-send-email 2.22.0.709.g102302147b-goog
Subject: [PATCH] mm/z3fold.c: Fix z3fold_destroy_pool() race condition
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

Calling z3fold_deregister_migration() before the workqueues are drained
means that there can be allocated pages referencing a freed inode,
causing any thread in compaction to be able to trip over the bad
pointer in PageMovable().

Fixes: 1f862989b04a ("mm/z3fold.c: support page migration")

Signed-off-by: Henry Burns <henryburns@google.com>
Cc: <stable@vger.kernel.org>
---
 mm/z3fold.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/z3fold.c b/mm/z3fold.c
index 43de92f52961..ed19d98c9dcd 100644
--- a/mm/z3fold.c
+++ b/mm/z3fold.c
@@ -817,16 +817,19 @@ static struct z3fold_pool *z3fold_create_pool(const char *name, gfp_t gfp,
 static void z3fold_destroy_pool(struct z3fold_pool *pool)
 {
 	kmem_cache_destroy(pool->c_handle);
-	z3fold_unregister_migration(pool);
 
 	/*
 	 * We need to destroy pool->compact_wq before pool->release_wq,
 	 * as any pending work on pool->compact_wq will call
 	 * queue_work(pool->release_wq, &pool->work).
+	 *
+	 * There are still outstanding pages until both workqueues are drained,
+	 * so we cannot unregister migration until then.
 	 */
 
 	destroy_workqueue(pool->compact_wq);
 	destroy_workqueue(pool->release_wq);
+	z3fold_unregister_migration(pool);
 	kfree(pool);
 }
 
-- 
2.22.0.709.g102302147b-goog

