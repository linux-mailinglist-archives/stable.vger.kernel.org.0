Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A16B1197B0
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730089AbfLJVeq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:34:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:40136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728071AbfLJVeq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:34:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A34A2467A;
        Tue, 10 Dec 2019 21:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013685;
        bh=3aXqtGp4o4Le56Dewifenxf3B2S3PUiUAh1FVSDurHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OqYO9qYVFzHhYPHa71qLTVvxoDSbMXp7XCG7SaoG1HxaPGlAK8szYtzyKa0avCqc9
         ynQcUz7ZJJxUvVd8lSDIZLfJnZo2dibHK0FqTcGKHOxDOJIH+C5SymbC79qnnBGVpL
         ldFronwIsbUAmH61ewkqXZZZYllxfCh42PkYK7t0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hawking Zhang <Hawking.Zhang@amd.com>,
        Candice Li <Candice.Li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 118/177] drm/amdgpu: disallow direct upload save restore list from gfx driver
Date:   Tue, 10 Dec 2019 16:31:22 -0500
Message-Id: <20191210213221.11921-118-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hawking Zhang <Hawking.Zhang@amd.com>

[ Upstream commit 58f46d4b65021083ef4b4d49c6e2c58e5783f626 ]

Direct uploading save/restore list via mmio register writes breaks the security
policy. Instead, the driver should pass s&r list to psp.

For all the ASICs that use rlc v2_1 headers, the driver actually upload s&r list
twice, in non-psp ucode front door loading phase and gfx pg initialization phase.
The latter is not allowed.

VG12 is the only exception where the driver still keeps legacy approach for S&R
list uploading. In theory, this can be elimnated if we have valid srcntl ucode
for VG12.

Signed-off-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Candice Li <Candice.Li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index 7824116498169..28794b1b15c10 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -2187,7 +2187,8 @@ static void gfx_v9_0_init_pg(struct amdgpu_device *adev)
 	 * And it's needed by gfxoff feature.
 	 */
 	if (adev->gfx.rlc.is_rlc_v2_1) {
-		gfx_v9_1_init_rlc_save_restore_list(adev);
+		if (adev->asic_type == CHIP_VEGA12)
+			gfx_v9_1_init_rlc_save_restore_list(adev);
 		gfx_v9_0_enable_save_restore_machine(adev);
 	}
 
-- 
2.20.1

