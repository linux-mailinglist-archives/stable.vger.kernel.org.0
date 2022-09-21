Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBF575C026F
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbiIUPwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbiIUPvh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:51:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE0B339;
        Wed, 21 Sep 2022 08:49:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D6B76313C;
        Wed, 21 Sep 2022 15:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E66CC433D6;
        Wed, 21 Sep 2022 15:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775347;
        bh=jnrtrwVThl7jBOaHqlfiiHiaXpyyPz87zg3tkY08qJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VUT3/NW9hmcQAaPJYQhmuVxDuYlXY8yVJZ52Ky8OwUcyYiD3xZJX/rVzHBXSFdA+y
         eliaU5FURzggPNkgaw+9m5SYwR986RXmFruLIRmUa9F2VpMQw9BH0LPphRvzif5wLA
         kRaAxz5bvluYyW+KmvrpFlygG7Rl8t1ULB0+OEf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gustaw Smolarczyk <wielkiegie@gmail.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 22/45] drm/amdgpu: Dont enable LTR if not supported
Date:   Wed, 21 Sep 2022 17:46:12 +0200
Message-Id: <20220921153647.598306582@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.931277075@linuxfoundation.org>
References: <20220921153646.931277075@linuxfoundation.org>
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
@@ -366,6 +366,7 @@ static void nbio_v2_3_enable_aspm(struct
 		WREG32_PCIE(smnPCIE_LC_CNTL, data);
 }
 
+#ifdef CONFIG_PCIEASPM
 static void nbio_v2_3_program_ltr(struct amdgpu_device *adev)
 {
 	uint32_t def, data;
@@ -387,9 +388,11 @@ static void nbio_v2_3_program_ltr(struct
 	if (def != data)
 		WREG32_PCIE(smnBIF_CFG_DEV0_EPF0_DEVICE_CNTL2, data);
 }
+#endif
 
 static void nbio_v2_3_program_aspm(struct amdgpu_device *adev)
 {
+#ifdef CONFIG_PCIEASPM
 	uint32_t def, data;
 
 	def = data = RREG32_PCIE(smnPCIE_LC_CNTL);
@@ -445,7 +448,10 @@ static void nbio_v2_3_program_aspm(struc
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL6, data);
 
-	nbio_v2_3_program_ltr(adev);
+	/* Don't bother about LTR if LTR is not enabled
+	 * in the path */
+	if (adev->pdev->ltr_path)
+		nbio_v2_3_program_ltr(adev);
 
 	def = data = RREG32_SOC15(NBIO, 0, mmRCC_BIF_STRAP3);
 	data |= 0x5DE0 << RCC_BIF_STRAP3__STRAP_VLINK_ASPM_IDLE_TIMER__SHIFT;
@@ -469,6 +475,7 @@ static void nbio_v2_3_program_aspm(struc
 	data &= ~PCIE_LC_CNTL3__LC_DSC_DONT_ENTER_L23_AFTER_PME_ACK_MASK;
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL3, data);
+#endif
 }
 
 static void nbio_v2_3_apply_lc_spc_mode_wa(struct amdgpu_device *adev)
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c
@@ -278,6 +278,7 @@ static void nbio_v6_1_init_registers(str
 		WREG32_PCIE(smnPCIE_CI_CNTL, data);
 }
 
+#ifdef CONFIG_PCIEASPM
 static void nbio_v6_1_program_ltr(struct amdgpu_device *adev)
 {
 	uint32_t def, data;
@@ -299,9 +300,11 @@ static void nbio_v6_1_program_ltr(struct
 	if (def != data)
 		WREG32_PCIE(smnBIF_CFG_DEV0_EPF0_DEVICE_CNTL2, data);
 }
+#endif
 
 static void nbio_v6_1_program_aspm(struct amdgpu_device *adev)
 {
+#ifdef CONFIG_PCIEASPM
 	uint32_t def, data;
 
 	def = data = RREG32_PCIE(smnPCIE_LC_CNTL);
@@ -357,7 +360,10 @@ static void nbio_v6_1_program_aspm(struc
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL6, data);
 
-	nbio_v6_1_program_ltr(adev);
+	/* Don't bother about LTR if LTR is not enabled
+	 * in the path */
+	if (adev->pdev->ltr_path)
+		nbio_v6_1_program_ltr(adev);
 
 	def = data = RREG32_PCIE(smnRCC_BIF_STRAP3);
 	data |= 0x5DE0 << RCC_BIF_STRAP3__STRAP_VLINK_ASPM_IDLE_TIMER__SHIFT;
@@ -381,6 +387,7 @@ static void nbio_v6_1_program_aspm(struc
 	data &= ~PCIE_LC_CNTL3__LC_DSC_DONT_ENTER_L23_AFTER_PME_ACK_MASK;
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL3, data);
+#endif
 }
 
 const struct amdgpu_nbio_funcs nbio_v6_1_funcs = {
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
@@ -630,6 +630,7 @@ const struct amdgpu_nbio_ras_funcs nbio_
 	.ras_fini = amdgpu_nbio_ras_fini,
 };
 
+#ifdef CONFIG_PCIEASPM
 static void nbio_v7_4_program_ltr(struct amdgpu_device *adev)
 {
 	uint32_t def, data;
@@ -651,9 +652,11 @@ static void nbio_v7_4_program_ltr(struct
 	if (def != data)
 		WREG32_PCIE(smnBIF_CFG_DEV0_EPF0_DEVICE_CNTL2, data);
 }
+#endif
 
 static void nbio_v7_4_program_aspm(struct amdgpu_device *adev)
 {
+#ifdef CONFIG_PCIEASPM
 	uint32_t def, data;
 
 	def = data = RREG32_PCIE(smnPCIE_LC_CNTL);
@@ -709,7 +712,10 @@ static void nbio_v7_4_program_aspm(struc
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL6, data);
 
-	nbio_v7_4_program_ltr(adev);
+	/* Don't bother about LTR if LTR is not enabled
+	 * in the path */
+	if (adev->pdev->ltr_path)
+		nbio_v7_4_program_ltr(adev);
 
 	def = data = RREG32_PCIE(smnRCC_BIF_STRAP3);
 	data |= 0x5DE0 << RCC_BIF_STRAP3__STRAP_VLINK_ASPM_IDLE_TIMER__SHIFT;
@@ -733,6 +739,7 @@ static void nbio_v7_4_program_aspm(struc
 	data &= ~PCIE_LC_CNTL3__LC_DSC_DONT_ENTER_L23_AFTER_PME_ACK_MASK;
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL3, data);
+#endif
 }
 
 const struct amdgpu_nbio_funcs nbio_v7_4_funcs = {


