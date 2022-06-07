Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6741541967
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376516AbiFGVV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377921AbiFGVTB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:19:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB2A224441;
        Tue,  7 Jun 2022 11:59:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 699DFB823A1;
        Tue,  7 Jun 2022 18:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5CAC385A2;
        Tue,  7 Jun 2022 18:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628366;
        bh=B1mGJDCgUMNLtQ+ObxvdZWb5V/Djv7GIn7G0SDoX2cM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZotGOdSyVxZ06yYKLS/kboY38Zgc+iFDQdKSUmvWFyv/nxavpuBbRdrZ6LaVYxZAT
         oumi/aVpxnBuWTsaqYaQPNAMdTMHOuItQ+YoRW2TmRQtW5ZB78L3gntpZIfSdkBO0M
         sW0wJLRtKrWRd/kUyvw/v1nVnnhsRxR+94jl4rT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Yongqiang Sun <yongqiang.sun@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 303/879] drm/amd/amdgpu: Fix asm/hypervisor.h build error.
Date:   Tue,  7 Jun 2022 18:57:01 +0200
Message-Id: <20220607165011.644122781@linuxfoundation.org>
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

[ Upstream commit d9e50239a9611b9a1759e007e9a810c8d178da28 ]

Add CONFIG_X86 check to fix the build error.

Fixes: 49aa98ca30cd18 ("drm/amd/amdgpu: Only reserve vram for firmware with vega9 MS_HYPERV host.")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Yongqiang Sun <yongqiang.sun@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
index 3e9582c245bb..88b852b3a2cb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -25,7 +25,9 @@
  */
 
 #include <linux/io-64-nonatomic-lo-hi.h>
+#ifdef CONFIG_X86
 #include <asm/hypervisor.h>
+#endif
 
 #include "amdgpu.h"
 #include "amdgpu_gmc.h"
@@ -650,10 +652,12 @@ void amdgpu_gmc_get_vbios_allocations(struct amdgpu_device *adev)
 		/*
 		 * VEGA10 SRIOV VF with MS_HYPERV host needs some firmware reserved area.
 		 */
+#ifdef CONFIG_X86
 		if (amdgpu_sriov_vf(adev) && hypervisor_is_type(X86_HYPER_MS_HYPERV)) {
 			adev->mman.stolen_reserved_offset = 0x500000;
 			adev->mman.stolen_reserved_size = 0x200000;
 		}
+#endif
 		break;
 	case CHIP_RAVEN:
 	case CHIP_RENOIR:
-- 
2.35.1



