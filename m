Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 160A9126B74
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730837AbfLSS4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:56:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:53218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730836AbfLSS4e (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:56:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE99124680;
        Thu, 19 Dec 2019 18:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781793;
        bh=7sY046JbMAysiL9yT1LYPKdCt5/b+zKjlxbI9OJCcas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F/RPvFqsgaq5OjPGUKtyO5A+osJ2lvnPeP7xSuQHkTvQZpHRpwKTZCtsaVXleouWh
         FAA/gm4xyzNOtQFab+xtHPxcSDPjxTTWApEMZWjJ+SL2Rgl9t4yFamLdvLfhJ2wGPn
         oVL94EpZs/s0NdlL5WP/rz24IXvWMvbszx81q/3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaojie Yuan <xiaojie.yuan@amd.com>,
        Jack Xiao <Jack.Xiao@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 76/80] drm/amdgpu/gfx10: explicitly wait for cp idle after halt/unhalt
Date:   Thu, 19 Dec 2019 19:35:08 +0100
Message-Id: <20191219183146.311627973@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaojie Yuan <xiaojie.yuan@amd.com>

commit 1e902a6d32d73e4a6b3bc9d7cd43d4ee2b242dea upstream.

50us is not enough to wait for cp ready after gpu reset on some navi asics.

Signed-off-by: Xiaojie Yuan <xiaojie.yuan@amd.com>
Suggested-by: Jack Xiao <Jack.Xiao@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -2400,7 +2400,7 @@ static int gfx_v10_0_wait_for_rlc_autolo
 	return 0;
 }
 
-static void gfx_v10_0_cp_gfx_enable(struct amdgpu_device *adev, bool enable)
+static int gfx_v10_0_cp_gfx_enable(struct amdgpu_device *adev, bool enable)
 {
 	int i;
 	u32 tmp = RREG32_SOC15(GC, 0, mmCP_ME_CNTL);
@@ -2413,7 +2413,17 @@ static void gfx_v10_0_cp_gfx_enable(stru
 			adev->gfx.gfx_ring[i].sched.ready = false;
 	}
 	WREG32_SOC15(GC, 0, mmCP_ME_CNTL, tmp);
-	udelay(50);
+
+	for (i = 0; i < adev->usec_timeout; i++) {
+		if (RREG32_SOC15(GC, 0, mmCP_STAT) == 0)
+			break;
+		udelay(1);
+	}
+
+	if (i >= adev->usec_timeout)
+		DRM_ERROR("failed to %s cp gfx\n", enable ? "unhalt" : "halt");
+
+	return 0;
 }
 
 static int gfx_v10_0_cp_gfx_load_pfp_microcode(struct amdgpu_device *adev)


