Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0514329A8
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 00:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233591AbhJRWSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 18:18:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhJRWSP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 18:18:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21C896112D;
        Mon, 18 Oct 2021 22:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634595363;
        bh=rQIaCPmTfVKa5eoipEl2gYNrJeNe//O9B9GN311CNKk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZiL/jubMikQD70xUHl2sr3AAEKNK/3jfiWi8mQ5SAx43j94JIcd5F72it1JHyszm7
         fb02+3P+F5HQ8OWA+Yq1AKHKIjEzILw2Bqi0N+qUy3AjShIQjBokBeojWznKvHJDBL
         lSCynKHj5Kse7o2+3oB9FGLkxeWWuq+Bv5SPHB9Q=
Date:   Mon, 18 Oct 2021 15:16:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        bharata@linux.ibm.com, cl@linux.com, faiyazm@codeaurora.org,
        gregkh@linuxfoundation.org, guro@fb.com, iamjoonsoo.kim@lge.com,
        keescook@chromium.org, linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, ryabinin.a.a@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 13/19] mm, slub: fix potential use-after-free in
 slab_debugfs_fops
Message-ID: <20211018221602.L12GIMrUl%akpm@linux-foundation.org>
In-Reply-To: <20211018151438.f2246e2656c041b6753a8bdd@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm, slub: fix potential use-after-free in slab_debugfs_fops

When sysfs_slab_add failed, we shouldn't call debugfs_slab_add() for s
because s will be freed soon.  And slab_debugfs_fops will use s later
leading to a use-after-free.

Link: https://lkml.kernel.org/r/20210916123920.48704-5-linmiaohe@huawei.com
Fixes: 64dd68497be7 ("mm: slub: move sysfs slab alloc/free interfaces to debugfs")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Bharata B Rao <bharata@linux.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Faiyaz Mohammed <faiyazm@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/slub.c~mm-slub-fix-potential-use-after-free-in-slab_debugfs_fops
+++ a/mm/slub.c
@@ -4887,13 +4887,15 @@ int __kmem_cache_create(struct kmem_cach
 		return 0;
 
 	err = sysfs_slab_add(s);
-	if (err)
+	if (err) {
 		__kmem_cache_release(s);
+		return err;
+	}
 
 	if (s->flags & SLAB_STORE_USER)
 		debugfs_slab_add(s);
 
-	return err;
+	return 0;
 }
 
 void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, unsigned long caller)
_
