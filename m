Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4572191C5
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfEISvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:51:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728195AbfEISvc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:51:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35941217D7;
        Thu,  9 May 2019 18:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427891;
        bh=TNMM64LqHJWwfNpECzm2lrav3fqNephfWJN/XMD7woA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bddhUUUYvjOIwrACpgvsuFsqrTDFso+NmnIFGkhRkGRuluFCCUm2SMTMMIM3iMdU8
         ef6BdDQvNfDzusGw3JXjuaUucvS8/k9F1I9FRliTu6A5UuBADpGsxoHjQaZLkixzZy
         O7OsFvwF0pvivLR6BtMUYbrs1+UnvNvGwUMnAvDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, shaoyunl <shaoyun.liu@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 43/95] drm/amdgpu: Adjust IB test timeout for XGMI configuration
Date:   Thu,  9 May 2019 20:42:00 +0200
Message-Id: <20190509181312.428756851@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d4162c61e253177936fcfe6c29f7b224d9a1efb8 ]

On XGMI configuration the ib test may take longer to finish

Signed-off-by: shaoyunl <shaoyun.liu@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
index c48207b377bc5..b82c5fca217b3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
@@ -35,6 +35,7 @@
 #include "amdgpu_trace.h"
 
 #define AMDGPU_IB_TEST_TIMEOUT	msecs_to_jiffies(1000)
+#define AMDGPU_IB_TEST_GFX_XGMI_TIMEOUT	msecs_to_jiffies(2000)
 
 /*
  * IB
@@ -344,6 +345,8 @@ int amdgpu_ib_ring_tests(struct amdgpu_device *adev)
 		 * cost waiting for it coming back under RUNTIME only
 		*/
 		tmo_gfx = 8 * AMDGPU_IB_TEST_TIMEOUT;
+	} else if (adev->gmc.xgmi.hive_id) {
+		tmo_gfx = AMDGPU_IB_TEST_GFX_XGMI_TIMEOUT;
 	}
 
 	for (i = 0; i < adev->num_rings; ++i) {
-- 
2.20.1



