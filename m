Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C6949159A
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244839AbiARC3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:29:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40436 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239994AbiARC1C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:27:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CBCBB81232;
        Tue, 18 Jan 2022 02:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7423AC36AE3;
        Tue, 18 Jan 2022 02:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472819;
        bh=I1V/IFg+vIvu92mF4fyATCy5Y+5SKhi/PFtWjx0XmD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iSFN+b1lLjiwOHxCBjHLqLNui1ULIlNsizdPhN1fEmX9zl2Y1Vy7QyJs2VZAyjOfC
         6D259GlBhQmvBGDJoqq5luWK4l8JDTzhjOr61jSD+OldXvmHCLjsKAiaKVyjepFyDw
         h0V1tzFX0LPPfuq0orfNzVD5KRSnm2RvLpDFHk/w45RaumYVvHzqxC3Izbv4UnzfrC
         onUen+AE/ptKjXJA1t30oF7fUYMyKN16IxV9CBz13ZDNl8UOcgWnRB9azJUA945nAf
         FTgmcIS77Fg/06tcvevFL63b4WOLNmnlVouXE2t7jMbFW3SLeHIijY8aWDZqCjhcsh
         exzi74DObR2Bw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jingwen Chen <Jingwen.Chen2@amd.com>,
        Horace Chen <horace.chen@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Hawking.Zhang@amd.com, ray.huang@amd.com, Felix.Kuehling@amd.com,
        Jack.Gui@amd.com, PengJu.Zhou@amd.com, Philip.Yang@amd.com,
        Yuliang.Shi@amd.com, Xiaomeng.Hou@amd.com, aaron.liu@amd.com,
        victor.skvortsov@amd.com, John.Clements@amd.com, Oak.Zeng@amd.com,
        alex.sierra@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.16 141/217] drm/amd/amdgpu: fix gmc bo pin count leak in SRIOV
Date:   Mon, 17 Jan 2022 21:18:24 -0500
Message-Id: <20220118021940.1942199-141-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jingwen Chen <Jingwen.Chen2@amd.com>

[ Upstream commit 948e7ce01413b71395723aaf846015062aea3a43 ]

[Why]
gmc bo will be pinned during loading amdgpu and reset in SRIOV while
only unpinned in unload amdgpu

[How]
add amdgpu_in_reset and sriov judgement to skip pin bo

v2: fix wrong judgement

Signed-off-by: Jingwen Chen <Jingwen.Chen2@amd.com>
Reviewed-by: Horace Chen <horace.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c | 4 ++++
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c  | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
index 3ec5ff5a6dbe6..61ec6145bbb16 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
@@ -992,10 +992,14 @@ static int gmc_v10_0_gart_enable(struct amdgpu_device *adev)
 		return -EINVAL;
 	}
 
+	if (amdgpu_sriov_vf(adev) && amdgpu_in_reset(adev))
+		goto skip_pin_bo;
+
 	r = amdgpu_gart_table_vram_pin(adev);
 	if (r)
 		return r;
 
+skip_pin_bo:
 	r = adev->gfxhub.funcs->gart_enable(adev);
 	if (r)
 		return r;
diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
index d84523cf5f759..4420c264c554c 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -1714,10 +1714,14 @@ static int gmc_v9_0_gart_enable(struct amdgpu_device *adev)
 		return -EINVAL;
 	}
 
+	if (amdgpu_sriov_vf(adev) && amdgpu_in_reset(adev))
+		goto skip_pin_bo;
+
 	r = amdgpu_gart_table_vram_pin(adev);
 	if (r)
 		return r;
 
+skip_pin_bo:
 	r = adev->gfxhub.funcs->gart_enable(adev);
 	if (r)
 		return r;
-- 
2.34.1

