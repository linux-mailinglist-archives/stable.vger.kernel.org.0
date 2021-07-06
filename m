Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C913BCE91
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232947AbhGFL0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:26:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232549AbhGFLTy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:19:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3ADE661C54;
        Tue,  6 Jul 2021 11:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570221;
        bh=EPOCnEXw8/VmsiNiam4/FX7tIxHAadbJoZ0kZXZvbMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i/PathUgbcCHYu0G8qDiOVX4KDtvoTI0UtNUgZVzI5GNChRA4j2A7edQDnyzNcd9N
         Ix5IrCo3/bf+FErARCeErlbibRl+IK9JMX5ODl72Fq7KOcrzxhIUE1qsMaT34ZCbt0
         3JqbmIjtujCsIUslqirycPQY6KX+zo1/Nvx8Q7QV1O60cS9DRT5f3ilO7uOD6GWhaH
         A0qlcqUvuMBlt63OaX266863cYsue5jxXDTyKHhPRzkoL6aN4eUNzKXJtpb91ssdYe
         ErJ9OOePb+te9/rg6f2ATIzYHXjTOZ1CUuoT5CfBUPz3s8nOdXIP/hRRYgXDkDewPF
         cXmrD9S7UAGzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Stanley.Yang" <Stanley.Yang@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 128/189] drm/amdgpu: fix bad address translation for sienna_cichlid
Date:   Tue,  6 Jul 2021 07:13:08 -0400
Message-Id: <20210706111409.2058071-128-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Stanley.Yang" <Stanley.Yang@amd.com>

[ Upstream commit 6ec598cc9dfbf40433e94a2ed1a622e3ef80268b ]

Signed-off-by: Stanley.Yang <Stanley.Yang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_umc.h | 5 +++++
 drivers/gpu/drm/amd/amdgpu/umc_v8_7.c   | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_umc.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_umc.h
index bbcccf53080d..e5a75fb788dd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_umc.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_umc.h
@@ -21,6 +21,11 @@
 #ifndef __AMDGPU_UMC_H__
 #define __AMDGPU_UMC_H__
 
+/*
+ * (addr / 256) * 4096, the higher 26 bits in ErrorAddr
+ * is the index of 4KB block
+ */
+#define ADDR_OF_4KB_BLOCK(addr)			(((addr) & ~0xffULL) << 4)
 /*
  * (addr / 256) * 8192, the higher 26 bits in ErrorAddr
  * is the index of 8KB block
diff --git a/drivers/gpu/drm/amd/amdgpu/umc_v8_7.c b/drivers/gpu/drm/amd/amdgpu/umc_v8_7.c
index 89d20adfa001..af59a35788e3 100644
--- a/drivers/gpu/drm/amd/amdgpu/umc_v8_7.c
+++ b/drivers/gpu/drm/amd/amdgpu/umc_v8_7.c
@@ -234,7 +234,7 @@ static void umc_v8_7_query_error_address(struct amdgpu_device *adev,
 		err_addr &= ~((0x1ULL << lsb) - 1);
 
 		/* translate umc channel address to soc pa, 3 parts are included */
-		retired_page = ADDR_OF_8KB_BLOCK(err_addr) |
+		retired_page = ADDR_OF_4KB_BLOCK(err_addr) |
 				ADDR_OF_256B_BLOCK(channel_index) |
 				OFFSET_IN_256B_BLOCK(err_addr);
 
-- 
2.30.2

