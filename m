Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 062C66C19BB
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbjCTPhX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233191AbjCTPgw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:36:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F323B21E
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:28:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D687FB80EC5
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:28:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B94AC433EF;
        Mon, 20 Mar 2023 15:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679326123;
        bh=93dlYql7Kh6eCQFq4Q3yrSYnSk1VkiRXwVuihcj4z1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BVjsjAwGiKVXPU1iGlrxcOl42DdmJjOp/CHbQ11d0pWP7McvGUBugUuyElfZ7yRJq
         REZFWyt38L5N66V2KwLwWbpRq9b5MDvW4/WBrn9/AS8pYDLk/j3Wrsm4OktXuPqYPf
         RT0eH0z2NujWD81ZUSxWDAm8HMYiEKUWD6T8UIbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Evan Quan <evan.quan@amd.com>,
        =?UTF-8?q?B=C5=82a=C5=BCej=20Szczygie=C5=82?= <mumei6102@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.2 167/211] drm/amd/pm: Fix sienna cichlid incorrect OD volage after resume
Date:   Mon, 20 Mar 2023 15:55:02 +0100
Message-Id: <20230320145520.436296081@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
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

From: Błażej Szczygieł <mumei6102@gmail.com>

commit a9386ee9681585794dbab95d4ce6826f73d19af6 upstream.

Always setup overdrive tables after resume. Preserve only some
user-defined settings in user_overdrive_table if they're set.

Copy restored user_overdrive_table into od_table to get correct
values.

On cold boot, BTC was triggered and GfxVfCurve was calibrated. We
got VfCurve settings (a). On resuming back, BTC will be triggered
again and GfxVfCurve will be recalibrated. VfCurve settings (b)
got may be different from those of cold boot.  So if we reuse
those VfCurve settings (a) got on cold boot on suspend, we can
run into discrepencies.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1897
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2276
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Błażej Szczygieł <mumei6102@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c |   43 ++++++++++++----
 1 file changed, 33 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -2143,16 +2143,9 @@ static int sienna_cichlid_set_default_od
 		(OverDriveTable_t *)smu->smu_table.boot_overdrive_table;
 	OverDriveTable_t *user_od_table =
 		(OverDriveTable_t *)smu->smu_table.user_overdrive_table;
+	OverDriveTable_t user_od_table_bak;
 	int ret = 0;
 
-	/*
-	 * For S3/S4/Runpm resume, no need to setup those overdrive tables again as
-	 *   - either they already have the default OD settings got during cold bootup
-	 *   - or they have some user customized OD settings which cannot be overwritten
-	 */
-	if (smu->adev->in_suspend)
-		return 0;
-
 	ret = smu_cmn_update_table(smu, SMU_TABLE_OVERDRIVE,
 				   0, (void *)boot_od_table, false);
 	if (ret) {
@@ -2163,7 +2156,23 @@ static int sienna_cichlid_set_default_od
 	sienna_cichlid_dump_od_table(smu, boot_od_table);
 
 	memcpy(od_table, boot_od_table, sizeof(OverDriveTable_t));
-	memcpy(user_od_table, boot_od_table, sizeof(OverDriveTable_t));
+
+	/*
+	 * For S3/S4/Runpm resume, we need to setup those overdrive tables again,
+	 * but we have to preserve user defined values in "user_od_table".
+	 */
+	if (!smu->adev->in_suspend) {
+		memcpy(user_od_table, boot_od_table, sizeof(OverDriveTable_t));
+		smu->user_dpm_profile.user_od = false;
+	} else if (smu->user_dpm_profile.user_od) {
+		memcpy(&user_od_table_bak, user_od_table, sizeof(OverDriveTable_t));
+		memcpy(user_od_table, boot_od_table, sizeof(OverDriveTable_t));
+		user_od_table->GfxclkFmin = user_od_table_bak.GfxclkFmin;
+		user_od_table->GfxclkFmax = user_od_table_bak.GfxclkFmax;
+		user_od_table->UclkFmin = user_od_table_bak.UclkFmin;
+		user_od_table->UclkFmax = user_od_table_bak.UclkFmax;
+		user_od_table->VddGfxOffset = user_od_table_bak.VddGfxOffset;
+	}
 
 	return 0;
 }
@@ -2373,6 +2382,20 @@ static int sienna_cichlid_od_edit_dpm_ta
 	return ret;
 }
 
+static int sienna_cichlid_restore_user_od_settings(struct smu_context *smu)
+{
+	struct smu_table_context *table_context = &smu->smu_table;
+	OverDriveTable_t *od_table = table_context->overdrive_table;
+	OverDriveTable_t *user_od_table = table_context->user_overdrive_table;
+	int res;
+
+	res = smu_v11_0_restore_user_od_settings(smu);
+	if (res == 0)
+		memcpy(od_table, user_od_table, sizeof(OverDriveTable_t));
+
+	return res;
+}
+
 static int sienna_cichlid_run_btc(struct smu_context *smu)
 {
 	int res;
@@ -4400,7 +4423,7 @@ static const struct pptable_funcs sienna
 	.set_soft_freq_limited_range = smu_v11_0_set_soft_freq_limited_range,
 	.set_default_od_settings = sienna_cichlid_set_default_od_settings,
 	.od_edit_dpm_table = sienna_cichlid_od_edit_dpm_table,
-	.restore_user_od_settings = smu_v11_0_restore_user_od_settings,
+	.restore_user_od_settings = sienna_cichlid_restore_user_od_settings,
 	.run_btc = sienna_cichlid_run_btc,
 	.set_power_source = smu_v11_0_set_power_source,
 	.get_pp_feature_mask = smu_cmn_get_pp_feature_mask,


