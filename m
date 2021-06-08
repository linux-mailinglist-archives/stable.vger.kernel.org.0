Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCAC3A0098
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234703AbhFHSpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:45:52 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:55950 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235296AbhFHSmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 14:42:53 -0400
Received: by mail-pj1-f49.google.com with SMTP id k7so12441031pjf.5
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 11:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Uwf15MYLwxoOU1qMfGZ6a+IKuws7ocGxDIxFsZ4OFug=;
        b=ZmhNQaEiRD+PqJ+xrZH8xI+iuIxofJdRY4W5A/5T7XGrwZdn/iYKbCqRjkoO6VyeJC
         8iOK+dhExpTRhmv1VGWbtvi9J6JBjS6DXHKz9T69rq+p+sdxt0rTvOPLXXk01OUb6R0U
         HTSYdglOuWFKjcdgHPtRlL5/e5zFab4FEbXZ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Uwf15MYLwxoOU1qMfGZ6a+IKuws7ocGxDIxFsZ4OFug=;
        b=TOuy8UmREWr/UZIkUog19RKNDSkJphzXvyGymDyMnzXFgRPptyTt7QT9zmsgrwpqHy
         GseAJBbMz774K0ZR85QPNrV4iwfmjplkqUQg4vGbWQ9qVQNs4j2hypDIQ9FQzo7+KvYl
         Veg6WwSAMxyhhTIIwFcVFbsvemXjdKBnXMiiSquBKQRvmQsNDYg2VCLWIQGbzK2Mv9bv
         rXqTPd5qqftiDIykyYJMgxWqfe/i1RWcRiVL2eropcL/9eWFdDkeraTIg45sOxIg2iXk
         /x928sURuHyrbwqn1cyiKVhaulYBrqCa7fDFbvd6SoBmcPiLSvTmpCTRzNLkAr6KtSG7
         IlIA==
X-Gm-Message-State: AOAM5306u4fHVuGLvdCqe6BAz3Nrx5Zv/Q59JCzF0cpFJboZEG655R6R
        kNlOMm0gljlcRbdgHDk2MUtmjw==
X-Google-Smtp-Source: ABdhPJyIRKmRRu2AYmJbx93jMDBAJ+npfATbrE3k5tSb2maqGENQ2XEQjv+jCNUyOXMkz7bKz3mtwA==
X-Received: by 2002:a17:90a:cf12:: with SMTP id h18mr26723016pju.131.1623177600473;
        Tue, 08 Jun 2021 11:40:00 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id x2sm6930010pfp.155.2021.06.08.11.39.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 11:39:58 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Kees Cook <keescook@chromium.org>, Marco Elver <elver@google.com>,
        "Lin, Zhenpeng" <zplin@psu.edu>, stable@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v4 3/3] mm/slub: Actually fix freelist pointer vs redzoning
Date:   Tue,  8 Jun 2021 11:39:55 -0700
Message-Id: <20210608183955.280836-4-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210608183955.280836-1-keescook@chromium.org>
References: <20210608183955.280836-1-keescook@chromium.org>
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=258aaf7fc047e39c606cfd78c6cb30ea0743ac4f; i=9r8xlkNM+5K11owYVXEwhB43FxFLIosDS833zHgjUAw=; m=Uy+f2vNqhL2FSdVsV3KF5XKnxC9QUfLtorR17aD8dZE=; p=6aeBvOTccD42eyT82fqBR4aM+xkklg7H28x6pgmR2f0=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmC/uXsACgkQiXL039xtwCZ8sw/5Aa5 oJlATMma0eyvLqBYz/VPZi0O91RhNhjLkzEC3UfMrsVk/DhG2h6PDnO70twLT2F4Pwq6BxupMP8xX vcQxlyw8m0wgL63mgczYCW2Y6zTP+nzGaTwjCY62voKzT/8KEaxt116eQTgveWgViqsdAU6KFDV7e xZDNsPPz8+y19OcDl4zHQUWmXkLOEComZnmT3AaNTHfbFRUn0k5NOpIK6vgB8mBQs0stN3PvBu6js 6Sr0L0eggxneKqkpFadWuW8cBlEXVHxGTqNxHgFFJv2GCWtCUsbSGqMhosJc05devWKzYSgzcjqUO +peNN+Ip7myqDGge3KlDRk9c5TMFxPpEsHrDfsBJHk5VGKn9JEEt5OoqGE2Iz3oVhaMfCuhJ+VB2S tWHHQqdBTHQOh4Ma96uEktGPlWhNGCnw+Z3Tyct6EjlnKQj/sRX+8xMGyn90p6UwXNhaE2ek1ulAC PBJeZOO9PhmVufmxx+WUUv7P5zV++PlVpIM3IWDiByHXwX8yO0z9qRN/ZTy/6LcpnVpb6YnFiRvAF N87lCQq+LykDFpMCpodukzVCgGB8+oilN7llyRY7j87jsg7Zip4MM5aEd/x8o7lcbIVJXJh7RbnzF OxZ3nLJT1mgwUg8HFsdx62qb8gFnNzT+idnsCTNZCiBxhtBlrXensTlmN+1wdsRA=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It turns out that SLUB redzoning ("slub_debug=Z") checks from
s->object_size rather than from s->inuse (which is normally bumped
to make room for the freelist pointer), so a cache created with an
object size less than 24 would have the freelist pointer written beyond
s->object_size, causing the redzone to be corrupted by the freelist
pointer. This was very visible with "slub_debug=ZF":

