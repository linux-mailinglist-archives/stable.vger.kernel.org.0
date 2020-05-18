Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A401D854B
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731112AbgERR4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:56:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730648AbgERR4f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:56:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CAFD20674;
        Mon, 18 May 2020 17:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824595;
        bh=5kS7ftuW0eVnEKt4iBHNF1ynTORvm3LKshKtVAfZDiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bdGuhnUFjbnevRk5K15xRCI2xGYjA5chJP/4Pga50cIugwQwWmnc2405fTHdbTERl
         cBKrWB9tp1s4bGaPA6y7HrvUyQijY8uAd7BmHNNW/AFDTGfkAiG4MaR94utf+jmLYV
         pBmuuvkWbSPbZXG3mh4j14Ms/S3cqQS9bCYrtfxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 073/147] drm/amdgpu: force fbdev into vram
Date:   Mon, 18 May 2020 19:36:36 +0200
Message-Id: <20200518173523.026685180@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
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
index 143753d237e7c..eaa5e7b7c19d6 100644
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



