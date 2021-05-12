Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAB837C798
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235019AbhELQA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:00:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237929AbhELP4y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:56:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AE5061433;
        Wed, 12 May 2021 15:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833333;
        bh=NMclS5wjHRBtVyRdUkVEaRAvKEfqBw3aJqBzkZT6iwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=02kABhb01CEXyS+bhqTYmTSD5XOO5YEO8b2HxGJtkYVaMD2o/B8RdWhi6ulMVyNyy
         j0eO9F9UFDmAkYKzco7CVWp4tnwIuXnopdZTM5/zM8mIgJWoXXj2G99sHtD9yW2u1T
         NcrvUJb0xZBr87cOcfmORAlogm3dHMrIGcG4H1Vs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.11 073/601] drm/amdgpu: add new MC firmware for Polaris12 32bit ASIC
Date:   Wed, 12 May 2021 16:42:30 +0200
Message-Id: <20210512144830.230383038@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

commit c83c4e1912446db697a120eb30126cd80cbf6349 upstream.

Polaris12 32bit ASIC needs a special MC firmware.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c
@@ -59,6 +59,7 @@ MODULE_FIRMWARE("amdgpu/tonga_mc.bin");
 MODULE_FIRMWARE("amdgpu/polaris11_mc.bin");
 MODULE_FIRMWARE("amdgpu/polaris10_mc.bin");
 MODULE_FIRMWARE("amdgpu/polaris12_mc.bin");
+MODULE_FIRMWARE("amdgpu/polaris12_32_mc.bin");
 MODULE_FIRMWARE("amdgpu/polaris11_k_mc.bin");
 MODULE_FIRMWARE("amdgpu/polaris10_k_mc.bin");
 MODULE_FIRMWARE("amdgpu/polaris12_k_mc.bin");
@@ -243,10 +244,16 @@ static int gmc_v8_0_init_microcode(struc
 			chip_name = "polaris10";
 		break;
 	case CHIP_POLARIS12:
-		if (ASICID_IS_P23(adev->pdev->device, adev->pdev->revision))
+		if (ASICID_IS_P23(adev->pdev->device, adev->pdev->revision)) {
 			chip_name = "polaris12_k";
-		else
-			chip_name = "polaris12";
+		} else {
+			WREG32(mmMC_SEQ_IO_DEBUG_INDEX, ixMC_IO_DEBUG_UP_159);
+			/* Polaris12 32bit ASIC needs a special MC firmware */
+			if (RREG32(mmMC_SEQ_IO_DEBUG_DATA) == 0x05b4dc40)
+				chip_name = "polaris12_32";
+			else
+				chip_name = "polaris12";
+		}
 		break;
 	case CHIP_FIJI:
 	case CHIP_CARRIZO:


