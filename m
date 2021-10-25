Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C2043A15E
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236550AbhJYTiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:38:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235172AbhJYTfh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:35:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D1A86109D;
        Mon, 25 Oct 2021 19:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190373;
        bh=WouTT5nKQHmeccXdB8dVONW/Be3x973bW5UTCRq4lcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=104yymZbjnb1dOprZsUCfWWJgViXDAKpS5IhKNToZ2/0En22iOr074aaZ5kArO5yn
         EZNAihQ4PXCMCmRUPIrYEMCfr0KzS+T/1OF9mJBzXzP96y9l7RZVFKxrjgZB/JcSO9
         o1JeEPzKxfJriN59HyzvVu/69o7QtizmxVay4r64=
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
Subject: [PATCH 5.10 59/95] mm, slub: fix mismatch between reconstructed freelist depth and cnt
Date:   Mon, 25 Oct 2021 21:14:56 +0200
Message-Id: <20211025191005.502876648@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
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
@@ -1543,7 +1543,8 @@ static __always_inline bool slab_free_ho
 }
 
 static inline bool slab_free_freelist_hook(struct kmem_cache *s,
-					   void **head, void **tail)
+					   void **head, void **tail,
+					   int *cnt)
 {
 
 	void *object;
@@ -1578,6 +1579,12 @@ static inline bool slab_free_freelist_ho
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
 
@@ -3137,7 +3144,7 @@ static __always_inline void slab_free(st
 	 * With KASAN enabled slab_free_freelist_hook modifies the freelist
 	 * to remove objects, whose reuse must be delayed.
 	 */
-	if (slab_free_freelist_hook(s, &head, &tail))
+	if (slab_free_freelist_hook(s, &head, &tail, &cnt))
 		do_slab_free(s, page, head, tail, cnt, addr);
 }
 


