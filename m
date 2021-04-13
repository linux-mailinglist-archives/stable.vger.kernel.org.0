Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B63135DBB0
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 11:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240878AbhDMJtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 05:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239994AbhDMJti (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 05:49:38 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DFFC061574
        for <stable@vger.kernel.org>; Tue, 13 Apr 2021 02:49:18 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id 12so15789307wrz.7
        for <stable@vger.kernel.org>; Tue, 13 Apr 2021 02:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KOCIo0GxcuBFJ7MAFxsDsYBoZyOhVlSKHbo+qwITV5Q=;
        b=adN7hP+T0iNVXfFXZvSvgr+93E9K98/BtliqF90MH8R8o5FKRtDJItG5KKbuc4MYMe
         qWK/ti+Hc73ReMOF1oIb5bn0cRI5vWpR+7N32rqQp4F42mweFWw9zjUMLl9kWoBC0RcG
         wxR9XZDiqN0RFaXyrUK1NIeHoIMwzwAMXoYoI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KOCIo0GxcuBFJ7MAFxsDsYBoZyOhVlSKHbo+qwITV5Q=;
        b=HrgNAtVZYcdiSEXYKr1bRD/M3pJ7K/WQ1MvzO/0+YfbRBdrGFQE343gAWz/hqbtL5Y
         EpZ9Kdurf9J/X3BnQOmaES/eCtIKMQJgr07ZO5UKaLWGzMTcmaUmklU9oYOLu3AOwwdK
         yBnlvnvsCx5dxajvqKZX0gC+AoEGFqKak3/qgteOWyXE4YBDuF3begPBDsrSuIWl8TX/
         arppx9268Q+/pE1l83/wzAv2+Tingu+QOyymdSKn4zhQQX9XISwX3IG16+vgc+Ftv2fW
         2U8ue+zn7fWTYTyD89kRpky18HPqWzqsXEQzmBnd7xEd06wkuNM9+vTOKP6cubSia6/j
         Efxw==
X-Gm-Message-State: AOAM530EnOlF2TjA7al79jgw1HeDwRfoHuQ/LZlk73hbc0MtygVm2yHk
        JtQ3fR6mr7SnUqvLXllkReOUyg==
X-Google-Smtp-Source: ABdhPJzuwM6zgnq1ioNXEfS/WwdqokduH0KbRvUyJrFDtNqmDFhRlSCyaOxnBcCKHkMTz2CRCLLbEg==
X-Received: by 2002:a05:6000:1004:: with SMTP id a4mr34540971wrx.202.1618307357555;
        Tue, 13 Apr 2021 02:49:17 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id 64sm1956458wmz.7.2021.04.13.02.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 02:49:17 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org,
        Pekka Paalanen <pekka.paalanen@collabora.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org
Subject: [PATCH 08/12] drm/nouveau: Don't set allow_fb_modifiers explicitly
Date:   Tue, 13 Apr 2021 11:48:59 +0200
Message-Id: <20210413094904.3736372-8-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210413094904.3736372-1-daniel.vetter@ffwll.ch>
References: <20210413094904.3736372-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since

commit 890880ddfdbe256083170866e49c87618b706ac7
Author: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Date:   Fri Jan 4 09:56:10 2019 +0100

    drm: Auto-set allow_fb_modifiers when given modifiers at plane init

this is done automatically as part of plane init, if drivers set the
modifier list correctly. Which is the case here.

Note that this fixes an inconsistency: We've set the cap everywhere,
but only nv50+ supports modifiers. Hence cc stable, but not further
back then the patch from Paul.

Cc: stable@vger.kernel.org # v5.1 +
Cc: Pekka Paalanen <pekka.paalanen@collabora.com>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: nouveau@lists.freedesktop.org
---
 drivers/gpu/drm/nouveau/nouveau_display.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_display.c b/drivers/gpu/drm/nouveau/nouveau_display.c
index 14101bd2a0ff..929de41c281f 100644
--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -697,7 +697,6 @@ nouveau_display_create(struct drm_device *dev)
 
 	dev->mode_config.preferred_depth = 24;
 	dev->mode_config.prefer_shadow = 1;
-	dev->mode_config.allow_fb_modifiers = true;
 
 	if (drm->client.device.info.chipset < 0x11)
 		dev->mode_config.async_page_flip = false;
-- 
2.31.0

