Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6133C3A00
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 05:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbhGKD4b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 23:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbhGKD4a (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Jul 2021 23:56:30 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81C3C0613E5
        for <stable@vger.kernel.org>; Sat, 10 Jul 2021 20:53:44 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id p22-20020a4a3c560000b0290256475d95fbso3457165oof.12
        for <stable@vger.kernel.org>; Sat, 10 Jul 2021 20:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jlekstrand-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8g0NKGsiBt+LRz/CeZwrcLpTtaHucndBMGpot3ZHzBo=;
        b=CWj1U9WycxGbEo1lWQsXldXtETWmHxTdqr2CAeNuOhFjS7ftCDZ84EM/gD3UELOfNl
         TILwRrujwFfVbUwFRjh+65CdPAc6zjZtdbjVpQfFIxU2Hp/X43UzuZF8edOUIpgTXir3
         Rmu3CgbeZNKinrb40jv5NWjz5Bo4zG86lQ1luUSYwyKk/WKkP3bAcQzh6HftDbY3rMvL
         nM6wnPda5R2zIqDz/yF45xM+vHzcT6NtmgHeH2l9H8tqIjtQYF5+M8QlGK6aBUkzQmTo
         yWg54h5a8bQzcpZNVHCnH0yeTvX4sCEB4vO6eluQ/QPzivLCcouSwjClMfzsS5d3yWh9
         MPgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8g0NKGsiBt+LRz/CeZwrcLpTtaHucndBMGpot3ZHzBo=;
        b=Vrb/TZ8vfT7rLjJMXwoBBLemrI/AyzcUrO0e8/qX14XChQQbnIN0OwZI/RpRF9GYv/
         aa3o5mzkF/qHAWpub3ZPLkYmp74rzhIWr91ECt+Yh7q4uNDQd9y6fHffmQXU9y9c9dAa
         i19n5qrHaSln0B+wiAcLr2Ea2vz1u45sLqXIPgYvmjBIRJDYZizswxY4y2Icc2L3OpgB
         ocdRK84sWeO8E9hKTnb9tuKHOaCMXSWu9lrLiAlRphFK45ehvA5OdNw0NZA+1Lk1EyCj
         t0+5Jemik7Q3ojYtcxudzIyQTTRfgXDHa7xNEuMDcaUEIfYevANveeUVdCXnZtcN3pdf
         NFqg==
X-Gm-Message-State: AOAM531vd3m93FgHLKwZA/WdgWm94PgnZdYV7aZ1DtVfvORC07kOuGwZ
        j4WCiiLmb9oq+iqCQjtJR4pk6A==
X-Google-Smtp-Source: ABdhPJwp0zPBXlmm05pTnn7gZ7FnNnEroogyFOjyRbn6K41ibsDQY+xmMQIbodr145LKZM/ULH+0Rg==
X-Received: by 2002:a4a:dd09:: with SMTP id m9mr28018133oou.42.1625975624010;
        Sat, 10 Jul 2021 20:53:44 -0700 (PDT)
Received: from omlet.lan ([68.203.99.148])
        by smtp.gmail.com with ESMTPSA id a11sm2310188otr.48.2021.07.10.20.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 20:53:43 -0700 (PDT)
From:   Jason Ekstrand <jason@jlekstrand.net>
To:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc:     Jason Ekstrand <jason@jlekstrand.net>,
        Marcin Slusarz <marcin.slusarz@intel.com>,
        stable@vger.kernel.org, Jason Ekstrand <jason.ekstrand@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jon Bloomfield <jon.bloomfield@intel.com>
Subject: [PATCH 2/5] Revert "drm/i915: Propagate errors on awaiting already signaled fences"
Date:   Sat, 10 Jul 2021 22:53:33 -0500
Message-Id: <20210711035336.803025-3-jason@jlekstrand.net>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210711035336.803025-1-jason@jlekstrand.net>
References: <20210711035336.803025-1-jason@jlekstrand.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/gpu/drm/i915/i915_request.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index 86b4c9f2613d5..09ebea9a0090a 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -1399,10 +1399,8 @@ i915_request_await_execution(struct i915_request *rq,
 
 	do {
 		fence = *child++;
-		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
-			i915_sw_fence_set_error_once(&rq->submit, fence->error);
+		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
 			continue;
-		}
 
 		if (fence->context == rq->fence.context)
 			continue;
@@ -1499,10 +1497,8 @@ i915_request_await_dma_fence(struct i915_request *rq, struct dma_fence *fence)
 
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

