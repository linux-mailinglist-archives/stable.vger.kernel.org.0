Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85AD40B634
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 19:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhINRt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 13:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhINRt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 13:49:58 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7A9C061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 10:48:41 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id a13so144008qvo.9
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 10:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vE+XbJKkpqZf2kFNVFWFF2mz4fMayebvGqrqdksM7Uw=;
        b=QYmDmNUoYYp7eyYlD5wjlPITOUgaZBpwUdDyd90J/f1Zy7D+a1vnc3FvDYQilXuKcp
         zfRUk6/mVs2Ebp5rcK+lstukvbs9HYPvigFzQw5nyDjEnrdLJ5tvifxT4mOa2QczJaPC
         uIg8nzIp3JH7kp4he+rmNd0+EI8A0K9grxEbp4/q3oJmBgOBjQB9ztpPbxYPh4dUlbuH
         NvdsoLWJn53/h25Uz4mz+M5gcS+FPdTtCx720oYNerAXXcaVyNuH7bHaZ7rQKYUVdTjO
         zCyibOw9tJgyJw7yRPWVn178LSNyXy2cF6YXNuSJKFYCY49wXsKm60SHhGTCaessNUyg
         TH6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vE+XbJKkpqZf2kFNVFWFF2mz4fMayebvGqrqdksM7Uw=;
        b=IxbOkoBZU5pZYPBPln65RvMB8XWuAwu4hO5+yObj1/YNEiarM90P2EiPM9zM0jECon
         O6jbeWDjwS8W0leHsosM0Hu78Us4nOJxKUK8d6DSMx6P79wtH8VEKjGFpvO+MjvfLk9L
         f41VrRtXkqwmKyK6d8mlkPrgcVdJMkFaq7/m7Ycb6vFzg18qT+CMrfoztCEYGqebWA/3
         pjV7mrVWSM0tpM7Vh5TJEh/afumfjrxOz/ktPiSycSAVPbECbVnVcNGWDyVLwj0MmXk/
         tKCCUBxDjxMpZPgYeDrIimu+jQSBeBWsl3HK2H64N6WvcorxGpd3SBfkfuivCsEEEx31
         3fpQ==
X-Gm-Message-State: AOAM533gOZqV/2e7aYkoVnAmn4Ir2Of/Vz2Ne8lFaRlzqIFkqf9MMMG2
        1ccQ8gaQLi49PEGOtuB04iI=
X-Google-Smtp-Source: ABdhPJxDJGpFBtye7VLJ1lrMBWIqsQn2vdPndhIiV2pGZgB8t/VUqCy4wayCpYTWumvDYqb8vrTwGw==
X-Received: by 2002:a0c:aa03:: with SMTP id d3mr6660817qvb.9.1631641720356;
        Tue, 14 Sep 2021 10:48:40 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:485:504a:c430:57f7:4c26:15c2])
        by smtp.gmail.com with ESMTPSA id p123sm8319478qke.94.2021.09.14.10.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 10:48:39 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     robdclark@gmail.com
Cc:     dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        abhinavk@codeaurora.org, dmitry.baryshkov@linaro.org,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] drm/msm: Do not run snapshot on non-DPU devices
Date:   Tue, 14 Sep 2021 14:48:31 -0300
Message-Id: <20210914174831.2044420-1-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit 98659487b845 ("drm/msm: add support to take dpu snapshot")
the following NULL pointer dereference is seen on i.MX53:

[ 3.275493] msm msm: bound 30000000.gpu (ops a3xx_ops)
[ 3.287174] [drm] Initialized msm 1.8.0 20130625 for msm on minor 0
[ 3.293915] 8<--- cut here ---
[ 3.297012] Unable to handle kernel NULL pointer dereference at virtual address 00000028
[ 3.305244] pgd = (ptrval)
[ 3.307989] [00000028] *pgd=00000000
[ 3.311624] Internal error: Oops: 805 [#1] SMP ARM
[ 3.316430] Modules linked in:
[ 3.319503] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.14.0+g682d702b426b #1
[ 3.326652] Hardware name: Freescale i.MX53 (Device Tree Support)
[ 3.332754] PC is at __mutex_init+0x14/0x54
[ 3.336969] LR is at msm_disp_snapshot_init+0x24/0xa0

i.MX53 does not use the DPU controller.

Fix the problem by only calling msm_disp_snapshot_init() on platforms that
use the DPU controller.

Cc: stable@vger.kernel.org
Fixes: 98659487b845 ("drm/msm: add support to take dpu snapshot")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 drivers/gpu/drm/msm/msm_drv.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index 2e6fc185e54d..2aa2266454b7 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -630,10 +630,11 @@ static int msm_drm_init(struct device *dev, const struct drm_driver *drv)
 	if (ret)
 		goto err_msm_uninit;
 
-	ret = msm_disp_snapshot_init(ddev);
-	if (ret)
-		DRM_DEV_ERROR(dev, "msm_disp_snapshot_init failed ret = %d\n", ret);
-
+	if (kms) {
+		ret = msm_disp_snapshot_init(ddev);
+		if (ret)
+			DRM_DEV_ERROR(dev, "msm_disp_snapshot_init failed ret = %d\n", ret);
+	}
 	drm_mode_config_reset(ddev);
 
 #ifdef CONFIG_DRM_FBDEV_EMULATION
-- 
2.25.1

