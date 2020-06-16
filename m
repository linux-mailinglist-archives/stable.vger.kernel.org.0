Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D51F1FBAC7
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730569AbgFPPnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:43:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731737AbgFPPnG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:43:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A78A220C56;
        Tue, 16 Jun 2020 15:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322185;
        bh=cfc5FjrY9vBGbt70tlqFyKkXVCs/JWORPS2LyxaMb0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C6AF0Zigar1wRvpKjFZvlVXnHFS7L9U233UhB5vuhlQweQaTHgbFvrLGlYdSuDYjr
         i0j+MWdj9GssV9nog6U8//tpjGG/tGZnGYqz7ilUtzjFsRYAYjZkCnlp8DQ8H6pjRO
         fK2HG9uz3OiApbWzazdGXUvN5CdtXmCmQRSsYw/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>, Jann Horn <jannh@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christopher Lameter <cl@linux.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        David Windsor <dave@nullcore.net>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andy Lutomirski <luto@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Laura Abbott <labbott@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Jan Kara <jack@suse.cz>,
        Luis de Bethencourt <luisbg@kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Rik van Riel <riel@surriel.com>,
        Matthew Garrett <mjg59@google.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.7 034/163] usercopy: mark dma-kmalloc caches as usercopy caches
Date:   Tue, 16 Jun 2020 17:33:28 +0200
Message-Id: <20200616153108.503176174@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>

commit 49f2d2419d60a103752e5fbaf158cf8d07c0d884 upstream.

We have seen a "usercopy: Kernel memory overwrite attempt detected to
SLUB object 'dma-kmalloc-1 k' (offset 0, size 11)!" error on s390x, as
IUCV uses kmalloc() with __GFP_DMA because of memory address
restrictions.  The issue has been discussed [2] and it has been noted
that if all the kmalloc caches are marked as usercopy, there's little
reason not to mark dma-kmalloc caches too.  The 'dma' part merely means
that __GFP_DMA is used to restrict memory address range.

As Jann Horn put it [3]:
 "I think dma-kmalloc slabs should be handled the same way as normal
  kmalloc slabs. When a dma-kmalloc allocation is freshly created, it is
  just normal kernel memory - even if it might later be used for DMA -,
  and it should be perfectly fine to copy_from_user() into such
  allocations at that point, and to copy_to_user() out of them at the
  end. If you look at the places where such allocations are created, you
  can see things like kmemdup(), memcpy() and so on - all normal
  operations that shouldn't conceptually be different from usercopy in
  any relevant way."

Thus this patch marks the dma-kmalloc-* caches as usercopy.

[1] https://bugzilla.suse.com/show_bug.cgi?id=1156053
[2] https://lore.kernel.org/kernel-hardening/bfca96db-bbd0-d958-7732-76e36c667c68@suse.cz/
[3] https://lore.kernel.org/kernel-hardening/CAG48ez1a4waGk9kB0WLaSbs4muSoK0AYAVk8=XYaKj4_+6e6Hg@mail.gmail.com/

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christopher Lameter <cl@linux.com>
Cc: Julian Wiedmann <jwi@linux.ibm.com>
Cc: Ursula Braun <ubraun@linux.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: David Windsor <dave@nullcore.net>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Luis de Bethencourt <luisbg@kernel.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Matthew Garrett <mjg59@google.com>
Cc: Michal Kubecek <mkubecek@suse.cz>
Link: http://lkml.kernel.org/r/7d810f6d-8085-ea2f-7805-47ba3842dc50@suse.cz
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/slab_common.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1303,7 +1303,8 @@ void __init create_kmalloc_caches(slab_f
 			kmalloc_caches[KMALLOC_DMA][i] = create_kmalloc_cache(
 				kmalloc_info[i].name[KMALLOC_DMA],
 				kmalloc_info[i].size,
-				SLAB_CACHE_DMA | flags, 0, 0);
+				SLAB_CACHE_DMA | flags, 0,
+				kmalloc_info[i].size);
 		}
 	}
 #endif


