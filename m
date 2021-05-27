Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A38C393897
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 00:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235720AbhE0WOq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 18:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233563AbhE0WOq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 18:14:46 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73AAEC061574
        for <stable@vger.kernel.org>; Thu, 27 May 2021 15:13:12 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id q6so1360220pjj.2
        for <stable@vger.kernel.org>; Thu, 27 May 2021 15:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jlekstrand-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L/YmRei2haL4XSNWlb3cugC49BMiEW7x7qBA7UjfIO4=;
        b=ygCTTdSXX34nSOFg8rVIiNo94Ti6DLLX0h54R4SKJQqLil6KjVAqVZGWkB9gsJaeQ9
         Jdv8iOQVvuRhYCbLPrPdTVivDnsnhhWT5piGsPpcYVnKwh0QTG4geFbSnDEhr+P1RFHC
         hl/+QKYOdPVtVsPwUhD0DyWen3xSVHmUVE+JoFahrZw3vPB4oKWJ3xrxDVeEg4mRgIvr
         MAeovigliaLWz7Q3bQjrI/dQgEoXIV40MfRAmSw28gwVxuDwn2WlfjjoouX31iMqFN6c
         eAg2yjBFvOI26gy1tSsDsPtKydbFkNxQtc82ZsiqKKqzpQUAYf4mb9Lr8HiQvQZR9zGN
         57/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L/YmRei2haL4XSNWlb3cugC49BMiEW7x7qBA7UjfIO4=;
        b=ZEUu9FiWL42PsLpYeCKQ2kvhHkIavzR/Y8i9x3fsIT6fQd80/xUdC1Q2rnPBtnKHcF
         CNbYrR+4rBuyBFxu8LFU/I8Fwlzh6aVt5qxkRKxd2xiJ9PbXlOQziNK8rTDWyg761NrE
         WpOjug9IoY1Rd43YgH/hHtnAFh4iiZQzpJGxclp0eh1stQFiWkU2s8pS1sVcI2DZou0t
         IkPFJBAKyG2ReoZCsDTsZfGJhacc5A28jqyHmXn7Wb2GB/+Hqit0knKIBQH87cyWCBp2
         FvTJ178rQo5q9SJP9+5GaQ1AjkwwICkqvbxFoTkFYnBNpGxsDBCQaUuYgIrHFtAyGCkY
         fgsw==
X-Gm-Message-State: AOAM531WiuwqBAvmZCnw1OlpYtdISR2FgmtkCSRSU2VMpw9ozeiPOGQz
        VQV96SZh1XcXDfDPre3xQhI8xQ==
X-Google-Smtp-Source: ABdhPJwKsIdrAE+6MGaDyjW67ulr0cPpti0HzkJLI8rCGaifNTDam/+DnnL5rmN1w4Wvp5EER/PNIw==
X-Received: by 2002:a17:90a:ec05:: with SMTP id l5mr763204pjy.141.1622153591939;
        Thu, 27 May 2021 15:13:11 -0700 (PDT)
Received: from omlet.lan (jfdmzpr03-ext.jf.intel.com. [134.134.139.72])
        by smtp.gmail.com with ESMTPSA id y26sm2736525pge.94.2021.05.27.15.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 15:13:11 -0700 (PDT)
From:   Jason Ekstrand <jason@jlekstrand.net>
To:     intel-gfx-trybot@lists.freedesktop.org
Cc:     Jason Ekstrand <jason@jlekstrand.net>,
        Jason Ekstrand <jason.ekstrand@intel.com>,
        Marcin Slusarz <marcin.slusarz@intel.com>,
        stable@vger.kernel.org, Jon Bloomfield <jon.bloomfield@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 4/5] Revert "drm/i915: Propagate errors on awaiting already signaled fences"
Date:   Thu, 27 May 2021 17:12:58 -0500
Message-Id: <20210527221259.131918-5-jason@jlekstrand.net>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527221259.131918-1-jason@jlekstrand.net>
References: <20210527221259.131918-1-jason@jlekstrand.net>
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
Cc: Jon Bloomfield <jon.bloomfield@intel.com>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/3080
Fixes: 9e31c1fe45d5 ("drm/i915: Propagate errors on awaiting already signaled fences")
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
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

