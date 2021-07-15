Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656283CAAF2
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242379AbhGOTQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:16:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244588AbhGOTO6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:14:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84CEB61404;
        Thu, 15 Jul 2021 19:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376246;
        bh=TfcyZbHDtm0negA0mJ3ob4L1Yy1Cygyt+vDwe+UK9HI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bHHv/kRsvf7bqDJ4uLDc9hNk7V6GMFTQu3yIunCuW2Qos1Bpe5CE7Muu1IU0zTF4X
         oMHieZw3/YK955VQfwf31dnV64elWq2ZVBR5fHKC9PTnP329zyRrnC49DOY1WpESM9
         VrHEQdamhu6RduP/1T0CdZWD59x/fjjm2plqAaR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.13 189/266] drm/amdgpu: fix the hang caused by PCIe link width switch
Date:   Thu, 15 Jul 2021 20:39:04 +0200
Message-Id: <20210715182644.422456016@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
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
@@ -94,6 +94,7 @@ struct amdgpu_nbio_funcs {
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
@@ -1197,6 +1197,9 @@ static int nv_common_hw_init(void *handl
 	if (adev->nbio.funcs->apply_lc_spc_mode_wa)
 		adev->nbio.funcs->apply_lc_spc_mode_wa(adev);
 
+	if (adev->nbio.funcs->apply_l1_link_width_reconfig_wa)
+		adev->nbio.funcs->apply_l1_link_width_reconfig_wa(adev);
+
 	/* enable pcie gen2/3 link */
 	nv_pcie_gen3_enable(adev);
 	/* enable aspm */


