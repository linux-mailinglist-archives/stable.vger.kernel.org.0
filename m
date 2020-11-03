Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0BC2A4B7D
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 17:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbgKCQ3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 11:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728299AbgKCQ3V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 11:29:21 -0500
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAFDC0613D1
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 08:29:21 -0800 (PST)
Received: by mail-qt1-x843.google.com with SMTP id i7so12011877qti.6
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 08:29:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p7iY6eYHf4NxVydfp019sX57cctHVcalCCd1rMRGLdM=;
        b=GGNk7JkeHuft05UOGno2bPj+iaJXHOtimyXZropoOivCIaKasrWH+o573tkDFtau0o
         Vq08KAKHRNNbFrzkMnqF2o8zGmyCp1DsGsKElQIu0/9rZo/s5xng/KH9J9VHDmt9f3Au
         DxHrZJIjrfglmgS3PMM6WfrOTZKJbXPfa6XVrkda+6UTQNOMrgkDF7KcLWC+eGIK3t7x
         UuFP51ziJjekozPHH6LDdT0ZD5H/SCoQ7ZdUuK8UFfn3ndTPf3a/iy78ndyzpfVGQO/u
         6z5LKZ8qwrdkQyqXYtOBmZD3YTYy0MGHrnxEGp2TPzZu/KE4P+gKbZllZJC1jEOSGHOv
         aicQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p7iY6eYHf4NxVydfp019sX57cctHVcalCCd1rMRGLdM=;
        b=RriPLvR7XXZeGbbaPh68jR5ZM+FuuD8UosTflEFnTqVwfq1AiVldZ7gRO8398wJ0Om
         2uGWhFOX8lpFBj4tCq+DmyRajdW7MbCj0P+NPYeVo1O/99pWgREdVWtmVeCxN1Yo9HL4
         JtEULFCUJw5Asu4+zxhFBnGq+8WO1ZkETdQsMzodvohkL+6I+BOoZgZGnASiYDRanFvi
         ix5ah2DShYyJd4neASmKp43eZwNSqxJFY2rfPmT2KS6oSP8cTY0f2e7B8S+HrlBIYXgE
         Si26qJKXYJbf3r0tfT6KCBOuFiS2sEXfcUJtjO3qHPg59ctqxzJaZ3byxSq8m149ceuR
         t4bw==
X-Gm-Message-State: AOAM532Oxjf9ZsT2AS95bFUDx/M9OKqulwyjqoYfFgqBBPl9faL+DfDl
        5HrPDXAzrT5vDhr2E+YM1W6HOloMDeA=
X-Google-Smtp-Source: ABdhPJxq5IL/f/MacY+EaoKR+fLDJkeN0jsNtxrIlxFxA6FJ5BTwvsjQfHJ7kEi7L3WpJe0fPgSIsA==
X-Received: by 2002:ac8:7752:: with SMTP id g18mr19047428qtu.42.1604420960363;
        Tue, 03 Nov 2020 08:29:20 -0800 (PST)
Received: from localhost.localdomain ([71.219.66.138])
        by smtp.gmail.com with ESMTPSA id d48sm10171434qta.26.2020.11.03.08.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 08:29:19 -0800 (PST)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org
Cc:     Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7/7] drm/amd/psp: Fix sysfs: cannot create duplicate filename
Date:   Tue,  3 Nov 2020 11:29:03 -0500
Message-Id: <20201103162903.687752-9-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201103162903.687752-1-alexander.deucher@amd.com>
References: <20201103162903.687752-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Grodzovsky <andrey.grodzovsky@amd.com>

psp sysfs not cleaned up on driver unload for sienna_cichlid

Fixes: ce87c98db428e7 ("drm/amdgpu: Include sienna_cichlid in USBC PD FW support.")
Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.9.x
(cherry picked from commit f1bcddffe46b349a82445a8d9efd5f5fcb72557f)
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 06757681b2ce..f1cae42dcc36 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -206,7 +206,8 @@ static int psp_sw_fini(void *handle)
 		adev->psp.ta_fw = NULL;
 	}
 
-	if (adev->asic_type == CHIP_NAVI10)
+	if (adev->asic_type == CHIP_NAVI10 ||
+	    adev->asic_type == CHIP_SIENNA_CICHLID)
 		psp_sysfs_fini(adev);
 
 	return 0;
-- 
2.25.4

