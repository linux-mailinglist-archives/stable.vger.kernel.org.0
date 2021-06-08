Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB46A3A0374
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237396AbhFHTRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:17:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238603AbhFHTPX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:15:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72EC861464;
        Tue,  8 Jun 2021 18:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178231;
        bh=exdhTaneULnsGNI+Wd7hkZj6EXBXExdOBga7eQRSL98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mxkPI1vn/QtBcyoiD44E0UPRnqsEWw25/5sDkI/j0kc296tGbY9fSxxiAq3DZOEPJ
         lVZoM8cL9WD8kj+bv/PhJttwRkc4ANLLf0buvZFzdiBukjoQorihJul8WxFLkmdUiB
         6YZ0JCt5ww7xiVecSuDjqi75iahrfr4ObogyVY3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Zhu <James.Zhu@amd.com>,
        Leo Liu <leo.liu@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 091/161] drm/amdgpu/jpeg3: add cancel_delayed_work_sync before power gate
Date:   Tue,  8 Jun 2021 20:27:01 +0200
Message-Id: <20210608175948.508144109@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Zhu <James.Zhu@amd.com>

[ Upstream commit 20ebbfd22f8115a1e4f60d3d289f66be4d47f1ec ]

Add cancel_delayed_work_sync before set power gating state
to avoid race condition issue when power gating.

Signed-off-by: James Zhu <James.Zhu@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
index 1d354245678d..2ea68c84e6b4 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
@@ -159,9 +159,9 @@ static int jpeg_v3_0_hw_init(void *handle)
 static int jpeg_v3_0_hw_fini(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
-	struct amdgpu_ring *ring;
 
-	ring = &adev->jpeg.inst->ring_dec;
+	cancel_delayed_work_sync(&adev->vcn.idle_work);
+
 	if (adev->jpeg.cur_state != AMD_PG_STATE_GATE &&
 	      RREG32_SOC15(JPEG, 0, mmUVD_JRBC_STATUS))
 		jpeg_v3_0_set_powergating_state(adev, AMD_PG_STATE_GATE);
-- 
2.30.2



