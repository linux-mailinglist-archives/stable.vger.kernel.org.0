Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4EA35DBAC
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 11:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240874AbhDMJtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 05:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239994AbhDMJtc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 05:49:32 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B13C061574
        for <stable@vger.kernel.org>; Tue, 13 Apr 2021 02:49:12 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 12so8361509wmf.5
        for <stable@vger.kernel.org>; Tue, 13 Apr 2021 02:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CGUka0sVW6wFNgc+ztoFeb2OUOiG/y4ojkNNplTLBt0=;
        b=fTO0Jx2vcmvQdLCXa8mhtAyXJVZEw/1VEXCGgr6kv8NHXjtswWDbLwl6sGbwuihz5L
         R9Fmq4p4wiuGl6SHTg0UW14WvKyh4/kLpXFh6bBAW6fUG50BX+Q8Fe9UT7PVdn2Dt8pc
         3KhNvwFs40NEccqchivj/VRWro8cT6y+TYwOY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CGUka0sVW6wFNgc+ztoFeb2OUOiG/y4ojkNNplTLBt0=;
        b=dfs05ddvZ5E4oNzha98egehyxoCrvYD41Xi6Bvc3qiQjiUsiFunFkcVOovjDDzAqG+
         Uj9TklnwKJXe05+IeYEeRDrzKniJaS0q1O8yD9etZltq5ve8xdFQVEa5gx9+UGM54vBe
         Njm+KSSzvY1i+8GCVLA9BtjD111qfcg2sg2ZIfkMHzCZEFcB2lccue1sL/VoxUPKt2Sv
         EDnka1BAsbO5Up6dQqNWz/u3v4+HHVgII9ljS1bVzNFbJuL4tr5mXUMtNPBYBDyGTt4U
         LFmEUB5eQapItWPM0YTSdJSOVy3cXZXnPbc8yCpWPyHr3dMfMBUsjbSkBEu/TPiPBNm+
         EGtA==
X-Gm-Message-State: AOAM530ATgi4C6F/2guc/R6Al3D34xI0Nb9CRptlM1AXqIfLpmfeop2c
        GRcEkbi43XnDJ8m1u3Ke1NeO4A==
X-Google-Smtp-Source: ABdhPJyDTagvp8Qr2MQeGN0Zbd+8hK2Pfwgv5a7NUG9u4fFQRmiEsT/K2Z4xwD3MJUyxJxiLf6KpmQ==
X-Received: by 2002:a1c:5454:: with SMTP id p20mr3305623wmi.187.1618307351369;
        Tue, 13 Apr 2021 02:49:11 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id 64sm1956458wmz.7.2021.04.13.02.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 02:49:10 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org,
        Pekka Paalanen <pekka.paalanen@collabora.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH 02/12] drm/arm/malidp: Always list modifiers
Date:   Tue, 13 Apr 2021 11:48:53 +0200
Message-Id: <20210413094904.3736372-2-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210413094904.3736372-1-daniel.vetter@ffwll.ch>
References: <20210413094904.3736372-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Even when all we support is linear, make that explicit. Otherwise the
uapi is rather confusing.

Cc: stable@vger.kernel.org
Cc: Pekka Paalanen <pekka.paalanen@collabora.com>
Cc: Liviu Dudau <liviu.dudau@arm.com>
Cc: Brian Starkey <brian.starkey@arm.com>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
---
 drivers/gpu/drm/arm/malidp_planes.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/arm/malidp_planes.c b/drivers/gpu/drm/arm/malidp_planes.c
index ddbba67f0283..8c2ab3d653b7 100644
--- a/drivers/gpu/drm/arm/malidp_planes.c
+++ b/drivers/gpu/drm/arm/malidp_planes.c
@@ -927,6 +927,11 @@ static const struct drm_plane_helper_funcs malidp_de_plane_helper_funcs = {
 	.atomic_disable = malidp_de_plane_disable,
 };
 
+static const uint64_t linear_only_modifiers[] = {
+	DRM_FORMAT_MOD_LINEAR,
+	DRM_FORMAT_MOD_INVALID
+};
+
 int malidp_de_planes_init(struct drm_device *drm)
 {
 	struct malidp_drm *malidp = drm->dev_private;
@@ -990,8 +995,8 @@ int malidp_de_planes_init(struct drm_device *drm)
 		 */
 		ret = drm_universal_plane_init(drm, &plane->base, crtcs,
 				&malidp_de_plane_funcs, formats, n,
-				(id == DE_SMART) ? NULL : modifiers, plane_type,
-				NULL);
+				(id == DE_SMART) ? linear_only_modifiers : modifiers,
+				plane_type, NULL);
 
 		if (ret < 0)
 			goto cleanup;
-- 
2.31.0

