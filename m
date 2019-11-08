Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B84CCF5547
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390168AbfKHTBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:01:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:58672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732355AbfKHTBW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:01:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F77F21D7B;
        Fri,  8 Nov 2019 19:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239679;
        bh=OKzxs6Vp36RleM3DGjN+gDcSlMvf+Optl6R2M+moc5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kMLTX50sVXvEWmtfVHleZMEChJsYaiiLVpcAIhSeKLEgc9K7psSd5nqY+fI/dFrzA
         QBDhW+pk985SBTTEKC9E+1JISfiGAsl1h5WvpzjRNa8AXCfQ+aNnjFj7GVOZlNdqqO
         0aeYFpP4aNC4kPWOJDfUzkVfu9juhyJoPHk+VOS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 24/79] drm/amdgpu: fix potential VM faults
Date:   Fri,  8 Nov 2019 19:50:04 +0100
Message-Id: <20191108174759.515948589@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b0e14a3d54efd..b14ce112703f0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -428,7 +428,8 @@ static int amdgpu_bo_do_create(struct amdgpu_device *adev,
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



