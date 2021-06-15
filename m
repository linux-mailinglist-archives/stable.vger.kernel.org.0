Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9514B3A856C
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbhFOPzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:55:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231621AbhFOPx2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:53:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4519361874;
        Tue, 15 Jun 2021 15:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772235;
        bh=XIYvHSSButC67HzU6fduVakbD0ni65gR3K7el6VrxOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sDOU8b41Y6YUrOQjDjQQEFbWkBVTuHfZ1zyEFNroc6MSdWe7Ak8MqxylVqa9G6qy6
         KnI5PkdDD8QA5E6NM1ditguWA8DHl7bMyPVmQhz3CPo2MkF2lVJ/M29CxE/S27Xz/9
         FCR6Jj03kX+6kCc23zzjmstshnGkSwr0TIxwrPFlUvok3sUD94YR+UJzdtQpw8sD4I
         ++jCE+rMVJBNmcR7DDxLbAQy6CGGBfsHCSE/7oSWAPnLq1yyvcQzrGFCaofvCU301z
         d0EzvhwetBrOvXJtDAMggc9Xq5rhuULaVH3vDjK7m1Z6sejxJfCLaS3HTmZTAiP87Y
         DWlWl7//5JLAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chen Li <chenli@uniontech.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 5/8] radeon: use memcpy_to/fromio for UVD fw upload
Date:   Tue, 15 Jun 2021 11:50:24 -0400
Message-Id: <20210615155027.63048-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615155027.63048-1-sashal@kernel.org>
References: <20210615155027.63048-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Li <chenli@uniontech.com>

[ Upstream commit ab8363d3875a83f4901eb1cc00ce8afd24de6c85 ]

I met a gpu addr bug recently and the kernel log
tells me the pc is memcpy/memset and link register is
radeon_uvd_resume.

As we know, in some architectures, optimized memcpy/memset
may not work well on device memory. Trival memcpy_toio/memset_io
can fix this problem.

BTW, amdgpu has already done it in:
commit ba0b2275a678 ("drm/amdgpu: use memcpy_to/fromio for UVD fw upload"),
that's why it has no this issue on the same gpu and platform.

Signed-off-by: Chen Li <chenli@uniontech.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_uvd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_uvd.c b/drivers/gpu/drm/radeon/radeon_uvd.c
index 95f4db70dd22..fde9c69ecc86 100644
--- a/drivers/gpu/drm/radeon/radeon_uvd.c
+++ b/drivers/gpu/drm/radeon/radeon_uvd.c
@@ -286,7 +286,7 @@ int radeon_uvd_resume(struct radeon_device *rdev)
 	if (rdev->uvd.vcpu_bo == NULL)
 		return -EINVAL;
 
-	memcpy(rdev->uvd.cpu_addr, rdev->uvd_fw->data, rdev->uvd_fw->size);
+	memcpy_toio((void __iomem *)rdev->uvd.cpu_addr, rdev->uvd_fw->data, rdev->uvd_fw->size);
 
 	size = radeon_bo_size(rdev->uvd.vcpu_bo);
 	size -= rdev->uvd_fw->size;
@@ -294,7 +294,7 @@ int radeon_uvd_resume(struct radeon_device *rdev)
 	ptr = rdev->uvd.cpu_addr;
 	ptr += rdev->uvd_fw->size;
 
-	memset(ptr, 0, size);
+	memset_io((void __iomem *)ptr, 0, size);
 
 	return 0;
 }
-- 
2.30.2

