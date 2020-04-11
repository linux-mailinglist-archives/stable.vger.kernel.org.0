Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62C941A58D8
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbgDKXJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:09:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729386AbgDKXJ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:09:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E64D620757;
        Sat, 11 Apr 2020 23:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646598;
        bh=o6LxklEs3CFqmUorRxPG7hw5z/Wv2HackpuNmTleWZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LJciSYHYlPysVbPW/iExEvsdIj54jKAQqFXat0D4/V71TrjcJ8lTMyjGYFv+LgQ0m
         I1RPXqISWJrjMS98uV5vmMGNYhNHpqcnB0n+8uz1bIscCb1HD/dKlus0Uv+/pllYTS
         MNl38oqpgMbo/98ysfa1sGyu3pwFgXko7poV951o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Hersen Wu <hersenxs.wu@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 012/108] drm/amd/display: Explicitly disable triplebuffer flips
Date:   Sat, 11 Apr 2020 19:08:07 -0400
Message-Id: <20200411230943.24951-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 2d673560b7b83f8fe4163610f35c51b4d095525c ]

[Why]
This is enabled by default on Renoir but there's userspace/API support
to actually make use of this.

Since we're not passing this down through surface updates, let's
explicitly disable this for now.

This fixes "dcn20_program_front_end_for_ctx" warnings associated with
incorrect/unexpected programming sequences performed while this is
enabled.

[How]
Disable it at the topmost level in DM in case anyone tries to flip this
to enabled for any of the other ASICs like Navi10/14.

Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Hersen Wu <hersenxs.wu@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 360c87ba45956..1b54744b1ba07 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2391,6 +2391,9 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
 	if (adev->asic_type != CHIP_CARRIZO && adev->asic_type != CHIP_STONEY)
 		dm->dc->debug.disable_stutter = amdgpu_pp_feature_mask & PP_STUTTER_MODE ? false : true;
 
+	/* No userspace support. */
+	dm->dc->debug.disable_tri_buf = true;
+
 	return 0;
 fail:
 	kfree(aencoder);
-- 
2.20.1

