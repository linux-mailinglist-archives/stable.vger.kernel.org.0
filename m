Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4D565EA25B
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237311AbiIZLGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237318AbiIZLFf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:05:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF7415FC7;
        Mon, 26 Sep 2022 03:33:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CFC160A36;
        Mon, 26 Sep 2022 10:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E93EC433D6;
        Mon, 26 Sep 2022 10:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188415;
        bh=oQPuOasZYVInoLrB9tEt2GLwL4GVW1WaHUuHC5vH7Bw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JI7J9XdznA8m9RQnlDZWmhW42Y4HAfzybCS5bijc28fH/PGyVCOThUNbmcz0E5zY+
         7Kckf5r5Mrs4jwzzuxLz5sWIok00EChKCI2XOxknW6gRNcdsixh6fI2d8PxYqyTYhp
         Q6SK2ngAAVTUPbKv6q+qR+V5nM/EFY4v0dzeN/gU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanley Yang <Stanley.Yang@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Luben Tuikov <luben.tuikov@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 123/141] drm/amdgpu: Fix check for RAS support
Date:   Mon, 26 Sep 2022 12:12:29 +0200
Message-Id: <20220926100758.905442053@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luben Tuikov <luben.tuikov@amd.com>

[ Upstream commit 084e2640e51626f413f85663e3ba7e32d4272477 ]

Use positive logic to check for RAS
support. Rename the function to actually indicate
what it is testing for. Essentially, make the
function a predicate with the correct name.

Cc: Stanley Yang <Stanley.Yang@amd.com>
Cc: Alexander Deucher <Alexander.Deucher@amd.com>
Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 6c2049066355 ("drm/amdgpu: Don't enable LTR if not supported")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index eb22a190c242..3638f0e12a2b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -1979,15 +1979,12 @@ int amdgpu_ras_request_reset_on_boot(struct amdgpu_device *adev,
 	return 0;
 }
 
-static int amdgpu_ras_check_asic_type(struct amdgpu_device *adev)
+static bool amdgpu_ras_asic_supported(struct amdgpu_device *adev)
 {
-	if (adev->asic_type != CHIP_VEGA10 &&
-		adev->asic_type != CHIP_VEGA20 &&
-		adev->asic_type != CHIP_ARCTURUS &&
-		adev->asic_type != CHIP_SIENNA_CICHLID)
-		return 1;
-	else
-		return 0;
+	return adev->asic_type == CHIP_VEGA10 ||
+		adev->asic_type == CHIP_VEGA20 ||
+		adev->asic_type == CHIP_ARCTURUS ||
+		adev->asic_type == CHIP_SIENNA_CICHLID;
 }
 
 /*
@@ -2006,7 +2003,7 @@ static void amdgpu_ras_check_supported(struct amdgpu_device *adev,
 	*supported = 0;
 
 	if (amdgpu_sriov_vf(adev) || !adev->is_atom_fw ||
-		amdgpu_ras_check_asic_type(adev))
+	    !amdgpu_ras_asic_supported(adev))
 		return;
 
 	if (amdgpu_atomfirmware_mem_ecc_supported(adev)) {
-- 
2.35.1



