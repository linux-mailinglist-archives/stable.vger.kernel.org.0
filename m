Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6849950515C
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239130AbiDRMed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239806AbiDRMd2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:33:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C8E1B7B7;
        Mon, 18 Apr 2022 05:26:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30C1160FB0;
        Mon, 18 Apr 2022 12:26:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240ADC385A1;
        Mon, 18 Apr 2022 12:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284788;
        bh=O09PFAPwZffQpgCKXo4uP0gYkLUEqgjf+QuRQFQAI84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FzU/Kqweq0oEqdeVS3aEqMdIkMXq2C8uEV5FZhWb2mDzwZUQ0nOeZbxmF/N1dgxV5
         4sNCzxeLYEa7gJkk9x9lpNy7IPOFsB95j8cOMauhcp6UQMDVJyek+ZHntqx5/6/d13
         jS4JUOnPzBuj4cRanjHL+LJVK5pDaTuVEOhyvZ/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Eric Yang <Eric.Yang2@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 001/189] drm/amd/display: Add pstate verification and recovery for DCN31
Date:   Mon, 18 Apr 2022 14:10:21 +0200
Message-Id: <20220418121200.382893208@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit e7031d8258f1b4d6d50e5e5b5d92ba16f66eb8b4 upstream.

[Why]
To debug when p-state is being blocked and avoid PMFW hangs when
it does occur.

[How]
Re-use the DCN10 hardware sequencer by adding a new interface for
verifying p-state high on the hubbub. The interface is mostly the
same as the DCN10 interface, but the bit definitions have changed for
the debug bus.

Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Eric Yang <Eric.Yang2@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubbub.c       |    1 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c |   10 +-
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubbub.c       |    1 
 drivers/gpu/drm/amd/display/dc/dcn301/dcn301_hubbub.c     |    1 
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c       |   60 ++++++++++++++
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c     |    2 
 drivers/gpu/drm/amd/display/dc/inc/hw/dchubbub.h          |    2 
 7 files changed, 73 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubbub.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubbub.c
@@ -940,6 +940,7 @@ static const struct hubbub_funcs hubbub1
 	.program_watermarks = hubbub1_program_watermarks,
 	.is_allow_self_refresh_enabled = hubbub1_is_allow_self_refresh_enabled,
 	.allow_self_refresh_control = hubbub1_allow_self_refresh_control,
