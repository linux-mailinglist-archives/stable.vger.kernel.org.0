Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902E837CEDF
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345130AbhELRHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:07:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244648AbhELQu5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:50:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7072A611AD;
        Wed, 12 May 2021 16:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836239;
        bh=oO341ZWYG1qiFUp2BeJG8MblbJBymjS884LDIvrxeKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xpr5gooTwM3xMMMJFJuGiaElGWljr1w9caxCn8KR45Uou7+zOzbZ7jWC9hj7ikEB1
         K3lp7ghHZNZCCOVCt46sarx0pGFH7qPiTpDdlXQCGwvDunE5ZANJxNkJcxm84jIGh6
         nCSM3VfX2Tm31RYyTKUwhdYSj5rHkRAL3iouElok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Oliver Glitta <glittao@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 666/677] mm, slub: enable slub_debug static key when creating cache with explicit debug flags
Date:   Wed, 12 May 2021 16:51:52 +0200
Message-Id: <20210512144859.494735668@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>

[ Upstream commit 1f0723a4c0df36cbdffc6fac82cd3c5d57e06d66 ]

Commit ca0cab65ea2b ("mm, slub: introduce static key for slub_debug()")
introduced a static key to optimize the case where no debugging is
enabled for any cache.  The static key is enabled when slub_debug boot
parameter is passed, or CONFIG_SLUB_DEBUG_ON enabled.

However, some caches might be created with one or more debugging flags
explicitly passed to kmem_cache_create(), and the commit missed this.
Thus the debugging functionality would not be actually performed for
these caches unless the static key gets enabled by boot param or config.

This patch fixes it by checking for debugging flags passed to
kmem_cache_create() and enabling the static key accordingly.

Note such explicit debugging flags should not be used outside of
debugging and testing as they will now enable the static key globally.
btrfs_init_cachep() creates a cache with SLAB_RED_ZONE but that's a
mistake that's being corrected [1].  rcu_torture_stats() creates a cache
with SLAB_STORE_USER, but that is a testing module so it's OK and will
start working as intended after this patch.

Also note that in case of backports to kernels before v5.12 that don't
have 59450bbc12be ("mm, slab, slub: stop taking cpu hotplug lock"),
static_branch_enable_cpuslocked() should be used.

[1] https://lore.kernel.org/linux-btrfs/20210315141824.26099-1-dsterba@suse.com/

Link: https://lkml.kernel.org/r/20210315153415.24404-1-vbabka@suse.cz
Fixes: ca0cab65ea2b ("mm, slub: introduce static key for slub_debug()")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Oliver Glitta <glittao@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slub.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index 3021ce9bf1b3..0fa68cfa648b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3827,6 +3827,15 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 
 static int kmem_cache_open(struct kmem_cache *s, slab_flags_t flags)
 {
+#ifdef CONFIG_SLUB_DEBUG
+	/*
+	 * If no slub_debug was enabled globally, the static key is not yet
+	 * enabled by setup_slub_debug(). Enable it if the cache is being
+	 * created with any of the debugging flags passed explicitly.
+	 */
+	if (flags & SLAB_DEBUG_FLAGS)
+		static_branch_enable(&slub_debug_enabled);
+#endif
 	s->flags = kmem_cache_flags(s->size, flags, s->name);
 #ifdef CONFIG_SLAB_FREELIST_HARDENED
 	s->random = get_random_long();
-- 
2.30.2



