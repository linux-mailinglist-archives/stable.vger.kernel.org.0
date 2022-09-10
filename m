Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C00D5B4951
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiIJVSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiIJVR7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:17:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94574DB10;
        Sat, 10 Sep 2022 14:17:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 522DC60AC9;
        Sat, 10 Sep 2022 21:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465B1C433D6;
        Sat, 10 Sep 2022 21:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844634;
        bh=vz5fOPB/0yc8mAdng/GhOFDcONd3/2mlwH7O9Qh8JFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZvKGYswPHe9xiZ/tsC6LIc+3HFqmVyW1IG8Gy6ni946eFQcze3pPloA8F8JfwEO3z
         p4l+iHXT/HqmXEeJm3pIXw8wfb9nbHxaSwDbUWjelLH4GwBLUNObFegFDtg8T/+b0t
         7lesb1OyZEY1dlFwq5afgesC79GFAemFsH8m9MBLd/kUvC4bEa1qVYmRCh+f/cNvtX
         rEjjfLanR4X1OQNXCuPghKMJIRrb3kO0uAZ9Qatytq0hCuGKo5XNAfDGqFYE2OVmm8
         +6QrGaGPKqTPe9U21lvET65bv3VR3XGj1P2LzlpLndXtV3k+ckVPpZQiEj8UDbiOdG
         R7wZdeys+Q+vw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guchun Chen <guchun.chen@amd.com>,
        Kent Russell <kent.russell@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        luben.tuikov@amd.com, Harish.Kasiviswanathan@amd.com,
        shaoyun.liu@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 24/38] drm/amdgpu: disable FRU access on special SIENNA CICHLID card
Date:   Sat, 10 Sep 2022 17:16:09 -0400
Message-Id: <20220910211623.69825-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211623.69825-1-sashal@kernel.org>
References: <20220910211623.69825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Guchun Chen <guchun.chen@amd.com>

[ Upstream commit c8fea9273fd1be308668496badfcbd55183e0dd3 ]

Below driver load error will be printed, not friendly to end user.

amdgpu: ATOM BIOS: 113-D603GLXE-077
[drm] FRU: Failed to get size field
[drm:amdgpu_fru_get_product_info [amdgpu]] *ERROR* Failed to read FRU Manufacturer, ret:-5

Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c
index ecada5eadfe35..e325150879df7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c
@@ -66,10 +66,15 @@ static bool is_fru_eeprom_supported(struct amdgpu_device *adev)
 		return true;
 	case CHIP_SIENNA_CICHLID:
 		if (strnstr(atom_ctx->vbios_version, "D603",
+		    sizeof(atom_ctx->vbios_version))) {
+			if (strnstr(atom_ctx->vbios_version, "D603GLXE",
 			    sizeof(atom_ctx->vbios_version)))
-			return true;
-		else
+				return false;
+			else
+				return true;
+		} else {
 			return false;
+		}
 	default:
 		return false;
 	}
-- 
2.35.1

