Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C458D4F2DBF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242187AbiDEIhJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238786AbiDEITY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0350B7246C;
        Tue,  5 Apr 2022 01:09:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 948356062B;
        Tue,  5 Apr 2022 08:09:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F05CC385A1;
        Tue,  5 Apr 2022 08:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146169;
        bh=dGJFby7CwqGK7QRBB72ycYFb+Cqu2SHdBW1KnfW31jI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eGspAmtSlVo1grdb+3SeLIi2Zm8LcQBA4LYZiCUXkdVc7xW6o7iYi7PNmah3Q0LJ4
         hcySzGSY4kIChbM5iJu6adsPu8ChlVj3Lu3VgmdGmxdY7oSNptzlS96GwMy7xSzK/m
         BxD9MRGoU74QphGxEgIoToxXyisZ/ucgOtscRp78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jimmy Kizito <Jimmy.Kizito@amd.com>,
        Alan Liu <HaoPing.Liu@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0666/1126] drm/amd/display: Fix double free during GPU reset on DC streams
Date:   Tue,  5 Apr 2022 09:23:33 +0200
Message-Id: <20220405070427.176651643@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 32685b32d825ca08c5dec826477332df886c4743 ]

[Why]
The issue only occurs during the GPU reset code path.

We first backup the current state prior to commiting 0 streams
internally from DM to DC. This state backup contains valid link
encoder assignments.

DC will clear the link encoder assignments as part of current state
(but not the backup, since it was a copied before the commit) and
free the extra stream reference it held.

DC requires that the link encoder assignments remain cleared/invalid
prior to commiting. Since the backup still has valid assignments we
call the interface post reset to clear them. This routine also
releases the extra reference that the link encoder interface held -
resulting in a double free (and eventually a NULL pointer dereference).

[How]
We'll have to do a full DC commit anyway after GPU reset because
the stream count previously went to 0.

We don't need to retain the assignment that we had backed up, so
just copy off of the now clean current state assignment after the
reset has occcurred with the new link_enc_cfg_copy() interface.

Fixes: 6d63fcc2a334 ("drm/amd/display: Reset link encoder assignments for GPU reset")

Reviewed-by: Jimmy Kizito <Jimmy.Kizito@amd.com>
Acked-by: Alan Liu <HaoPing.Liu@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c     | 9 ++++++---
 drivers/gpu/drm/amd/display/dc/core/dc_link_enc_cfg.c | 7 +++++++
 drivers/gpu/drm/amd/display/dc/inc/link_enc_cfg.h     | 5 +++++
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index eae9f9e26f0e..b28b5c490860 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2613,10 +2613,13 @@ static int dm_resume(void *handle)
 		 * before the 0 streams commit.
 		 *
 		 * DC expects that link encoder assignments are *not* valid
-		 * when committing a state, so as a workaround it needs to be
-		 * cleared here.
+		 * when committing a state, so as a workaround we can copy
+		 * off of the current state.
+		 *
+		 * We lose the previous assignments, but we had already
+		 * commit 0 streams anyway.
 		 */
-		link_enc_cfg_init(dm->dc, dc_state);
+		link_enc_cfg_copy(adev->dm.dc->current_state, dc_state);
 
 		if (dc_enable_dmub_notifications(adev->dm.dc))
 			amdgpu_dm_outbox_init(adev);
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_enc_cfg.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_enc_cfg.c
index 00f72f66a7ef..72a3fded7142 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_enc_cfg.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_enc_cfg.c
@@ -272,6 +272,13 @@ void link_enc_cfg_init(
 	state->res_ctx.link_enc_cfg_ctx.mode = LINK_ENC_CFG_STEADY;
 }
 
+void link_enc_cfg_copy(const struct dc_state *src_ctx, struct dc_state *dst_ctx)
+{
+	memcpy(&dst_ctx->res_ctx.link_enc_cfg_ctx,
+	       &src_ctx->res_ctx.link_enc_cfg_ctx,
+	       sizeof(dst_ctx->res_ctx.link_enc_cfg_ctx));
+}
+
 void link_enc_cfg_link_encs_assign(
 		struct dc *dc,
 		struct dc_state *state,
diff --git a/drivers/gpu/drm/amd/display/dc/inc/link_enc_cfg.h b/drivers/gpu/drm/amd/display/dc/inc/link_enc_cfg.h
index a4e43b4826e0..59ceb9ed385d 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/link_enc_cfg.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/link_enc_cfg.h
@@ -39,6 +39,11 @@ void link_enc_cfg_init(
 		const struct dc *dc,
 		struct dc_state *state);
 
+/*
+ * Copies a link encoder assignment from another state.
+ */
+void link_enc_cfg_copy(const struct dc_state *src_ctx, struct dc_state *dst_ctx);
+
 /*
  * Algorithm for assigning available DIG link encoders to streams.
  *
-- 
2.34.1



