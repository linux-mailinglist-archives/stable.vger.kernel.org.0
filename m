Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B4F2DF2FE
	for <lists+stable@lfdr.de>; Sun, 20 Dec 2020 04:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbgLTDf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 22:35:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:57994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727454AbgLTDf6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 22:35:58 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Kuehling <Felix.Kuehling@amd.com>,
        Kent Russell <kent.russell@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.9 09/15] drm/amdkfd: Fix leak in dmabuf import
Date:   Sat, 19 Dec 2020 22:34:27 -0500
Message-Id: <20201220033434.2728348-9-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201220033434.2728348-1-sashal@kernel.org>
References: <20201220033434.2728348-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Kuehling <Felix.Kuehling@amd.com>

[ Upstream commit c897934da15f182ce99536007f8ef61c4748c07e ]

Release dmabuf reference before returning from kfd_ioctl_import_dmabuf.
amdgpu_amdkfd_gpuvm_import_dmabuf takes a reference to the underlying
GEM BO and doesn't keep the reference to the dmabuf wrapper.

Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index e9b96ad3d9a52..fdad4d108dd36 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1729,6 +1729,7 @@ static int kfd_ioctl_import_dmabuf(struct file *filep,
 	}
 
 	mutex_unlock(&p->mutex);
+	dma_buf_put(dmabuf);
 
 	args->handle = MAKE_HANDLE(args->gpu_id, idr_handle);
 
@@ -1738,6 +1739,7 @@ static int kfd_ioctl_import_dmabuf(struct file *filep,
 	amdgpu_amdkfd_gpuvm_free_memory_of_gpu(dev->kgd, (struct kgd_mem *)mem, NULL);
 err_unlock:
 	mutex_unlock(&p->mutex);
+	dma_buf_put(dmabuf);
 	return r;
 }
 
-- 
2.27.0

