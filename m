Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12473B9157
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbfITOD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:03:59 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36822 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727904AbfITOD6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:03:58 -0400
Received: by mail-pl1-f196.google.com with SMTP id f19so3239706plr.3
        for <stable@vger.kernel.org>; Fri, 20 Sep 2019 07:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=na0uArJnXROHfqUkRT3i4m1p89imfG3hiUyVo7V9aMI=;
        b=gpdqdMzlOwj0+hw6qAItsR0hEnBJvBexyvoZTVyb8V1KsErBxMZx4Z9JBKqzmmxnCs
         hBExO+i8QYL7dO14LZXDHNEIxCN0dgLBn81RjDSM6MWiAPtoAJIX0CDbbvruXEIMdavM
         Ajd1qJHtYJXEtzkpOWSPdpesFlEAqXcud/PbDFmXYyXE48NA7yqwICTuJvjA1fw8iU76
         JJZZdaxDkqDX+omuGMoBRp4EZGSyECdcE/BzEX9ciEat7oenCLzw5hzVdA0/uU2t8yD1
         4La6YOVwjFLF6VvebUVpmsDXfeGcYaI9KPT6vWuwLNRm/Y2FBATD9pdPQ7ME11jAe39i
         YRtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=na0uArJnXROHfqUkRT3i4m1p89imfG3hiUyVo7V9aMI=;
        b=qRS+veJcqbWvstY6AzMs46u23/EP31TVorU7c3cKwWtGyk1vloaD2hpBuP3gmXlcOz
         uDcTxTTCPyqF9QrDR3Yi91jt8/rCAgAUtUVl4I4F+Byd1hYst7rfAe75oDiaxGZuESYf
         SafacUYEQTT9a8cPgsXOTjv8cLSL/y7C6o6SqzhczBc1cPMJCVAaE8Fr4XsIxasNSsy1
         Vnj34pnw1OjIKFYgRKLhqguTodk4V4/+Oi9m0mqDYsGdmeENTro1nkQP71Q01jSofARd
         OZ0SXczFXxkaA349SRGbH40Ui6rqXCsi1wW/JxfsKijw5pVHO1sOWbTLkyfUi4YQzVLj
         Op9A==
X-Gm-Message-State: APjAAAXdAJUvPZf3FqCk6tUomD1HpzzrXRBCJtvg0jRjA6jL7BOu4gzI
        o+gBRaIgMzJlLd8dKMYoLgTrEECa
X-Google-Smtp-Source: APXvYqx46bfoN4r3xbaYF2Ia2x48hb/+XmnHYmbHAMe7VAqupMS1Kn1SRCcK/EEesO8dyN8sxhjq8Q==
X-Received: by 2002:a17:902:b58f:: with SMTP id a15mr17043523pls.81.1568988237416;
        Fri, 20 Sep 2019 07:03:57 -0700 (PDT)
Received: from localhost.localdomain ([71.219.73.178])
        by smtp.gmail.com with ESMTPSA id 8sm2232180pgd.87.2019.09.20.07.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 07:03:56 -0700 (PDT)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org
Cc:     nicholas.kazlauskas@amd.com,
        Alex Deucher <alexander.deucher@amd.com>,
        David Francis <david.francis@amd.com>
Subject: [PATCH 1/3] drm/amd/display: Allow cursor async updates for framebuffer swaps
Date:   Fri, 20 Sep 2019 09:03:36 -0500
Message-Id: <20190920140338.3172-2-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190920140338.3172-1-alexander.deucher@amd.com>
References: <20190920140338.3172-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[Why]
We previously allowed framebuffer swaps as async updates for cursor
planes but had to disable them due to a bug in DRM with async update
handling and incorrect ref counting. The check to block framebuffer
swaps has been added to DRM for a while now, so this check is redundant.

The real fix that allows this to properly in DRM has also finally been
merged and is getting backported into stable branches, so dropping
this now seems to be the right time to do so.

[How]
Drop the redundant check for old_fb != new_fb.

With the proper fix in DRM, this should also fix some cursor stuttering
issues with xf86-video-amdgpu since it double buffers the cursor.

IGT tests that swap framebuffers (-varying-size for example) should
also pass again.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=204181
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: David Francis <david.francis@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e16e37efb4c9eb7bcb9dab756c975040c5257e98)
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 45be7a2132bb..ab341fca9647 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4548,20 +4548,10 @@ static int dm_plane_atomic_check(struct drm_plane *plane,
 static int dm_plane_atomic_async_check(struct drm_plane *plane,
 				       struct drm_plane_state *new_plane_state)
 {
-	struct drm_plane_state *old_plane_state =
-		drm_atomic_get_old_plane_state(new_plane_state->state, plane);
-
 	/* Only support async updates on cursor planes. */
 	if (plane->type != DRM_PLANE_TYPE_CURSOR)
 		return -EINVAL;
 
-	/*
-	 * DRM calls prepare_fb and cleanup_fb on new_plane_state for
-	 * async commits so don't allow fb changes.
-	 */
-	if (old_plane_state->fb != new_plane_state->fb)
-		return -EINVAL;
-
 	return 0;
 }
 
-- 
2.20.1

