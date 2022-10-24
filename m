Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 785DC60A1A6
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiJXLby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiJXLbw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:31:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691775603D;
        Mon, 24 Oct 2022 04:31:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A30CCB81133;
        Mon, 24 Oct 2022 11:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19B4C43141;
        Mon, 24 Oct 2022 11:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611108;
        bh=/VSGSHF0sdxC4vEXEymNZSjiWrDALm65vLVmrVSJcNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UzqUfRRfKxXKGe7f+JguNlHAxyaM/YCmW9bhZnFgz+tXgLvLC6vi3f17WPIY9Jnel
         kir0x7klAv5JE8I/QZ0dv1icCu/SUMbMZD6ZULUJDDIOgbx87tt0swz9IkOsOv2gA0
         oZASLvGaZ1/YgYkoXTneQxVXpJXzA9RytQhX67io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 12/20] drm/amd/pm: fulfill SMU13.0.0 cstate control interface
Date:   Mon, 24 Oct 2022 13:31:14 +0200
Message-Id: <20221024112934.932218124@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112934.415391158@linuxfoundation.org>
References: <20221024112934.415391158@linuxfoundation.org>
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

From: Evan Quan <evan.quan@amd.com>

commit 528c0e66e0c01a8c078d2d94431db80f9c75d2a0 upstream.

Fulfill the functionality for cstate control.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -119,6 +119,7 @@ static struct cmn2asic_msg_mapping smu_v
 	MSG_MAP(NotifyPowerSource,		PPSMC_MSG_NotifyPowerSource,           0),
 	MSG_MAP(Mode1Reset,			PPSMC_MSG_Mode1Reset,                  0),
 	MSG_MAP(PrepareMp1ForUnload,		PPSMC_MSG_PrepareMp1ForUnload,         0),
+	MSG_MAP(DFCstateControl,		PPSMC_MSG_SetExternalClientDfCstateAllow, 0),
 };
 
 static struct cmn2asic_mapping smu_v13_0_0_clk_map[SMU_CLK_COUNT] = {
@@ -1753,6 +1754,15 @@ static int smu_v13_0_0_set_mp1_state(str
 	return ret;
 }
 
+static int smu_v13_0_0_set_df_cstate(struct smu_context *smu,
+				     enum pp_df_cstate state)
+{
+	return smu_cmn_send_smc_msg_with_param(smu,
+					       SMU_MSG_DFCstateControl,
+					       state,
+					       NULL);
+}
+
 static const struct pptable_funcs smu_v13_0_0_ppt_funcs = {
 	.get_allowed_feature_mask = smu_v13_0_0_get_allowed_feature_mask,
 	.set_default_dpm_table = smu_v13_0_0_set_default_dpm_table,
@@ -1822,6 +1832,7 @@ static const struct pptable_funcs smu_v1
 	.mode1_reset_is_support = smu_v13_0_0_is_mode1_reset_supported,
 	.mode1_reset = smu_v13_0_mode1_reset,
 	.set_mp1_state = smu_v13_0_0_set_mp1_state,
+	.set_df_cstate = smu_v13_0_0_set_df_cstate,
 };
 
 void smu_v13_0_0_set_ppt_funcs(struct smu_context *smu)


