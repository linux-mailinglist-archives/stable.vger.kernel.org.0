Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563183CAAB7
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243752AbhGOTPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:15:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242071AbhGOTMz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:12:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DDFE61158;
        Thu, 15 Jul 2021 19:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376169;
        bh=HhaYMKe+gYvr5fouIoEMZDfS7Qqzvf/gvr/BR7jO6tM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DhgGl/bZE0C/7Tgh5Mxo1WhmWlRSgKHPIcAVcijrCa7ASW22j6Jyu0RqLJa049gaj
         gUWPOMYhaobYDQyeMuZ+wLR8T50y6XUUdxh5GZnNfMeTT/hq8mse80UjRP3pqAZh2q
         9U8zFOMuO27cfz4PyluivheoXcvjtb3vypxPMQ1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Stanley.Yang" <Stanley.Yang@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 119/266] drm/amdgpu: fix bad address translation for sienna_cichlid
Date:   Thu, 15 Jul 2021 20:37:54 +0200
Message-Id: <20210715182634.909727446@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanley.Yang <Stanley.Yang@amd.com>

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



