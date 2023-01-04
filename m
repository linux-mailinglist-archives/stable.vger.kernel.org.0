Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD3065D7F7
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239743AbjADQJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239745AbjADQJ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:09:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75BB1BE89
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:09:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FD456179C
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500E4C433F1;
        Wed,  4 Jan 2023 16:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848545;
        bh=HQ2DdUwRTFOmXHOTydP8GQyWnfXm9i/LD1lNXaF7Ikg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hp6hh/95pk2kiIHmJ77Ol5jpEXKMLepT6F2zTzHeu4BaiiYRy/vAfyyA43O8xY+qf
         NB48GJ+zwk/Zpwo2+VRD7QM57ShE1947UUNnzRuBqM+vzNVuGdD7RGI9Z9DTEiennI
         XmeWG4bUdfaqkuOlJKtVSsY+OmaaqaRI6ti9kVk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 018/207] drm/amd/pm: update SMU13.0.0 reported maximum shader clock
Date:   Wed,  4 Jan 2023 17:04:36 +0100
Message-Id: <20230104160512.491229981@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

From: Evan Quan <evan.quan@amd.com>

commit 7a18e089eff02f17eaee49fc18641f5d16a8284b upstream.

Update the reported maximum shader clock to the value which can
be guarded to be achieved on all cards. This is to align with
Window setting.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c |   70 ++++++++++++++++++-
 1 file changed, 69 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -517,6 +517,23 @@ static int smu_v13_0_0_set_default_dpm_t
 						     dpm_table);
 		if (ret)
 			return ret;
+
+		/*
+		 * Update the reported maximum shader clock to the value
+		 * which can be guarded to be achieved on all cards. This
+		 * is aligned with Window setting. And considering that value
+		 * might be not the peak frequency the card can achieve, it
+		 * is normal some real-time clock frequency can overtake this
+		 * labelled maximum clock frequency(for example in pp_dpm_sclk
+		 * sysfs output).
+		 */
+		if (skutable->DriverReportedClocks.GameClockAc &&
+		    (dpm_table->dpm_levels[dpm_table->count - 1].value >
+		    skutable->DriverReportedClocks.GameClockAc)) {
+			dpm_table->dpm_levels[dpm_table->count - 1].value =
+				skutable->DriverReportedClocks.GameClockAc;
+			dpm_table->max = skutable->DriverReportedClocks.GameClockAc;
+		}
 	} else {
 		dpm_table->count = 1;
 		dpm_table->dpm_levels[0].value = smu->smu_table.boot_values.gfxclk / 100;
@@ -779,6 +796,57 @@ static int smu_v13_0_0_get_smu_metrics_d
 	return ret;
 }
 
+static int smu_v13_0_0_get_dpm_ultimate_freq(struct smu_context *smu,
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
 static int smu_v13_0_0_read_sensor(struct smu_context *smu,
 				   enum amd_pp_sensors sensor,
 				   void *data,
@@ -1813,7 +1881,7 @@ static const struct pptable_funcs smu_v1
 	.get_enabled_mask = smu_cmn_get_enabled_mask,
 	.dpm_set_vcn_enable = smu_v13_0_set_vcn_enable,
 	.dpm_set_jpeg_enable = smu_v13_0_set_jpeg_enable,
-	.get_dpm_ultimate_freq = smu_v13_0_get_dpm_ultimate_freq,
+	.get_dpm_ultimate_freq = smu_v13_0_0_get_dpm_ultimate_freq,
 	.get_vbios_bootup_values = smu_v13_0_get_vbios_bootup_values,
 	.read_sensor = smu_v13_0_0_read_sensor,
 	.feature_is_enabled = smu_cmn_feature_is_enabled,


