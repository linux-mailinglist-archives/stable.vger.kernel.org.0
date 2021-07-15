Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933DC3CA967
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242273AbhGOTGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:06:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242763AbhGOTFh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:05:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82FD6613D0;
        Thu, 15 Jul 2021 19:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375720;
        bh=PYQwH381dJ8DrPCGAtiLLg9DJaaQdtKh+dXprzd9LkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OR1xB/167GK0nHL6k2Ckopu9ipzbf/KKA/5zCasuNi5BVybVrtPSR+NbUrluJwj0p
         vIoclvRmWl/TBTlUqD7EVLqbznJBR8Ft2/zAZv4tGtNxnni+WXgPWX+cmigsuU21ES
         HJrUII2/Zofi48l1uP9VDBSEuBDXtneoQaIqjLpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.12 165/242] drm/amdgpu: fix the hang caused by PCIe link width switch
Date:   Thu, 15 Jul 2021 20:38:47 +0200
Message-Id: <20210715182622.199012923@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

commit adcf949e664a8b04df2fb8aa916892e58561653c upstream.

SMU had set all the necessary fields for a link width switch
but the width switch wasn't occurring because the link was idle
in the L1 state. Setting LC_L1_RECONFIG_EN=0x1 will allow width
switches to also be initiated while in L1 instead of waiting until
the link is back in L0.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_nbio.h |    1 +
 drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c   |   13 +++++++++++++
 drivers/gpu/drm/amd/amdgpu/nv.c          |    3 +++
 3 files changed, 17 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_nbio.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_nbio.h
@@ -90,6 +90,7 @@ struct amdgpu_nbio_funcs {
 			    bool enable);
 	void (*program_aspm)(struct amdgpu_device *adev);
 	void (*apply_lc_spc_mode_wa)(struct amdgpu_device *adev);
+	void (*apply_l1_link_width_reconfig_wa)(struct amdgpu_device *adev);
 };
 
 struct amdgpu_nbio {
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
@@ -490,6 +490,18 @@ static void nbio_v2_3_apply_lc_spc_mode_
 	}
 }
 
+static void nbio_v2_3_apply_l1_link_width_reconfig_wa(struct amdgpu_device *adev)
+{
+	uint32_t reg_data = 0;
+
+	if (adev->asic_type != CHIP_NAVI10)
+		return;
+
+	reg_data = RREG32_PCIE(smnPCIE_LC_LINK_WIDTH_CNTL);
+	reg_data |= PCIE_LC_LINK_WIDTH_CNTL__LC_L1_RECONFIG_EN_MASK;
+	WREG32_PCIE(smnPCIE_LC_LINK_WIDTH_CNTL, reg_data);
+}
+
 const struct amdgpu_nbio_funcs nbio_v2_3_funcs = {
 	.get_hdp_flush_req_offset = nbio_v2_3_get_hdp_flush_req_offset,
 	.get_hdp_flush_done_offset = nbio_v2_3_get_hdp_flush_done_offset,
@@ -512,4 +524,5 @@ const struct amdgpu_nbio_funcs nbio_v2_3
 	.enable_aspm = nbio_v2_3_enable_aspm,
 	.program_aspm =  nbio_v2_3_program_aspm,
 	.apply_lc_spc_mode_wa = nbio_v2_3_apply_lc_spc_mode_wa,
+	.apply_l1_link_width_reconfig_wa = nbio_v2_3_apply_l1_link_width_reconfig_wa,
 };
--- a/drivers/gpu/drm/amd/amdgpu/nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/nv.c
@@ -1076,6 +1076,9 @@ static int nv_common_hw_init(void *handl
 	if (adev->nbio.funcs->apply_lc_spc_mode_wa)
 		adev->nbio.funcs->apply_lc_spc_mode_wa(adev);
 
+	if (adev->nbio.funcs->apply_l1_link_width_reconfig_wa)
+		adev->nbio.funcs->apply_l1_link_width_reconfig_wa(adev);
+
 	/* enable pcie gen2/3 link */
 	nv_pcie_gen3_enable(adev);
 	/* enable aspm */


