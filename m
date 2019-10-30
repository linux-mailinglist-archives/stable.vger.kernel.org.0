Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8DB9EA016
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfJ3Pxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:53:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728186AbfJ3Px3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:53:29 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C10D020856;
        Wed, 30 Oct 2019 15:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450809;
        bh=gv1fTVcMYT3t+RNSRTZEKgmTRhHvkmvmvq7qtcg5k6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pmI6csuYo5Pb641U/UFbSqBnr7EZ+Kbg+5lIeFcNLKi1mD/L9mbhTm0/vj+d1S/sc
         lz6Jjo/KBlQxTgIhky/s5ChUhEGpXBgb/4iL3BIdrGmvzfPSXmgxDaWAjlDivh24yb
         Y3glUtBUumHlIC8CB7vaYwhlHHdSMOE5NpCUbuSI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 55/81] drm/amdgpu: fix potential VM faults
Date:   Wed, 30 Oct 2019 11:49:01 -0400
Message-Id: <20191030154928.9432-55-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 3122051edc7c27cc08534be730f4c7c180919b8a ]

When we allocate new page tables under memory
pressure we should not evict old ones.

Signed-off-by: Christian König <christian.koenig@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index bea6f298dfdc5..0ff786dec8c4a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -421,7 +421,8 @@ static int amdgpu_bo_do_create(struct amdgpu_device *adev,
 		.interruptible = (bp->type != ttm_bo_type_kernel),
 		.no_wait_gpu = false,
 		.resv = bp->resv,
-		.flags = TTM_OPT_FLAG_ALLOW_RES_EVICT
+		.flags = bp->type != ttm_bo_type_kernel ?
+			TTM_OPT_FLAG_ALLOW_RES_EVICT : 0
 	};
 	struct amdgpu_bo *bo;
 	unsigned long page_align, size = bp->size;
-- 
2.20.1

