Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64BE91195AF
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfLJVWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:22:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:34322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728765AbfLJVLb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:11:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 324D4246B9;
        Tue, 10 Dec 2019 21:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012291;
        bh=fJPimYsHSwNdeO7CSF+BPyv1bPotHHVu2QO+EXVK0J8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YT2IbqeaQBfTQU9BEmz4tWEqzJi1IFiROQVto2UjYa7XU8WmpAkECLVAIHweyjTWP
         JFFTl1hLeZ5RBV2MsPdoL9x37M0usaN0fjOxhkfylU3qfGo4gLI+cfC1jSoXy6AAdo
         FdYS/pA5f7zwvRDJjES/QD7ZYgODeZCOv+yNCUBs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hawking Zhang <Hawking.Zhang@amd.com>,
        Candice Li <Candice.Li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 230/350] drm/amdgpu: disallow direct upload save restore list from gfx driver
Date:   Tue, 10 Dec 2019 16:05:35 -0500
Message-Id: <20191210210735.9077-191-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
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
index 97cf0b5368737..c9ba2ec6d0382 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -2930,7 +2930,8 @@ static void gfx_v9_0_init_pg(struct amdgpu_device *adev)
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

