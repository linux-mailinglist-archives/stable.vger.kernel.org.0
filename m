Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5319399034
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 18:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhFBQno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 12:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbhFBQnn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Jun 2021 12:43:43 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C90C061574
        for <stable@vger.kernel.org>; Wed,  2 Jun 2021 09:42:00 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id e22so2700026pgv.10
        for <stable@vger.kernel.org>; Wed, 02 Jun 2021 09:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jlekstrand-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gPVNq3xY6/pVhK42Qp957298GnOdq1x2LLqM9lPcSF0=;
        b=WwIZN77eYfoJ1K/hpdlXAfsBsosrcxsjt80seY3+/6dr7oWCnGj51ZBiJy2woMqt0C
         +8BJ2GHg+hJs8owJOO1RK3FyvbAnjwpmsAxzzS9InZP8e65RGM5pMTJ5VnDI93yx/6tX
         Nc4Yw/C6dYPdSU/dDxYD+tqgDTrAX+cE43hJGGQ/02vkv2+zwLemKDFEV7TNupN0txqk
         Xomz1eJ8T0MnOgpFjqXuqatz/OXsCRUCJzjvGKknUWG0h387SFc2N+/vueMreiMmzXVt
         LscFzQkInVvCrpP3aAEBmhPxNv8iEqsLmFe62VA9HIW6XUpha1PtAodV0fTkBsUcDvQI
         Wg5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gPVNq3xY6/pVhK42Qp957298GnOdq1x2LLqM9lPcSF0=;
        b=iJ5DgU3QPOjBvj6PpXki+ScyVjB/9hv8sWxyTD8XJzCBN0z3JlCBoHPldz+CEZ3EYk
         CIlin92ZHlBsnE8/UQBdwPs5/kwqXI5LSKaH9sqbWo889NPSVR4IcDk80et4FaOBogrJ
         yynJpTGfPBjnC8v06Hfkh2ZLVpjl/B6tRc7QY66B7DOyCEGKUMS+w0vIRoQyCENuzV3E
         xk+B8nMm5vWYN21dDD+0ERW2tCtQ3BFXSsv5kSDqXZwApBx3gihHXFZTXnnYGkJ4GZ8L
         5XxIh/Fa39M6fla2axGF6dqLQNJyJAOkd9erBkS3u7L7kVnblK/6oGbLvKWm0+9dICb+
         Zo7Q==
X-Gm-Message-State: AOAM532em4yPzOGgzwFL1cjzkb26TZxYqpP3KpfvvtDSL6/DzIGK0Q9C
        MQ3fX+nInsg0frFoJlr/fZ3Lfg==
X-Google-Smtp-Source: ABdhPJxlqXWTNaqRa5erKgD5YGNKy4A/O7o19m2tpIvDsZcU/e33F551nOmmOZC0UVcLlzWTNFe8aA==
X-Received: by 2002:a63:f344:: with SMTP id t4mr19286061pgj.314.1622652119744;
        Wed, 02 Jun 2021 09:41:59 -0700 (PDT)
Received: from omlet.lan (jfdmzpr04-ext.jf.intel.com. [134.134.137.73])
        by smtp.gmail.com with ESMTPSA id h6sm75803pjs.15.2021.06.02.09.41.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 09:41:59 -0700 (PDT)
From:   Jason Ekstrand <jason@jlekstrand.net>
To:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org
Cc:     Jason Ekstrand <jason@jlekstrand.net>,
        Jason Ekstrand <jason.ekstrand@intel.com>,
        Marcin Slusarz <marcin.slusarz@intel.com>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jon Bloomfield <jon.bloomfield@intel.com>
Subject: [PATCH 4/5] Revert "drm/i915: Propagate errors on awaiting already signaled fences"
Date:   Wed,  2 Jun 2021 11:41:48 -0500
Message-Id: <20210602164149.391653-5-jason@jlekstrand.net>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210602164149.391653-1-jason@jlekstrand.net>
References: <20210602164149.391653-1-jason@jlekstrand.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 9e31c1fe45d555a948ff66f1f0e3fe1f83ca63f7.  Ever
since that commit, we've been having issues where a hang in one client
can propagate to another.  In particular, a hang in an app can propagate
to the X server which causes the whole desktop to lock up.

Signed-off-by: Jason Ekstrand <jason.ekstrand@intel.com>
Reported-by: Marcin Slusarz <marcin.slusarz@intel.com>
Cc: <stable@vger.kernel.org> # v5.6+
Cc: Jason Ekstrand <jason.ekstrand@intel.com>
Cc: Marcin Slusarz <marcin.slusarz@intel.com>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/3080
Fixes: 9e31c1fe45d5 ("drm/i915: Propagate errors on awaiting already signaled fences")
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Jon Bloomfield <jon.bloomfield@intel.com>
---
 drivers/gpu/drm/i915/i915_request.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index 970d8f4986bbe..b796197c07722 100644
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

