Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E4C3C8BBE
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhGNThX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhGNThW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 15:37:22 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C262AC06175F
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 12:34:30 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d12so2958619pfj.2
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 12:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jlekstrand-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8g0NKGsiBt+LRz/CeZwrcLpTtaHucndBMGpot3ZHzBo=;
        b=yWsa9uBzT4hk3NcPhCG3JMvB3gAraFy3dbpmKYJ7o2evC99NZ2FkBYCuyUtIccEDGY
         bJBcOAANtWB6TKchz4y6lQQowmPryZgDeemTRiRb0qrE6XLyQ2iiMjrEeaFlVi4fPrzC
         TVnGqSR/dxU4Gx2pIzXx35aZfJ1BV4Er+ZPhp0M/SiIODQ6p9bUgBCQQ/5Da4m6qyaOz
         VJy55WvmGBER1bZgBquV3a7oBcryf+vFGD84KTqRUPtDPxfjJYphYA8rfh/OKfX6Pt+c
         2U+osrKydcI7MUh1YdkGT4ewAEf0Za4BPVQuGHAE7p57AOKGyOND2daEGgByavX2mfsV
         kJ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8g0NKGsiBt+LRz/CeZwrcLpTtaHucndBMGpot3ZHzBo=;
        b=LT4dmayrcGz5jZ/7VNAztOfO9EoidTHWXH3N9/fNk4st6/0matOZeoIf/o/haDjeau
         s/fk0dZuPHKV/vErXmONU1My/IguqTRuAi3rBPuoDpLmr/2g6NgFAvQn3lxANkYUw8rP
         RMo2vKRZK4NPXFWFhC2hnfpmIBTyRaPzIZC9D6VHMc3tAiNxumBp5H0SULlmkm8jL3B7
         Xlur+IWKurTPqKbgV0rAMfab6f2ntlgS3CDl4Am1R0AU791Co9qvwLQgWWY5xHo8cPNW
         F6ZqZGKgf/fFCbkpYfENscPLWizJDb37ntSxK8gAB+mYNBRCGiyXgf1Qr1+IEF/hXUN9
         zUJA==
X-Gm-Message-State: AOAM532w9d65JFbfXRwswxg66a9dblX11rjX1zGibJtfx8B1JiYRr3Cm
        tx0I72/m4Pn7bW2rvIKZg1O/6A==
X-Google-Smtp-Source: ABdhPJx2Kt5tejKPEix4ne/J6ilOQy1+0CAgqPl4xeuT5GntMfxp+J9m9dr4TElop+/9eSQ036pN9Q==
X-Received: by 2002:a63:d711:: with SMTP id d17mr11137949pgg.268.1626291270299;
        Wed, 14 Jul 2021 12:34:30 -0700 (PDT)
Received: from omlet.com ([134.134.139.71])
        by smtp.gmail.com with ESMTPSA id i1sm3679740pfo.37.2021.07.14.12.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 12:34:29 -0700 (PDT)
From:   Jason Ekstrand <jason@jlekstrand.net>
To:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc:     Jason Ekstrand <jason@jlekstrand.net>,
        Marcin Slusarz <marcin.slusarz@intel.com>,
        stable@vger.kernel.org, Jason Ekstrand <jason.ekstrand@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jon Bloomfield <jon.bloomfield@intel.com>
Subject: [PATCH 2/5] Revert "drm/i915: Propagate errors on awaiting already signaled fences"
Date:   Wed, 14 Jul 2021 14:34:16 -0500
Message-Id: <20210714193419.1459723-3-jason@jlekstrand.net>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210714193419.1459723-1-jason@jlekstrand.net>
References: <20210714193419.1459723-1-jason@jlekstrand.net>
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

