Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8B84329A5
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 00:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbhJRWSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 18:18:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhJRWSF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 18:18:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7349610FB;
        Mon, 18 Oct 2021 22:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634595353;
        bh=U0Actcc/OSh9cQh2yHQNzWE9Mg940651b9NgdX1qHss=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zJOpAmT44JuMJ3erkV5blFnpiD6yVVfQRRTiadnsZbEDPiuwl/nGrSZx274W4lLAi
         gNrwmT79y2NW+FRqyV+HPsywhwzhVu00iPMzt8kO0Hifj7eaca8fxuuRWsWLd3mQjc
         X9/AabEHdn2oKxjPWpt9wZfMAsQOOGvvaxARsBho=
Date:   Mon, 18 Oct 2021 15:15:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        bharata@linux.ibm.com, cl@linux.com, faiyazm@codeaurora.org,
        gregkh@linuxfoundation.org, guro@fb.com, iamjoonsoo.kim@lge.com,
        keescook@chromium.org, linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, ryabinin.a.a@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 10/19] mm, slub: fix two bugs in
 slab_debug_trace_open()
Message-ID: <20211018221552.EuQq8HNNO%akpm@linux-foundation.org>
In-Reply-To: <20211018151438.f2246e2656c041b6753a8bdd@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm, slub: fix two bugs in slab_debug_trace_open()

Patch series "Fixups for slub".

This series contains various bug fixes for slub.  We fix memoryleak,
use-afer-free, NULL pointer dereferencing and so on in slub.  More details
can be found in the respective changelogs.


This patch (of 5):

It's possible that __seq_open_private() will return NULL.  So we should
check it before using lest dereferencing NULL pointer.  And in error
paths, we forgot to release private buffer via seq_release_private(). 
Memory will leak in these paths.

Link: https://lkml.kernel.org/r/20210916123920.48704-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210916123920.48704-2-linmiaohe@huawei.com
Fixes: 64dd68497be7 ("mm: slub: move sysfs slab alloc/free interfaces to debugfs")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Faiyaz Mohammed <faiyazm@codeaurora.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Bharata B Rao <bharata@linux.ibm.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-fix-two-bugs-in-slab_debug_trace_open
+++ a/mm/slub.c
@@ -6108,9 +6108,14 @@ static int slab_debug_trace_open(struct
 	struct kmem_cache *s = file_inode(filep)->i_private;
 	unsigned long *obj_map;
 
+	if (!t)
+		return -ENOMEM;
+
 	obj_map = bitmap_alloc(oo_objects(s->oo), GFP_KERNEL);
-	if (!obj_map)
+	if (!obj_map) {
+		seq_release_private(inode, filep);
 		return -ENOMEM;
+	}
 
 	if (strcmp(filep->f_path.dentry->d_name.name, "alloc_traces") == 0)
 		alloc = TRACK_ALLOC;
@@ -6119,6 +6124,7 @@ static int slab_debug_trace_open(struct
 
 	if (!alloc_loc_track(t, PAGE_SIZE / sizeof(struct location), GFP_KERNEL)) {
 		bitmap_free(obj_map);
+		seq_release_private(inode, filep);
 		return -ENOMEM;
 	}
 
_
