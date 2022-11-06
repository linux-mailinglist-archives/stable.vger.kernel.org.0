Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844D361E39F
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiKFRDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:03:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiKFRDw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:03:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84180DFC4;
        Sun,  6 Nov 2022 09:03:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CBCFB80B38;
        Sun,  6 Nov 2022 17:03:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A151C433C1;
        Sun,  6 Nov 2022 17:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754228;
        bh=aBETzMf0OclZ0SaVEPr4il3hPRXeVDkWT00EYqZWNXQ=;
        h=From:To:Cc:Subject:Date:From;
        b=TPzKC7Mz5MCCkwQKeWtIvTNO2t34monjJW7W4WQ+kO2/kchlTWSjnmtLQeLVKoCJS
         CA32IoDqYmv7LUGnj2hBVnVxa+HvRke2sBuo+u3AXU50yDLvJwMFI7/0p6f/dljrbG
         E9m244vW//2NQm0+JWRkQKOxbmzlsN72qm36pyDTbblCrLyL6+Cvn36BTB4U200Hds
         ZPSEBTlYdp7c2qgEt078ZLFB8kJKBv1zIWefdpNo2Q/uwH3aXsVKAAHr1flkYnA7mY
         OwuN1wdYTQ6kDTWIgIC8gcy050ZA3IqaDVJVlD50nlqFo03BWlqfpooxZxQRCbSqZD
         AOb5UXDJegE+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Akhil P Oommen <quic_akhilpo@quicinc.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, robdclark@gmail.com,
        quic_abhinavk@quicinc.com, dmitry.baryshkov@linaro.org,
        airlied@gmail.com, daniel@ffwll.ch,
        angelogioacchino.delregno@collabora.com, andersson@kernel.org,
        olvaffe@gmail.com, konrad.dybcio@somainline.org, nathan@kernel.org,
        vladimir.lypak@gmail.com, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 01/30] drm/msm/gpu: Fix crash during system suspend after unbind
Date:   Sun,  6 Nov 2022 12:03:13 -0500
Message-Id: <20221106170345.1579893-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akhil P Oommen <quic_akhilpo@quicinc.com>

[ Upstream commit 76efc2453d0e8e5d6692ef69981b183ad674edea ]

In adreno_unbind, we should clean up gpu device's drvdata to avoid
accessing a stale pointer during system suspend. Also, check for NULL
ptr in both system suspend/resume callbacks.

Signed-off-by: Akhil P Oommen <quic_akhilpo@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/505075/
Link: https://lore.kernel.org/r/20220928124830.2.I5ee0ac073ccdeb81961e5ec0cce5f741a7207a71@changeid
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_device.c | 10 +++++++++-
 drivers/gpu/drm/msm/msm_gpu.c              |  2 ++
 drivers/gpu/drm/msm/msm_gpu.h              |  4 ++++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_device.c b/drivers/gpu/drm/msm/adreno/adreno_device.c
index 24b489b6129a..628806423f7d 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_device.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_device.c
@@ -679,6 +679,9 @@ static int adreno_system_suspend(struct device *dev)
 	struct msm_gpu *gpu = dev_to_gpu(dev);
 	int remaining, ret;
 
+	if (!gpu)
+		return 0;
+
 	suspend_scheduler(gpu);
 
 	remaining = wait_event_timeout(gpu->retire_event,
@@ -700,7 +703,12 @@ static int adreno_system_suspend(struct device *dev)
 
 static int adreno_system_resume(struct device *dev)
 {
-	resume_scheduler(dev_to_gpu(dev));
+	struct msm_gpu *gpu = dev_to_gpu(dev);
+
+	if (!gpu)
+		return 0;
+
+	resume_scheduler(gpu);
 	return pm_runtime_force_resume(dev);
 }
 
diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
index c2bfcf3f1f40..01aae792ffa9 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -993,4 +993,6 @@ void msm_gpu_cleanup(struct msm_gpu *gpu)
 	}
 
 	msm_devfreq_cleanup(gpu);
+
+	platform_set_drvdata(gpu->pdev, NULL);
 }
diff --git a/drivers/gpu/drm/msm/msm_gpu.h b/drivers/gpu/drm/msm/msm_gpu.h
index 4d935fedd2ac..fd22cf4041af 100644
--- a/drivers/gpu/drm/msm/msm_gpu.h
+++ b/drivers/gpu/drm/msm/msm_gpu.h
@@ -282,6 +282,10 @@ struct msm_gpu {
 static inline struct msm_gpu *dev_to_gpu(struct device *dev)
 {
 	struct adreno_smmu_priv *adreno_smmu = dev_get_drvdata(dev);
+
+	if (!adreno_smmu)
+		return NULL;
+
 	return container_of(adreno_smmu, struct msm_gpu, adreno_smmu);
 }
 
-- 
2.35.1

