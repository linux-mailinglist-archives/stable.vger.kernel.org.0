Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E9240E4E7
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349561AbhIPRGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:06:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348493AbhIPRC7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:02:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03E3561B25;
        Thu, 16 Sep 2021 16:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810041;
        bh=h8kVdUEkVzsjqaVb1iR/iLwVz0RLom4uufhPCsCk83Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ai2KgHutogFvjjsBMuMxRH2jsLcoZD9KLSljE0Q/8nBF+DoKJzbLXE/3NlyE8+PK4
         R0ytOH7DHfFGtrOB7ho1+p822Z9f3Tgkv6OU2xPOaqn4Ji+1Dfi83NlxFxLQVmoN9/
         0GoUecQHGtb7RHgoePB9ZASODyvU6a6sPOJVow40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaron Liu <aaron.liu@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.13 376/380] drm/amd/display: setup system context for APUs
Date:   Thu, 16 Sep 2021 18:02:13 +0200
Message-Id: <20210916155816.840875841@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Liu <aaron.liu@amd.com>

commit 3ca001aff0878546494d7f403334c8d987924977 upstream.

Scatter/gather is APU feature starting from carrizo.
adev->apu_flags is not used for all APUs.
adev->flags & AMD_IS_APU can be used for all APUs.

Signed-off-by: Aaron Liu <aaron.liu@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1176,7 +1176,7 @@ static int amdgpu_dm_init(struct amdgpu_
 	dc_hardware_init(adev->dm.dc);
 
 #if defined(CONFIG_DRM_AMD_DC_DCN)
-	if (adev->apu_flags) {
+	if ((adev->flags & AMD_IS_APU) && (adev->asic_type >= CHIP_CARRIZO)) {
 		struct dc_phy_addr_space_config pa_config;
 
 		mmhub_read_system_context(adev, &pa_config);


