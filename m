Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2DAA43A2B8
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236156AbhJYTvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:51:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237015AbhJYTtk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:49:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A569961248;
        Mon, 25 Oct 2021 19:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190913;
        bh=5p8bZG8z4p9WGxRfQLTTQFOry9/dc9pJK+hpBQ75HDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wm+GCXtf3BN8nO+g0EDOzPMiXQsuYTVDmENo3GqP+HvNwCz0hi7VWciliEHIy6r2+
         JTUdSsT3RVjmBpEKGaVgEwv+CF0zHD3DkBBr60M2BV6IjzW0V3X76oqWIMjsFEUDTK
         gTpEj6pTq13u95MNtz8KPzUigKGDQip7VINQggpI=
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
Subject: [PATCH 5.14 100/169] mm, slub: fix mismatch between reconstructed freelist depth and cnt
Date:   Mon, 25 Oct 2021 21:14:41 +0200
Message-Id: <20211025191030.534001211@linuxfoundation.org>
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

commit 899447f669da76cc3605665e1a95ee877bc464cc upstream.

If object's reuse is delayed, it will be excluded from the reconstructed
freelist.  But we forgot to adjust the cnt accordingly.  So there will
be a mismatch between reconstructed freelist depth and cnt.  This will
lead to free_debug_processing() complaining about freelist count or a
incorrect slub inuse count.

Link: https://lkml.kernel.org/r/20210916123920.48704-3-linmiaohe@huawei.com
Fixes: c3895391df38 ("kasan, slub: fix handling of kasan_slab_free hook")
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
 mm/slub.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1629,7 +1629,8 @@ static __always_inline bool slab_free_ho
 }
 
 static inline bool slab_free_freelist_hook(struct kmem_cache *s,
-					   void **head, void **tail)
+					   void **head, void **tail,
+					   int *cnt)
 {
 
 	void *object;
@@ -1656,6 +1657,12 @@ static inline bool slab_free_freelist_ho
 			*head = object;
 			if (!*tail)
 				*tail = object;
+		} else {
+			/*
+			 * Adjust the reconstructed freelist depth
+			 * accordingly if object's reuse is delayed.
+			 */
+			--(*cnt);
 		}
 	} while (object != old_tail);
 
@@ -3210,7 +3217,7 @@ static __always_inline void slab_free(st
 	 * With KASAN enabled slab_free_freelist_hook modifies the freelist
 	 * to remove objects, whose reuse must be delayed.
 	 */
-	if (slab_free_freelist_hook(s, &head, &tail))
+	if (slab_free_freelist_hook(s, &head, &tail, &cnt))
 		do_slab_free(s, page, head, tail, cnt, addr);
 }
 


