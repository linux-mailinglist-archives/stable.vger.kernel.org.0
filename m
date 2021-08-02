Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2297C3DDF91
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 20:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhHBSsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 14:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhHBSsf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 14:48:35 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CC3C061760
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 11:48:26 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id i10so20725132pla.3
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 11:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jlekstrand-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l2Qpt9XBX9tIzh4X/SXdw+kZqA96vfKA/OcvOyxR+m8=;
        b=PbyIihIX1BEhQdnGxiwM9NzmWc7UkEh7HmX33p+uGuJdcc+5OWwegoJVpBN9xzV8ae
         Sq4w0FRIAC8brU2ECIDQEJDGKNspWc4jkTPNdIhX0AF3bZCdx51B4ajqCH86MRrNQmOW
         km4BwNG0XccoXLFd+AoCa4uko/RewPvdS4VPz/pkq88qm1BFEnb4y/yzCQ4lqXgcL9Qm
         Aq1aCzuSqCkvlAHBe7zxrl42iIPgajLXTG3eMFHvNc4EhQ0zEbUlx8miw9zOO6ZQdKMi
         7Y//zTLgOYumlMxpu86/n51UiOx+4LtA1HhPuAjMGZJhFgb8bnW+EDrUQ/Qmwz02K3bJ
         2LnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l2Qpt9XBX9tIzh4X/SXdw+kZqA96vfKA/OcvOyxR+m8=;
        b=Nbls0KXVUYNpRaEIRphpCu2zzmzPToDxTVEziYPd1XfyZtHgLcvZu4+M5eSImFTiVD
         yIyuf3O9mNlSwm35wXwLzVH/l1CNA7cW7J6hPAvIvjYehsq5yfVlT/4UGfz0FYELlMdu
         q23M3onW/AlJ+1oGdTzfSnONzVbBX6FFwbvNofg+41xcpjk5M50J7Amk+saUMgYwtg4C
         q/odmH3urMnG2hhT4VKU571GORoRwAQu7SN13fYJRz3StSCIpdnVq1vq1vgQqzwwl+lq
         APFPnAp8jY9/4uqUciCYxE4t+tEJa1gJP7lVLQW8N/ND5i/WhW8eiPaASFBXTRLwJwmy
         zSKw==
X-Gm-Message-State: AOAM533tdRznYFHQ2INDbH5DrXAf1nLZ10tNxVgR0cXB4q6TCfVToRVy
        PyBJizUEINM+xHY07N/sSr/2MG0jiC3RPII4
X-Google-Smtp-Source: ABdhPJxnY6PZqZViSIoep8+DaGjIXcpdQeRtLivHKzEO2sv4jm6CrQANYSCsntEZlbYcN8wH0rvv7w==
X-Received: by 2002:a63:4c53:: with SMTP id m19mr103019pgl.226.1627930105320;
        Mon, 02 Aug 2021 11:48:25 -0700 (PDT)
Received: from omlet.lan ([134.134.137.81])
        by smtp.gmail.com with ESMTPSA id n4sm7987819pfj.62.2021.08.02.11.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 11:48:25 -0700 (PDT)
From:   Jason Ekstrand <jason@jlekstrand.net>
To:     stable@vger.kernel.org
Cc:     Jason Ekstrand <jason@jlekstrand.net>,
        Marcin Slusarz <marcin.slusarz@intel.com>,
        Jason Ekstrand <jason.ekstrand@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 2/2] Revert "drm/i915: Propagate errors on awaiting already signaled fences"
Date:   Mon,  2 Aug 2021 13:48:19 -0500
Message-Id: <20210802184819.414914-3-jason@jlekstrand.net>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210802184819.414914-1-jason@jlekstrand.net>
References: <20210802184819.414914-1-jason@jlekstrand.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 3761baae908a7b5012be08d70fa553cc2eb82305 upstream.  This version
applies to the 5.13 tree.

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
index bec9c3652188..59d48a6a83d2 100644
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
2.31.1

