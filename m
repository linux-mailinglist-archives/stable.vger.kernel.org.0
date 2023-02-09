Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E181E6906EC
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbjBILWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbjBILVL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:21:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFABF5ACD8;
        Thu,  9 Feb 2023 03:18:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F9DEB820FE;
        Thu,  9 Feb 2023 11:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CCBC433D2;
        Thu,  9 Feb 2023 11:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941445;
        bh=gVh6vKcD3veQO8dD/zvVPFaBQ6I3xHyzxSFt5Ew0QQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nm91bZHIQXMkdSs0UUnqYJTd4aAsp4y2mrAbO1FMMm3/mI6HsyGpUPrnCr8iOS3L1
         nZAkoaIum9f77oTMXD31822zostzHF7pN7x8YUMbrlYUeErpMWp13UsYXYBBKsmicN
         vB64zG+4ZRNPh2HWRQGZgeQqfDwciGnVh6dzo3TljSwzv0d+AX1CpFdAv7mPP60hYb
         /qvvtVnaW4W9t+HP3d366T0Z0KH/w19fBSxf6i704BCOuxsA4WAs2ikm5yEnjbIL6C
         eWY0OwSxyi88Ev6Db0Y+RkZUkv34dQzKMWJik+CIgxIdrbu5GC2tXOvV4zv7XMV0cJ
         mOietlAk5LyLg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, roman.li@amd.com, Jerry.Zuo@amd.com,
        lyude@redhat.com, stylon.wang@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 35/38] drm/amd/display: Properly handle additional cases where DCN is not supported
Date:   Thu,  9 Feb 2023 06:14:54 -0500
Message-Id: <20230209111459.1891941-35-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111459.1891941-1-sashal@kernel.org>
References: <20230209111459.1891941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 6fc547a5a2ef5ce05b16924106663ab92f8f87a7 ]

There could be boards with DCN listed in IP discovery, but no
display hardware actually wired up.  In this case the vbios
display table will not be populated.  Detect this case and
skip loading DM when we detect it.

v2: Mark DCN as harvested as well so other display checks
elsewhere in the driver are handled properly.

Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 85bd1f18259c7..c92aaf5c36ef5 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4512,6 +4512,17 @@ DEVICE_ATTR_WO(s3_debug);
 static int dm_early_init(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
+	struct amdgpu_mode_info *mode_info = &adev->mode_info;
+	struct atom_context *ctx = mode_info->atom_context;
+	int index = GetIndexIntoMasterTable(DATA, Object_Header);
+	u16 data_offset;
+
+	/* if there is no object header, skip DM */
+	if (!amdgpu_atom_parse_data_header(ctx, index, NULL, NULL, NULL, &data_offset)) {
+		adev->harvest_ip_mask |= AMD_HARVEST_IP_DMU_MASK;
+		dev_info(adev->dev, "No object header, skipping DM\n");
+		return -ENOENT;
+	}
 
 	switch (adev->asic_type) {
 #if defined(CONFIG_DRM_AMD_DC_SI)
-- 
2.39.0

