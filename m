Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5390E3B8498
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 16:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235594AbhF3OEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 10:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236419AbhF3OEb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 10:04:31 -0400
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719C2C09B098
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 06:53:24 -0700 (PDT)
Received: by mail-wm1-x349.google.com with SMTP id z4-20020a1ce2040000b02901ee8d8e151eso2887180wmg.1
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 06:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+15b98OXWiOrEiKCGfnfeWun+23tJxDlHH/wqzYj+20=;
        b=WXi9U1Vip4zaz3uBNoqN8a2omyzEGIgwOHLP1ooDckRXK/3CMYy03EQAgTTOXhOVsW
         jmdHZZ/yF5Ox7Fm9TusoCFGZ0KQvVrQD8c0rnGTiyFQ5kYC/sOYOD8RhHBbipYvQbkua
         hbATd9xyZ/oofzWhQ8fJ7n2GYJpKXKgTNuIMJvXeJKLcEiWZqt4oH73eDwErt19gObFj
         ePK7x/B/Ih4lHpv4jC71OibbjGzGJnOtWFBhjgCiOsYOdkloQyCxlTiyVmI87HqAC84k
         5hnGD95dAdkRHC2aMiJXl0S33hgVvZJ0D7hXugZAczLXqj4T1Pd3i6XgmT6Mspy8gKv5
         hxBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+15b98OXWiOrEiKCGfnfeWun+23tJxDlHH/wqzYj+20=;
        b=O7hQJR1qs2a6yHiCiOh4/uy5uqfk6USy1DZpDCvlDWZAwBHO8ChUIAywi8bH8wCTol
         r48G3B5O49/KDMrHiL2NdADpxOlbYUAAgroMt/XyDFEAHpR4p0wzY+440LxsvMDoTCZ5
         KinR+4djv1PF7XrJsLZO93Ep3h+GooVX1f7YvRyXWSDRcRaGGuYj3FEmTTqrlsD5dhDa
         9Wv0FZGn/UQ38iFO0WeAx+YnXxxpVfeJJDCOsdHYS7sC4AZEAckNrYNukNzdUZckc+kZ
         Ak9HNLoiiSpcR0PkUDDTqtv/Vfev5AB/32X4uuJnSwtPzDV7URxTHLzsVo6wWg9kYtkg
         iPjg==
X-Gm-Message-State: AOAM530e7Py9kuxCyohQI0U6FUaw/FI0cpwMHAJrzHFvCe/nSInoDtKw
        HxZLYh6NrizmQgtIcM91ArvAa6CtqiY=
X-Google-Smtp-Source: ABdhPJwZS4PQ4Qo0dgN0XnUOHZBFG5LDZXGSPSb4r9wuy4xppmcnGhAYbCV0/Tahu7HBzZ78p13B8Ltwwjo=
X-Received: from glider.muc.corp.google.com ([2a00:79e0:15:13:a3fc:e8:8089:1013])
 (user=glider job=sendgmr) by 2002:a05:600c:3504:: with SMTP id
 h4mr4860507wmq.118.1625061203035; Wed, 30 Jun 2021 06:53:23 -0700 (PDT)
Date:   Wed, 30 Jun 2021 15:53:13 +0200
In-Reply-To: <20210630135313.1072577-1-glider@google.com>
Message-Id: <20210630135313.1072577-2-glider@google.com>
Mime-Version: 1.0
References: <20210630135313.1072577-1-glider@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v3 2/2] kfence: skip all GFP_ZONEMASK allocations
From:   Alexander Potapenko <glider@google.com>
To:     akpm@linux-foundation.org
Cc:     dvyukov@google.com, elver@google.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org,
        gregkh@linuxfoundation.org, jrdr.linux@gmail.com,
        Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Allocation requests outside ZONE_NORMAL (MOVABLE, HIGHMEM or DNA) cannot
be fulfilled by KFENCE, because KFENCE memory pool is located in a
zone different from the requested one.

Because callers of kmem_cache_alloc() may actually rely on the
allocation to reside in the requested zone (e.g. memory allocations done
with __GFP_DMA must be DMAable), skip all allocations done with
GFP_ZONEMASK and/or respective SLAB flags (SLAB_CACHE_DMA and
SLAB_CACHE_DMA32).

Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Cc: stable@vger.kernel.org # 5.12+
Signed-off-by: Alexander Potapenko <glider@google.com>

---

v2:
 - added parentheses around the GFP clause, as requested by Marco
v3:
 - ignore GFP_ZONEMASK, which also covers __GFP_HIGHMEM and __GFP_MOVABLE
 - move the flag check at the beginning of the function, as requested by
   Souptick Joarder
---
 mm/kfence/core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 33bb20d91bf6a..d51f77329fd3c 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -740,6 +740,14 @@ void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags)
 	if (size > PAGE_SIZE)
 		return NULL;
 
+	/*
+	 * Skip allocations from non-default zones, including DMA. We cannot guarantee that pages
+	 * in the KFENCE pool will have the requested properties (e.g. reside in DMAable memory).
+	 */
+	if ((flags & GFP_ZONEMASK) ||
+	    (s->flags & (SLAB_CACHE_DMA | SLAB_CACHE_DMA32)))
+		return NULL;
+
 	/*
 	 * allocation_gate only needs to become non-zero, so it doesn't make
 	 * sense to continue writing to it and pay the associated contention
-- 
2.32.0.93.g670b81a890-goog

