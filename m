Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE5B5419E7
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378047AbiFGV1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378643AbiFGVX4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:23:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06C0227376;
        Tue,  7 Jun 2022 12:00:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7265261787;
        Tue,  7 Jun 2022 19:00:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B07C385A2;
        Tue,  7 Jun 2022 19:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628442;
        bh=TIJngYH102qEmFZnYblf7kWBift6Ih/yHXSL/OiT3Aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=izRvNDWc/lqgIR7r8xPDgDeLGD5UuMasr1FmydNExX1gOu3Gn5EPUYF0JZgUMNHbo
         tZxw9h6ehLY0kzFayx/K2fZoSaaauOBNIDdo9jutRcJys5aLzSIKkRnK8ixee95pb4
         FiR8BZlBvVRipgLdJ0fwKPNe01xEsWaD0+FWGLec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yongqiang Sun <yongqiang.sun@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 291/879] drm/amd/amdgpu: Only reserve vram for firmware with vega9 MS_HYPERV host.
Date:   Tue,  7 Jun 2022 18:56:49 +0200
Message-Id: <20220607165011.294913080@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yongqiang Sun <yongqiang.sun@amd.com>

[ Upstream commit 49aa98ca30cd186ab33fc5802066e2024d3bfa39 ]

driver loading failed on VEGA10 SRIOV VF with linux host due to a wide
range of stolen reserved vram.
Since VEGA10 SRIOV VF need to reserve vram for firmware with windows
Hyper_V host specifically, check hypervisor type to only reserve
memory for it, and the range of the reserved vram can be limited
to between 5M-7M area.

Fixes: faad5ccac1eaae ("drm/amdgpu: Add stolen reserved memory for MI25 SRIOV.")
Signed-off-by: Yongqiang Sun <yongqiang.sun@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
index a66a0881a934..3e9582c245bb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -25,6 +25,7 @@
  */
 
 #include <linux/io-64-nonatomic-lo-hi.h>
+#include <asm/hypervisor.h>
 
 #include "amdgpu.h"
 #include "amdgpu_gmc.h"
@@ -647,11 +648,11 @@ void amdgpu_gmc_get_vbios_allocations(struct amdgpu_device *adev)
 	case CHIP_VEGA10:
 		adev->mman.keep_stolen_vga_memory = true;
 		/*
-		 * VEGA10 SRIOV VF needs some firmware reserved area.
+		 * VEGA10 SRIOV VF with MS_HYPERV host needs some firmware reserved area.
 		 */
-		if (amdgpu_sriov_vf(adev)) {
-			adev->mman.stolen_reserved_offset = 0x100000;
-			adev->mman.stolen_reserved_size = 0x600000;
+		if (amdgpu_sriov_vf(adev) && hypervisor_is_type(X86_HYPER_MS_HYPERV)) {
+			adev->mman.stolen_reserved_offset = 0x500000;
+			adev->mman.stolen_reserved_size = 0x200000;
 		}
 		break;
 	case CHIP_RAVEN:
-- 
2.35.1



