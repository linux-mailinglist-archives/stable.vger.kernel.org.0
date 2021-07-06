Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6FB93BCEC8
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234274AbhGFL1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:27:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234524AbhGFLYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:24:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF3B661D00;
        Tue,  6 Jul 2021 11:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570315;
        bh=43o12DKparZTph3QHIxzT2RGZNQMhr45ctVvpCSwr1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B5J/KunLp3ThfmRRvyXiprGXXfOCmo2ooA0m8xwnacA3ctGfYSrWbqBo/CfsWrbvW
         3yv47z/TuJpmA0CpopC0M/lTNmmI3k6NaDp7cp48PVFGu3THwjAmP+BMpFub7pd1jC
         ZldrBRLZ+jtQkl3Ywn6ryuRNgV0Lo+cQoZ82PexB3x8gl439au/jWwtXAMeXJLPsIq
         malMN275pl5mJES4qLMWbn9U0VHlI8PMIaM7/lYMeUgWYQLbm5P2LZAR4rYnOIl2We
         9asyusO7gkrykMzIczgJwiDKC4MC3h1qaUPRgM5pJKPlYnvdqHCYy3AGZR0m7iMVn+
         dbbBS4pmjjK5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jack Zhang <Jack.Zhang1@amd.com>, Emily Deng <Emily.Deng@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 006/160] drm/amd/amdgpu/sriov disable all ip hw status by default
Date:   Tue,  6 Jul 2021 07:15:52 -0400
Message-Id: <20210706111827.2060499-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Zhang <Jack.Zhang1@amd.com>

[ Upstream commit 95ea3dbc4e9548d35ab6fbf67675cef8c293e2f5 ]

Disable all ip's hw status to false before any hw_init.
Only set it to true until its hw_init is executed.

The old 5.9 branch has this change but somehow the 5.11 kernrel does
not have this fix.

Without this change, sriov tdr have gfx IB test fail.

Signed-off-by: Jack Zhang <Jack.Zhang1@amd.com>
Review-by: Emily Deng <Emily.Deng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 85d90e857693..a32b41e4c24e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2818,7 +2818,7 @@ static int amdgpu_device_ip_reinit_early_sriov(struct amdgpu_device *adev)
 		AMD_IP_BLOCK_TYPE_IH,
 	};
 
-	for (i = 0; i < ARRAY_SIZE(ip_order); i++) {
+	for (i = 0; i < adev->num_ip_blocks; i++) {
 		int j;
 		struct amdgpu_ip_block *block;
 
-- 
2.30.2

