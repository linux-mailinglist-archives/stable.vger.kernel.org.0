Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A29D4388B5
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 13:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhJXLy5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 07:54:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229867AbhJXLy5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 Oct 2021 07:54:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67E4060E0C;
        Sun, 24 Oct 2021 11:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635076356;
        bh=aa8AOqLgBGhjPTf6XREqfAlyc/nEylHSCGEaYqwcnSs=;
        h=Subject:To:Cc:From:Date:From;
        b=G3fXSvNX6Rj7YA6JAFs+jcAIKOp0ucMIGarjI4U95DEzmdJYmW3wyF9RqIEqaia6M
         D/h3iipMPflbmRfaxEbOyD5BlcyAUOTVmL+poygoGQD9m3xi+zFdz1hQZzpzbkCJpI
         OqHofjc4yt6W+BuQguNxOW0p5s0CmfbPDneokpTA=
Subject: FAILED: patch "[PATCH] mm, slub: fix potential memoryleak in kmem_cache_open()" failed to apply to 4.19-stable tree
To:     linmiaohe@huawei.com, akpm@linux-foundation.org,
        andreyknvl@gmail.com, bharata@linux.ibm.com, cl@linux.com,
        faiyazm@codeaurora.org, gregkh@linuxfoundation.org, guro@fb.com,
        iamjoonsoo.kim@lge.com, keescook@chromium.org, penberg@kernel.org,
        rientjes@google.com, ryabinin.a.a@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Oct 2021 13:52:34 +0200
Message-ID: <163507635420184@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9037c57681d25e4dcc442d940d6dbe24dd31f461 Mon Sep 17 00:00:00 2001
From: Miaohe Lin <linmiaohe@huawei.com>
Date: Mon, 18 Oct 2021 15:15:59 -0700
Subject: [PATCH] mm, slub: fix potential memoryleak in kmem_cache_open()

In error path, the random_seq of slub cache might be leaked.  Fix this
by using __kmem_cache_release() to release all the relevant resources.

Link: https://lkml.kernel.org/r/20210916123920.48704-4-linmiaohe@huawei.com
Fixes: 210e7a43fa90 ("mm: SLUB freelist randomization")
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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/slub.c b/mm/slub.c
index a56a6423d4e8..bf1793fb4ce5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4210,8 +4210,8 @@ static int kmem_cache_open(struct kmem_cache *s, slab_flags_t flags)
 	if (alloc_kmem_cache_cpus(s))
 		return 0;
 
-	free_kmem_cache_nodes(s);
 error:
+	__kmem_cache_release(s);
 	return -EINVAL;
 }
 

