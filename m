Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C8327C833
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730707AbgI2L7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:59:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730586AbgI2Lky (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:40:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10093207F7;
        Tue, 29 Sep 2020 11:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379649;
        bh=nRDPaV9puZECvmpAJ1pxKIa9voaWUssG0EnYs8bxZUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xz+LbBIGlBWHuPj5I6vVMT4ANPqV5r0LyWK3JIYlRtkE3jV60N/Xv3+nIidsf+QhN
         VfCe9QhSj1HEajBN68W+sdGsg58f1/eMs4VJrheDFqHdfbBdkptR6nwz5HT3E9CR1p
         iPgzkJJKVZIj2N60qh7WY2lZGJqewHVbaJAKv+js=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Kees Cook <keescook@chromium.org>,
        Rafael Aquini <aquini@redhat.com>,
        Christoph Lameter <cl@linux.com>,
        Vitaly Nikolenko <vnik@duasynt.com>,
        Silvio Cesare <silvio.cesare@gmail.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Markus Elfring <Markus.Elfring@web.de>,
        Changbin Du <changbin.du@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 250/388] mm/slub: fix incorrect interpretation of s->offset
Date:   Tue, 29 Sep 2020 12:59:41 +0200
Message-Id: <20200929110022.583512518@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

[ Upstream commit cbfc35a48609ceac978791e3ab9dde0c01f8cb20 ]

In a couple of places in the slub memory allocator, the code uses
"s->offset" as a check to see if the free pointer is put right after the
object.  That check is no longer true with commit 3202fa62fb43 ("slub:
relocate freelist pointer to middle of object").

As a result, echoing "1" into the validate sysfs file, e.g.  of dentry,
may cause a bunch of "Freepointer corrupt" error reports like the
following to appear with the system in panic afterwards.

  =============================================================================
  BUG dentry(666:pmcd.service) (Tainted: G    B): Freepointer corrupt
  -----------------------------------------------------------------------------

To fix it, use the check "s->offset == s->inuse" in the new helper
function freeptr_outside_object() instead.  Also add another helper
function get_info_end() to return the end of info block (inuse + free
pointer if not overlapping with object).

Fixes: 3202fa62fb43 ("slub: relocate freelist pointer to middle of object")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Rafael Aquini <aquini@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Vitaly Nikolenko <vnik@duasynt.com>
Cc: Silvio Cesare <silvio.cesare@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Markus Elfring <Markus.Elfring@web.de>
Cc: Changbin Du <changbin.du@gmail.com>
Link: http://lkml.kernel.org/r/20200429135328.26976-1-longman@redhat.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slub.c | 45 ++++++++++++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 15 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 822ba07245291..d69934eac9e94 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -533,15 +533,32 @@ static void print_section(char *level, char *text, u8 *addr,
 	metadata_access_disable();
 }
 
+/*
+ * See comment in calculate_sizes().
+ */
+static inline bool freeptr_outside_object(struct kmem_cache *s)
+{
+	return s->offset >= s->inuse;
+}
+
+/*
+ * Return offset of the end of info block which is inuse + free pointer if
+ * not overlapping with object.
+ */
+static inline unsigned int get_info_end(struct kmem_cache *s)
+{
+	if (freeptr_outside_object(s))
+		return s->inuse + sizeof(void *);
+	else
+		return s->inuse;
+}
+
 static struct track *get_track(struct kmem_cache *s, void *object,
 	enum track_item alloc)
 {
 	struct track *p;
 
-	if (s->offset)
-		p = object + s->offset + sizeof(void *);
-	else
-		p = object + s->inuse;
+	p = object + get_info_end(s);
 
 	return p + alloc;
 }
@@ -682,10 +699,7 @@ static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
 		print_section(KERN_ERR, "Redzone ", p + s->object_size,
 			s->inuse - s->object_size);
 
-	if (s->offset)
-		off = s->offset + sizeof(void *);
-	else
-		off = s->inuse;
+	off = get_info_end(s);
 
 	if (s->flags & SLAB_STORE_USER)
 		off += 2 * sizeof(struct track);
@@ -776,7 +790,7 @@ static int check_bytes_and_report(struct kmem_cache *s, struct page *page,
  * object address
  * 	Bytes of the object to be managed.
  * 	If the freepointer may overlay the object then the free
- * 	pointer is the first word of the object.
+ *	pointer is at the middle of the object.
  *
  * 	Poisoning uses 0x6b (POISON_FREE) and the last byte is
  * 	0xa5 (POISON_END)
@@ -810,11 +824,7 @@ static int check_bytes_and_report(struct kmem_cache *s, struct page *page,
 
 static int check_pad_bytes(struct kmem_cache *s, struct page *page, u8 *p)
 {
-	unsigned long off = s->inuse;	/* The end of info */
-
-	if (s->offset)
-		/* Freepointer is placed after the object. */
-		off += sizeof(void *);
+	unsigned long off = get_info_end(s);	/* The end of info */
 
 	if (s->flags & SLAB_STORE_USER)
 		/* We also have user information there */
@@ -900,7 +910,7 @@ static int check_object(struct kmem_cache *s, struct page *page,
 		check_pad_bytes(s, page, p);
 	}
 
-	if (!s->offset && val == SLUB_RED_ACTIVE)
+	if (!freeptr_outside_object(s) && val == SLUB_RED_ACTIVE)
 		/*
 		 * Object and freepointer overlap. Cannot check
 		 * freepointer while object is allocated.
@@ -3585,6 +3595,11 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 		 *
 		 * This is the case if we do RCU, have a constructor or
 		 * destructor or are poisoning the objects.
+		 *
+		 * The assumption that s->offset >= s->inuse means free
+		 * pointer is outside of the object is used in the
+		 * freeptr_outside_object() function. If that is no
+		 * longer true, the function needs to be modified.
 		 */
 		s->offset = size;
 		size += sizeof(void *);
-- 
2.25.1



