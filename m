Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA99437CB23
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242408AbhELQeq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:34:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241467AbhELQ1W (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C0C061DDB;
        Wed, 12 May 2021 15:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834781;
        bh=NMclS5wjHRBtVyRdUkVEaRAvKEfqBw3aJqBzkZT6iwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CCo2wba7qNOEO51CWCXbxOFEnaEySSEznCk1XKevmTwkqSgThc4X0Bfb0+VNeN57L
         gL/CSojPf4VpoInSA8Bam+p29hqrxJBhScGIhXlfK0gmZKALsBP0BguQZ2a6EgWIbG
         y1dMkMmVagtJh7S9BaPrr8MzLTVuDdkWdePehqFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.12 082/677] drm/amdgpu: add new MC firmware for Polaris12 32bit ASIC
Date:   Wed, 12 May 2021 16:42:08 +0200
Message-Id: <20210512144839.951342335@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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


