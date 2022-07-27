Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A73F4582D02
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240914AbiG0QxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240840AbiG0QwS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:52:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3E554AE7;
        Wed, 27 Jul 2022 09:34:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7A36B821C5;
        Wed, 27 Jul 2022 16:34:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0065C433C1;
        Wed, 27 Jul 2022 16:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939655;
        bh=+g2pLYhP4bQmZMk3IlOF+le1a4hQ0xKeaAGPi1gxwdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hz/G/Z+9ZLGn1o4v/oW+TSVTOb5IfzVWnYPS3thvrbPyqpzypRS/uR1t1EtfcOs3b
         ufRBOPbKcgnMlkZ1mDXz3yLP8+uQoTIIcjZ+JAStucG4o+FB47sk3U1m8+rbkWdn/N
         AioVajWEVCB1doXu6X558bPxDSMZMgPcixOySLxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/105] drm/amdgpu/display: add quirk handling for stutter mode
Date:   Wed, 27 Jul 2022 18:10:12 +0200
Message-Id: <20220727161013.149328291@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 3ce51649cdf23ab463494df2bd6d1e9529ebdc6a ]

Stutter mode is a power saving feature on GPUs, however at
least one early raven system exhibits stability issues with
it.  Add a quirk to disable it for that system.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=214417
Fixes: 005440066f929b ("drm/amdgpu: enable gfxoff again on raven series (v2)")
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 33 +++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index f069d0faba64..55ecc67592eb 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -922,6 +922,37 @@ static void amdgpu_check_debugfs_connector_property_change(struct amdgpu_device
 	}
 }
 
+struct amdgpu_stutter_quirk {
+	u16 chip_vendor;
+	u16 chip_device;
+	u16 subsys_vendor;
+	u16 subsys_device;
+	u8 revision;
+};
+
+static const struct amdgpu_stutter_quirk amdgpu_stutter_quirk_list[] = {
+	/* https://bugzilla.kernel.org/show_bug.cgi?id=214417 */
+	{ 0x1002, 0x15dd, 0x1002, 0x15dd, 0xc8 },
+	{ 0, 0, 0, 0, 0 },
+};
+
+static bool dm_should_disable_stutter(struct pci_dev *pdev)
+{
+	const struct amdgpu_stutter_quirk *p = amdgpu_stutter_quirk_list;
+
+	while (p && p->chip_device != 0) {
+		if (pdev->vendor == p->chip_vendor &&
+		    pdev->device == p->chip_device &&
+		    pdev->subsystem_vendor == p->subsys_vendor &&
+		    pdev->subsystem_device == p->subsys_device &&
+		    pdev->revision == p->revision) {
+			return true;
+		}
+		++p;
+	}
+	return false;
+}
+
 static int amdgpu_dm_init(struct amdgpu_device *adev)
 {
 	struct dc_init_data init_data;
@@ -1014,6 +1045,8 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 
 	if (adev->asic_type != CHIP_CARRIZO && adev->asic_type != CHIP_STONEY)
 		adev->dm.dc->debug.disable_stutter = amdgpu_pp_feature_mask & PP_STUTTER_MODE ? false : true;
+	if (dm_should_disable_stutter(adev->pdev))
+		adev->dm.dc->debug.disable_stutter = true;
 
 	if (amdgpu_dc_debug_mask & DC_DISABLE_STUTTER)
 		adev->dm.dc->debug.disable_stutter = true;
-- 
2.35.1



