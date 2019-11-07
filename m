Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E22AF2458
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 02:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbfKGBha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 20:37:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:51842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727924AbfKGBha (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 20:37:30 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4374D217F5;
        Thu,  7 Nov 2019 01:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573090649;
        bh=DvUZr3RFB6BA8P1SJYKdNBxEA7emdeeyZuGZiY6qhaU=;
        h=Date:From:To:Subject:From;
        b=RJSk/YMLayGHLlAKb61BP9OWEt1ZbEooTN1kdWxhuNWnJeJs2am9codVQw0iRDToO
         1sw3hOr8Boqk7Ffn+sfKHIPaDxZU/rWgEXlGF8JEFsRFQPq4tW36PoNOxK4AqcRyXf
         8ohtI26Ihe29VvW8UOczDL00Fd0JI67eU7vFUkdA=
Date:   Wed, 06 Nov 2019 17:37:28 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, clipos@ssi.gouv.fr, davem@davemloft.net,
        glider@google.com, iamjoonsoo.kim@lge.com, keescook@chromium.org,
        labbott@redhat.com, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, stable@vger.kernel.org,
        thibaut.sautereau@clip-os.org, vbabka@suse.cz
Subject:  + mm-slub-really-fix-slab-walking-for-init_on_free.patch
 added to -mm tree
Message-ID: <20191107013728.aogXof2uw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: slub: really fix slab walking for init_on_free
has been added to the -mm tree.  Its filename is
     mm-slub-really-fix-slab-walking-for-init_on_free.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-really-fix-slab-walking-for-init_on_free.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-really-fix-slab-walking-for-init_on_free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laura Abbott <labbott@redhat.com>
Subject: mm: slub: really fix slab walking for init_on_free

Commit 1b7e816fc80e ("mm: slub: Fix slab walking for init_on_free") fixed
one problem with the slab walking but missed a key detail: When walking
the list, the head and tail pointers need to be updated since we end up
reversing the list as a result.  Without doing this, bulk free is broken. 
One way this is exposed is a NULL pointer with slub_debug=F:

=============================================================================
BUG skbuff_head_cache (Tainted: G                T): Object already free
-----------------------------------------------------------------------------

INFO: Slab 0x000000000d2d2f8f objects=16 used=3 fp=0x0000000064309071 flags=0x3fff00000000201
BUG: kernel NULL pointer dereference, address: 0000000000000000
PGD 0 P4D 0
Oops: 0000 [#1] PREEMPT SMP PTI
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G    B           T 5.3.8 #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
RIP: 0010:print_trailer+0x70/0x1d5
Code: 28 4d 8b 4d 00 4d 8b 45 20 81 e2 ff 7f 00 00 e8 86 ce ef ff 8b 4b 20 48 89 ea 48 89 ee 4c 29 e2 48 c7 c7 90 6f d4 89 48 01 e9 <48> 33 09 48 33 8b 70 01 00 00 e8 61 ce ef ff f6 43 09 04 74 35 8b
RSP: 0018:ffffbf7680003d58 EFLAGS: 00010046
RAX: 000000000000005d RBX: ffffa3d2bb08e540 RCX: 0000000000000000
RDX: 00005c2d8fdc2000 RSI: 0000000000000000 RDI: ffffffff89d46f90
RBP: 0000000000000000 R08: 0000000000000242 R09: 000000000000006c
R10: 0000000000000000 R11: 0000000000000030 R12: ffffa3d27023e000
R13: fffff11080c08f80 R14: ffffa3d2bb047a80 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffffa3d2be400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000007a6c4000 CR4: 00000000000006f0
Call Trace:
 <IRQ>
 free_debug_processing.cold.37+0xc9/0x149
 ? __kfree_skb_flush+0x30/0x40
 ? __kfree_skb_flush+0x30/0x40
 __slab_free+0x22a/0x3d0
 ? tcp_wfree+0x2a/0x140
 ? __sock_wfree+0x1b/0x30
 kmem_cache_free_bulk+0x415/0x420
 ? __kfree_skb_flush+0x30/0x40
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
Cc: Kees Cook <keescook@chromium.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <clipos@ssi.gouv.fr>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   39 +++++++++------------------------------
 1 file changed, 9 insertions(+), 30 deletions(-)

--- a/mm/slub.c~mm-slub-really-fix-slab-walking-for-init_on_free
+++ a/mm/slub.c
@@ -1433,12 +1433,15 @@ static inline bool slab_free_freelist_ho
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
@@ -1448,29 +1451,8 @@ static inline bool slab_free_freelist_ho
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
@@ -1485,9 +1467,6 @@ static inline bool slab_free_freelist_ho
 		*tail = NULL;
 
 	return *head != NULL;
-#else
-	return true;
-#endif
 }
 
 static void *setup_object(struct kmem_cache *s, struct page *page,
_

Patches currently in -mm which might be from labbott@redhat.com are

mm-slub-really-fix-slab-walking-for-init_on_free.patch

