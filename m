Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C17A4FD37A
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 11:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356602AbiDLIK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 04:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353953AbiDLHiB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:38:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B59517FB;
        Tue, 12 Apr 2022 00:09:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28762B81B58;
        Tue, 12 Apr 2022 07:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA20C385A5;
        Tue, 12 Apr 2022 07:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747382;
        bh=P+yUphLekVSunkS4tg37Dl51JfFmmML9Ddy2YUNFXgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EVSbDotQ2ZQGegzHkqIf6/5qmcyeOu9wdKSeM8V1OF70F5ttKbBemoGjZ6Ca+4le+
         PqDARmzG0zXQ1DBOA0Zb8+ViZOvCtR4KzRnDgXG00CVHRsL4YSY6XX5e8lfExaDVMu
         mudkRonCJVVjyrVl06v7zmGkT8sDkXtTAxAAngm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Anthony Koo <Anthony.Koo@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 022/343] drm/amd/display: Use PSR version selected during set_psr_caps
Date:   Tue, 12 Apr 2022 08:27:20 +0200
Message-Id: <20220412062951.745001905@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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

[ Upstream commit b80ddeb29d9df449f875f0b6f5de08d7537c02b8 ]

[Why]
If the DPCD caps specifies a PSR version newer than PSR_VERSION_1 then
we fallback to using PSR_VERSION_1 in amdgpu_dm_set_psr_caps.

This gets overriden with the raw DPCD value in amdgpu_dm_link_setup_psr,
which can result in DMCUB hanging if we pass in an unsupported PSR
version number.

[How]
Fix the hang by using link->psr_settings.psr_version directly during
amdgpu_dm_link_setup_psr.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
index c510638b4f99..a009fc654ac9 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
@@ -149,10 +149,8 @@ bool amdgpu_dm_link_setup_psr(struct dc_stream_state *stream)
 
 	link = stream->link;
 
-	psr_config.psr_version = link->dpcd_caps.psr_caps.psr_version;
-
-	if (psr_config.psr_version > 0) {
-		psr_config.psr_exit_link_training_required = 0x1;
+	if (link->psr_settings.psr_version != DC_PSR_VERSION_UNSUPPORTED) {
+		psr_config.psr_version = link->psr_settings.psr_version;
 		psr_config.psr_frame_capture_indication_req = 0;
 		psr_config.psr_rfb_setup_time = 0x37;
 		psr_config.psr_sdp_transmit_line_num_deadline = 0x20;
-- 
2.35.1



