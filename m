Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9908823D3B2
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 23:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbgHEV5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 17:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbgHEV5P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 17:57:15 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66865C061575
        for <stable@vger.kernel.org>; Wed,  5 Aug 2020 14:57:14 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id t6so16579675qvw.1
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 14:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U7VYDn64dFaNrOzrZ1JpPjis8QfdUcSYrZFIEVpa150=;
        b=pygcnPN8FmJyLMaqx0BahUHPEgV9af9Wif1UPO32Sn+S78hL86xiR93+YJ8En7jucW
         1zyJjc1nzFu4cYHZhfGuv8xAUgrmpuy6VP7pPYCqhdkWXfnAVT7GJGG/SIlBaPtlmDQR
         rUE+MN/w6+9+/lLK6pu2bPiPDJgZnFkyRE5aK37iQrEExzuX040WCB6I8DlndzsN+Ts5
         6DCoDH0VL3GzYbO2UuUH32R2HyDuydg2cEf3XxN3snRJEwSZAEHWSxbJz4ZWDoTVaiFH
         xfBWu5HVYIVEyo4gpU6/bIBkhcawRzdIUEbmpL7rfQwk0Z66vW9vrqVXnRzPaN/Dd4np
         4S/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U7VYDn64dFaNrOzrZ1JpPjis8QfdUcSYrZFIEVpa150=;
        b=D8/QcJjbk9ZvXllzZV3lf4a3mVlnREVn6AAiaoiJmchhY4ODVfIse5M3Fp1U1u59lC
         EUUFwsdZlExlGhw/Yf/TgVC4k5DT6FGC0oENV8tlUp1qighv+bKKsEkVycLM4rwJ5JSW
         G1Kt6uhZOS+E5BS23CpzApv6hnUP46eS4fjH7fiX6cgHoCL36vGacxmMuZO+R88cZ98g
         DOx8UqHbE98HdyGjthbAN+JMKpByxSOwKXTmmW/HAn9t/XpokDOwn06T6NAhk1vP0Qsg
         ehomoax8j1QRQR2JdQaBhgD7GqgMm36Ao2P5JgRX3R7YUSV4QGJVnEPAEpJ3M+sKlGtm
         Ieig==
X-Gm-Message-State: AOAM532AffoU/bOJ0OR8sf/njF/6Jm8Ro8cURfOtHCNJlu4f2gOeRLmk
        /nvRN3SVgj67PpOtdYHZFOeNhNXu
X-Google-Smtp-Source: ABdhPJyasR4viBs6qQJwscOrvafdrd+ZcVSQ8bekePelSg3ruhcyEEIKl51KCHClsnwDMkvYajMW8A==
X-Received: by 2002:a05:6214:290:: with SMTP id l16mr5968990qvv.187.1596664632359;
        Wed, 05 Aug 2020 14:57:12 -0700 (PDT)
Received: from localhost.localdomain ([71.219.66.138])
        by smtp.gmail.com with ESMTPSA id n85sm2522286qkn.80.2020.08.05.14.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 14:57:11 -0700 (PDT)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Huang Rui <ray.huang@amd.com>
Subject: [PATCH] drm/amdgpu: fix ordering of psp suspend
Date:   Wed,  5 Aug 2020 17:57:00 -0400
Message-Id: <20200805215700.451808-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The ordering of psp_tmr_terminate() and psp_asd_unload()
got reversed when the patches were applied to stable.

Fixes: 22ff658396b446 ("drm/amdgpu: asd function needs to be unloaded in suspend phase")
Fixes: 2c41c968c6f648 ("drm/amdgpu: add TMR destory function for psp")
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.7.x
Cc: Huang Rui <ray.huang@amd.com>
---
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

