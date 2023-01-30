Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52DB0681043
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237030AbjA3OCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236926AbjA3OB0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:01:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B6C2799E
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:01:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E65C261031
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059D9C433D2;
        Mon, 30 Jan 2023 14:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087282;
        bh=T76+MV6P5E+vCULiQnsuChBayLA50K+junCa4W2o0aE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sVlbhl7LQ/w/db2/tRbidivnyU7FaDKrW54wCP0OXS+wKMte9uCegXRM0dvoQTm+q
         Sw+MrgCdoqFqmAKEkJLAcBwCtIU1GXVoRbHvMpDYoseT3WBXbJufIr/0pdQCIVhZBI
         6F5re9sqgM+KIcqBj3xwu/XnkQTxtcwDwEZbJQD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Akhil P Oommen <quic_akhilpo@quicinc.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 156/313] drm/msm/a6xx: Avoid gx gbit halt during rpm suspend
Date:   Mon, 30 Jan 2023 14:49:51 +0100
Message-Id: <20230130134343.922692479@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akhil P Oommen <quic_akhilpo@quicinc.com>

[ Upstream commit f4a75b5933c998e60fd812a7680e0971eb1c7cee ]

As per the downstream driver, gx gbif halt is required only during
recovery sequence. So lets avoid it during regular rpm suspend.

Signed-off-by: Akhil P Oommen <quic_akhilpo@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/515279/
Link: https://lore.kernel.org/r/20221216223253.1.Ice9c47bfeb1fddb8dc377a3491a043a3ee7fca7d@changeid
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c | 15 +++++++++------
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c |  7 +++++++
 drivers/gpu/drm/msm/adreno/a6xx_gpu.h |  1 +
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index e033d6a67a20..870252bef23f 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -876,7 +876,8 @@ static void a6xx_gmu_rpmh_off(struct a6xx_gmu *gmu)
 #define GBIF_CLIENT_HALT_MASK             BIT(0)
 #define GBIF_ARB_HALT_MASK                BIT(1)
 
-static void a6xx_bus_clear_pending_transactions(struct adreno_gpu *adreno_gpu)
+static void a6xx_bus_clear_pending_transactions(struct adreno_gpu *adreno_gpu,
+		bool gx_off)
 {
 	struct msm_gpu *gpu = &adreno_gpu->base;
 
@@ -889,9 +890,11 @@ static void a6xx_bus_clear_pending_transactions(struct adreno_gpu *adreno_gpu)
 		return;
 	}
 
-	/* Halt the gx side of GBIF */
-	gpu_write(gpu, REG_A6XX_RBBM_GBIF_HALT, 1);
-	spin_until(gpu_read(gpu, REG_A6XX_RBBM_GBIF_HALT_ACK) & 1);
+	if (gx_off) {
+		/* Halt the gx side of GBIF */
+		gpu_write(gpu, REG_A6XX_RBBM_GBIF_HALT, 1);
+		spin_until(gpu_read(gpu, REG_A6XX_RBBM_GBIF_HALT_ACK) & 1);
+	}
 
 	/* Halt new client requests on GBIF */
 	gpu_write(gpu, REG_A6XX_GBIF_HALT, GBIF_CLIENT_HALT_MASK);
@@ -929,7 +932,7 @@ static void a6xx_gmu_force_off(struct a6xx_gmu *gmu)
 	/* Halt the gmu cm3 core */
 	gmu_write(gmu, REG_A6XX_GMU_CM3_SYSRESET, 1);
 
-	a6xx_bus_clear_pending_transactions(adreno_gpu);
+	a6xx_bus_clear_pending_transactions(adreno_gpu, true);
 
 	/* Reset GPU core blocks */
 	gpu_write(gpu, REG_A6XX_RBBM_SW_RESET_CMD, 1);
@@ -1083,7 +1086,7 @@ static void a6xx_gmu_shutdown(struct a6xx_gmu *gmu)
 			return;
 		}
 
-		a6xx_bus_clear_pending_transactions(adreno_gpu);
+		a6xx_bus_clear_pending_transactions(adreno_gpu, a6xx_gpu->hung);
 
 		/* tell the GMU we want to slumber */
 		ret = a6xx_gmu_notify_slumber(gmu);
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index e846e629c00d..9d7fc44c1e2a 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1277,6 +1277,12 @@ static void a6xx_recover(struct msm_gpu *gpu)
 	if (hang_debug)
 		a6xx_dump(gpu);
 
+	/*
+	 * To handle recovery specific sequences during the rpm suspend we are
+	 * about to trigger
+	 */
+	a6xx_gpu->hung = true;
+
 	/* Halt SQE first */
 	gpu_write(gpu, REG_A6XX_CP_SQE_CNTL, 3);
 
@@ -1319,6 +1325,7 @@ static void a6xx_recover(struct msm_gpu *gpu)
 	mutex_unlock(&gpu->active_lock);
 
 	msm_gpu_hw_init(gpu);
+	a6xx_gpu->hung = false;
 }
 
 static const char *a6xx_uche_fault_block(struct msm_gpu *gpu, u32 mid)
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.h b/drivers/gpu/drm/msm/adreno/a6xx_gpu.h
index ab853f61db63..eea2e60ce3b7 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.h
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.h
@@ -32,6 +32,7 @@ struct a6xx_gpu {
 	void *llc_slice;
 	void *htw_llc_slice;
 	bool have_mmu500;
+	bool hung;
 };
 
 #define to_a6xx_gpu(x) container_of(x, struct a6xx_gpu, base)
-- 
2.39.0



