Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9923A6E64E8
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbjDRMxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbjDRMx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:53:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1600C18394
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:53:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8342F63438
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963FBC433EF;
        Tue, 18 Apr 2023 12:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822367;
        bh=Ge72OqRcixKM2Jf9l7Pfex98g4TYNlsYZcE52zNsAMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mpggrmf2bGETc3rCPdv2Wy4fVqe+/cYmOzgL4vl0paFKaRx0JxDCpFCdJrxhF73Fi
         gBMitgdV/RwJhv7sOH4gqD9Q9SbRvAaVSeS1AqBUjdLHeLKhNjnHGTvujw+rCtmWX0
         WRXC1MWSD+00XlLWkt3klOigOu9XLGV0WkYzpH8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Horatio Zhang <Hongkun.Zhang@amd.com>,
        Kenneth Feng <kenneth.feng@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.2 123/139] drm/amd/pm: correct SMU13.0.7 max shader clock reporting
Date:   Tue, 18 Apr 2023 14:23:08 +0200
Message-Id: <20230418120318.459231979@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horatio Zhang <Hongkun.Zhang@amd.com>

commit 85e0689eb6b10cd3b2fb455d1b3f4d4d0b13ff78 upstream.

Correct the max shader clock reporting on SMU
13.0.7.

Signed-off-by: Horatio Zhang <Hongkun.Zhang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c |   61 ++++++++++++++++++-
 1 file changed, 60 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -575,6 +575,14 @@ static int smu_v13_0_7_set_default_dpm_t
 						     dpm_table);
 		if (ret)
 			return ret;
+
+		if (skutable->DriverReportedClocks.GameClockAc &&
+			(dpm_table->dpm_levels[dpm_table->count - 1].value >
+			skutable->DriverReportedClocks.GameClockAc)) {
+			dpm_table->dpm_levels[dpm_table->count - 1].value =
+				skutable->DriverReportedClocks.GameClockAc;
+			dpm_table->max = skutable->DriverReportedClocks.GameClockAc;
+		}
 	} else {
 		dpm_table->count = 1;
 		dpm_table->dpm_levels[0].value = smu->smu_table.boot_values.gfxclk / 100;
@@ -828,6 +836,57 @@ static int smu_v13_0_7_get_smu_metrics_d
 	return ret;
 }
 
+static int smu_v13_0_7_get_dpm_ultimate_freq(struct smu_context *smu,
+					     enum smu_clk_type clk_type,
+					     uint32_t *min,
+					     uint32_t *max)
+{
+	struct smu_13_0_dpm_context *dpm_context =
+		smu->smu_dpm.dpm_context;
+	struct smu_13_0_dpm_table *dpm_table;
+
+	switch (clk_type) {
+	case SMU_MCLK:
+	case SMU_UCLK:
+		/* uclk dpm table */
+		dpm_table = &dpm_context->dpm_tables.uclk_table;
+		break;
+	case SMU_GFXCLK:
+	case SMU_SCLK:
+		/* gfxclk dpm table */
+		dpm_table = &dpm_context->dpm_tables.gfx_table;
+		break;
+	case SMU_SOCCLK:
+		/* socclk dpm table */
+		dpm_table = &dpm_context->dpm_tables.soc_table;
+		break;
+	case SMU_FCLK:
+		/* fclk dpm table */
+		dpm_table = &dpm_context->dpm_tables.fclk_table;
+		break;
+	case SMU_VCLK:
+	case SMU_VCLK1:
+		/* vclk dpm table */
+		dpm_table = &dpm_context->dpm_tables.vclk_table;
+		break;
+	case SMU_DCLK:
+	case SMU_DCLK1:
+		/* dclk dpm table */
+		dpm_table = &dpm_context->dpm_tables.dclk_table;
+		break;
+	default:
+		dev_err(smu->adev->dev, "Unsupported clock type!\n");
+		return -EINVAL;
+	}
+
+	if (min)
+		*min = dpm_table->min;
+	if (max)
+		*max = dpm_table->max;
+
+	return 0;
+}
+
 static int smu_v13_0_7_read_sensor(struct smu_context *smu,
 				   enum amd_pp_sensors sensor,
 				   void *data,
@@ -1684,7 +1743,7 @@ static const struct pptable_funcs smu_v1
 	.dpm_set_jpeg_enable = smu_v13_0_set_jpeg_enable,
 	.init_pptable_microcode = smu_v13_0_init_pptable_microcode,
 	.populate_umd_state_clk = smu_v13_0_7_populate_umd_state_clk,
-	.get_dpm_ultimate_freq = smu_v13_0_get_dpm_ultimate_freq,
+	.get_dpm_ultimate_freq = smu_v13_0_7_get_dpm_ultimate_freq,
 	.get_vbios_bootup_values = smu_v13_0_get_vbios_bootup_values,
 	.read_sensor = smu_v13_0_7_read_sensor,
 	.feature_is_enabled = smu_cmn_feature_is_enabled,


