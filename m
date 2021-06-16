Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21283A8E43
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 03:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbhFPBZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 21:25:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230265AbhFPBZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 21:25:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3578E61356;
        Wed, 16 Jun 2021 01:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623806603;
        bh=JDA+uQj+K1d3SfrTSfO9ZzUv+CldmXRZMGxAbidp56s=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IEaireWPGi22na24aSwrqMIPfH7JQShS37nF5Hpi5B+syAIRPUyTQemJWta9zylgm
         ZdqhAxBdSeAUghswITKDbyI8zGaEwgkFX/8LzqHcgPD+gV1HIPPBLGlVfZ9KfY9KnJ
         VDzJnGtNGqmC1LsyPCTu+Im8/VdJOpZuF9PTYhFo=
Date:   Tue, 15 Jun 2021 18:23:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, elver@google.com,
        guro@fb.com, iamjoonsoo.kim@lge.com, keescook@chromium.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, zplin@psu.edu
Subject:  [patch 04/18] mm/slub: fix redzoning for small
 allocations
Message-ID: <20210616012322.mtEbkr1Dt%akpm@linux-foundation.org>
In-Reply-To: <20210615182248.9a0ba90e8e66b9f4a53c0d23@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Subject: mm/slub: fix redzoning for small allocations

The redzone area for SLUB exists between s->object_size and s->inuse
(which is at least the word-aligned object_size).  If a cache were created
with an object_size smaller than sizeof(void *), the in-object stored
freelist pointer would overwrite the redzone (e.g.  with boot param
"slub_debug=ZF"):

BUG test (Tainted: G    B            ): Right Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff957ead1c05de-0xffff957ead1c05df @offset=1502. First byte 0x1a instead of 0xbb
INFO: Slab 0xffffef3950b47000 objects=170 used=170 fp=0x0000000000000000 flags=0x8000000000000200
INFO: Object 0xffff957ead1c05d8 @offset=1496 fp=0xffff957ead1c0620

Redzone  (____ptrval____): bb bb bb bb bb bb bb bb    ........
Object   (____ptrval____): f6 f4 a5 40 1d e8          ...@..
Redzone  (____ptrval____): 1a aa                      ..
Padding  (____ptrval____): 00 00 00 00 00 00 00 00    ........

Store the freelist pointer out of line when object_size is smaller than
sizeof(void *) and redzoning is enabled.

Additionally remove the "smaller than sizeof(void *)" check under
CONFIG_DEBUG_VM in kmem_cache_sanity_check() as it is now redundant:
SLAB and SLOB both handle small sizes.

(Note that no caches within this size range are known to exist in the
kernel currently.)

Link: https://lkml.kernel.org/r/20210608183955.280836-3-keescook@chromium.org
Fixes: 81819f0fc828 ("SLUB core")
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Lin, Zhenpeng" <zplin@psu.edu>
Cc: Marco Elver <elver@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    3 +--
 mm/slub.c        |    8 +++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/mm/slab_common.c~mm-slub-fix-redzoning-for-small-allocations
+++ a/mm/slab_common.c
@@ -97,8 +97,7 @@ EXPORT_SYMBOL(kmem_cache_size);
 #ifdef CONFIG_DEBUG_VM
 static int kmem_cache_sanity_check(const char *name, unsigned int size)
 {
-	if (!name || in_interrupt() || size < sizeof(void *) ||
-		size > KMALLOC_MAX_SIZE) {
+	if (!name || in_interrupt() || size > KMALLOC_MAX_SIZE) {
 		pr_err("kmem_cache_create(%s) integrity check failed\n", name);
 		return -EINVAL;
 	}
--- a/mm/slub.c~mm-slub-fix-redzoning-for-small-allocations
+++ a/mm/slub.c
@@ -3734,15 +3734,17 @@ static int calculate_sizes(struct kmem_c
 	 */
 	s->inuse = size;
 
-	if (((flags & (SLAB_TYPESAFE_BY_RCU | SLAB_POISON)) ||
-		s->ctor)) {
+	if ((flags & (SLAB_TYPESAFE_BY_RCU | SLAB_POISON)) ||
+	    ((flags & SLAB_RED_ZONE) && s->object_size < sizeof(void *)) ||
+	    s->ctor) {
 		/*
 		 * Relocate free pointer after the object if it is not
 		 * permitted to overwrite the first word of the object on
 		 * kmem_cache_free.
 		 *
 		 * This is the case if we do RCU, have a constructor or
-		 * destructor or are poisoning the objects.
+		 * destructor, are poisoning the objects, or are
+		 * redzoning an object smaller than sizeof(void *).
 		 *
 		 * The assumption that s->offset >= s->inuse means free
 		 * pointer is outside of the object is used in the
_
