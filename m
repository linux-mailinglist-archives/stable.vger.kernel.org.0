Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D044F36C18F
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 11:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235048AbhD0JVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 05:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbhD0JVN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Apr 2021 05:21:13 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16991C061756
        for <stable@vger.kernel.org>; Tue, 27 Apr 2021 02:20:30 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id l2so6356714wrm.9
        for <stable@vger.kernel.org>; Tue, 27 Apr 2021 02:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KOCIo0GxcuBFJ7MAFxsDsYBoZyOhVlSKHbo+qwITV5Q=;
        b=eqYcy5pEgjEbNBPBox4dInLBHfCo5j5j+wLOf5FWeDDHDm35ZfHa+F5PzHefmdBR6Y
         mQW4c1LZ9C340D8p4VatAiPiLY3FHujh7UGENv0MV6WyIJwZcmvgTMPp/O/XIZZvCLfc
         tqpPiLk+lTMEF0Qfwn2RGiopa0yyp2/jXUk1s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KOCIo0GxcuBFJ7MAFxsDsYBoZyOhVlSKHbo+qwITV5Q=;
        b=M7H6mRvL5nrD2s7xqrAaF3pbGxmQwXlOveVdoGYi9bZU1QzdQRScW2Wa3naDVwGzD9
         F/SXPUf5wBYqvqHiDXN5w19DhPiKgEWAeDyWgN8Y1cLffyacmV3PyBXwGQXueJcsWT8q
         z1k4Iw/KKMXeAxah6iKdR3B6lrbCZN37ZDWXY+RglBUOHos+0JsTrgEt6TPzhBds04Km
         G3MlvMjOtw0gZChOHupiplISdlUsBDAutTRq+iowkaW0j/PvBMYl+2JaVjcA00x3TdY5
         fezR+rXOHHF7F6//VawYwEWHcWeyjef8NtqTLikz5ZS2cRoC1kj51TCE0pQ3qzh3XXxR
         RUhA==
X-Gm-Message-State: AOAM532pmXmWryiubyrwffYOHVr6ifzfHg3JKSwFXCgrkWR5vtINm2gB
        xsy2i/AaLflaSrQzTWNro3vGzg==
X-Google-Smtp-Source: ABdhPJxBaxOImxswpfiXYoCXOXsQQQFm/5Ib8J6++xeSyqcKN0bxddZpkjc1KLyL1GncdKpYFf7B5A==
X-Received: by 2002:adf:e60d:: with SMTP id p13mr18428250wrm.326.1619515228862;
        Tue, 27 Apr 2021 02:20:28 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id r24sm1939816wmh.8.2021.04.27.02.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 02:20:28 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org,
        Pekka Paalanen <pekka.paalanen@collabora.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org
Subject: [PATCH 6/8] drm/nouveau: Don't set allow_fb_modifiers explicitly
Date:   Tue, 27 Apr 2021 11:20:16 +0200
Message-Id: <20210427092018.832258-6-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210427092018.832258-1-daniel.vetter@ffwll.ch>
References: <20210427092018.832258-1-daniel.vetter@ffwll.ch>
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

