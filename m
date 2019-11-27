Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7769C10BC0F
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730815AbfK0VLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:11:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:40290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728507AbfK0VLf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:11:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE1D6217AB;
        Wed, 27 Nov 2019 21:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889094;
        bh=x0r3Mfd+VwYR6oqV1ER4Hs/zpIxUEsd0Q/jnlt4hZsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0GiTXa24RqaHyfbJp/3hNHTzjD3Kzw2CIDlUGUY9vAxvDeNVbFMPA9x063ac9qcnK
         AjiqPgZ4WLIKvz/gD9pkefAW/0Kmjb9yGC3IUsa/XXS4HhuIcn/TlRqEKMqSqydEoY
         bGrgtlXxaVdntk0wylCwYKxqKYuto2cC8Qhfzh+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Potapenko <glider@google.com>,
        Thibaut Sautereau <thibaut@sautereau.fr>,
        Kees Cook <keescook@chromium.org>,
        Christoph Lameter <cl@linux.com>,
        Laura Abbott <labbott@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 80/95] mm/slub.c: init_on_free=1 should wipe freelist ptr for bulk allocations
Date:   Wed, 27 Nov 2019 21:32:37 +0100
Message-Id: <20191127202949.148851697@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
References: <20191127202845.651587549@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Potapenko <glider@google.com>

[ Upstream commit 0f181f9fbea8bc7ea2f7e13ae7f8c256b39e254c ]

slab_alloc_node() already zeroed out the freelist pointer if
init_on_free was on.  Thibaut Sautereau noticed that the same needs to
be done for kmem_cache_alloc_bulk(), which performs the allocations
separately.

kmem_cache_alloc_bulk() is currently used in two places in the kernel,
so this change is unlikely to have a major performance impact.

SLAB doesn't require a similar change, as auto-initialization makes the
allocator store the freelist pointers off-slab.

Link: http://lkml.kernel.org/r/20191007091605.30530-1-glider@google.com
Fixes: 6471384af2a6 ("mm: security: introduce init_on_alloc=1 and init_on_free=1 boot options")
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: Thibaut Sautereau <thibaut@sautereau.fr>
Reported-by: Kees Cook <keescook@chromium.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Laura Abbott <labbott@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slub.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index d2445dd1c7eda..f24ea152cdbb3 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2648,6 +2648,17 @@ static void *__slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	return p;
 }
 
+/*
+ * If the object has been wiped upon free, make sure it's fully initialized by
+ * zeroing out freelist pointer.
+ */
+static __always_inline void maybe_wipe_obj_freeptr(struct kmem_cache *s,
+						   void *obj)
+{
+	if (unlikely(slab_want_init_on_free(s)) && obj)
+		memset((void *)((char *)obj + s->offset), 0, sizeof(void *));
+}
+
 /*
  * Inlined fastpath so that allocation functions (kmalloc, kmem_cache_alloc)
  * have the fastpath folded into their functions. So no function call
@@ -2736,12 +2747,8 @@ redo:
 		prefetch_freepointer(s, next_object);
 		stat(s, ALLOC_FASTPATH);
 	}
-	/*
-	 * If the object has been wiped upon free, make sure it's fully
-	 * initialized by zeroing out freelist pointer.
-	 */
-	if (unlikely(slab_want_init_on_free(s)) && object)
-		memset(object + s->offset, 0, sizeof(void *));
+
+	maybe_wipe_obj_freeptr(s, object);
 
 	if (unlikely(slab_want_init_on_alloc(gfpflags, s)) && object)
 		memset(object, 0, s->object_size);
@@ -3155,10 +3162,13 @@ int kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
 				goto error;
 
 			c = this_cpu_ptr(s->cpu_slab);
+			maybe_wipe_obj_freeptr(s, p[i]);
+
 			continue; /* goto for-loop */
 		}
 		c->freelist = get_freepointer(s, object);
 		p[i] = object;
+		maybe_wipe_obj_freeptr(s, p[i]);
 	}
 	c->tid = next_tid(c->tid);
 	local_irq_enable();
-- 
2.20.1



