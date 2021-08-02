Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B461D3DDF8E
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 20:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbhHBSsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 14:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhHBSsU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 14:48:20 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515F4C06175F
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 11:48:11 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so1311289pjb.2
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 11:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jlekstrand-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ictjcxkLz+p2L00FlRj8tctodcJDOmssBZ2DadTrU/8=;
        b=DZ7bKaHfHcyhMq2695H0lIi+qQSTooQO2e8GRE1W1gqTXiSurYDdSgHgiKkR+vufcT
         ElCLMmsByCz01haCVehV1cPo0DmSq/Mv5jBzhY2IxMP9FqgoOOzmvtELTcluLMjwZIo0
         z8MxkYwIhKuQE2Z0TRzcpdxjbLSQfwIsPxLVmKmXsHhzQGUQnbj0qVbU52uH7T55MgBd
         DJ2kLekjUexLPKI2ZTqsbefOWlRygWM42DveD1sTCfBtF3InZ6Nl353yBMBts95xIL4/
         CXOZEnBR2sZvwTQvTEhJZ8h6lzPhcaYfuCAXhrK5+p+JaQxZjwI1s+t4OVYPnrkKVw3g
         BiyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ictjcxkLz+p2L00FlRj8tctodcJDOmssBZ2DadTrU/8=;
        b=DncvZ5zGK+036aEAHEuTJRLPQs1SbH9nRCfeXLa3WwpuUbvVi1WP1ARNv9yRHcp6xI
         D0+bD8IKHB32AqZoA5YBPqJtk7BHJVYRx6/qT04ObLC+GVNMRWAZJgg6BYAMUcJaHT43
         Uie/I3dyPhY7YLLauCdLPJBm8GPumZT7tXM9z3R6KAS6mh61GZtSX1HTy7viOl/2RGrk
         37l8ASlJewfyD8gpCpA6sXtiXC7QUjUCLpZppfJH/hnSVQ9CzsQIJCUTi1JZXO7aiQEh
         P11Muo7lSpwggUB2lbfYOHUSKpTC8VgwrJo7Dmf+XjdslLLdUD8zxFc58VQGkbb9V+Ea
         k5lg==
X-Gm-Message-State: AOAM532nJHCgDPBzLlxEn1Hmekx3gLUypvRs/rE0xuCpS2B2uxLBqvm5
        DoyZT8KL6Vqjm3GHdPOIGtyEbY0tCTpRaiW9
X-Google-Smtp-Source: ABdhPJyPAuRYkaltO/QmTda/s70TxOSKYcT0zI6rFDWd71TJSy3ImZvu92LnqplS8Dpa+arl10QDFQ==
X-Received: by 2002:a17:90a:ca93:: with SMTP id y19mr301198pjt.142.1627930090605;
        Mon, 02 Aug 2021 11:48:10 -0700 (PDT)
Received: from omlet.lan ([134.134.137.81])
        by smtp.gmail.com with ESMTPSA id w9sm849931pfg.151.2021.08.02.11.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 11:48:10 -0700 (PDT)
From:   Jason Ekstrand <jason@jlekstrand.net>
To:     stable@vger.kernel.org
Cc:     Jason Ekstrand <jason@jlekstrand.net>,
        Marcin Slusarz <marcin.slusarz@intel.com>,
        Jason Ekstrand <jason.ekstrand@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 2/2] Revert "drm/i915: Propagate errors on awaiting already signaled fences"
Date:   Mon,  2 Aug 2021 13:48:02 -0500
Message-Id: <20210802184802.414849-3-jason@jlekstrand.net>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210802184802.414849-1-jason@jlekstrand.net>
References: <20210802184802.414849-1-jason@jlekstrand.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 3761baae908a7b5012be08d70fa553cc2eb82305 upstream.  This version
applies to the 5.10 tree.

This reverts commit 9e31c1fe45d555a948ff66f1f0e3fe1f83ca63f7.  Ever
since that commit, we've been having issues where a hang in one client
can propagate to another.  In particular, a hang in an app can propagate
to the X server which causes the whole desktop to lock up.

Error propagation along fences sound like a good idea, but as your bug
shows, surprising consequences, since propagating errors across security
boundaries is not a good thing.

What we do have is track the hangs on the ctx, and report information to
userspace using RESET_STATS. That's how arb_robustness works. Also, if my
understanding is still correct, the EIO from execbuf is when your context
is banned (because not recoverable or too many hangs). And in all these
cases it's up to userspace to figure out what is all impacted and should
be reported to the application, that's not on the kernel to guess and
automatically propagate.

What's more, we're also building more features on top of ctx error
reporting with RESET_STATS ioctl: Encrypted buffers use the same, and the
userspace fence wait also relies on that mechanism. So it is the path
going forward for reporting gpu hangs and resets to userspace.

So all together that's why I think we should just bury this idea again as
not quite the direction we want to go to, hence why I think the revert is
the right option here.

For backporters: Please note that you _must_ have a backport of
https://lore.kernel.org/dri-devel/20210602164149.391653-2-jason@jlekstrand.net/
for otherwise backporting just this patch opens up a security bug.

v2: Augment commit message. Also restore Jason's sob that I
accidentally lost.

v3: Add a note for backporters

Signed-off-by: Jason Ekstrand <jason@jlekstrand.net>
Reported-by: Marcin Slusarz <marcin.slusarz@intel.com>
Cc: <stable@vger.kernel.org> # v5.6+
Cc: Jason Ekstrand <jason.ekstrand@intel.com>
Cc: Marcin Slusarz <marcin.slusarz@intel.com>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/3080
Fixes: 9e31c1fe45d5 ("drm/i915: Propagate errors on awaiting already signaled fences")
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Jon Bloomfield <jon.bloomfield@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210714193419.1459723-3-jason@jlekstrand.net
(cherry picked from commit 93a2711cddd5760e2f0f901817d71c93183c3b87)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
---
 drivers/gpu/drm/i915/i915_request.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index 0e813819b041..d8fef42ca38e 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -1285,10 +1285,8 @@ i915_request_await_execution(struct i915_request *rq,
 
 	do {
 		fence = *child++;
-		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
-			i915_sw_fence_set_error_once(&rq->submit, fence->error);
+		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
 			continue;
-		}
 
 		if (fence->context == rq->fence.context)
 			continue;
@@ -1386,10 +1384,8 @@ i915_request_await_dma_fence(struct i915_request *rq, struct dma_fence *fence)
 
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
2.31.1

