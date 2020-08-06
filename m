Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF5823DCBF
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 18:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729523AbgHFQzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 12:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729820AbgHFQzI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 12:55:08 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F02C0A889C
        for <stable@vger.kernel.org>; Thu,  6 Aug 2020 07:49:48 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id s23so36513727qtq.12
        for <stable@vger.kernel.org>; Thu, 06 Aug 2020 07:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SL+1v+RarsORJEz5ZKUjCCITEv9GWVrRtEq5OdvpGSU=;
        b=be/bJ/XSwQ2+bp7+EHKhH9v8S9feUIa618Riwv9FyEswMWdWaaD7B13Gpu82NaaWV/
         LGucCNQYVMAll6T2L1bs6CB/pS/CL7TsHeoXGcfQloGN7S00hr4jAmKD7Am84fRrzOCo
         gRZlsuTwCpnfbVNaYOfHeMVce+P67nndc+MtKHYvP7AceCq5KiHjVcQtZQGsj0M8bnLq
         Kw2IEjoTm0f4YoSWUtO6KMfHaQ8OzXvSEa0AvVt6R55RMvH4a4OedEYHsJoRS1CYk4P1
         xY60pCILrTOG7KeSZs01qNMak3uLcAvx1bCn8ohzgLk8tBMPFLW0Cy4jwzD6j/TnouYp
         53Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SL+1v+RarsORJEz5ZKUjCCITEv9GWVrRtEq5OdvpGSU=;
        b=NKdzgcqfr37so8KeuHzVNdOrET54c8mkVbAq2CgsGgT77SA1msydkZgxS7WE4m0Vka
         w0D1dxrHx4myIbV/XVwhOvaOW/JUUUr9IA0FGHt0l3ESFVltp8SiicNUfAst034qQi/y
         GoLNn7++5bGeCZ2+95kMXaiuV1o6ilpBA037XfKBxZI4hNyt8/kemH6h1TV5EBN+/FOp
         a9JPrsgFTTeWSfJ9rcWMVOUoGISHslU/oC98Rgs4uCbGcx8IAu/Sx0ZbCVS0x3m822Fh
         feHjU9q/dO7oOiKGbQAOtDNeMc8oKm8HCRLkKIGQ2Ammo467t5SDB0hTnHN/B7bhctgw
         qxsg==
X-Gm-Message-State: AOAM531tJmawtsAaBH0Nj9haeohPeJTVHcc1rrS0E80hf7qmzkaGkPUO
        I1D/TaO9u0qIimwJgDfSHrFPM8e+
X-Google-Smtp-Source: ABdhPJytHCyznPJbD0iBXkih349b0qMHsKI92mWvxS/z9dPY4rHKRkdf0HCKA25NadwMBHumH1Cwzg==
X-Received: by 2002:ac8:1b0f:: with SMTP id y15mr9467153qtj.144.1596725387888;
        Thu, 06 Aug 2020 07:49:47 -0700 (PDT)
Received: from localhost.localdomain ([71.219.66.138])
        by smtp.gmail.com with ESMTPSA id q7sm4407702qkf.35.2020.08.06.07.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 07:49:47 -0700 (PDT)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Huang Rui <ray.huang@amd.com>
Subject: [PATCH v2] drm/amdgpu: fix ordering of psp suspend
Date:   Thu,  6 Aug 2020 10:49:39 -0400
Message-Id: <20200806144939.466297-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The ordering of psp_tmr_terminate() and psp_asd_unload()
got reversed when the patches were applied to stable.

This patch does not exist in Linus' tree because the ordering
is correct there.  It got reversed when the patches were applied
to stable.  This patch is for stable only.

Fixes: 22ff658396b446 ("drm/amdgpu: asd function needs to be unloaded in suspend phase")
Fixes: 2c41c968c6f648 ("drm/amdgpu: add TMR destory function for psp")
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.7.x
Cc: Huang Rui <ray.huang@amd.com>
---

Make the description more explicit as to why this patch is only for stable.

 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 3c6f60c5b1a5..088f43ebdceb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -1679,15 +1679,15 @@ static int psp_suspend(void *handle)
 		}
 	}
 
-	ret = psp_tmr_terminate(psp);
+	ret = psp_asd_unload(psp);
 	if (ret) {
-		DRM_ERROR("Falied to terminate tmr\n");
+		DRM_ERROR("Failed to unload asd\n");
 		return ret;
 	}
 
-	ret = psp_asd_unload(psp);
+	ret = psp_tmr_terminate(psp);
 	if (ret) {
-		DRM_ERROR("Failed to unload asd\n");
+		DRM_ERROR("Falied to terminate tmr\n");
 		return ret;
 	}
 
-- 
2.25.4

