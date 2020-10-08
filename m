Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB77A287F2A
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 01:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731038AbgJHXeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 19:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbgJHXet (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Oct 2020 19:34:49 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B31C0613D2
        for <stable@vger.kernel.org>; Thu,  8 Oct 2020 16:34:49 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id p11so3548120pld.5
        for <stable@vger.kernel.org>; Thu, 08 Oct 2020 16:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MRZxCY82VT8AbmDDW9cNgiSjhXieUNCL4lvDa6bH9cQ=;
        b=k2l02j+qVTgPRzl0YEB+iSSs1OzEALMQl31r6XgVZU/yO4vFIlyi/eqIIu/eZ2jIXL
         oD6Ai7UmXysgGKc6ayu+h5ZHYMxGqlk/cmIoX3T89xR0Ad7c3hY+n5cJC1Kv4L8ZAc3l
         5J341dy3JiQZ5XmfItqHSYWmpOXA3bVvHSkpk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MRZxCY82VT8AbmDDW9cNgiSjhXieUNCL4lvDa6bH9cQ=;
        b=QpPv+5hBD7ejbVhWApvByotdmNIhhEZ2ZayIJL9L3qfCDNuV48ia18lhL67jq1XK5L
         4YIGfBjcUTsO656SSY/+xoTJbchEcwRtkVewMi5MnWduvv1irlNU2i/O68PZq/yF1lNs
         IOAi0vTWOIyCXwxbzhHQeOMGuxbRTMnf18pnSkEZkwpeuU9Zdl+1PC/k+XMAC1sjLzUE
         I8V3tVG+gTy9b7ptaV9Dn1p/7DHv27w4NeUtXSW7VkEAKmzkoGWNRL7kJplSISQDs6VH
         9RVMmDwfvNHE3HJmgctJW/6iuDwz6ei4ykdncYPLR01J/uk8lG5rlpDfmFgH5odzTS80
         r1WQ==
X-Gm-Message-State: AOAM531KVfr6gVkJAZX7/gzO20amYFBWha61qJl3QzFbNRbEMkcS0ehl
        gBrcJP3yEQkGiq8APcgHoEkQng==
X-Google-Smtp-Source: ABdhPJyexpe9/8XvCs+4d0A3Z2MTbhqPh7RXZQkKLPSCe9cckWw8dLV1aj2qH4TGZOwGLSFuLsmsAw==
X-Received: by 2002:a17:902:8d8e:b029:d3:df0c:60a0 with SMTP id v14-20020a1709028d8eb02900d3df0c60a0mr9331844plo.35.1602200088961;
        Thu, 08 Oct 2020 16:34:48 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id c21sm8660051pfo.139.2020.10.08.16.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 16:34:48 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Kees Cook <keescook@chromium.org>, Marco Elver <elver@google.com>,
        stable@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] slub: Actually fix freelist pointer vs redzoning
Date:   Thu,  8 Oct 2020 16:34:43 -0700
Message-Id: <20201008233443.3335464-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It turns out that SLUB redzoning ("slub_debug=Z") checks from
s->object_size rather than from s->inuse (which is normally bumped to
make room for the freelist pointer), so a cache created with an object
size less than 24 would have their freelist pointer written beyond
s->object_size, causing the redzone to corrupt the freelist pointer.
This was very visible with "slub_debug=ZF":

BUG test (Tainted: G    B            ): Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff957ead1c05de-0xffff957ead1c05df @offset=1502. First byte 0x1a instead of 0xbb
INFO: Slab 0xffffef3950b47000 objects=170 used=170 fp=0x0000000000000000 flags=0x8000000000000200
INFO: Object 0xffff957ead1c05d8 @offset=1496 fp=0xffff957ead1c0620

Redzone (____ptrval____): bb bb bb bb bb bb bb bb               ........
Object  (____ptrval____): 00 00 00 00 00 f6 f4 a5               ........
Redzone (____ptrval____): 40 1d e8 1a aa                        @....
Padding (____ptrval____): 00 00 00 00 00 00 00 00               ........

Adjust the offset to stay within s->object_size.

(Note that there appear to be no such small-sized caches in the kernel
currently.)

Reported-by: Marco Elver <elver@google.com>
Link: https://lore.kernel.org/linux-mm/20200807160627.GA1420741@elver.google.com/
Fixes: 89b83f282d8b (slub: avoid redzone when choosing freepointer location)
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 mm/slub.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 68c02b2eecd9..979f5da26992 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3641,7 +3641,6 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 {
 	slab_flags_t flags = s->flags;
 	unsigned int size = s->object_size;
-	unsigned int freepointer_area;
 	unsigned int order;
 
 	/*
@@ -3650,13 +3649,6 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
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
@@ -3682,7 +3674,7 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 
 	/*
 	 * With that we have determined the number of bytes in actual use
-	 * by the object. This is the potential offset to the free pointer.
+	 * by the object and redzoning.
 	 */
 	s->inuse = size;
 
@@ -3694,7 +3686,8 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 		 * kmem_cache_free.
 		 *
 		 * This is the case if we do RCU, have a constructor or
-		 * destructor or are poisoning the objects.
+		 * destructor, are poisoning the objects, or are
+		 * redzoning an object smaller than sizeof(void *).
 		 *
 		 * The assumption that s->offset >= s->inuse means free
 		 * pointer is outside of the object is used in the
@@ -3703,13 +3696,13 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
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

