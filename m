Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE6263575F
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238015AbiKWJmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238072AbiKWJlq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:41:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D7F112C53
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:39:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86AE8B81E54
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC79AC433D6;
        Wed, 23 Nov 2022 09:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196361;
        bh=aBETzMf0OclZ0SaVEPr4il3hPRXeVDkWT00EYqZWNXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D6Y/xLWrQVdTJ/dI86oTCnNP/sGnk1T3kFK0OoG3WQDJy2aiuroC57AL7GFmBxaqg
         93RJr2+S3qcrVYsKTWnKy634G2jKUwb+fLmZwfJnPGyJwEyJQPESsddkuMbkVdp0Mm
         4E6y8RDTO6HGgHm7eksOI7b4Kv9SfKDoA8ujTa+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Akhil P Oommen <quic_akhilpo@quicinc.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 002/314] drm/msm/gpu: Fix crash during system suspend after unbind
Date:   Wed, 23 Nov 2022 09:47:27 +0100
Message-Id: <20221123084625.591524745@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



