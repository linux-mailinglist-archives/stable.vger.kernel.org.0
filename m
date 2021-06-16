Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C424B3A8E42
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 03:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbhFPBZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 21:25:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230265AbhFPBZ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 21:25:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D586161159;
        Wed, 16 Jun 2021 01:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623806600;
        bh=HJt7DgSPqPsuOFn2TSXEtOS2EZSr5q/s8Ly2AowAmEM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=c/s3T6+2F/MJf4hloxOFzLhvBaHiYQ7hTrFUCqagwCwlgLqTA7K9ZPYsNiunVRXnt
         aJFHIsbeyR2f49ErwQ4a7YWlUKkP9WVl//nihZVwPZIRcaHppJfqaY1qy8f1mjH0cN
         nwFYD0cOsMXXQlDT+QKWxxvSQTrrbvyjGTqD7eXU=
Date:   Tue, 15 Jun 2021 18:23:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, elver@google.com,
        guro@fb.com, iamjoonsoo.kim@lge.com, keescook@chromium.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, zplin@psu.edu
Subject:  [patch 03/18] mm/slub: clarify verification reporting
Message-ID: <20210616012319.QR2BB6iJq%akpm@linux-foundation.org>
In-Reply-To: <20210615182248.9a0ba90e8e66b9f4a53c0d23@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Subject: mm/slub: clarify verification reporting

Patch series "Actually fix freelist pointer vs redzoning", v4.

This fixes redzoning vs the freelist pointer (both for middle-position and
very small caches).  Both are "theoretical" fixes, in that I see no
evidence of such small-sized caches actually be used in the kernel, but
that's no reason to let the bugs continue to exist, especially since
people doing local development keep tripping over it.  :)


This patch (of 3):

Instead of repeating "Redzone" and "Poison", clarify which sides of those
zones got tripped.  Additionally fix column alignment in the trailer.

Before:

BUG test (Tainted: G    B            ): Redzone overwritten
...
Redzone (____ptrval____): bb bb bb bb bb bb bb bb      ........
Object (____ptrval____): f6 f4 a5 40 1d e8            ...@..
Redzone (____ptrval____): 1a aa                        ..
Padding (____ptrval____): 00 00 00 00 00 00 00 00      ........

After:

BUG test (Tainted: G    B            ): Right Redzone overwritten
...
Redzone  (____ptrval____): bb bb bb bb bb bb bb bb      ........
Object   (____ptrval____): f6 f4 a5 40 1d e8            ...@..
Redzone  (____ptrval____): 1a aa                        ..
Padding  (____ptrval____): 00 00 00 00 00 00 00 00      ........

The earlier commits that slowly resulted in the "Before" reporting were:

  d86bd1bece6f ("mm/slub: support left redzone")
  ffc79d288000 ("slub: use print_hex_dump")
  2492268472e7 ("SLUB: change error reporting format to follow lockdep loosely")

Link: https://lkml.kernel.org/r/20210608183955.280836-1-keescook@chromium.org
Link: https://lkml.kernel.org/r/20210608183955.280836-2-keescook@chromium.org
Link: https://lore.kernel.org/lkml/cfdb11d7-fb8e-e578-c939-f7f5fb69a6bd@suse.cz/
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Marco Elver <elver@google.com>
Cc: "Lin, Zhenpeng" <zplin@psu.edu>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/slub.rst |   10 +++++-----
 mm/slub.c                 |   14 +++++++-------
 2 files changed, 12 insertions(+), 12 deletions(-)

--- a/Documentation/vm/slub.rst~mm-slub-clarify-verification-reporting
+++ a/Documentation/vm/slub.rst
@@ -181,7 +181,7 @@ SLUB Debug output
 Here is a sample of slub debug output::
 
  ====================================================================
- BUG kmalloc-8: Redzone overwritten
+ BUG kmalloc-8: Right Redzone overwritten
  --------------------------------------------------------------------
 
  INFO: 0xc90f6d28-0xc90f6d2b. First byte 0x00 instead of 0xcc
@@ -189,10 +189,10 @@ Here is a sample of slub debug output::
  INFO: Object 0xc90f6d20 @offset=3360 fp=0xc90f6d58
  INFO: Allocated in get_modalias+0x61/0xf5 age=53 cpu=1 pid=554
 
- Bytes b4 0xc90f6d10:  00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
-   Object 0xc90f6d20:  31 30 31 39 2e 30 30 35                         1019.005
-  Redzone 0xc90f6d28:  00 cc cc cc                                     .
-  Padding 0xc90f6d50:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ
+ Bytes b4 (0xc90f6d10): 00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
+ Object   (0xc90f6d20): 31 30 31 39 2e 30 30 35                         1019.005
+ Redzone  (0xc90f6d28): 00 cc cc cc                                     .
+ Padding  (0xc90f6d50): 5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ
 
    [<c010523d>] dump_trace+0x63/0x1eb
    [<c01053df>] show_trace_log_lvl+0x1a/0x2f
--- a/mm/slub.c~mm-slub-clarify-verification-reporting
+++ a/mm/slub.c
@@ -712,15 +712,15 @@ static void print_trailer(struct kmem_ca
 	       p, p - addr, get_freepointer(s, p));
 
 	if (s->flags & SLAB_RED_ZONE)
-		print_section(KERN_ERR, "Redzone ", p - s->red_left_pad,
+		print_section(KERN_ERR, "Redzone  ", p - s->red_left_pad,
 			      s->red_left_pad);
 	else if (p > addr + 16)
 		print_section(KERN_ERR, "Bytes b4 ", p - 16, 16);
 
-	print_section(KERN_ERR, "Object ", p,
+	print_section(KERN_ERR,         "Object   ", p,
 		      min_t(unsigned int, s->object_size, PAGE_SIZE));
 	if (s->flags & SLAB_RED_ZONE)
-		print_section(KERN_ERR, "Redzone ", p + s->object_size,
+		print_section(KERN_ERR, "Redzone  ", p + s->object_size,
 			s->inuse - s->object_size);
 
 	off = get_info_end(s);
@@ -732,7 +732,7 @@ static void print_trailer(struct kmem_ca
 
 	if (off != size_from_object(s))
 		/* Beginning of the filler is the free pointer */
-		print_section(KERN_ERR, "Padding ", p + off,
+		print_section(KERN_ERR, "Padding  ", p + off,
 			      size_from_object(s) - off);
 
 	dump_stack();
@@ -909,11 +909,11 @@ static int check_object(struct kmem_cach
 	u8 *endobject = object + s->object_size;
 
 	if (s->flags & SLAB_RED_ZONE) {
-		if (!check_bytes_and_report(s, page, object, "Redzone",
+		if (!check_bytes_and_report(s, page, object, "Left Redzone",
 			object - s->red_left_pad, val, s->red_left_pad))
 			return 0;
 
-		if (!check_bytes_and_report(s, page, object, "Redzone",
+		if (!check_bytes_and_report(s, page, object, "Right Redzone",
 			endobject, val, s->inuse - s->object_size))
 			return 0;
 	} else {
@@ -928,7 +928,7 @@ static int check_object(struct kmem_cach
 		if (val != SLUB_RED_ACTIVE && (s->flags & __OBJECT_POISON) &&
 			(!check_bytes_and_report(s, page, p, "Poison", p,
 					POISON_FREE, s->object_size - 1) ||
-			 !check_bytes_and_report(s, page, p, "Poison",
+			 !check_bytes_and_report(s, page, p, "End Poison",
 				p + s->object_size - 1, POISON_END, 1)))
 			return 0;
 		/*
_
