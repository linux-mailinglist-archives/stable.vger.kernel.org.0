Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C981E3AEF21
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbhFUQfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:35:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232625AbhFUQeP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:34:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10886613E8;
        Mon, 21 Jun 2021 16:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292811;
        bh=BJvZ7lmORa1Y+vQrFYqAEdzyWH10bmrilziAzKaU0Uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gWK2o97ENWmYQrUa9ul0OtqDBTwGUo++GJXRJ0hmR5/S9hMV+rpbP87OB/vnx7wPM
         /3QLj5LiahNMuzrFMYr2SWRwZzubxQOtSwexcnfhYII8K6v8tSlcEBTFlDIjCPTj7V
         t2Q6h6xFv4Q0X65k44rkUJhOvmUQbx6Q0KVSvl/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Marco Elver <elver@google.com>,
        "Lin, Zhenpeng" <zplin@psu.edu>, Vlastimil Babka <vbabka@suse.cz>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        Roman Gushchin <guro@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 139/146] mm/slub: actually fix freelist pointer vs redzoning
Date:   Mon, 21 Jun 2021 18:16:09 +0200
Message-Id: <20210621154920.443635487@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit e41a49fadbc80b60b48d3c095d9e2ee7ef7c9a8e upstream.

It turns out that SLUB redzoning ("slub_debug=Z") checks from
s->object_size rather than from s->inuse (which is normally bumped to
make room for the freelist pointer), so a cache created with an object
size less than 24 would have the freelist pointer written beyond
s->object_size, causing the redzone to be corrupted by the freelist
pointer.  This was very visible with "slub_debug=ZF":

  BUG test (Tainted: G    B            ): Right Redzone overwritten
  -----------------------------------------------------------------------------

  INFO: 0xffff957ead1c05de-0xffff957ead1c05df @offset=1502. First byte 0x1a instead of 0xbb
  INFO: Slab 0xffffef3950b47000 objects=170 used=170 fp=0x0000000000000000 flags=0x8000000000000200
  INFO: Object 0xffff957ead1c05d8 @offset=1496 fp=0xffff957ead1c0620

  Redzone  (____ptrval____): bb bb bb bb bb bb bb bb               ........
  Object   (____ptrval____): 00 00 00 00 00 f6 f4 a5               ........
  Redzone  (____ptrval____): 40 1d e8 1a aa                        @....
  Padding  (____ptrval____): 00 00 00 00 00 00 00 00               ........

Adjust the offset to stay within s->object_size.

(Note that no caches of in this size range are known to exist in the
kernel currently.)

Link: https://lkml.kernel.org/r/20210608183955.280836-4-keescook@chromium.org
Link: https://lore.kernel.org/linux-mm/20200807160627.GA1420741@elver.google.com/
Link: https://lore.kernel.org/lkml/0f7dd7b2-7496-5e2d-9488-2ec9f8e90441@suse.cz/Fixes: 89b83f282d8b (slub: avoid redzone when choosing freepointer location)
Link: https://lore.kernel.org/lkml/CANpmjNOwZ5VpKQn+SYWovTkFB4VsT-RPwyENBmaK0dLcpqStkA@mail.gmail.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Marco Elver <elver@google.com>
Reported-by: "Lin, Zhenpeng" <zplin@psu.edu>
Tested-by: Marco Elver <elver@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3639,7 +3639,6 @@ static int calculate_sizes(struct kmem_c
 {
 	slab_flags_t flags = s->flags;
 	unsigned int size = s->object_size;
-	unsigned int freepointer_area;
 	unsigned int order;
 
 	/*
@@ -3648,13 +3647,6 @@ static int calculate_sizes(struct kmem_c
 	 * the possible location of the free pointer.
 	 */
 	size = ALIGN(size, sizeof(void *));
-	/*
-	 * This is the area of the object where a freepointer can be
-	 * safely written. If redzoning adds more to the inuse size, we
-	 * can't use that portion for writing the freepointer, so
-	 * s->offset must be limited within this for the general case.
-	 */
-	freepointer_area = size;
 
 #ifdef CONFIG_SLUB_DEBUG
 	/*
@@ -3680,7 +3672,7 @@ static int calculate_sizes(struct kmem_c
 
 	/*
 	 * With that we have determined the number of bytes in actual use
-	 * by the object. This is the potential offset to the free pointer.
+	 * by the object and redzoning.
 	 */
 	s->inuse = size;
 
@@ -3703,13 +3695,13 @@ static int calculate_sizes(struct kmem_c
 		 */
 		s->offset = size;
 		size += sizeof(void *);
-	} else if (freepointer_area > sizeof(void *)) {
+	} else {
 		/*
 		 * Store freelist pointer near middle of object to keep
 		 * it away from the edges of the object to avoid small
 		 * sized over/underflows from neighboring allocations.
 		 */
-		s->offset = ALIGN(freepointer_area / 2, sizeof(void *));
+		s->offset = ALIGN_DOWN(s->object_size / 2, sizeof(void *));
 	}
 
 #ifdef CONFIG_SLUB_DEBUG


