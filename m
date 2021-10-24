Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7DD4388BE
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 13:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbhJXLzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 07:55:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229867AbhJXLzy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 Oct 2021 07:55:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFC4260EBD;
        Sun, 24 Oct 2021 11:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635076414;
        bh=xFTl1FaNN8PW90boVgFgGtwSBxzb1R7y79iONkzR69Y=;
        h=Subject:To:Cc:From:Date:From;
        b=Jh23x8NG6aHGiFAEB1nhjOery/KMCjgmQSGGIzb4SDMl6VGUEpZPpOv/hIGie2Gbq
         jaq2H66apZg3gUleBxUlKQ33hBtWfX8J90LOpWanNlMCK3Z+qn2tRsqbLh28QN0AWr
         fIBhsQt05YKXigRqO2rnj9fzJWpD4MQOhrMsoa1I=
Subject: FAILED: patch "[PATCH] mm, slub: fix two bugs in slab_debug_trace_open()" failed to apply to 5.14-stable tree
To:     linmiaohe@huawei.com, akpm@linux-foundation.org,
        andreyknvl@gmail.com, bharata@linux.ibm.com, cl@linux.com,
        faiyazm@codeaurora.org, gregkh@linuxfoundation.org, guro@fb.com,
        iamjoonsoo.kim@lge.com, keescook@chromium.org, penberg@kernel.org,
        rientjes@google.com, ryabinin.a.a@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Oct 2021 13:53:32 +0200
Message-ID: <163507641218149@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2127d22509aec3a83dffb2a3c736df7ba747a7ce Mon Sep 17 00:00:00 2001
From: Miaohe Lin <linmiaohe@huawei.com>
Date: Mon, 18 Oct 2021 15:15:52 -0700
Subject: [PATCH] mm, slub: fix two bugs in slab_debug_trace_open()

Patch series "Fixups for slub".

This series contains various bug fixes for slub.  We fix memoryleak,
use-afer-free, NULL pointer dereferencing and so on in slub.  More
details can be found in the respective changelogs.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/slub.c b/mm/slub.c
index 3d2025f7163b..ed160b6c54f8 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6108,9 +6108,14 @@ static int slab_debug_trace_open(struct inode *inode, struct file *filep)
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
@@ -6119,6 +6124,7 @@ static int slab_debug_trace_open(struct inode *inode, struct file *filep)
 
 	if (!alloc_loc_track(t, PAGE_SIZE / sizeof(struct location), GFP_KERNEL)) {
 		bitmap_free(obj_map);
+		seq_release_private(inode, filep);
 		return -ENOMEM;
 	}
 

