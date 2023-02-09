Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF7326906D7
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbjBILVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbjBILUi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:20:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20995AB0C;
        Thu,  9 Feb 2023 03:17:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF3A3B820FC;
        Thu,  9 Feb 2023 11:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E312C433EF;
        Thu,  9 Feb 2023 11:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941430;
        bh=YNLyIVRVxLzZjl2teEsz55uXci79wNQmkekQSx3mLAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZXbBIXrOCbEEjUG915Aro1WvPkZi20dvyYUKUoklyHMJKAwqRjXrled0E06B6OrIF
         k5p7/rt+F3qUhyVIcB19Fo4JjI6UcmQEcQ3YSPswwr1Ajijnst4j4dBUo/fzDg9Wu8
         Gz9ZDP66cxcnkYOO/2niBT63ENrl+0fCMeKPizAYWdnhNqRhYgZIXHckcE+M9Weuvl
         ekfCCorlaZBYJlX32wwHZTz3B0ACJdQUGAGnk3pvACLT0yBmMHyJoex2laUlMWezak
         MZnv7BW3kR/WCLY8VAx5R1f9qDzvLwYI1cBR05l0aeEvTelnO8khbq3pCbYp3hV/FO
         MRdpbaC/WUyNA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Hansen Dsouza <hansen.dsouza@amd.com>,
        Alex Hung <alex.hung@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, aurabindo.pillai@amd.com, roman.li@amd.com,
        qingqing.zhuo@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 32/38] drm/amd/display: Reset DMUB mailbox SW state after HW reset
Date:   Thu,  9 Feb 2023 06:14:51 -0500
Message-Id: <20230209111459.1891941-32-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111459.1891941-1-sashal@kernel.org>
References: <20230209111459.1891941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_PDS_OTHER_BAD_TLD autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 154711aa5759ef9b45903124fa813c4c29ee681c ]

[Why]
Otherwise we can be out of sync with what's in the hardware, leading
to us rerunning every command that's presently in the ringbuffer.

[How]
Reset software state for the mailboxes in hw_reset callback.
This is already done as part of the mailbox init in hw_init, but we
do need to remember to reset the last cached wptr value as well here.

Reviewed-by: Hansen Dsouza <hansen.dsouza@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c b/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c
index 4a122925c3ae9..92c18bfb98b3b 100644
--- a/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c
@@ -532,6 +532,9 @@ enum dmub_status dmub_srv_hw_init(struct dmub_srv *dmub,
 	if (dmub->hw_funcs.reset)
 		dmub->hw_funcs.reset(dmub);
 
+	/* reset the cache of the last wptr as well now that hw is reset */
+	dmub->inbox1_last_wptr = 0;
+
 	cw0.offset.quad_part = inst_fb->gpu_addr;
 	cw0.region.base = DMUB_CW0_BASE;
 	cw0.region.top = cw0.region.base + inst_fb->size - 1;
@@ -649,6 +652,15 @@ enum dmub_status dmub_srv_hw_reset(struct dmub_srv *dmub)
 	if (dmub->hw_funcs.reset)
 		dmub->hw_funcs.reset(dmub);
 
+	/* mailboxes have been reset in hw, so reset the sw state as well */
+	dmub->inbox1_last_wptr = 0;
+	dmub->inbox1_rb.wrpt = 0;
+	dmub->inbox1_rb.rptr = 0;
+	dmub->outbox0_rb.wrpt = 0;
+	dmub->outbox0_rb.rptr = 0;
+	dmub->outbox1_rb.wrpt = 0;
+	dmub->outbox1_rb.rptr = 0;
+
 	dmub->hw_init = false;
 
 	return DMUB_STATUS_OK;
-- 
2.39.0

