Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71943AF018
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbhFUQqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:46:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232391AbhFUQn5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:43:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2834613C5;
        Mon, 21 Jun 2021 16:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293122;
        bh=dH7xJQayrZBIPMfOJf6UdvY+v0w6s/jfGmwldd66918=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eLlVqgMVptu/PEAflHQrH5ttN+baecFazx+ucAtDQ5ve/iZLkkoUrvfMe9ggyT8/Q
         Mkj5J7Xk6HctojhEDz/LJbni5+YBz6nvxFt0ZJ1JnLmJbPdko09zZmbYhjoOVhPTTl
         YaO52FofsRoZiPwbWg9E2ozoEjybV9ryPh8eNLzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Li <chenli@uniontech.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 107/178] radeon: use memcpy_to/fromio for UVD fw upload
Date:   Mon, 21 Jun 2021 18:15:21 +0200
Message-Id: <20210621154926.410094969@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index dfa9fdbe98da..06bb24d7a9fe 100644
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



