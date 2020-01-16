Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFFA913FF4E
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388928AbgAPXlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:41:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:58288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389199AbgAPX1C (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:27:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B1502072E;
        Thu, 16 Jan 2020 23:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217221;
        bh=NFxnKCjBfr6dkSPF25OUS484+i8f0PDBqaTCmWfvZms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TGUezLwA9UFAgDN7mC9h4sAaeHaVTqRiUwVM5+CMN97NimQkpVI1d7ib89pVddh2x
         9DcH/XXyMyoePrK1AzZi7Nk2bIr9rvUyyX13nB2mO9xPqAe0GpRVdGxKd/BEgAcHoA
         AhAzVsLeWAPAGY0XrN5cLHRrayfor3OB6d6uAvGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, changzhu <Changfeng.Zhu@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 198/203] drm/amdgpu: enable gfxoff for raven1 refresh
Date:   Fri, 17 Jan 2020 00:18:35 +0100
Message-Id: <20200116231801.435065278@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: changzhu <Changfeng.Zhu@amd.com>

[ Upstream commit e0c63812352298efbce2a71483c1dab627d0c288 ]

When smu version is larger than 0x41e2b, it will load
raven_kicker_rlc.bin.To enable gfxoff for raven_kicker_rlc.bin,it
needs to avoid adev->pm.pp_feature &= ~PP_GFXOFF_MASK when it loads
raven_kicker_rlc.bin.

Signed-off-by: changzhu <Changfeng.Zhu@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index c9ba2ec6d038..ab4a0d8545dc 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1038,17 +1038,10 @@ static void gfx_v9_0_check_if_need_gfxoff(struct amdgpu_device *adev)
 	case CHIP_VEGA20:
 		break;
 	case CHIP_RAVEN:
-		/* Disable GFXOFF on original raven.  There are combinations
-		 * of sbios and platforms that are not stable.
-		 */
-		if (!(adev->rev_id >= 0x8 || adev->pdev->device == 0x15d8))
-			adev->pm.pp_feature &= ~PP_GFXOFF_MASK;
-		else if (!(adev->rev_id >= 0x8 || adev->pdev->device == 0x15d8)
-			 &&((adev->gfx.rlc_fw_version != 106 &&
-			     adev->gfx.rlc_fw_version < 531) ||
-			    (adev->gfx.rlc_fw_version == 53815) ||
-			    (adev->gfx.rlc_feature_version < 1) ||
-			    !adev->gfx.rlc.is_rlc_v2_1))
+		if (!(adev->rev_id >= 0x8 ||
+		      adev->pdev->device == 0x15d8) &&
+		    (adev->pm.fw_version < 0x41e2b || /* not raven1 fresh */
+		     !adev->gfx.rlc.is_rlc_v2_1)) /* without rlc save restore ucodes */
 			adev->pm.pp_feature &= ~PP_GFXOFF_MASK;
 
 		if (adev->pm.pp_feature & PP_GFXOFF_MASK)
-- 
2.20.1



