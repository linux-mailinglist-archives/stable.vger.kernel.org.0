Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7156A3B629B
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233928AbhF1Osr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:48:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235681AbhF1Opg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:45:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 008CC61C82;
        Mon, 28 Jun 2021 14:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890851;
        bh=TmCl2+E1DvidPUwxSNA7O2T7usiyexpvtOtyxmgIppw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZs/F40602KzhgopLiajVTy9Xsdo34loDy2upeH/H5gE3blaQVMSNbjh1IPZza5od
         Q7sOkYpJ+yRxerNAST6pnHxacV4Cbs/IqHRXeb+ADHkI8hCvaKTXhK6s+AISg/1Sou
         qp7wtKsH1+N+v/QKqRDrCszLbiAp5+1EUqonfiEk+FpoeaHE4jjghFAFCKtjqEUlNp
         C542VquH0c63J/4aHtDI5stuyuDYOgaK9ujWEyH5bD7qbCUBW1OiTw8tcMV4zqzOlR
         QaL5PnIzQHcmJo1rzcK6IUgv2xNhNTENmYzJwSpe1/ig+aFPlCIoowdy2aSHq9Xsiu
         EFc/Lsv6G5uEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Marco Elver <elver@google.com>,
        "Lin, Zhenpeng" <zplin@psu.edu>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Roman Gushchin <guro@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 073/109] mm/slub: clarify verification reporting
Date:   Mon, 28 Jun 2021 10:32:29 -0400
Message-Id: <20210628143305.32978-74-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 8669dbab2ae56085c128894b181c2aa50f97e368 upstream.

Patch series "Actually fix freelist pointer vs redzoning", v4.

This fixes redzoning vs the freelist pointer (both for middle-position
and very small caches).  Both are "theoretical" fixes, in that I see no
evidence of such small-sized caches actually be used in the kernel, but
that's no reason to let the bugs continue to exist, especially since
people doing local development keep tripping over it.  :)

This patch (of 3):

Instead of repeating "Redzone" and "Poison", clarify which sides of
those zones got tripped.  Additionally fix column alignment in the
trailer.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/vm/slub.rst | 10 +++++-----
 mm/slub.c                 | 14 +++++++-------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/vm/slub.rst b/Documentation/vm/slub.rst
index 3a775fd64e2d..3602959d5f92 100644
--- a/Documentation/vm/slub.rst
+++ b/Documentation/vm/slub.rst
@@ -154,7 +154,7 @@ SLUB Debug output
 Here is a sample of slub debug output::
 
  ====================================================================
- BUG kmalloc-8: Redzone overwritten
+ BUG kmalloc-8: Right Redzone overwritten
  --------------------------------------------------------------------
 
  INFO: 0xc90f6d28-0xc90f6d2b. First byte 0x00 instead of 0xcc
@@ -162,10 +162,10 @@ Here is a sample of slub debug output::
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
diff --git a/mm/slub.c b/mm/slub.c
index da141e5974f2..11a2df00729e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -672,15 +672,15 @@ static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
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
 
 	if (s->offset)
@@ -695,7 +695,7 @@ static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
 
 	if (off != size_from_object(s))
 		/* Beginning of the filler is the free pointer */
-		print_section(KERN_ERR, "Padding ", p + off,
+		print_section(KERN_ERR, "Padding  ", p + off,
 			      size_from_object(s) - off);
 
 	dump_stack();
@@ -873,11 +873,11 @@ static int check_object(struct kmem_cache *s, struct page *page,
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
@@ -892,7 +892,7 @@ static int check_object(struct kmem_cache *s, struct page *page,
 		if (val != SLUB_RED_ACTIVE && (s->flags & __OBJECT_POISON) &&
 			(!check_bytes_and_report(s, page, p, "Poison", p,
 					POISON_FREE, s->object_size - 1) ||
-			 !check_bytes_and_report(s, page, p, "Poison",
+			 !check_bytes_and_report(s, page, p, "End Poison",
 				p + s->object_size - 1, POISON_END, 1)))
 			return 0;
 		/*
-- 
2.30.2

