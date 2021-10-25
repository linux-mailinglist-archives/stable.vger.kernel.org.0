Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C74843A2ED
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbhJYTyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:54:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236287AbhJYTvk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:51:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADE9360EBB;
        Mon, 25 Oct 2021 19:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190999;
        bh=mOvEVNxYNRl/ZN/MGAHnucol57wjejix5RQ3HlnnpRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uaQCdPrsrPY9KxyRBBjS/+6sk0M0OuFFu5lRbOwNz31dCW47rfKlyLL3LBqvQMua0
         CjY+/Fewb6930JbWL57G5FwUkRZGZwQWIXBof5DFo3zN9l/3cJarfUVvOZD+JIiKOw
         RPV2ZKrqYwe4VUQVPG6/ef2WPtmkW6M6YGLYnUwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Faiyaz Mohammed <faiyazm@codeaurora.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Kees Cook <keescook@chromium.org>,
        Pekka Enberg <penberg@kernel.org>,
        Roman Gushchin <guro@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.14 103/169] mm, slub: fix incorrect memcg slab count for bulk free
Date:   Mon, 25 Oct 2021 21:14:44 +0200
Message-Id: <20211025191031.038078156@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

commit 3ddd60268c24bcac9d744404cc277e9dc52fe6b6 upstream.

kmem_cache_free_bulk() will call memcg_slab_free_hook() for all objects
when doing bulk free.  So we shouldn't call memcg_slab_free_hook() again
for bulk free to avoid incorrect memcg slab count.

Link: https://lkml.kernel.org/r/20210916123920.48704-6-linmiaohe@huawei.com
Fixes: d1b2cf6cb84a ("mm: memcg/slab: uncharge during kmem_cache_free_bulk()")
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3173,7 +3173,9 @@ static __always_inline void do_slab_free
 	struct kmem_cache_cpu *c;
 	unsigned long tid;
 
-	memcg_slab_free_hook(s, &head, 1);
+	/* memcg_slab_free_hook() is already called for bulk free. */
+	if (!tail)
+		memcg_slab_free_hook(s, &head, 1);
 redo:
 	/*
 	 * Determine the currently cpus per cpu slab.


