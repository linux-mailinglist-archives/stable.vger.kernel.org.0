Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0975C0224
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbiIUPsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbiIUPsR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:48:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4530D96FD3;
        Wed, 21 Sep 2022 08:47:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8136EB830A0;
        Wed, 21 Sep 2022 15:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7459C433D6;
        Wed, 21 Sep 2022 15:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775255;
        bh=3ivMZ11AgPCuYA4AoxzTj/EVjww+87Beeoga76D963M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HmqKppku515muD6EuOaRDsK7dSp5SJe/Vcgp4aPtBu5/i+VhLevOB99hphlX3gS1Y
         HVBeLbmVLSR/sU0a8fMQfPT5x0T3Ii+shhIi0ZekvIbzbGAQ4SOYVN/eJ/6mBVjOLx
         72rHtPEb3JrK4MDrXP+iuq2qvrkI03cvsy6uM9qY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gustaw Smolarczyk <wielkiegie@gmail.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.19 31/38] drm/amdgpu: Dont enable LTR if not supported
Date:   Wed, 21 Sep 2022 17:46:15 +0200
Message-Id: <20220921153647.245053881@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.298361220@linuxfoundation.org>
References: <20220921153646.298361220@linuxfoundation.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

commit 6c20490663553cd7e07d8de8af482012329ab9d6 upstream.

As per PCIE Base Spec r4.0 Section 6.18
'Software must not enable LTR in an Endpoint unless the Root Complex
and all intermediate Switches indicate support for LTR.'

This fixes the Unsupported Request error reported through AER during
ASPM enablement.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216455

The error was unnoticed before and got visible because of the commit
referenced below. This doesn't fix anything in the commit below, rather
fixes the issue in amdgpu exposed by the commit. The reference is only
to associate this commit with below one so that both go together.

Fixes: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in get_port_device_capability()")

Reported-by: Gustaw Smolarczyk <wielkiegie@gmail.com>
Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Cc: stable@vger.kernel.org
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c |    9 ++++++++-
 drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c |    9 ++++++++-
 drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c |    9 ++++++++-
 3 files changed, 24 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
@@ -380,6 +380,7 @@ static void nbio_v2_3_enable_aspm(struct
 		WREG32_PCIE(smnPCIE_LC_CNTL, data);
 }
 
+#ifdef CONFIG_PCIEASPM
 static void nbio_v2_3_program_ltr(struct amdgpu_device *adev)
 {
 	uint32_t def, data;
@@ -401,9 +402,11 @@ static void nbio_v2_3_program_ltr(struct
 	if (def != data)
 		WREG32_PCIE(smnBIF_CFG_DEV0_EPF0_DEVICE_CNTL2, data);
 }
+#endif
 
 static void nbio_v2_3_program_aspm(struct amdgpu_device *adev)
 {
+#ifdef CONFIG_PCIEASPM
 	uint32_t def, data;
 
 	def = data = RREG32_PCIE(smnPCIE_LC_CNTL);
@@ -459,7 +462,10 @@ static void nbio_v2_3_program_aspm(struc
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL6, data);
 
-	nbio_v2_3_program_ltr(adev);
+	/* Don't bother about LTR if LTR is not enabled
+	 * in the path */
+	if (adev->pdev->ltr_path)
+		nbio_v2_3_program_ltr(adev);
 
 	def = data = RREG32_SOC15(NBIO, 0, mmRCC_BIF_STRAP3);
 	data |= 0x5DE0 << RCC_BIF_STRAP3__STRAP_VLINK_ASPM_IDLE_TIMER__SHIFT;
@@ -483,6 +489,7 @@ static void nbio_v2_3_program_aspm(struc
 	data &= ~PCIE_LC_CNTL3__LC_DSC_DONT_ENTER_L23_AFTER_PME_ACK_MASK;
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL3, data);
+#endif
 }
 
 static void nbio_v2_3_apply_lc_spc_mode_wa(struct amdgpu_device *adev)
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c
@@ -282,6 +282,7 @@ static void nbio_v6_1_init_registers(str
 			mmBIF_BX_DEV0_EPF0_VF0_HDP_MEM_COHERENCY_FLUSH_CNTL) << 2;
 }
 
+#ifdef CONFIG_PCIEASPM
 static void nbio_v6_1_program_ltr(struct amdgpu_device *adev)
 {
 	uint32_t def, data;
@@ -303,9 +304,11 @@ static void nbio_v6_1_program_ltr(struct
 	if (def != data)
 		WREG32_PCIE(smnBIF_CFG_DEV0_EPF0_DEVICE_CNTL2, data);
 }
+#endif
 
 static void nbio_v6_1_program_aspm(struct amdgpu_device *adev)
 {
+#ifdef CONFIG_PCIEASPM
 	uint32_t def, data;
 
 	def = data = RREG32_PCIE(smnPCIE_LC_CNTL);
@@ -361,7 +364,10 @@ static void nbio_v6_1_program_aspm(struc
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL6, data);
 
-	nbio_v6_1_program_ltr(adev);
+	/* Don't bother about LTR if LTR is not enabled
+	 * in the path */
+	if (adev->pdev->ltr_path)
+		nbio_v6_1_program_ltr(adev);
 
 	def = data = RREG32_PCIE(smnRCC_BIF_STRAP3);
 	data |= 0x5DE0 << RCC_BIF_STRAP3__STRAP_VLINK_ASPM_IDLE_TIMER__SHIFT;
@@ -385,6 +391,7 @@ static void nbio_v6_1_program_aspm(struc
 	data &= ~PCIE_LC_CNTL3__LC_DSC_DONT_ENTER_L23_AFTER_PME_ACK_MASK;
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL3, data);
+#endif
 }
 
 const struct amdgpu_nbio_funcs nbio_v6_1_funcs = {
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
@@ -673,6 +673,7 @@ struct amdgpu_nbio_ras nbio_v7_4_ras = {
 };
 
 
+#ifdef CONFIG_PCIEASPM
 static void nbio_v7_4_program_ltr(struct amdgpu_device *adev)
 {
 	uint32_t def, data;
@@ -694,9 +695,11 @@ static void nbio_v7_4_program_ltr(struct
 	if (def != data)
 		WREG32_PCIE(smnBIF_CFG_DEV0_EPF0_DEVICE_CNTL2, data);
 }
+#endif
 
 static void nbio_v7_4_program_aspm(struct amdgpu_device *adev)
 {
+#ifdef CONFIG_PCIEASPM
 	uint32_t def, data;
 
 	if (adev->ip_versions[NBIO_HWIP][0] == IP_VERSION(7, 4, 4))
@@ -755,7 +758,10 @@ static void nbio_v7_4_program_aspm(struc
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL6, data);
 
-	nbio_v7_4_program_ltr(adev);
+	/* Don't bother about LTR if LTR is not enabled
+	 * in the path */
+	if (adev->pdev->ltr_path)
+		nbio_v7_4_program_ltr(adev);
 
 	def = data = RREG32_PCIE(smnRCC_BIF_STRAP3);
 	data |= 0x5DE0 << RCC_BIF_STRAP3__STRAP_VLINK_ASPM_IDLE_TIMER__SHIFT;
@@ -779,6 +785,7 @@ static void nbio_v7_4_program_aspm(struc
 	data &= ~PCIE_LC_CNTL3__LC_DSC_DONT_ENTER_L23_AFTER_PME_ACK_MASK;
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL3, data);
+#endif
 }
 
 const struct amdgpu_nbio_funcs nbio_v7_4_funcs = {