BUG test (Tainted: G    B            ): Right Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff957ead1c05de-0xffff957ead1c05df @offset=1502. First byte 0x1a instead of 0xbb
INFO: Slab 0xffffef3950b47000 objects=170 used=170 fp=0x0000000000000000 flags=0x8000000000000200
INFO: Object 0xffff957ead1c05d8 @offset=1496 fp=0xffff957ead1c0620

Redzone  (____ptrval____): bb bb bb bb bb bb bb bb               ........
Object   (____ptrval____): 00 00 00 00 00 f6 f4 a5               ........
Redzone  (____ptrval____): 40 1d e8 1a aa                        @....
Padding  (____ptrval____): 00 00 00 00 00 00 00 00               ........

Adjust the offset to stay within s->object_size.

(Note that no caches of in this size range are known to exist in the
kernel currently.)

Reported-by: Marco Elver <elver@google.com>
Reported-by: "Lin, Zhenpeng" <zplin@psu.edu>
Link: https://lore.kernel.org/linux-mm/20200807160627.GA1420741@elver.google.com/
Fixes: 89b83f282d8b (slub: avoid redzone when choosing freepointer location)
Cc: stable@vger.kernel.org
Tested-by: Marco Elver <elver@google.com>
Link: https://lore.kernel.org/lkml/CANpmjNOwZ5VpKQn+SYWovTkFB4VsT-RPwyENBmaK0dLcpqStkA@mail.gmail.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Link: https://lore.kernel.org/lkml/0f7dd7b2-7496-5e2d-9488-2ec9f8e90441@suse.cz/
---
 mm/slub.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index f58cfd456548..fe30df460fad 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3689,7 +3689,6 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 {
 	slab_flags_t flags = s->flags;
 	unsigned int size = s->object_size;
-	unsigned int freepointer_area;
 	unsigned int order;
 
 	/*
@@ -3698,13 +3697,6 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 	 * the possible location of the free pointer.
 	 */
 	size = ALIGN(size, sizeof(void *));
-	/*
-	 * This is the area of the object where a freepointer can be
-	 * safely written. If redzoning adds more to the inuse size, we
-	 * can't use that portion for writing the freepointer, so
-	 * s->offset must be limited within this for the general case.
-	 */
-	freepointer_area = size;
 
 #ifdef CONFIG_SLUB_DEBUG
 	/*
@@ -3730,7 +3722,7 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 
 	/*
 	 * With that we have determined the number of bytes in actual use
-	 * by the object. This is the potential offset to the free pointer.
+	 * by the object and redzoning.
 	 */
 	s->inuse = size;
 
@@ -3753,13 +3745,13 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 		 */
 		s->offset = size;
 		size += sizeof(void *);
-	} else if (freepointer_area > sizeof(void *)) {
+	} else {
 		/*
 		 * Store freelist pointer near middle of object to keep
 		 * it away from the edges of the object to avoid small
 		 * sized over/underflows from neighboring allocations.
 		 */
-		s->offset = ALIGN(freepointer_area / 2, sizeof(void *));
+		s->offset = ALIGN_DOWN(s->object_size / 2, sizeof(void *));
 	}
 
 #ifdef CONFIG_SLUB_DEBUG
-- 
2.25.1

