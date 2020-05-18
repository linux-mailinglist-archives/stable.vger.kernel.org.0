Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3281D834E
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732673AbgERSDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:03:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732667AbgERSDg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:03:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 535D520715;
        Mon, 18 May 2020 18:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825015;
        bh=GGnJNp2Cr9o98JBWRJx55Ike4NOjI4uLkxCaJOm8jGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ROEyFHuzmGzCmg9scSINo/Ua5AbqRPCVEs9QPVzYrU5QyCi0SwTYCpNBt5aPTXIik
         NSpSq2+8zG+j+CSgTyn4Ts3iAezxSK6stN/EZk4T5hN22tBOslrWm3+XUMWHlZ6yQg
         p5T80iS3Fw0FjVlr82kvCLkgu2OQ8X1rE2Cf/21g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 096/194] drm/amdgpu: force fbdev into vram
Date:   Mon, 18 May 2020 19:36:26 +0200
Message-Id: <20200518173540.074086739@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit a6aacb2b26e85aa619cf0c6f98d0ca77314cd2a1 ]

We set the fb smem pointer to the offset into the BAR, so keep
the fbdev bo in vram.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=207581
Fixes: 6c8d74caa2fa33 ("drm/amdgpu: Enable scatter gather display support")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
index 2672dc64a3101..6a76ab16500fa 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
@@ -133,8 +133,7 @@ static int amdgpufb_create_pinned_object(struct amdgpu_fbdev *rfbdev,
 	u32 cpp;
 	u64 flags = AMDGPU_GEM_CREATE_CPU_ACCESS_REQUIRED |
 			       AMDGPU_GEM_CREATE_VRAM_CONTIGUOUS     |
-			       AMDGPU_GEM_CREATE_VRAM_CLEARED 	     |
-			       AMDGPU_GEM_CREATE_CPU_GTT_USWC;
+			       AMDGPU_GEM_CREATE_VRAM_CLEARED;
 
 	info = drm_get_format_info(adev->ddev, mode_cmd);
 	cpp = info->cpp[0];
-- 
2.20.1



