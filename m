Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A678B4420B
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731098AbfFMQS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:18:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731103AbfFMIkH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:40:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CE0021479;
        Thu, 13 Jun 2019 08:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415206;
        bh=9KyvKUWZnBx1g14YIg5S+FWNtGtXZCZOK0xXgOx15PE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z125h0k6fpVO5rnuwkPo297j/MBP9okdd+nb2ec5ysA5EJOt/0BhWbh58UHmHfLYQ
         sXATPWgHUVPSRWxgVfzxNOgFldFulBsuD8yOpPcHZKL2Ho3OJav6rBVDtbb8UhLg7p
         ioGXp/E/7wGdnKWT7Mc9k3aoVqHU1B8I+snpCxw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 015/118] mm/slab.c: fix an infinite loop in leaks_show()
Date:   Thu, 13 Jun 2019 10:32:33 +0200
Message-Id: <20190613075644.535772360@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 745e10146c31b1c6ed3326286704ae251b17f663 ]

"cat /proc/slab_allocators" could hang forever on SMP machines with
kmemleak or object debugging enabled due to other CPUs running do_drain()
will keep making kmemleak_object or debug_objects_cache dirty and unable
to escape the first loop in leaks_show(),

do {
	set_store_user_clean(cachep);
	drain_cpu_caches(cachep);
	...

} while (!is_store_user_clean(cachep));

For example,

do_drain
  slabs_destroy
    slab_destroy
      kmem_cache_free
        __cache_free
          ___cache_free
            kmemleak_free_recursive
              delete_object_full
                __delete_object
                  put_object
                    free_object_rcu
                      kmem_cache_free
                        cache_free_debugcheck --> dirty kmemleak_object

One approach is to check cachep->name and skip both kmemleak_object and
debug_objects_cache in leaks_show().  The other is to set store_user_clean
after drain_cpu_caches() which leaves a small window between
drain_cpu_caches() and set_store_user_clean() where per-CPU caches could
be dirty again lead to slightly wrong information has been stored but
could also speed up things significantly which sounds like a good
compromise.  For example,

 # cat /proc/slab_allocators
 0m42.778s # 1st approach
 0m0.737s  # 2nd approach

[akpm@linux-foundation.org: tweak comment]
Link: http://lkml.kernel.org/r/20190411032635.10325-1-cai@lca.pw
Fixes: d31676dfde25 ("mm/slab: alternative implementation for DEBUG_SLAB_LEAK")
Signed-off-by: Qian Cai <cai@lca.pw>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slab.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/slab.c b/mm/slab.c
index 018d32496e8d..46f21e73db2f 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -4326,8 +4326,12 @@ static int leaks_show(struct seq_file *m, void *p)
 	 * whole processing.
 	 */
 	do {
-		set_store_user_clean(cachep);
 		drain_cpu_caches(cachep);
+		/*
+		 * drain_cpu_caches() could make kmemleak_object and
+		 * debug_objects_cache dirty, so reset afterwards.
+		 */
+		set_store_user_clean(cachep);
 
 		x[1] = 0;
 
-- 
2.20.1



