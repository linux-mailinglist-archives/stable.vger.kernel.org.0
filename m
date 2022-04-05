Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC454F28C4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239910AbiDEIVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233908AbiDEIKp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:10:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD046D841;
        Tue,  5 Apr 2022 01:02:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 777BA61748;
        Tue,  5 Apr 2022 08:02:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8588AC385A1;
        Tue,  5 Apr 2022 08:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145769;
        bh=UJ/54c6wLHr/AtOqJwdfuGclGS7Q/AGrlldy0PLD/tE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aBF59F6y1BnNwGl/LzLFJRPSBHteoqhqDBIMRAkJApCqoyX14gjw6nwFT54XTOFUe
         in4ALI0me+MvbdwOdvcYMzS2QgAgTLYGiXsp11V4LLzhQg8ktG05d6yFPQ5LaI36La
         qHAtXMQurKGP6vFsyA91UOpthO0Pf9EWg+fooaXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <Alexander.Deucher@amd.com>,
        Kent Russell <kent.russell@amd.com>,
        Andrey Grodzovsky <Andrey.Grodzovsky@amd.com>,
        Luben Tuikov <luben.tuikov@amd.com>,
        Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0524/1126] drm/amdgpu: Dont offset by 2 in FRU EEPROM
Date:   Tue,  5 Apr 2022 09:21:11 +0200
Message-Id: <20220405070423.010334536@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luben Tuikov <luben.tuikov@amd.com>

[ Upstream commit 3f3a24a0a3a58677d2b4f3c442d7a1be05afb123 ]

Read buffers no longer expose the I2C address, and so we don't need to
offset by two when we get the read data.

Cc: Alex Deucher <Alexander.Deucher@amd.com>
Cc: Kent Russell <kent.russell@amd.com>
Cc: Andrey Grodzovsky <Andrey.Grodzovsky@amd.com>
Fixes: bd607166af7fe3 ("drm/amdgpu: Enable reading FRU chip via I2C v3")
Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Acked-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c
index 2a786e788627..978c46395ced 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c
@@ -91,17 +91,13 @@ static int amdgpu_fru_read_eeprom(struct amdgpu_device *adev, uint32_t addrptr,
 
 int amdgpu_fru_get_product_info(struct amdgpu_device *adev)
 {
-	unsigned char buff[AMDGPU_PRODUCT_NAME_LEN+2];
+	unsigned char buff[AMDGPU_PRODUCT_NAME_LEN];
 	u32 addrptr;
 	int size, len;
-	int offset = 2;
 
 	if (!is_fru_eeprom_supported(adev))
 		return 0;
 
-	if (adev->asic_type == CHIP_ALDEBARAN)
-		offset = 0;
-
 	/* If algo exists, it means that the i2c_adapter's initialized */
 	if (!adev->pm.smu_i2c.algo) {
 		DRM_WARN("Cannot access FRU, EEPROM accessor not initialized");
@@ -143,8 +139,7 @@ int amdgpu_fru_get_product_info(struct amdgpu_device *adev)
 				AMDGPU_PRODUCT_NAME_LEN);
 		len = AMDGPU_PRODUCT_NAME_LEN - 1;
 	}
-	/* Start at 2 due to buff using fields 0 and 1 for the address */
-	memcpy(adev->product_name, &buff[offset], len);
+	memcpy(adev->product_name, buff, len);
 	adev->product_name[len] = '\0';
 
 	addrptr += size + 1;
@@ -162,7 +157,7 @@ int amdgpu_fru_get_product_info(struct amdgpu_device *adev)
 		DRM_WARN("FRU Product Number is larger than 16 characters. This is likely a mistake");
 		len = sizeof(adev->product_number) - 1;
 	}
-	memcpy(adev->product_number, &buff[offset], len);
+	memcpy(adev->product_number, buff, len);
 	adev->product_number[len] = '\0';
 
 	addrptr += size + 1;
@@ -189,7 +184,7 @@ int amdgpu_fru_get_product_info(struct amdgpu_device *adev)
 		DRM_WARN("FRU Serial Number is larger than 16 characters. This is likely a mistake");
 		len = sizeof(adev->serial) - 1;
 	}
-	memcpy(adev->serial, &buff[offset], len);
+	memcpy(adev->serial, buff, len);
 	adev->serial[len] = '\0';
 
 	return 0;
-- 
2.34.1



