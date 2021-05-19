Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5464388847
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 09:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240567AbhESHo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 03:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240604AbhESHox (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 03:44:53 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC80C06175F
        for <stable@vger.kernel.org>; Wed, 19 May 2021 00:43:32 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id a4so12922787wrr.2
        for <stable@vger.kernel.org>; Wed, 19 May 2021 00:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3DkNIkydloyBNXsM4DUT+1wB5zlc/1I1RiMPxasZ1o4=;
        b=QT3TR7+gcB5ZgeHsAAYGoTlaoRivIDyZnyi7Hu12D0du6f3tXVnV1W6nqTa4oZiXcq
         DYmRc7GiJKdH/XmW9LVzEDOzXa6Qrp10N2mj+75vFcfxz+nvh8H4Q3rlAx7oEBfKVV3s
         +y2Vykne1PrBLl+PVpvylkhdtEzKy/u6tnZho=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3DkNIkydloyBNXsM4DUT+1wB5zlc/1I1RiMPxasZ1o4=;
        b=EnSvk/YJPn2ytQV54YjPbdWLL7Oo5taA0Y2Y/9MONMkvup4L9i7WYNj+L+HE8liDEe
         JFlZHLAZCRp9MjYYwlRfnV9XcEkAUB1daHcIjpsC6xxugokeYWFSpS4EQwitJ0HosJE5
         hwJOwaZ+1r1e74oTOgRx2OXCl991EOFTpcZCdYZgzMztILVOiZX8beG7fP/UpBPSBLRP
         SuEwH8kc6Yy1HLEVLmIYUnjk9z48HKT/UuhL6+PmgmKnaTZi69fLqI2yTVTyTGAlG/Tt
         vaNdWXgu8REw3oEfmjC8MJVOnvJ1pGo3paau6x8hp2TNeP1S5tAPdpc8PGwBPFqy5E64
         2fEQ==
X-Gm-Message-State: AOAM531+sJAt0Pye7GT9y469A0NBgkfjZ8wM+e38VzAvHreVhLLY0TEz
        hpB5LwQ3+7nX41pFDYsAidez3xCVemas4A==
X-Google-Smtp-Source: ABdhPJxY/s/pbrtEVXeB0LgwX2qCPUKkV8QxADPiaZ/KyvvaHb6Ub3VbrNxEzEfshwI5F4OAYx8VSQ==
X-Received: by 2002:a5d:650b:: with SMTP id x11mr12601721wru.186.1621410210754;
        Wed, 19 May 2021 00:43:30 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id h13sm21189986wml.26.2021.05.19.00.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 00:43:30 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org,
        Jason Ekstrand <jason.ekstrand@intel.com>,
        Marcin Slusarz <marcin.slusarz@intel.com>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH 1/2] drm/i915/cmdparser: No-op failed batches on all platforms
Date:   Wed, 19 May 2021 09:43:22 +0200
Message-Id: <20210519074323.665872-1-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On gen9 for blt cmd parser we relied on the magic fence error
propagation which:
- doesn't work on gen7, because there's no scheduler with ringbuffers
  there yet
- fence error propagation can be weaponized to attack other things, so
  not a good design idea

Instead of magic, do the same thing on gen9 as on gen7.

Kudos to Jason for figuring this out.

Fixes: 9e31c1fe45d5 ("drm/i915: Propagate errors on awaiting already signaled fences")
Cc: <stable@vger.kernel.org> # v5.6+
Cc: Jason Ekstrand <jason.ekstrand@intel.com>
Cc: Marcin Slusarz <marcin.slusarz@intel.com>
Cc: Jon Bloomfield <jon.bloomfield@intel.com>
Relates: https://gitlab.freedesktop.org/drm/intel/-/issues/3080
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
---
 drivers/gpu/drm/i915/i915_cmd_parser.c | 34 +++++++++++++-------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_cmd_parser.c b/drivers/gpu/drm/i915/i915_cmd_parser.c
index 5b4b2bd46e7c..2d3336ab7ba3 100644
--- a/drivers/gpu/drm/i915/i915_cmd_parser.c
+++ b/drivers/gpu/drm/i915/i915_cmd_parser.c
@@ -1509,6 +1509,12 @@ int intel_engine_cmd_parser(struct intel_engine_cs *engine,
 		}
 	}
 
+	/* Batch unsafe to execute with privileges, cancel! */
+	if (ret) {
+		cmd = page_mask_bits(shadow->obj->mm.mapping);
+		*cmd = MI_BATCH_BUFFER_END;
+	}
+
 	if (trampoline) {
 		/*
 		 * With the trampoline, the shadow is executed twice.
@@ -1524,26 +1530,20 @@ int intel_engine_cmd_parser(struct intel_engine_cs *engine,
 		 */
 		*batch_end = MI_BATCH_BUFFER_END;
 
-		if (ret) {
-			/* Batch unsafe to execute with privileges, cancel! */
-			cmd = page_mask_bits(shadow->obj->mm.mapping);
-			*cmd = MI_BATCH_BUFFER_END;
+		/* If batch is unsafe but valid, jump to the original */
+		if (ret == -EACCES) {
+			unsigned int flags;
 
-			/* If batch is unsafe but valid, jump to the original */
-			if (ret == -EACCES) {
-				unsigned int flags;
+			flags = MI_BATCH_NON_SECURE_I965;
+			if (IS_HASWELL(engine->i915))
+				flags = MI_BATCH_NON_SECURE_HSW;
 
-				flags = MI_BATCH_NON_SECURE_I965;
-				if (IS_HASWELL(engine->i915))
-					flags = MI_BATCH_NON_SECURE_HSW;
+			GEM_BUG_ON(!IS_GEN_RANGE(engine->i915, 6, 7));
+			__gen6_emit_bb_start(batch_end,
+					     batch_addr,
+					     flags);
 
-				GEM_BUG_ON(!IS_GEN_RANGE(engine->i915, 6, 7));
-				__gen6_emit_bb_start(batch_end,
-						     batch_addr,
-						     flags);
-
-				ret = 0; /* allow execution */
-			}
+			ret = 0; /* allow execution */
 		}
 	}
 
-- 
2.31.0

