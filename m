Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A08E9199182
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730853AbgCaJPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:15:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730547AbgCaJPU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:15:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0260220675;
        Tue, 31 Mar 2020 09:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646119;
        bh=+qQRse8RqlkU/6s73AD5+3QBNHW78pnuLWsIUtuDqKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dkafwPa6DGLJBnA4PnHYI0YIMULJhsN8pgSDp6yREaHKYpp2flOyM/Yx9M9K3NBgL
         8eaMwLGjiTeGVMEiycnMrNv5ZVgd0J9tN7wnqUmf3w/LHonJswkU5lpuFPVC8mptGq
         OxD8cxijCp5UDmQGBRRrQGAWiuXzVjdCyO1ADO5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hawking Zhang <Hawking.Zhang@amd.com>,
        Candice Li <Candice.Li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 063/155] drm/amdgpu: correct ROM_INDEX/DATA offset for VEGA20
Date:   Tue, 31 Mar 2020 10:58:23 +0200
Message-Id: <20200331085425.576534719@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hawking Zhang <Hawking.Zhang@amd.com>

[ Upstream commit f1c2cd3f8fb959123a9beba18c0e8112dcb2e137 ]

The ROMC_INDEX/DATA offset was changed to e4/e5 since
from smuio_v11 (vega20/arcturus).

Signed-off-by: Hawking Zhang <Hawking.Zhang@amd.com>
Tested-by: Candice Li <Candice.Li@amd.com>
Reviewed-by: Candice Li <Candice.Li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/soc15.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index 80934ca172607..c086262cc181d 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -84,6 +84,13 @@
 #define HDP_MEM_POWER_CTRL__RC_MEM_POWER_CTRL_EN_MASK	0x00010000L
 #define HDP_MEM_POWER_CTRL__RC_MEM_POWER_LS_EN_MASK		0x00020000L
 #define mmHDP_MEM_POWER_CTRL_BASE_IDX	0
+
+/* for Vega20/arcturus regiter offset change */
+#define	mmROM_INDEX_VG20				0x00e4
+#define	mmROM_INDEX_VG20_BASE_IDX			0
+#define	mmROM_DATA_VG20					0x00e5
+#define	mmROM_DATA_VG20_BASE_IDX			0
+
 /*
  * Indirect registers accessor
  */
@@ -304,6 +311,8 @@ static bool soc15_read_bios_from_rom(struct amdgpu_device *adev,
 {
 	u32 *dw_ptr;
 	u32 i, length_dw;
+	uint32_t rom_index_offset;
+	uint32_t rom_data_offset;
 
 	if (bios == NULL)
 		return false;
@@ -316,11 +325,23 @@ static bool soc15_read_bios_from_rom(struct amdgpu_device *adev,
 	dw_ptr = (u32 *)bios;
 	length_dw = ALIGN(length_bytes, 4) / 4;
 
+	switch (adev->asic_type) {
+	case CHIP_VEGA20:
+	case CHIP_ARCTURUS:
+		rom_index_offset = SOC15_REG_OFFSET(SMUIO, 0, mmROM_INDEX_VG20);
+		rom_data_offset = SOC15_REG_OFFSET(SMUIO, 0, mmROM_DATA_VG20);
+		break;
+	default:
+		rom_index_offset = SOC15_REG_OFFSET(SMUIO, 0, mmROM_INDEX);
+		rom_data_offset = SOC15_REG_OFFSET(SMUIO, 0, mmROM_DATA);
+		break;
+	}
+
 	/* set rom index to 0 */
-	WREG32(SOC15_REG_OFFSET(SMUIO, 0, mmROM_INDEX), 0);
+	WREG32(rom_index_offset, 0);
 	/* read out the rom data */
 	for (i = 0; i < length_dw; i++)
-		dw_ptr[i] = RREG32(SOC15_REG_OFFSET(SMUIO, 0, mmROM_DATA));
+		dw_ptr[i] = RREG32(rom_data_offset);
 
 	return true;
 }
-- 
2.20.1



