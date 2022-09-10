Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F445B4953
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiIJVS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiIJVSK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:18:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417254DB53;
        Sat, 10 Sep 2022 14:17:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4449060E1F;
        Sat, 10 Sep 2022 21:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6FDC4347C;
        Sat, 10 Sep 2022 21:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844642;
        bh=lKWIFsFMln7pe1vmo5/zv2VQOb0rZrQ3m5h6WbdOT+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pu4hU4ANPeTOXsyhoUFVfe075qHTWhXf+GVa94v7pxjDv5OmXTkv5Phn0zqJHL51D
         oL0kDU0jkpSdHzXUp5srfOc074QKYVi7n6jyrVlFPzpuMoNOezmO/VyYnmE//j9y8S
         En3/AQ1d+HPqYJ0cXt7RrxhdoXECjTRfayAJqYT9eL3CoxK1hg0HZoMu6HADdiBnAE
         0VIWEcZIkiuNPwYUwntsuHvK0r8ac18laDu/YO+rmPzKiU/Pt6oUodHwaJWD+E1Egf
         zAKEZZ1q7aXws/NC+SfDnmfsG+67hE4/iw6RnhniNDCREsSxafbqLm5UHhrAuiFgF7
         /ApLPWZWsLUyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Quan <evan.quan@amd.com>, Kenneth Feng <kenneth.feng@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        KevinYang.Wang@amd.com, Hawking.Zhang@amd.com, Jack.Gui@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 25/38] drm/amd/pm: use vbios carried pptable for all SMU13.0.7 SKUs
Date:   Sat, 10 Sep 2022 17:16:10 -0400
Message-Id: <20220910211623.69825-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211623.69825-1-sashal@kernel.org>
References: <20220910211623.69825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit b023053592646b1da9477b0b598f2cdd5d3f89d8 ]

For those SMU13.0.7 unsecure SKUs, the vbios carried pptable is ready to go.
Use that one instead of hardcoded softpptable.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c  | 35 ++++++++++++-------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
index 4e1861fb2c6a4..ef811ba1c5a7d 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -382,11 +382,27 @@ static int smu_v13_0_7_append_powerplay_table(struct smu_context *smu)
 	return 0;
 }
 
+static int smu_v13_0_7_get_pptable_from_pmfw(struct smu_context *smu,
+					     void **table,
+					     uint32_t *size)
+{
+	struct smu_table_context *smu_table = &smu->smu_table;
+	void *combo_pptable = smu_table->combo_pptable;
+	int ret = 0;
+
+	ret = smu_cmn_get_combo_pptable(smu);
+	if (ret)
+		return ret;
+
+	*table = combo_pptable;
+	*size = sizeof(struct smu_13_0_7_powerplay_table);
+
+	return 0;
+}
 
 static int smu_v13_0_7_setup_pptable(struct smu_context *smu)
 {
 	struct smu_table_context *smu_table = &smu->smu_table;
-	void *combo_pptable = smu_table->combo_pptable;
 	struct amdgpu_device *adev = smu->adev;
 	int ret = 0;
 
@@ -395,18 +411,11 @@ static int smu_v13_0_7_setup_pptable(struct smu_context *smu)
 	 * be used directly by driver. To get the raw pptable, we need to
 	 * rely on the combo pptable(and its revelant SMU message).
 	 */
-	if (adev->scpm_enabled) {
-		ret = smu_cmn_get_combo_pptable(smu);
-		if (ret)
-			return ret;
-
-		smu->smu_table.power_play_table = combo_pptable;
-		smu->smu_table.power_play_table_size = sizeof(struct smu_13_0_7_powerplay_table);
-	} else {
-		ret = smu_v13_0_setup_pptable(smu);
-		if (ret)
-			return ret;
-	}
+	ret = smu_v13_0_7_get_pptable_from_pmfw(smu,
+						&smu_table->power_play_table,
+						&smu_table->power_play_table_size);
+	if (ret)
+		return ret;
 
 	ret = smu_v13_0_7_store_powerplay_table(smu);
 	if (ret)
-- 
2.35.1

