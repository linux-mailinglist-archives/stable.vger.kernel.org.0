Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662E263567A
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237694AbiKWJbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237706AbiKWJan (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:30:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64EC9112C5C
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:29:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 027CB61B43
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2109C433D7;
        Wed, 23 Nov 2022 09:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195743;
        bh=iPxNq6OZIAYYK2AOMlVT08B1wcF9j2sMEKlxUF6HeFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZCbnSohoI1vhBpY8iAWVRDRUP1KpPBT6Yi7Aarqvgt94F7WiZw0jOlsfJ2E9PWXT
         TnrVz1wgqihBU0zC3ltSX5RAvYLhLFR1OpHiZE5x46hH3kb/1IyOqXgKkd5I5OC00u
         v+6d7ErsOzn/8MnzfmWps/uiOsgBTBYtAfIhTXXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Daniel Wheeler <daniel.wheeler@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/181] drm/amd/display: Remove wrong pipe control lock
Date:   Wed, 23 Nov 2022 09:49:43 +0100
Message-Id: <20221123084603.348224420@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 0de1bbbabf9a..58eea3aa3bfc 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1765,7 +1765,7 @@ void dcn20_post_unlock_program_front_end(
 
 			for (j = 0; j < TIMEOUT_FOR_PIPE_ENABLE_MS*1000
 					&& hubp->funcs->hubp_is_flip_pending(hubp); j++)
-				mdelay(1);
+				udelay(1);
 		}
 	}
 
-- 
2.35.1



