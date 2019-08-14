Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 049C18C8B9
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbfHNCd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:33:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728676AbfHNCOQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:14:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59CF020842;
        Wed, 14 Aug 2019 02:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748856;
        bh=wozasWgbjk3RDT7vvWL0bibciU5WOlPVahhGuZNQ2Y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=niVcyaQBBh3zH76faNFvxu9fbPTgDrMSq6hxZDWw/PWqELhaQwvsEdP8r5JHNf25T
         osi5ruRzHr+oDDeWNMBNnELslg1gKAsts9UGknCR+q2QToR+rBCn0H9hwU6/wM/ku0
         +JE1mUIZM0O39WcybV6imloe2WI4Nx0Z1QFhq/Bk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Likun Gao <Likun.Gao@amd.com>, Paul Gover <pmw.gover@yahoo.co.uk>,
        Feifei Xu <Feifei.Xu@amd.com>,
        Xiaojie Yuan <xiaojie.yuan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 105/123] drm/amdgpu: pin the csb buffer on hw init for gfx v8
Date:   Tue, 13 Aug 2019 22:10:29 -0400
Message-Id: <20190814021047.14828-105-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Likun Gao <Likun.Gao@amd.com>

[ Upstream commit 72cda9bb5e219aea0f2f62f56ae05198c59022a7 ]

Without this pin, the csb buffer will be filled with inconsistent
data after S3 resume. And that will causes gfx hang on gfxoff
exit since this csb will be executed then.

Signed-off-by: Likun Gao <Likun.Gao@amd.com>
Tested-by: Paul Gover <pmw.gover@yahoo.co.uk>
Reviewed-by: Feifei Xu <Feifei.Xu@amd.com>
Reviewed-by: Xiaojie Yuan <xiaojie.yuan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c | 40 +++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
index 02955e6e9dd9e..c21ef99cc590f 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
@@ -1317,6 +1317,39 @@ static int gfx_v8_0_rlc_init(struct amdgpu_device *adev)
 	return 0;
 }
 
+static int gfx_v8_0_csb_vram_pin(struct amdgpu_device *adev)
+{
+	int r;
+
+	r = amdgpu_bo_reserve(adev->gfx.rlc.clear_state_obj, false);
+	if (unlikely(r != 0))
+		return r;
+
+	r = amdgpu_bo_pin(adev->gfx.rlc.clear_state_obj,
+			AMDGPU_GEM_DOMAIN_VRAM);
+	if (!r)
+		adev->gfx.rlc.clear_state_gpu_addr =
+			amdgpu_bo_gpu_offset(adev->gfx.rlc.clear_state_obj);
+
+	amdgpu_bo_unreserve(adev->gfx.rlc.clear_state_obj);
+
+	return r;
+}
+
+static void gfx_v8_0_csb_vram_unpin(struct amdgpu_device *adev)
+{
+	int r;
+
+	if (!adev->gfx.rlc.clear_state_obj)
+		return;
+
+	r = amdgpu_bo_reserve(adev->gfx.rlc.clear_state_obj, true);
+	if (likely(r == 0)) {
+		amdgpu_bo_unpin(adev->gfx.rlc.clear_state_obj);
+		amdgpu_bo_unreserve(adev->gfx.rlc.clear_state_obj);
+	}
+}
+
 static void gfx_v8_0_mec_fini(struct amdgpu_device *adev)
 {
 	amdgpu_bo_free_kernel(&adev->gfx.mec.hpd_eop_obj, NULL, NULL);
@@ -4777,6 +4810,10 @@ static int gfx_v8_0_hw_init(void *handle)
 	gfx_v8_0_init_golden_registers(adev);
 	gfx_v8_0_constants_init(adev);
 
+	r = gfx_v8_0_csb_vram_pin(adev);
+	if (r)
+		return r;
+
 	r = adev->gfx.rlc.funcs->resume(adev);
 	if (r)
 		return r;
@@ -4893,6 +4930,9 @@ static int gfx_v8_0_hw_fini(void *handle)
 	else
 		pr_err("rlc is busy, skip halt rlc\n");
 	amdgpu_gfx_rlc_exit_safe_mode(adev);
+
+	gfx_v8_0_csb_vram_unpin(adev);
+
 	return 0;
 }
 
-- 
2.20.1

