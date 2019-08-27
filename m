Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10D569E06D
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732338AbfH0IDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:03:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:32932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731544AbfH0IDl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:03:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 053FF206BA;
        Tue, 27 Aug 2019 08:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893021;
        bh=gzfEi06O/WlgoD9nlxsUDqj2SCZQELiibpe/EqFoojc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rAaOrfNdnNhz5C8zvimjcjYK6Y2poFusV71BNDGZBiNBC3pxYE1yVR9s68PbuCjN1
         r9VgyFUFfUlgjVwks4578IuQLWY/W12p/mZ6oiOKQB8mrOiNRlAIBwiwNHfCKFwFE8
         dwa+fN27qKgNXKXL/gwfRuLauMg+XV7fWi5rEXfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Likun Gao <Likun.Gao@amd.com>,
        Paul Gover <pmw.gover@yahoo.co.uk>,
        Feifei Xu <Feifei.Xu@amd.com>,
        Xiaojie Yuan <xiaojie.yuan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 092/162] drm/amdgpu: pin the csb buffer on hw init for gfx v8
Date:   Tue, 27 Aug 2019 09:50:20 +0200
Message-Id: <20190827072741.383013060@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



