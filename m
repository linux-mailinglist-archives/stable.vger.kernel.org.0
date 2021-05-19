Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B10388848
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 09:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240604AbhESHo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 03:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240620AbhESHox (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 03:44:53 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBB1C061760
        for <stable@vger.kernel.org>; Wed, 19 May 2021 00:43:32 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id x8so12872858wrq.9
        for <stable@vger.kernel.org>; Wed, 19 May 2021 00:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XREiNZvCt6m1Dz1Oz10kerKOA32xyw0gcDqrFl0Jar4=;
        b=YhbZIvlwlURfAY2JJWuFzVGxB9Q6qk/356Juc+n9uPixFDUJtEab9cjJ4rMEoq7RPu
         YkLCt0La26xbLf/28C/O6O7EXaUiroCs0qN+IIU8fHVXvNQ2ejJdrrm/wpaBWUAvoYw6
         ZwDR3gFKoVWA56fRO/9uoZhA4GaqqLwpsm/t0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XREiNZvCt6m1Dz1Oz10kerKOA32xyw0gcDqrFl0Jar4=;
        b=d/QUH60NmkFZiyeTtgs9k3sfFZItMAVKzK2e4xaZ0scYN3Fcaq0OK4+V8wryh96J2A
         pXunfOjGWdx+1p19gk6d4B/uPZzDJ5U+Wrm1NJWjszGHKQ44jVJPRAmqYelI1MubmZN6
         FeRkGIHSSpwFmYiznVQXoTDuoUD9H2A18yOdTq8jTVEz0U4tGR4RrkXPA6Vv4fxk+6Qj
         ZBae81CpyzL+uQbFvV7KOiD6H0sIE/tu30d6snlkuFpcuYpgavNrvbd0ZFOGJ/e9jBLL
         Oz4BVHJfFvRUcGSmIickjGIQC3VeamTiN9RhUim5vGa/hSdRpqx7eVBwEcTg/0P4AGhN
         lYlQ==
X-Gm-Message-State: AOAM532UDN/DlODbWYa++iIt40E6FkHlnuWq+shhIJqEo1VDB15ypLDs
        /ZmGaN+GYT5caSBLhMO/18JoRA==
X-Google-Smtp-Source: ABdhPJz8JhBGQu/oYkUVZ03JmiiNYW+/5RKbEJ8XJyjhgFE0mMNWQ6MBSBe4JIXo63fHTQldZkVr8w==
X-Received: by 2002:a5d:4a4f:: with SMTP id v15mr12954340wrs.154.1621410211567;
        Wed, 19 May 2021 00:43:31 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id h13sm21189986wml.26.2021.05.19.00.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 00:43:31 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Cc:     Jason Ekstrand <jason@jlekstrand.net>,
        Jason Ekstrand <jason.ekstrand@intel.com>,
        Marcin Slusarz <marcin.slusarz@intel.com>,
        stable@vger.kernel.org, Jon Bloomfield <jon.bloomfield@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 2/2] Revert "drm/i915: Propagate errors on awaiting already signaled fences"
Date:   Wed, 19 May 2021 09:43:23 +0200
Message-Id: <20210519074323.665872-2-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210519074323.665872-1-daniel.vetter@ffwll.ch>
References: <20210519074323.665872-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Ekstrand <jason@jlekstrand.net>

This reverts commit 9e31c1fe45d555a948ff66f1f0e3fe1f83ca63f7.  Ever
since that commit, we've been having issues where a hang in one client
can propagate to another.  In particular, a hang in an app can propagate
to the X server which causes the whole desktop to lock up.

Signed-off-by: Jason Ekstrand <jason.ekstrand@intel.com>
Reported-by: Marcin Slusarz <marcin.slusarz@intel.com>
Cc: <stable@vger.kernel.org> # v5.6+
Cc: Jason Ekstrand <jason.ekstrand@intel.com>
Cc: Marcin Slusarz <marcin.slusarz@intel.com>
Cc: Jon Bloomfield <jon.bloomfield@intel.com>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/3080
Fixes: 9e31c1fe45d5 ("drm/i915: Propagate errors on awaiting already signaled fences")
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/i915_request.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index 970d8f4986bb..b796197c0772 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -1426,10 +1426,8 @@ i915_request_await_execution(struct i915_request *rq,
 
 	do {
 		fence = *child++;
-		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
-			i915_sw_fence_set_error_once(&rq->submit, fence->error);
+		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
 			continue;
-		}
 
 		if (fence->context == rq->fence.context)
 			continue;
@@ -1527,10 +1525,8 @@ i915_request_await_dma_fence(struct i915_request *rq, struct dma_fence *fence)
 
 	do {
 		fence = *child++;
-		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
-			i915_sw_fence_set_error_once(&rq->submit, fence->error);
+		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
 			continue;
-		}
 
 		/*
 		 * Requests on the same timeline are explicitly ordered, along
-- 
2.31.0

