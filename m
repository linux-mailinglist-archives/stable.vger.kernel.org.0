Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A7920BDF2
	for <lists+stable@lfdr.de>; Sat, 27 Jun 2020 05:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbgF0Dd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 23:33:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:45094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbgF0Dd0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jun 2020 23:33:26 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4C342084C;
        Sat, 27 Jun 2020 03:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593228806;
        bh=KXKa2R/gCT/GTQV96Nx4wM9deX2UvewwrcWJiZabPZs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=R500MG7ym4iGH3+9QPIhk7Yfx9lOVzIFdby63VoL4qr2Jg2C/ZUPh7601NO5C8bib
         3s69qxiXv1fWgNCGvIL2U3q8ZasxEk16X3za4Vb04MC0gKTswYXduISL2E00AEw0Vb
         zsphmgeJR6ctywAaffMEeR5bz4GzlgIJGUczNiG8=
Date:   Fri, 26 Jun 2020 20:33:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     dan.carpenter@oracle.com, dhowells@redhat.com, hannes@cmpxchg.org,
        jarkko.sakkinen@linux.intel.com, Jason@zx2c4.com,
        jmorris@namei.org, joe@perches.com, longman@redhat.com,
        mhocko@suse.com, mm-commits@vger.kernel.org, rientjes@google.com,
        serge@hallyn.com, stable@vger.kernel.org, willy@infradead.org
Subject:  [merged] mm-slab-use-memzero_explicit-in-kzfree.patch
 removed from -mm tree
Message-ID: <20200627033325.LQpE9C2F1%akpm@linux-foundation.org>
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/slab: use memzero_explicit() in kzfree()
has been removed from the -mm tree.  Its filename was
     mm-slab-use-memzero_explicit-in-kzfree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/slab: use memzero_explicit() in kzfree()

The kzfree() function is normally used to clear some sensitive
information, like encryption keys, in the buffer before freeing it back to
the pool.  Memset() is currently used for buffer clearing.  However
unlikely, there is still a non-zero probability that the compiler may
choose to optimize away the memory clearing especially if LTO is being
used in the future.  To make sure that this optimization will never
happen, memzero_explicit(), which is introduced in v3.18, is now used in
kzfree() to future-proof it.

Link: http://lkml.kernel.org/r/20200616154311.12314-2-longman@redhat.com
Fixes: 3ef0e5ba4673 ("slab: introduce kzfree()")
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Joe Perches <joe@perches.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slab_common.c~mm-slab-use-memzero_explicit-in-kzfree
+++ a/mm/slab_common.c
@@ -1726,7 +1726,7 @@ void kzfree(const void *p)
 	if (unlikely(ZERO_OR_NULL_PTR(mem)))
 		return;
 	ks = ksize(mem);
-	memset(mem, 0, ks);
+	memzero_explicit(mem, ks);
 	kfree(mem);
 }
 EXPORT_SYMBOL(kzfree);
_

Patches currently in -mm which might be from longman@redhat.com are

mm-treewide-rename-kzfree-to-kfree_sensitive.patch
sched-mm-optimize-current_gfp_context.patch

