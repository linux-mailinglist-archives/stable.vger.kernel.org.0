Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4EFB61E3F5
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbiKFRGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:06:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiKFRFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:05:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA288DFE5;
        Sun,  6 Nov 2022 09:04:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FAE0B8013C;
        Sun,  6 Nov 2022 17:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3769C433D6;
        Sun,  6 Nov 2022 17:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754297;
        bh=A2xAvQbnLCqr8nWJbVANHA9l03LHWAGNYIoynTr8tk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eo8GDCy0FJX8SLwDPdVy0V2mH5tOSxTlrm9YtD6WcaKfgvTG3B8co3NcCR1A+WyTQ
         5oI4HUsndoXnHfj+zJJ6a9jNQasLkeyXi6ibhIOkcwD60RO79kkQ6xWTZUHM9w0xa1
         HCjBT9jOCeiRH3+lh5K9Ns/20smOyirb0bAcJw/t0QwP0wFtt76017yVhstm1df4qB
         XE2czbhUAUA4ha763dITSUqkkaeud4j5QhC8D5tuzeO9uqFvgmUYqaromVOtGKTv6x
         xTT4eP1rWvxvzkWnSRAECoJHj46fc/NZpdu2tqK0ddexs+6VWc+xaZfr/DFUGn8bGC
         Bs4HmWgb3Ymww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, christian.koenig@amd.com, Xinhui.Pan@amd.com,
        airlied@gmail.com, daniel@ffwll.ch, Jun.Lei@amd.com,
        wenjing.liu@amd.com, Aric.Cyr@amd.com, Alvin.Lee2@amd.com,
        duncan.ma@amd.com, mwen@igalia.com, Yi-Ling.Chen2@amd.com,
        aurabindo.pillai@amd.com, jiapeng.chong@linux.alibaba.com,
        Sungjoon.Kim@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 27/30] drm/amd/display: Remove wrong pipe control lock
Date:   Sun,  6 Nov 2022 12:03:39 -0500
Message-Id: <20221106170345.1579893-27-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221106170345.1579893-1-sashal@kernel.org>
References: <20221106170345.1579893-1-sashal@kernel.org>
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

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

[ Upstream commit ca08a1725d0d78efca8d2dbdbce5ea70355da0f2 ]

When using a device based on DCN32/321,
we have an issue where a second
4k@60Hz display does not light up,
and the system becomes unresponsive
for a few minutes. In the debug process,
it was possible to see a hang
in the function dcn20_post_unlock_program_front_end
in this part:

for (j = 0; j < TIMEOUT_FOR_PIPE_ENABLE_MS*1000
	&& hubp->funcs->hubp_is_flip_pending(hubp); j++)
	mdelay(1);
}

The hubp_is_flip_pending always returns positive
for waiting pending flips which is a symptom of
pipe hang. Additionally, the dmesg log shows
this message after a few minutes:

  BUG: soft lockup - CPU#4 stuck for 26s!
  ...
  [  +0.000003]  dcn20_post_unlock_program_front_end+0x112/0x340 [amdgpu]
  [  +0.000171]  dc_commit_state_no_check+0x63d/0xbf0 [amdgpu]
  [  +0.000155]  ? dc_validate_global_state+0x358/0x3d0 [amdgpu]
  [  +0.000154]  dc_commit_state+0xe2/0xf0 [amdgpu]

This confirmed the hypothesis that we had a pipe
hanging somewhere. Next, after checking the
ftrace entries, we have the below weird
sequence:

 [..]
  2)               |        dcn10_lock_all_pipes [amdgpu]() {
  2)   0.120 us    |          optc1_is_tg_enabled [amdgpu]();
  2)               |          dcn20_pipe_control_lock [amdgpu]() {
  2)               |            dc_dmub_srv_clear_inbox0_ack [amdgpu]() {
  2)   0.121 us    |              amdgpu_dm_dmub_reg_write [amdgpu]();
  2)   0.551 us    |            }
  2)               |            dc_dmub_srv_send_inbox0_cmd [amdgpu]() {
  2)   0.110 us    |              amdgpu_dm_dmub_reg_write [amdgpu]();
  2)   0.511 us    |            }
  2)               |            dc_dmub_srv_wait_for_inbox0_ack [amdgpu]() {
  2)   0.110 us    |              amdgpu_dm_dmub_reg_read [amdgpu]();
  2)   0.110 us    |              amdgpu_dm_dmub_reg_read [amdgpu]();
  2)   0.110 us    |              amdgpu_dm_dmub_reg_read [amdgpu]();
  2)   0.110 us    |              amdgpu_dm_dmub_reg_read [amdgpu]();
  2)   0.110 us    |              amdgpu_dm_dmub_reg_read [amdgpu]();
  2)   0.110 us    |              amdgpu_dm_dmub_reg_read [amdgpu]();
  2)   0.110 us    |              amdgpu_dm_dmub_reg_read [amdgpu]();
 [..]

We are not expected to read from dmub register
so many times and for so long. From the trace log,
it was possible to identify that the function
dcn20_pipe_control_lock was triggering the dmub
operation when it was unnecessary and causing
the hang issue. This commit drops the unnecessary
dmub code and, consequently, fixes the second display not
lighting up the issue.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 598ce872a8d7..0f30df523fdf 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1262,16 +1262,6 @@ void dcn20_pipe_control_lock(
 					lock,
 					&hw_locks,
 					&inst_flags);
-	} else if (pipe->stream && pipe->stream->mall_stream_config.type == SUBVP_MAIN) {
-		union dmub_inbox0_cmd_lock_hw hw_lock_cmd = { 0 };
-		hw_lock_cmd.bits.command_code = DMUB_INBOX0_CMD__HW_LOCK;
-		hw_lock_cmd.bits.hw_lock_client = HW_LOCK_CLIENT_DRIVER;
-		hw_lock_cmd.bits.lock_pipe = 1;
-		hw_lock_cmd.bits.otg_inst = pipe->stream_res.tg->inst;
-		hw_lock_cmd.bits.lock = lock;
-		if (!lock)
-			hw_lock_cmd.bits.should_release = 1;
-		dmub_hw_lock_mgr_inbox0_cmd(dc->ctx->dmub_srv, hw_lock_cmd);
 	} else if (pipe->plane_state != NULL && pipe->plane_state->triplebuffer_flips) {
 		if (lock)
 			pipe->stream_res.tg->funcs->triplebuffer_lock(pipe->stream_res.tg);
@@ -1848,7 +1838,7 @@ void dcn20_post_unlock_program_front_end(
 
 			for (j = 0; j < TIMEOUT_FOR_PIPE_ENABLE_MS*1000
 					&& hubp->funcs->hubp_is_flip_pending(hubp); j++)
-				mdelay(1);
+				udelay(1);
 		}
 	}
 
-- 
2.35.1

