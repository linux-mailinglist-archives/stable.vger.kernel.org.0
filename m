Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998E73AEE10
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbhFUQZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:25:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231855AbhFUQX4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:23:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80DAE613B1;
        Mon, 21 Jun 2021 16:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292453;
        bh=JpF9PHmnLFcRm9SP4W7S5Qc4n7/hmkgnJicBGZ+qye8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=amshJI2XtveEBh3hVVgaOx06fM/Zwa6k0J/0PquFClfD+eqGv5MO8UBsi1HIYzq0M
         tQ/2LwBxxWvYMH5etYJMqpYs4fFmkSB27Ld1bOMElGXBlmMzvjz0mhjkAozvzdfT5z
         oCCQNU/J5DlQ3Vvwv4xXvWP23t8sDQZ1cPQPv9AM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Lin, Zhenpeng" <zplin@psu.edu>, Marco Elver <elver@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Roman Gushchin <guro@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 79/90] mm/slub: fix redzoning for small allocations
Date:   Mon, 21 Jun 2021 18:15:54 +0200
Message-Id: <20210621154906.829857412@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 74c1d3e081533825f2611e46edea1fcdc0701985 upstream.

The redzone area for SLUB exists between s->object_size and s->inuse
(which is at least the word-aligned object_size).  If a cache were
created with an object_size smaller than sizeof(void *), the in-object
stored freelist pointer would overwrite the redzone (e.g.  with boot
param "slub_debug=ZF"):

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slab_common.c |    3 +--
 mm/slub.c        |    8 +++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -85,8 +85,7 @@ EXPORT_SYMBOL(kmem_cache_size);
 #ifdef CONFIG_DEBUG_VM
 static int kmem_cache_sanity_check(const char *name, unsigned int size)
 {
-	if (!name || in_interrupt() || size < sizeof(void *) ||
-		size > KMALLOC_MAX_SIZE) {
+	if (!name || in_interrupt() || size > KMALLOC_MAX_SIZE) {
 		pr_err("kmem_cache_create(%s) integrity check failed\n", name);
 		return -EINVAL;
 	}
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3586,15 +3586,17 @@ static int calculate_sizes(struct kmem_c
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


