Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70A6010132B
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbfKSFXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:23:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:38494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726905AbfKSFXC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:23:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABD0222350;
        Tue, 19 Nov 2019 05:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140981;
        bh=FxKPO7jAChxQpNp61sriPsywXO1Z/3Nf73A8Tln1LT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zmNSN6CHrEAOwhSHSQavCOJXAtJOZVQ19qkesBGqgBc//J1zVJgLyLV6vrnHlrGgY
         6efvw9s/oJunn2ARQaPtK4MTl+ID4v4FL3f2G1wvPLZeH3y8X20SmM/5fzaHgy/l2C
         nhMBkz4Q3uETQMprYMX2JB1YAPQ2h9oslCtfg+fY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laura Abbott <labbott@redhat.com>,
        Thibaut Sautereau <thibaut.sautereau@clip-os.org>,
        David Rientjes <rientjes@google.com>,
        Alexander Potapenko <glider@google.com>,
        Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vlastimil Babka <vbabka@suse.cz>, clipos@ssi.gouv.fr,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.3 45/48] mm: slub: really fix slab walking for init_on_free
Date:   Tue, 19 Nov 2019 06:20:05 +0100
Message-Id: <20191119051028.131345484@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laura Abbott <labbott@redhat.com>

commit aea4df4c53f754cc229edde6c5465e481311cc49 upstream.

Commit 1b7e816fc80e ("mm: slub: Fix slab walking for init_on_free")
fixed one problem with the slab walking but missed a key detail: When
walking the list, the head and tail pointers need to be updated since we
end up reversing the list as a result.  Without doing this, bulk free is
broken.

One way this is exposed is a NULL pointer with slub_debug=F:

  =============================================================================
  BUG skbuff_head_cache (Tainted: G                T): Object already free
  -----------------------------------------------------------------------------

  INFO: Slab 0x000000000d2d2f8f objects=16 used=3 fp=0x0000000064309071 flags=0x3fff00000000201
  BUG: kernel NULL pointer dereference, address: 0000000000000000
  Oops: 0000 [#1] PREEMPT SMP PTI
  RIP: 0010:print_trailer+0x70/0x1d5
  Call Trace:
   <IRQ>
   free_debug_processing.cold.37+0xc9/0x149
   __slab_free+0x22a/0x3d0
   kmem_cache_free_bulk+0x415/0x420
   __kfree_skb_flush+0x30/0x40
   net_rx_action+0x2dd/0x480
   __do_softirq+0xf0/0x246
   irq_exit+0x93/0xb0
   do_IRQ+0xa0/0x110
   common_interrupt+0xf/0xf
   </IRQ>

Given we're now almost identical to the existing debugging code which
correctly walks the list, combine with that.

Link: https://lkml.kernel.org/r/20191104170303.GA50361@gandi.net
Link: http://lkml.kernel.org/r/20191106222208.26815-1-labbott@redhat.com
Fixes: 1b7e816fc80e ("mm: slub: Fix slab walking for init_on_free")
Signed-off-by: Laura Abbott <labbott@redhat.com>
Reported-by: Thibaut Sautereau <thibaut.sautereau@clip-os.org>
Acked-by: David Rientjes <rientjes@google.com>
Tested-by: Alexander Potapenko <glider@google.com>
Acked-by: Alexander Potapenko <glider@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <clipos@ssi.gouv.fr>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/slub.c |   39 +++++++++------------------------------
 1 file changed, 9 insertions(+), 30 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1432,12 +1432,15 @@ static inline bool slab_free_freelist_ho
 	void *old_tail = *tail ? *tail : *head;
 	int rsize;
 
-	if (slab_want_init_on_free(s)) {
-		void *p = NULL;
+	/* Head and tail of the reconstructed freelist */
+	*head = NULL;
+	*tail = NULL;
+
+	do {
+		object = next;
+		next = get_freepointer(s, object);
 
-		do {
-			object = next;
-			next = get_freepointer(s, object);
+		if (slab_want_init_on_free(s)) {
 			/*
 			 * Clear the object and the metadata, but don't touch
 			 * the redzone.
@@ -1447,29 +1450,8 @@ static inline bool slab_free_freelist_ho
 							   : 0;
 			memset((char *)object + s->inuse, 0,
 			       s->size - s->inuse - rsize);
-			set_freepointer(s, object, p);
-			p = object;
-		} while (object != old_tail);
-	}
-
-/*
- * Compiler cannot detect this function can be removed if slab_free_hook()
- * evaluates to nothing.  Thus, catch all relevant config debug options here.
- */
-#if defined(CONFIG_LOCKDEP)	||		\
-	defined(CONFIG_DEBUG_KMEMLEAK) ||	\
-	defined(CONFIG_DEBUG_OBJECTS_FREE) ||	\
-	defined(CONFIG_KASAN)
-
-	next = *head;
 
-	/* Head and tail of the reconstructed freelist */
-	*head = NULL;
-	*tail = NULL;
-
-	do {
-		object = next;
-		next = get_freepointer(s, object);
+		}
 		/* If object's reuse doesn't have to be delayed */
 		if (!slab_free_hook(s, object)) {
 			/* Move object to the new freelist */
@@ -1484,9 +1466,6 @@ static inline bool slab_free_freelist_ho
 		*tail = NULL;
 
 	return *head != NULL;
-#else
-	return true;
-#endif
 }
 
 static void *setup_object(struct kmem_cache *s, struct page *page,


