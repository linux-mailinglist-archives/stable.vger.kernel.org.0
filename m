Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E99330E60
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbhCHMgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:36:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231224AbhCHMgU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:36:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC68A651DD;
        Mon,  8 Mar 2021 12:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206980;
        bh=tj4WuOSRPka5qXnH++FmxEFSn3ff9Ojr4uex2YvEmGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UTx9VTJWOAn5MH+/vf17U2Iu3ctcbTFMm1/j1PUXGzxHIl8KmJISDbLpNteRovRe2
         dJ8uY+AIx2kA7v45L8oBpr5I2BgNaFIN3+2SM3oAE1HRsVU3DwfRzoDec11NValdOy
         agLjX2KIQ8+zhku+WbTUKoyVUgUX6l3PRp58COpA=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Guchun Chen <guchun.chen@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.11 25/44] drm/amd/pm: correct Arcturus mmTHM_BACO_CNTL register address
Date:   Mon,  8 Mar 2021 13:35:03 +0100
Message-Id: <20210308122719.818593160@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
References: <20210308122718.586629218@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Evan Quan <evan.quan@amd.com>

commit 6efda1671312e8432216ee8b106e71fa3102e1d3 upstream.

Arcturus has a different register address from other SMU V11
ASICs.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Acked-by: Guchun Chen <guchun.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
@@ -78,6 +78,9 @@ MODULE_FIRMWARE("amdgpu/dimgrey_cavefish
 #define PCIE_LC_SPEED_CNTL__LC_CURRENT_DATA_RATE_MASK 0xC000
 #define PCIE_LC_SPEED_CNTL__LC_CURRENT_DATA_RATE__SHIFT 0xE
 
+#define mmTHM_BACO_CNTL_ARCT			0xA7
+#define mmTHM_BACO_CNTL_ARCT_BASE_IDX		0
+
 static int link_width[] = {0, 1, 2, 4, 8, 12, 16};
 static int link_speed[] = {25, 50, 80, 160};
 
@@ -1581,9 +1584,15 @@ int smu_v11_0_baco_set_state(struct smu_
 			break;
 		default:
 			if (!ras || !ras->supported) {
-				data = RREG32_SOC15(THM, 0, mmTHM_BACO_CNTL);
-				data |= 0x80000000;
-				WREG32_SOC15(THM, 0, mmTHM_BACO_CNTL, data);
+				if (adev->asic_type == CHIP_ARCTURUS) {
+					data = RREG32_SOC15(THM, 0, mmTHM_BACO_CNTL_ARCT);
+					data |= 0x80000000;
+					WREG32_SOC15(THM, 0, mmTHM_BACO_CNTL_ARCT, data);
+				} else {
+					data = RREG32_SOC15(THM, 0, mmTHM_BACO_CNTL);
+					data |= 0x80000000;
+					WREG32_SOC15(THM, 0, mmTHM_BACO_CNTL, data);
+				}
 
 				ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_EnterBaco, 0, NULL);
 			} else {


