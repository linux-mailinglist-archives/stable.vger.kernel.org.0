Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249C93A8598
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbhFOP4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:56:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231824AbhFOPyv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:54:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDF8C61928;
        Tue, 15 Jun 2021 15:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772252;
        bh=2l+0AzhN1G7V/d61jrCVzbn9/bKseKtLGum0/a0ArHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iFsrjeHQtMVB3JpblFadNwbMYMTAeFuA9B33jI5t6w12Qzmkt7DurO3M/CBVXPlIh
         S5n11LXX0hsf29eu/CsZ6DxTP9QjW31WGC01SO3Ls5EvUu4ydVrfxpmz6cQ/g8PAGT
         dFUUYN/X5iN6kgpZPHPV/FgL6y4r7fwbN14gbSvgWKI/pSlCCf8SCNFoOZ+BxPKw8K
         DlCiYmz3qhxsbMPrbhMf9GbdOidJ4nUuR4/NYtXOFWcvLK/4hmDhoU12F+AslLyTp9
         q6jUvEJjLbyio7NYBcw9rqkcdVqBpYhmUHm/jK8BPje5rZYRTKc6kBJXRqnLjMVup+
         AiyIRaQUhrEAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chen Li <chenli@uniontech.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.4 3/3] radeon: use memcpy_to/fromio for UVD fw upload
Date:   Tue, 15 Jun 2021 11:50:47 -0400
Message-Id: <20210615155048.63448-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615155048.63448-1-sashal@kernel.org>
References: <20210615155048.63448-1-sashal@kernel.org>
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
index b35ebabd6a9f..eab985fdcfbd 100644
--- a/drivers/gpu/drm/radeon/radeon_uvd.c
+++ b/drivers/gpu/drm/radeon/radeon_uvd.c
@@ -242,7 +242,7 @@ int radeon_uvd_resume(struct radeon_device *rdev)
 	if (rdev->uvd.vcpu_bo == NULL)
 		return -EINVAL;
 
-	memcpy(rdev->uvd.cpu_addr, rdev->uvd_fw->data, rdev->uvd_fw->size);
+	memcpy_toio((void __iomem *)rdev->uvd.cpu_addr, rdev->uvd_fw->data, rdev->uvd_fw->size);
 
 	size = radeon_bo_size(rdev->uvd.vcpu_bo);
 	size -= rdev->uvd_fw->size;
@@ -250,7 +250,7 @@ int radeon_uvd_resume(struct radeon_device *rdev)
 	ptr = rdev->uvd.cpu_addr;
 	ptr += rdev->uvd_fw->size;
 
-	memset(ptr, 0, size);
+	memset_io((void __iomem *)ptr, 0, size);
 
 	return 0;
 }
-- 
2.30.2

