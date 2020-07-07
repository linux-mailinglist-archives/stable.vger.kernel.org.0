Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678DB216FDC
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbgGGPLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:11:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728579AbgGGPLE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:11:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDBD52065D;
        Tue,  7 Jul 2020 15:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594134663;
        bh=PrlYdbWp9Ffquuk7fWY1ltFZHSFXNu/zgVWG4pa/Bow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iEzl0ABAaJBwdQGsVlXHxpH24M7VNuvNz9f9tQdDUumnQvn1qlUK+JVU3qY9HJB+c
         Izs2GtsdjNKfO6W7Bg2/ZlNei2wUJyRC8cRV1yaOsfFX7/JLZDY48iFw0TC85K+HQB
         IpuvysnsLF33Hbfe8amJVXNJQWwLCXaAlIX4+ZV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glauber@scylladb.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 05/19] mm/slub: fix stack overruns with SLUB_STATS
Date:   Tue,  7 Jul 2020 17:10:08 +0200
Message-Id: <20200707145747.778401609@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145747.493710555@linuxfoundation.org>
References: <20200707145747.493710555@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit a68ee0573991e90af2f1785db309206408bad3e5 ]

There is no need to copy SLUB_STATS items from root memcg cache to new
memcg cache copies.  Doing so could result in stack overruns because the
store function only accepts 0 to clear the stat and returns an error for
everything else while the show method would print out the whole stat.

Then, the mismatch of the lengths returns from show and store methods
happens in memcg_propagate_slab_attrs():

	else if (root_cache->max_attr_size < ARRAY_SIZE(mbuf))
		buf = mbuf;

max_attr_size is only 2 from slab_attr_store(), then, it uses mbuf[64]
in show_stat() later where a bounch of sprintf() would overrun the stack
variable.  Fix it by always allocating a page of buffer to be used in
show_stat() if SLUB_STATS=y which should only be used for debug purpose.

  # echo 1 > /sys/kernel/slab/fs_cache/shrink
  BUG: KASAN: stack-out-of-bounds in number+0x421/0x6e0
  Write of size 1 at addr ffffc900256cfde0 by task kworker/76:0/53251

  Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 07/10/2019
  Workqueue: memcg_kmem_cache memcg_kmem_cache_create_func
  Call Trace:
    number+0x421/0x6e0
    vsnprintf+0x451/0x8e0
    sprintf+0x9e/0xd0
    show_stat+0x124/0x1d0
    alloc_slowpath_show+0x13/0x20
    __kmem_cache_create+0x47a/0x6b0

  addr ffffc900256cfde0 is located in stack of task kworker/76:0/53251 at offset 0 in frame:
   process_one_work+0x0/0xb90

  this frame has 1 object:
   [32, 72) 'lockdep_map'

  Memory state around the buggy address:
   ffffc900256cfc80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
   ffffc900256cfd00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  >ffffc900256cfd80: 00 00 00 00 00 00 00 00 00 00 00 00 f1 f1 f1 f1
                                                         ^
   ffffc900256cfe00: 00 00 00 00 00 f2 f2 f2 00 00 00 00 00 00 00 00
   ffffc900256cfe80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ==================================================================
  Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: __kmem_cache_create+0x6ac/0x6b0
  Workqueue: memcg_kmem_cache memcg_kmem_cache_create_func
  Call Trace:
    __kmem_cache_create+0x6ac/0x6b0

Fixes: 107dab5c92d5 ("slub: slub-specific propagation changes")
Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Glauber Costa <glauber@scylladb.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Link: http://lkml.kernel.org/r/20200429222356.4322-1-cai@lca.pw
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slub.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index bb5237c67cbc9..a3870034bfcc4 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5305,7 +5305,8 @@ static void memcg_propagate_slab_attrs(struct kmem_cache *s)
 		 */
 		if (buffer)
 			buf = buffer;
-		else if (root_cache->max_attr_size < ARRAY_SIZE(mbuf))
+		else if (root_cache->max_attr_size < ARRAY_SIZE(mbuf) &&
+			 !IS_ENABLED(CONFIG_SLUB_STATS))
 			buf = mbuf;
 		else {
 			buffer = (char *) get_zeroed_page(GFP_KERNEL);
-- 
2.25.1



