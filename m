Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62ADA217059
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728988AbgGGPQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:16:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728996AbgGGPQf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:16:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A84920674;
        Tue,  7 Jul 2020 15:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594134994;
        bh=DYTtz0AJqjOTxhsSgTwzu2wTfGAn/INv3TcuS10RgMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I6LU5TPS2a8Q9Kppgkf8fF8iITKVHik1G+gNHus/DQpXogu1YqWRE5Qo11YKq33DH
         DguogyxkLTjBuMrAavuqOSLoBc2uQY66/unZNnGPjyqViMYdNjO/rErBkJhc/GIzvS
         jFvS7jhUbsapYSt5nrZu+0Kx3auFgWBfFcXmg0HQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongli Zhang <dongli.zhang@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Jin <joe.jin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 07/27] mm/slub.c: fix corrupted freechain in deactivate_slab()
Date:   Tue,  7 Jul 2020 17:15:34 +0200
Message-Id: <20200707145749.311991335@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145748.944863698@linuxfoundation.org>
References: <20200707145748.944863698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongli Zhang <dongli.zhang@oracle.com>

[ Upstream commit 52f23478081ae0dcdb95d1650ea1e7d52d586829 ]

The slub_debug is able to fix the corrupted slab freelist/page.
However, alloc_debug_processing() only checks the validity of current
and next freepointer during allocation path.  As a result, once some
objects have their freepointers corrupted, deactivate_slab() may lead to
page fault.

Below is from a test kernel module when 'slub_debug=PUF,kmalloc-128
slub_nomerge'.  The test kernel corrupts the freepointer of one free
object on purpose.  Unfortunately, deactivate_slab() does not detect it
when iterating the freechain.

  BUG: unable to handle page fault for address: 00000000123456f8
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] SMP PTI
  ... ...
  RIP: 0010:deactivate_slab.isra.92+0xed/0x490
  ... ...
  Call Trace:
   ___slab_alloc+0x536/0x570
   __slab_alloc+0x17/0x30
   __kmalloc+0x1d9/0x200
   ext4_htree_store_dirent+0x30/0xf0
   htree_dirblock_to_tree+0xcb/0x1c0
   ext4_htree_fill_tree+0x1bc/0x2d0
   ext4_readdir+0x54f/0x920
   iterate_dir+0x88/0x190
   __x64_sys_getdents+0xa6/0x140
   do_syscall_64+0x49/0x170
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

Therefore, this patch adds extra consistency check in deactivate_slab().
Once an object's freepointer is corrupted, all following objects
starting at this object are isolated.

[akpm@linux-foundation.org: fix build with CONFIG_SLAB_DEBUG=n]
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Jin <joe.jin@oracle.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Link: http://lkml.kernel.org/r/20200331031450.12182-1-dongli.zhang@oracle.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slub.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index 8807a0c98a675..66b7987129337 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -658,6 +658,20 @@ static void slab_fix(struct kmem_cache *s, char *fmt, ...)
 	va_end(args);
 }
 
+static bool freelist_corrupted(struct kmem_cache *s, struct page *page,
+			       void *freelist, void *nextfree)
+{
+	if ((s->flags & SLAB_CONSISTENCY_CHECKS) &&
+	    !check_valid_pointer(s, page, nextfree)) {
+		object_err(s, page, freelist, "Freechain corrupt");
+		freelist = NULL;
+		slab_fix(s, "Isolate corrupted freechain");
+		return true;
+	}
+
+	return false;
+}
+
 static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
 {
 	unsigned int off;	/* Offset of last byte */
@@ -1339,6 +1353,11 @@ static inline void inc_slabs_node(struct kmem_cache *s, int node,
 static inline void dec_slabs_node(struct kmem_cache *s, int node,
 							int objects) {}
 
+static bool freelist_corrupted(struct kmem_cache *s, struct page *page,
+			       void *freelist, void *nextfree)
+{
+	return false;
+}
 #endif /* CONFIG_SLUB_DEBUG */
 
 /*
@@ -2029,6 +2048,14 @@ static void deactivate_slab(struct kmem_cache *s, struct page *page,
 		void *prior;
 		unsigned long counters;
 
+		/*
+		 * If 'nextfree' is invalid, it is possible that the object at
+		 * 'freelist' is already corrupted.  So isolate all objects
+		 * starting at 'freelist'.
+		 */
+		if (freelist_corrupted(s, page, freelist, nextfree))
+			break;
+
 		do {
 			prior = page->freelist;
 			counters = page->counters;
-- 
2.25.1



