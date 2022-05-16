Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B286F527FC4
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 10:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241744AbiEPIdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 04:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241764AbiEPIdl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 04:33:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D45E0A5
        for <stable@vger.kernel.org>; Mon, 16 May 2022 01:33:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBED3B80ED7
        for <stable@vger.kernel.org>; Mon, 16 May 2022 08:33:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F591C385AA;
        Mon, 16 May 2022 08:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652690017;
        bh=cD+fFroM9xBuYyTDo2ItvE65jmu0pUmL3ebOf7a3VMI=;
        h=Subject:To:Cc:From:Date:From;
        b=tTKMyKItmT9hj3gbvYQ/wt0RLhIORHDeqMQsAaBmy81cmulGGB3qGYvYCyi0zMpsJ
         sKEV4tf1qSF0pAML1vHgsrnSVsCSRhBW/mux5i6KPdwPFtPQhc1L/kwV+6C40ibkcF
         4VXur2shDxKkjVRxDukDA24+azyMDHP61EKT1yNU=
Subject: FAILED: patch "[PATCH] drm/amdgpu: vi: disable ASPM on Intel Alder Lake based" failed to apply to 5.17-stable tree
To:     richard.gong@amd.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 May 2022 10:33:27 +0200
Message-ID: <16526900079672@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.17-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From aa482ddca85a3485be0e7b83a0789dc4d987670b Mon Sep 17 00:00:00 2001
From: Richard Gong <richard.gong@amd.com>
Date: Fri, 8 Apr 2022 12:08:38 -0500
Subject: [PATCH] drm/amdgpu: vi: disable ASPM on Intel Alder Lake based
 systems

Active State Power Management (ASPM) feature is enabled since kernel 5.14.
There are some AMD Volcanic Islands (VI) GFX cards, such as the WX3200 and
RX640, that do not work with ASPM-enabled Intel Alder Lake based systems.
Using these GFX cards as video/display output, Intel Alder Lake based
systems will freeze after suspend/resume.

The issue was originally reported on one system (Dell Precision 3660 with
BIOS version 0.14.81), but was later confirmed to affect at least 4
pre-production Alder Lake based systems.

Add an extra check to disable ASPM on Intel Alder Lake based systems with
the problematic AMD Volcanic Islands GFX cards.

Fixes: 0064b0ce85bb ("drm/amd/pm: enable ASPM by default")
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1885
Signed-off-by: Richard Gong <richard.gong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/vi.c b/drivers/gpu/drm/amd/amdgpu/vi.c
index 039b90cdc3bc..45f0188c4273 100644
--- a/drivers/gpu/drm/amd/amdgpu/vi.c
+++ b/drivers/gpu/drm/amd/amdgpu/vi.c
@@ -81,6 +81,10 @@
 #include "mxgpu_vi.h"
 #include "amdgpu_dm.h"
 
+#if IS_ENABLED(CONFIG_X86)
+#include <asm/intel-family.h>
+#endif
+
 #define ixPCIE_LC_L1_PM_SUBSTATE	0x100100C6
 #define PCIE_LC_L1_PM_SUBSTATE__LC_L1_SUBSTATES_OVERRIDE_EN_MASK	0x00000001L
 #define PCIE_LC_L1_PM_SUBSTATE__LC_PCI_PM_L1_2_OVERRIDE_MASK	0x00000002L
@@ -1134,13 +1138,24 @@ static void vi_enable_aspm(struct amdgpu_device *adev)
 		WREG32_PCIE(ixPCIE_LC_CNTL, data);
 }
 
+static bool aspm_support_quirk_check(void)
+{
+#if IS_ENABLED(CONFIG_X86)
+	struct cpuinfo_x86 *c = &cpu_data(0);
+
+	return !(c->x86 == 6 && c->x86_model == INTEL_FAM6_ALDERLAKE);
+#else
+	return true;
+#endif
+}
+
 static void vi_program_aspm(struct amdgpu_device *adev)
 {
 	u32 data, data1, orig;
 	bool bL1SS = false;
 	bool bClkReqSupport = true;
 
-	if (!amdgpu_device_should_use_aspm(adev))
+	if (!amdgpu_device_should_use_aspm(adev) || !aspm_support_quirk_check())
 		return;
 
 	if (adev->flags & AMD_IS_APU ||

