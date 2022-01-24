Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACA549A411
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369283AbiAYABZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1847527AbiAXXUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:20:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40850C08E8AC;
        Mon, 24 Jan 2022 13:27:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2C72B81257;
        Mon, 24 Jan 2022 21:27:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2492EC340E4;
        Mon, 24 Jan 2022 21:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059665;
        bh=I1V/IFg+vIvu92mF4fyATCy5Y+5SKhi/PFtWjx0XmD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PW9BXlYfoRcCqRYVO80Go9uCV5fX/SaW4b4DEGFGTihZZ6cZaoeg6+zMDiiCvNr4B
         O5M7N0isTqRZb8C3Kwv5y3CJGK99Z61VPoETuYXUTDnLqRCFAnSEf8R2Y21OW/ZmJo
         nqBM0g8klskmJfFcdulaLzs9LUlDWdxmSaX52UV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jingwen Chen <Jingwen.Chen2@amd.com>,
        Horace Chen <horace.chen@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0659/1039] drm/amd/amdgpu: fix gmc bo pin count leak in SRIOV
Date:   Mon, 24 Jan 2022 19:40:48 +0100
Message-Id: <20220124184147.516227710@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



