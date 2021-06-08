Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061A13A0372
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237573AbhFHTRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:17:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238421AbhFHTO4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:14:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B56DD6145E;
        Tue,  8 Jun 2021 18:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178229;
        bh=zrhf8ozr/DI3kvZDoVXzNxgzRAZ+YdpBuivAu2wEZf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GsIW8BSelW3g/3koznDLF5KRGC9aFtoJfPL6lKEVIF5Rw+pXY2nPy1LMHZmGQw1lv
         2XyCYzLXxJTKkdDCNihk+EWV1JUxxdSpr9gq1ohbdGxevjsd4RIIWiwuu5hHnCAg3L
         D6uvi23zCN2fhn8DnSSHNmyzuwjAR7pYDkg6yiyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Zhu <James.Zhu@amd.com>,
        Leo Liu <leo.liu@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 090/161] drm/amdgpu/jpeg2.5: add cancel_delayed_work_sync before power gate
Date:   Tue,  8 Jun 2021 20:27:00 +0200
Message-Id: <20210608175948.476292412@linuxfoundation.org>
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

[ Upstream commit 23f10a571da5eaa63b7845d16e2f49837e841ab9 ]

Add cancel_delayed_work_sync before set power gating state
to avoid race condition issue when power gating.

Signed-off-by: James Zhu <James.Zhu@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
index dc947c8ffe21..e6c4a36eaf9a 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
@@ -187,14 +187,14 @@ static int jpeg_v2_5_hw_init(void *handle)
 static int jpeg_v2_5_hw_fini(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
-	struct amdgpu_ring *ring;
 	int i;
 
+	cancel_delayed_work_sync(&adev->vcn.idle_work);
+
 	for (i = 0; i < adev->jpeg.num_jpeg_inst; ++i) {
 		if (adev->jpeg.harvest_config & (1 << i))
 			continue;
 
-		ring = &adev->jpeg.inst[i].ring_dec;
 		if (adev->jpeg.cur_state != AMD_PG_STATE_GATE &&
 		      RREG32_SOC15(JPEG, i, mmUVD_JRBC_STATUS))
 			jpeg_v2_5_set_powergating_state(adev, AMD_PG_STATE_GATE);
-- 
2.30.2



