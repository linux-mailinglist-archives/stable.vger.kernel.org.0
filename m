Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D52360A731
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234330AbiJXMsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234612AbiJXMpU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:45:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455D02E691;
        Mon, 24 Oct 2022 05:09:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AF6961281;
        Mon, 24 Oct 2022 12:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E89C433C1;
        Mon, 24 Oct 2022 12:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613342;
        bh=/DnBlGEHmDsKGRdYo7vtlx+6+pve0D4reGzgxgMkpRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kkmgqS6vrXuNc4EyLhVgDcj9NN5/KwxnvnNRVXUuvD+lcPPzeIy3YdSuYhhdWle67
         KblEpOCNJz1jYGcbaNfaiEVhFNyVWWcyPqSEQeVmwe3Qv5T/DQWvUni6YKu6nMwPwE
         iW9Mqr1V+w+TY7tYd6SStVxt57C1WVXZSIzZzyA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 101/255] drm/msm/dpu: index dpu_kms->hw_vbif using vbif_idx
Date:   Mon, 24 Oct 2022 13:30:11 +0200
Message-Id: <20221024113005.834791195@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 7538f80ae0d98bf51eb89eee5344aec219902d42 ]

Remove loops over hw_vbif. Instead always VBIF's idx as an index in the
array. This fixes an error in dpu_kms_hw_init(), where we fill
dpu_kms->hw_vbif[i], but check for an error pointer at
dpu_kms->hw_vbif[vbif_idx].

Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/489569/
Link: https://lore.kernel.org/r/20220615125703.24647-1-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c  | 12 ++++------
 drivers/gpu/drm/msm/disp/dpu1/dpu_vbif.c | 29 +++++++++++-------------
 2 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
index c08c67338d73..a74f8ae1a894 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
@@ -596,12 +596,10 @@ static void _dpu_kms_hw_destroy(struct dpu_kms *dpu_kms)
 	_dpu_kms_mmu_destroy(dpu_kms);
 
 	if (dpu_kms->catalog) {
-		for (i = 0; i < dpu_kms->catalog->vbif_count; i++) {
-			u32 vbif_idx = dpu_kms->catalog->vbif[i].id;
-
-			if ((vbif_idx < VBIF_MAX) && dpu_kms->hw_vbif[vbif_idx]) {
-				dpu_hw_vbif_destroy(dpu_kms->hw_vbif[vbif_idx]);
-				dpu_kms->hw_vbif[vbif_idx] = NULL;
+		for (i = 0; i < ARRAY_SIZE(dpu_kms->hw_vbif); i++) {
+			if (dpu_kms->hw_vbif[i]) {
+				dpu_hw_vbif_destroy(dpu_kms->hw_vbif[i]);
+				dpu_kms->hw_vbif[i] = NULL;
 			}
 		}
 	}
@@ -899,7 +897,7 @@ static int dpu_kms_hw_init(struct msm_kms *kms)
 	for (i = 0; i < dpu_kms->catalog->vbif_count; i++) {
 		u32 vbif_idx = dpu_kms->catalog->vbif[i].id;
 
-		dpu_kms->hw_vbif[i] = dpu_hw_vbif_init(vbif_idx,
+		dpu_kms->hw_vbif[vbif_idx] = dpu_hw_vbif_init(vbif_idx,
 				dpu_kms->vbif[vbif_idx], dpu_kms->catalog);
 		if (IS_ERR_OR_NULL(dpu_kms->hw_vbif[vbif_idx])) {
 			rc = PTR_ERR(dpu_kms->hw_vbif[vbif_idx]);
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_vbif.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_vbif.c
index 8d24b79fd400..5e6bb2f306be 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_vbif.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_vbif.c
@@ -11,6 +11,14 @@
 #include "dpu_hw_vbif.h"
 #include "dpu_trace.h"
 
+static struct dpu_hw_vbif *dpu_get_vbif(struct dpu_kms *dpu_kms, enum dpu_vbif vbif_idx)
+{
+	if (vbif_idx < ARRAY_SIZE(dpu_kms->hw_vbif))
+		return dpu_kms->hw_vbif[vbif_idx];
+
+	return NULL;
+}
+
 /**
  * _dpu_vbif_wait_for_xin_halt - wait for the xin to halt
  * @vbif:	Pointer to hardware vbif driver
@@ -148,11 +156,11 @@ static u32 _dpu_vbif_get_ot_limit(struct dpu_hw_vbif *vbif,
 void dpu_vbif_set_ot_limit(struct dpu_kms *dpu_kms,
 		struct dpu_vbif_set_ot_params *params)
 {
-	struct dpu_hw_vbif *vbif = NULL;
+	struct dpu_hw_vbif *vbif;
 	struct dpu_hw_mdp *mdp;
 	bool forced_on = false;
 	u32 ot_lim;
-	int ret, i;
+	int ret;
 
 	if (!dpu_kms) {
 		DPU_ERROR("invalid arguments\n");
@@ -160,12 +168,7 @@ void dpu_vbif_set_ot_limit(struct dpu_kms *dpu_kms,
 	}
 	mdp = dpu_kms->hw_mdp;
 
-	for (i = 0; i < ARRAY_SIZE(dpu_kms->hw_vbif); i++) {
-		if (dpu_kms->hw_vbif[i] &&
-				dpu_kms->hw_vbif[i]->idx == params->vbif_idx)
-			vbif = dpu_kms->hw_vbif[i];
-	}
-
+	vbif = dpu_get_vbif(dpu_kms, params->vbif_idx);
 	if (!vbif || !mdp) {
 		DPU_DEBUG("invalid arguments vbif %d mdp %d\n",
 				vbif != 0, mdp != 0);
@@ -208,7 +211,7 @@ void dpu_vbif_set_ot_limit(struct dpu_kms *dpu_kms,
 void dpu_vbif_set_qos_remap(struct dpu_kms *dpu_kms,
 		struct dpu_vbif_set_qos_params *params)
 {
-	struct dpu_hw_vbif *vbif = NULL;
+	struct dpu_hw_vbif *vbif;
 	struct dpu_hw_mdp *mdp;
 	bool forced_on = false;
 	const struct dpu_vbif_qos_tbl *qos_tbl;
@@ -220,13 +223,7 @@ void dpu_vbif_set_qos_remap(struct dpu_kms *dpu_kms,
 	}
 	mdp = dpu_kms->hw_mdp;
 
-	for (i = 0; i < ARRAY_SIZE(dpu_kms->hw_vbif); i++) {
-		if (dpu_kms->hw_vbif[i] &&
-				dpu_kms->hw_vbif[i]->idx == params->vbif_idx) {
-			vbif = dpu_kms->hw_vbif[i];
-			break;
-		}
-	}
+	vbif = dpu_get_vbif(dpu_kms, params->vbif_idx);
 
 	if (!vbif || !vbif->cap) {
 		DPU_ERROR("invalid vbif %d\n", params->vbif_idx);
-- 
2.35.1



