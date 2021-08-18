Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C5A3F071E
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 16:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239310AbhHROw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 10:52:56 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:54074
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238721AbhHROw4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 10:52:56 -0400
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id D02D9412EC
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 14:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629298340;
        bh=C63KvaJ+cWhAEINSiaxTGMz7FLf9euvtefJ5UKJKvuw=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=aU/M0lDC3lnWmWPUa2sIxOGmfjLAmCGdzn+Vlb+3oTTNJ6w0y28PZer6Zhk5AiNO7
         i/VvFqLWkFnm94H9rDL3ufDFmmVgec3CZO5avjNGL+ZrqGyyqdHGTcciRN5r1MtMlj
         JR+T7BCG627JjzgjPg1MOVLVVX/jmDJuCDX0CFt9ZnpSwuUbrpnsmrxDIJM6YPVvIi
         77VkWbypUnmgTk92Cpt4gwFB10MeASo0EiA/94jHvy1pk1bIu4VTaDaw8SUlbFSEV3
         jHTO8KhS27s4qD8snT96XdUr2DX4GEURih5bm/6EZ7Dtvbq0daRLyLfXeuvPsfhl+L
         QoXsKRZVZerWA==
Received: by mail-pg1-f200.google.com with SMTP id k28-20020a63ff1c0000b029023b84262596so1566575pgi.1
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 07:52:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C63KvaJ+cWhAEINSiaxTGMz7FLf9euvtefJ5UKJKvuw=;
        b=bbN58SI2XGnOc+nY1Xqd2QqYD2g08NbXSVDasf0+wuyPFfc+su/ufYNd6DLoEU1kDL
         iK5MM5+WlpuXtWiFBd+oa5/QWlIlfZmKC2pT+VZH98swolU2dpNxyNcXbAZOibCBgDet
         onmaHrB50L7JThvj3CsE14gL5VSmDqPA/Mply9Tsy7ncY9AeZuAHnq3+vv2b6hjcKWpL
         mqsR2HGJuuP/DWzAdtrktr+sh23wyejeoHzCcOieDIGnE5uNMDHiTdsAekxzRm/f6ZKC
         JDJfQErwwPzLw0NmXj+hs4xv+kc+SxDRQKTe/Nqa/ZiSylMOApRuFvkl6w7qa6nn7KdK
         /TRA==
X-Gm-Message-State: AOAM533V9AkgAiQDk5AstfvZOdNqBRXlLTgMvo17y2BNYbqGKdEoNS5C
        dygJUMjQxA7CFJaJcUQTPSnznUU0pbkBFTcq7hDgPp8llm07Q17Weur5eMLdHjFeE7tBGfq9o9x
        uqAUB00OS5ubaRV7CCHH10K5KBO7475TXpw==
X-Received: by 2002:a17:90a:f314:: with SMTP id ca20mr10053539pjb.210.1629298339357;
        Wed, 18 Aug 2021 07:52:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzIX0xUNdP8jrpWXr9FRIo/5CxYkCcC18au0WkZhrfprpv1h8lb2dEHNI4DzTUBH3RtKFQesg==
X-Received: by 2002:a17:90a:f314:: with SMTP id ca20mr10053525pjb.210.1629298339084;
        Wed, 18 Aug 2021 07:52:19 -0700 (PDT)
Received: from localhost.localdomain ([69.163.84.166])
        by smtp.gmail.com with ESMTPSA id 73sm7331pfz.73.2021.08.18.07.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 07:52:18 -0700 (PDT)
From:   Tim Gardner <tim.gardner@canonical.com>
To:     linux-kernel@vger.kernel.org
Cc:     tim.gardner@canonical.com, stable@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: [PATCH] drm/i915/gem: Avoid NULL dereference in __i915_gem_object_lock()
Date:   Wed, 18 Aug 2021 08:51:59 -0600
Message-Id: <20210818145159.12402-1-tim.gardner@canonical.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Coverity warns of a possible NULL dereference:

Both dma_resv_lock_interruptible() and dma_resv_lock() can return -EDEADLK. Protect
against a NULL dereference by checking for NULL before saving the object pointer. This
is consistent with previous checks for ww==NULL.

Addresses-Coverity: ("Dereference after null check")

Cc: stable@vger.kernel.org
Fixes: 80f0b679d6f0683f23cf98a511af3e44dd509472 ("drm/i915: Add an implementation for i915_gem_ww_ctx locking, v2.")
Cc: kernel-janitors@vger.kernel.org
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: intel-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: linaro-mm-sig@lists.linaro.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/gpu/drm/i915/gem/i915_gem_object.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object.h b/drivers/gpu/drm/i915/gem/i915_gem_object.h
index 48112b9d76df..3391ca4f662a 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_object.h
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object.h
@@ -187,7 +187,7 @@ static inline int __i915_gem_object_lock(struct drm_i915_gem_object *obj,
 	if (ret == -EALREADY)
 		ret = 0;
 
-	if (ret == -EDEADLK) {
+	if (ret == -EDEADLK && ww) {
 		i915_gem_object_get(obj);
 		ww->contended = obj;
 	}
-- 
2.33.0

