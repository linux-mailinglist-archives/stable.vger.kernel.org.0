Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0CF3CA8A0
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243296AbhGOTBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:01:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241942AbhGOTBN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:01:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C296613E0;
        Thu, 15 Jul 2021 18:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375475;
        bh=n86+w8O6N0pvk5qMBoCzjmKUr1xZRZkBBwAiYoSVUe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UwXTEOINRT2a/1athoKbT++g4DkWitiuC/g5/wWwjWd3kQgIF0lGiQdW6S7+k7Kx7
         6hRRvenewFynDe0G1ECjMoP5xo3NEaRGFx7lbuLXpH+jv6760G9I+C2bGl83Khw4XR
         DYUAUJE1Dy9DpzY8CTr2lNNRcuE/ECjGvZp2Ycas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Stanley.Yang" <Stanley.Yang@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 102/242] drm/amdgpu: fix bad address translation for sienna_cichlid
Date:   Thu, 15 Jul 2021 20:37:44 +0200
Message-Id: <20210715182610.970298269@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
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
index 183814493658..bda4438c3925 100644
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
index a064c097690c..66fd797a6f0e 100644
--- a/drivers/gpu/drm/amd/amdgpu/umc_v8_7.c
+++ b/drivers/gpu/drm/amd/amdgpu/umc_v8_7.c
@@ -233,7 +233,7 @@ static void umc_v8_7_query_error_address(struct amdgpu_device *adev,
 		err_addr &= ~((0x1ULL << lsb) - 1);
 
 		/* translate umc channel address to soc pa, 3 parts are included */
-		retired_page = ADDR_OF_8KB_BLOCK(err_addr) |
+		retired_page = ADDR_OF_4KB_BLOCK(err_addr) |
 				ADDR_OF_256B_BLOCK(channel_index) |
 				OFFSET_IN_256B_BLOCK(err_addr);
 
-- 
2.30.2



