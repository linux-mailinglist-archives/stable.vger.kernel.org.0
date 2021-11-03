Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7586443ABB
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 02:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbhKCBN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 21:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbhKCBN6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 21:13:58 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882C9C061714
        for <stable@vger.kernel.org>; Tue,  2 Nov 2021 18:11:23 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id n23so891716pgh.8
        for <stable@vger.kernel.org>; Tue, 02 Nov 2021 18:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dNH8eciGojVjY46fZCeKUIUNeaCP1ehIOQAcJy8VsG8=;
        b=hJbAgQ31UAE0p2/35E6pxu8qXHCQ5zMQXec/7du2V5Mb3OsWsIg6Lt0rCUjlxOU58t
         8o7UTdVZPfhdOU4OPWr/ehvpa0CijXGSsr3m2tSrdWy9jI0tXjOmUZbFtPwCSfqfJK52
         Gsj1DTodrc2IsJkxOr6whdQXmMSDj470DUbEa9C2xVTWoFNHNW2DEAI+IlFLuGA8uw0t
         Wms/qyfiADIncyhALK/ztjzPG7hqcexTGbN2M3k9DnCTWXjP51ZhlpK6J9Io9tfpTGuf
         Mn0iAyUj3/GlHTyRl8nwiCJcQ1GtXx3fJTlmf+QZOvqNOTdV1MvW0eE35/8jqThGIfyB
         6Wmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dNH8eciGojVjY46fZCeKUIUNeaCP1ehIOQAcJy8VsG8=;
        b=el20OciZEQLP+y05OefdHrR5Ik0vzxRqQV+yvBM3eAeEFn4L5Sgt3OwkfE9BP+Z3tp
         qb+a8hjYqdQfG6DtI8Tk4OgSZm3TTfZzNZNWaZmBWou+VhqRGU/hFoQyDvoKpt4GN7Jn
         aW3IbsmaAF3xdILaSc3haTS1pqyJXbcUOMyE3dn1B2/3lSS+o2ea4F1aZVpUrnLLFcA2
         v2C8w5dkAEvG/viEFu6Ur68LVbHD0MHSOU/R4+CSP26N5PThvadfPAcAHOt3bflx0XDv
         PGpSIYPa50RhKbNJXr9Bmia/B8X1Q80RConOUpmbGTl3dZ1LORfxsViZgivartJclaVG
         FqQg==
X-Gm-Message-State: AOAM530ER8JZeLWYIS/mZrDvhdcztkHMRuVArmD3X/Vr/zd93cjVi9zF
        w7XBgSVe1zOi7G2Mb4mtjKA=
X-Google-Smtp-Source: ABdhPJzOip5xZ5w1wdTzyZzhBuEkUqkmW+pVe0ZIcV6zYZHrDSp+CyGFmtK0D4m9S5aCkwDwwDf4Ug==
X-Received: by 2002:a05:6a00:2492:b0:48c:3150:1117 with SMTP id c18-20020a056a00249200b0048c31501117mr2689988pfv.55.1635901882968;
        Tue, 02 Nov 2021 18:11:22 -0700 (PDT)
Received: from localhost.localdomain (52.55.96.58.static.exetel.com.au. [58.96.55.52])
        by smtp.gmail.com with ESMTPSA id w12sm3782564pjq.2.2021.11.02.18.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 18:11:22 -0700 (PDT)
From:   Ben Skeggs <skeggsb@gmail.com>
To:     nouveau@lists.freedesktop.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] ce/gf100: fix incorrect CE0 address calculation on some GPUs
Date:   Wed,  3 Nov 2021 11:10:57 +1000
Message-Id: <20211103011057.15344-1-skeggsb@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

The code which constructs the modules for each engine present on the GPU
passes -1 for 'instance' on non-instanced engines, which affects how the
name for a sub-device is generated.  This is then stored as 'instance 0'
in nvkm_subdev.inst, so code can potentially be shared with earlier GPUs
that only had a single instance of an engine.

However, GF100's CE constructor uses this value to calculate the address
of its falcon before it's translated, resulting in CE0 getting the wrong
address.

This slightly modifies the approach, always passing a valid instance for
engines that *can* have multiple copies, and having the code for earlier
GPUs explicitly ask for non-instanced name generation.

Bug: https://gitlab.freedesktop.org/drm/nouveau/-/issues/91

Fixes: 50551b15c760 ("drm/nouveau/ce: switch to instanced constructor")
Cc: <stable@vger.kernel.org> # v5.12+
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
---
 drivers/gpu/drm/nouveau/nvkm/engine/ce/gt215.c    | 2 +-
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/ce/gt215.c b/drivers/gpu/drm/nouveau/nvkm/engine/ce/gt215.c
index 704df0f2d1f1..09a112af2f89 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/ce/gt215.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/ce/gt215.c
@@ -78,6 +78,6 @@ int
 gt215_ce_new(struct nvkm_device *device, enum nvkm_subdev_type type, int inst,
 	     struct nvkm_engine **pengine)
 {
-	return nvkm_falcon_new_(&gt215_ce, device, type, inst,
+	return nvkm_falcon_new_(&gt215_ce, device, type, -1,
 				(device->chipset != 0xaf), 0x104000, pengine);
 }
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
index ca75c5f6ecaf..b51d690f375f 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
@@ -3147,8 +3147,7 @@ nvkm_device_ctor(const struct nvkm_device_func *func,
 	WARN_ON(device->chip->ptr.inst & ~((1 << ARRAY_SIZE(device->ptr)) - 1));             \
 	for (j = 0; device->chip->ptr.inst && j < ARRAY_SIZE(device->ptr); j++) {            \
 		if ((device->chip->ptr.inst & BIT(j)) && (subdev_mask & BIT_ULL(type))) {    \
-			int inst = (device->chip->ptr.inst == 1) ? -1 : (j);                 \
-			ret = device->chip->ptr.ctor(device, (type), inst, &device->ptr[j]); \
+			ret = device->chip->ptr.ctor(device, (type), (j), &device->ptr[j]);  \
 			subdev = nvkm_device_subdev(device, (type), (j));                    \
 			if (ret) {                                                           \
 				nvkm_subdev_del(&subdev);                                    \
-- 
2.31.1

