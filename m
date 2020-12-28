Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C5F2E3DEF
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441461AbgL1OV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:21:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:57490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441433AbgL1OV6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:21:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7392E221F0;
        Mon, 28 Dec 2020 14:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165278;
        bh=dZn5O+DNoIlyQ7eVyRid+SmugfrjUNdAQX8cUqeS0gM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZvaIcYdKAfDZg5kwpSO0EX+aT21lZrRct5UA0ByQeYb23plsJ7/tfSUhOxtjHbxAf
         c5oF9sYsf1J+1Rfnsc8WbTwsp7m96eqrEfiCoPnCL65wnlQQhWWSGb4S57X7nrJW1Q
         +nn9xovkf6/JdsyrIHqDBzrpS1pYy7GUeX4kyPh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guchun Chen <guchun.chen@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 445/717] drm/amdgpu: fix regression in vbios reservation handling on headless
Date:   Mon, 28 Dec 2020 13:47:23 +0100
Message-Id: <20201228125042.291855184@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 7eded018bfeccb365963bb51be731a9f99aeea59 ]

We need to move the check under the non-headless case, otherwise
we always reserve the VGA save size.

Fixes: 157fe68d74c2ad ("drm/amdgpu: fix size calculation with stolen vga memory")
Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
index 3e4892b7b7d3c..ff4e226739308 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -494,13 +494,14 @@ void amdgpu_gmc_get_vbios_allocations(struct amdgpu_device *adev)
 		break;
 	}
 
-	if (!amdgpu_device_ip_get_ip_block(adev, AMD_IP_BLOCK_TYPE_DCE))
+	if (!amdgpu_device_ip_get_ip_block(adev, AMD_IP_BLOCK_TYPE_DCE)) {
 		size = 0;
-	else
+	} else {
 		size = amdgpu_gmc_get_vbios_fb_size(adev);
 
-	if (adev->mman.keep_stolen_vga_memory)
-		size = max(size, (unsigned)AMDGPU_VBIOS_VGA_ALLOCATION);
+		if (adev->mman.keep_stolen_vga_memory)
+			size = max(size, (unsigned)AMDGPU_VBIOS_VGA_ALLOCATION);
+	}
 
 	/* set to 0 if the pre-OS buffer uses up most of vram */
 	if ((adev->gmc.real_vram_size - size) < (8 * 1024 * 1024))
-- 
2.27.0