+	.verify_allow_pstate_change_high = hubbub1_verify_allow_pstate_change_high,
 };
 
 void hubbub1_construct(struct hubbub *hubbub,
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -1052,9 +1052,13 @@ static bool dcn10_hw_wa_force_recovery(s
 
 void dcn10_verify_allow_pstate_change_high(struct dc *dc)
 {
+	struct hubbub *hubbub = dc->res_pool->hubbub;
 	static bool should_log_hw_state; /* prevent hw state log by default */
 
-	if (!hubbub1_verify_allow_pstate_change_high(dc->res_pool->hubbub)) {
+	if (!hubbub->funcs->verify_allow_pstate_change_high)
+		return;
+
+	if (!hubbub->funcs->verify_allow_pstate_change_high(hubbub)) {
 		int i = 0;
 
 		if (should_log_hw_state)
@@ -1063,8 +1067,8 @@ void dcn10_verify_allow_pstate_change_hi
 		TRACE_DC_PIPE_STATE(pipe_ctx, i, MAX_PIPES);
 		BREAK_TO_DEBUGGER();
 		if (dcn10_hw_wa_force_recovery(dc)) {
-		/*check again*/
-			if (!hubbub1_verify_allow_pstate_change_high(dc->res_pool->hubbub))
+			/*check again*/
+			if (!hubbub->funcs->verify_allow_pstate_change_high(hubbub))
 				BREAK_TO_DEBUGGER();
 		}
 	}
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubbub.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubbub.c
@@ -448,6 +448,7 @@ static const struct hubbub_funcs hubbub3
 	.program_watermarks = hubbub3_program_watermarks,
 	.allow_self_refresh_control = hubbub1_allow_self_refresh_control,
 	.is_allow_self_refresh_enabled = hubbub1_is_allow_self_refresh_enabled,
+	.verify_allow_pstate_change_high = hubbub1_verify_allow_pstate_change_high,
 	.force_wm_propagate_to_pipes = hubbub3_force_wm_propagate_to_pipes,
 	.force_pstate_change_control = hubbub3_force_pstate_change_control,
 	.init_watermarks = hubbub3_init_watermarks,
--- a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_hubbub.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_hubbub.c
@@ -60,6 +60,7 @@ static const struct hubbub_funcs hubbub3
 	.program_watermarks = hubbub3_program_watermarks,
 	.allow_self_refresh_control = hubbub1_allow_self_refresh_control,
 	.is_allow_self_refresh_enabled = hubbub1_is_allow_self_refresh_enabled,
+	.verify_allow_pstate_change_high = hubbub1_verify_allow_pstate_change_high,
 	.force_wm_propagate_to_pipes = hubbub3_force_wm_propagate_to_pipes,
 	.force_pstate_change_control = hubbub3_force_pstate_change_control,
 	.hubbub_read_state = hubbub2_read_state,
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c
@@ -949,6 +949,65 @@ static void hubbub31_get_dchub_ref_freq(
 	}
 }
 
+static bool hubbub31_verify_allow_pstate_change_high(struct hubbub *hubbub)
+{
+	struct dcn20_hubbub *hubbub2 = TO_DCN20_HUBBUB(hubbub);
+
+	/*
+	 * Pstate latency is ~20us so if we wait over 40us and pstate allow
+	 * still not asserted, we are probably stuck and going to hang
+	 */
+	const unsigned int pstate_wait_timeout_us = 100;
+	const unsigned int pstate_wait_expected_timeout_us = 40;
+
+	static unsigned int max_sampled_pstate_wait_us; /* data collection */
+	static bool forced_pstate_allow; /* help with revert wa */
+
+	unsigned int debug_data = 0;
+	unsigned int i;
+
+	if (forced_pstate_allow) {
+		/* we hacked to force pstate allow to prevent hang last time
+		 * we verify_allow_pstate_change_high.  so disable force
+		 * here so we can check status
+		 */
+		REG_UPDATE_2(DCHUBBUB_ARB_DRAM_STATE_CNTL,
+			     DCHUBBUB_ARB_ALLOW_PSTATE_CHANGE_FORCE_VALUE, 0,
+			     DCHUBBUB_ARB_ALLOW_PSTATE_CHANGE_FORCE_ENABLE, 0);
+		forced_pstate_allow = false;
+	}
+
+	REG_WRITE(DCHUBBUB_TEST_DEBUG_INDEX, hubbub2->debug_test_index_pstate);
+
+	for (i = 0; i < pstate_wait_timeout_us; i++) {
+		debug_data = REG_READ(DCHUBBUB_TEST_DEBUG_DATA);
+
+		/* Debug bit is specific to ASIC. */
+		if (debug_data & (1 << 26)) {
+			if (i > pstate_wait_expected_timeout_us)
+				DC_LOG_WARNING("pstate took longer than expected ~%dus\n", i);
+			return true;
+		}
+		if (max_sampled_pstate_wait_us < i)
+			max_sampled_pstate_wait_us = i;
+
+		udelay(1);
+	}
+
+	/* force pstate allow to prevent system hang
+	 * and break to debugger to investigate
+	 */
+	REG_UPDATE_2(DCHUBBUB_ARB_DRAM_STATE_CNTL,
+		     DCHUBBUB_ARB_ALLOW_PSTATE_CHANGE_FORCE_VALUE, 1,
+		     DCHUBBUB_ARB_ALLOW_PSTATE_CHANGE_FORCE_ENABLE, 1);
+	forced_pstate_allow = true;
+
+	DC_LOG_WARNING("pstate TEST_DEBUG_DATA: 0x%X\n",
+			debug_data);
+
+	return false;
+}
+
 static const struct hubbub_funcs hubbub31_funcs = {
 	.update_dchub = hubbub2_update_dchub,
 	.init_dchub_sys_ctx = hubbub31_init_dchub_sys_ctx,
@@ -961,6 +1020,7 @@ static const struct hubbub_funcs hubbub3
 	.program_watermarks = hubbub31_program_watermarks,
 	.allow_self_refresh_control = hubbub1_allow_self_refresh_control,
 	.is_allow_self_refresh_enabled = hubbub1_is_allow_self_refresh_enabled,
+	.verify_allow_pstate_change_high = hubbub31_verify_allow_pstate_change_high,
 	.program_det_size = dcn31_program_det_size,
 	.program_compbuf_size = dcn31_program_compbuf_size,
 	.init_crb = dcn31_init_crb,
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
@@ -940,7 +940,7 @@ static const struct dc_debug_options deb
 	.max_downscale_src_width = 4096,/*upto true 4K*/
 	.disable_pplib_wm_range = false,
 	.scl_reset_length10 = true,
-	.sanity_checks = false,
+	.sanity_checks = true,
 	.underflow_assert_delay_us = 0xFFFFFFFF,
 	.dwb_fi_phase = -1, // -1 = disable,
 	.dmub_command_table = true,
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/dchubbub.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/dchubbub.h
@@ -154,6 +154,8 @@ struct hubbub_funcs {
 	bool (*is_allow_self_refresh_enabled)(struct hubbub *hubbub);
 	void (*allow_self_refresh_control)(struct hubbub *hubbub, bool allow);
 
+	bool (*verify_allow_pstate_change_high)(struct hubbub *hubbub);
+
 	void (*apply_DEDCN21_147_wa)(struct hubbub *hubbub);
 
 	void (*force_wm_propagate_to_pipes)(struct hubbub *hubbub);


