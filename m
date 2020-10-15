Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDE828EBA0
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 05:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387621AbgJODhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 23:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729105AbgJODhR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 23:37:17 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BE2C061755
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 20:37:17 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id c20so1124307pfr.8
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 20:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SurWNoEuD6TTtB4XFp88vfsS4MGv6DgcHJa9LNU4sRM=;
        b=cSRzfwSvHvjyHkoYE/K38T5Ur3yGQeAFQ/A0BVo05yNGOGjLBV7RmE2tnUgaWIJZcm
         gJCezP1zrirgCcF787B66uPhC8K1r2moXDD1eVOS3GEn7XGMiaIh5afWbiuFJbQx7EDS
         fTDqiysEC79UP8Y/HxFBu2Q2r7ifekHzFspcE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SurWNoEuD6TTtB4XFp88vfsS4MGv6DgcHJa9LNU4sRM=;
        b=t41mRIAzm3G2STob6AKZCAtUhz6ci2T6BfbmyKaTC2yh9U2KtzaPI7ymt/p8ha8OX8
         DGvL+egPhrv49fhxdS9T1WAlGueLlRAjnziZf00cEj4+47hjIj5w49/kc0N0D5p8N8sl
         2MY99YZXcJA13StWdX0IUHMCyJlt9e1CUdZ/BKV25IieLrLNQpNFeQxcrMcIxGPCrW2o
         9yD6AhPTk4Rpgo7aWbwkT/qGAKX95H86AJVrcx3oBp7OiOVaRnJG+1HIOtY7Z99yjvcS
         75SaIf9UZd1+ItdN6ChtheWBvyGCpwreR7hG568IKEEmMMdkYWtwvLFSIKJ1Nj6mO1xE
         ueeg==
X-Gm-Message-State: AOAM533pgPGjl54U2rsxxN2FrvbtayBzpXM7+PujHNnxcZdXMma0wLEP
        LJIGFTQdUUoR7u2BJ51+LdyVIQ==
X-Google-Smtp-Source: ABdhPJxtMQurAs24PVDe3ClRON3VZXKCxnFyNNGqQxzQkVllW9GeD0AsKT82EWzmD3Jg8GfZs9INug==
X-Received: by 2002:a63:5c5e:: with SMTP id n30mr1749232pgm.54.1602733036990;
        Wed, 14 Oct 2020 20:37:16 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t6sm1204756pfl.50.2020.10.14.20.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 20:37:14 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Kees Cook <keescook@chromium.org>, Marco Elver <elver@google.com>,
        stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Christoph Lameter <cl@linux.com>,
        Waiman Long <longman@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v3 3/3] mm/slub: Actually fix freelist pointer vs redzoning
Date:   Wed, 14 Oct 2020 20:37:12 -0700
Message-Id: <20201015033712.1491731-4-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201015033712.1491731-1-keescook@chromium.org>
References: <20201015033712.1491731-1-keescook@chromium.org>
MIME-Version: 1.0
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

(Note that no caches in this size range are known to exist in the kernel
currently.)

Reported-by: Marco Elver <elver@google.com>
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
index 752fad36522c..6f115e56c5d0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3637,7 +3637,6 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 {
 	slab_flags_t flags = s->flags;
 	unsigned int size = s->object_size;
-	unsigned int freepointer_area;
 	unsigned int order;
 
 	/*
@@ -3646,13 +3645,6 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
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
@@ -3678,7 +3670,7 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 
 	/*
 	 * With that we have determined the number of bytes in actual use
-	 * by the object. This is the potential offset to the free pointer.
+	 * by the object and redzoning.
 	 */
 	s->inuse = size;
 
@@ -3701,13 +3693,13 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
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

