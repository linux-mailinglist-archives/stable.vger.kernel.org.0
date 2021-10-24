Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8734388BB
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 13:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhJXLzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 07:55:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229867AbhJXLzF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 Oct 2021 07:55:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C941C60E0C;
        Sun, 24 Oct 2021 11:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635076365;
        bh=RIC1oo4P/oClRU7OeLoVFF3j26qQvxTZxjCSaAB2Kgo=;
        h=Subject:To:Cc:From:Date:From;
        b=D9vzYa5m6WUgKQeJprDntnFud/KF7pQvw1Syuan1joe78u3ROJgbeO/EL+xR7Hw5a
         UnSfsgiNlMKgtMTk81Yc52zhwrFtZKclKb+GOGUZajOZJoSgsR9m3qAP4iLlZJgdgy
         PfWnJiX+0Xdc0pEZH0gjcbA59V9BWQM6ebs/xvsM=
Subject: FAILED: patch "[PATCH] mm, slub: fix potential memoryleak in kmem_cache_open()" failed to apply to 4.14-stable tree
To:     linmiaohe@huawei.com, akpm@linux-foundation.org,
        andreyknvl@gmail.com, bharata@linux.ibm.com, cl@linux.com,
        faiyazm@codeaurora.org, gregkh@linuxfoundation.org, guro@fb.com,
        iamjoonsoo.kim@lge.com, keescook@chromium.org, penberg@kernel.org,
        rientjes@google.com, ryabinin.a.a@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Oct 2021 13:52:35 +0200
Message-ID: <163507635563191@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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
 

