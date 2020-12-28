Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99DA92E4367
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407181AbgL1PeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:34:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:53574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407104AbgL1NwY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:52:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D33862078D;
        Mon, 28 Dec 2020 13:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163523;
        bh=3HkZ9PXJwfxEQDm5KuWxlZSG6ooTyzHe2hj+hacBDpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OR3PKgXSemJTmhpF4BvhB5IaUwDlFmkvhrHKlB4RVC8UsMsOtuHF1livh3P70Y6B2
         Qy6YKz0bhsegsLtma8iSeU4sgVjX3kwK/JT/Qtbn4A2DSlVPd8sEeZwQIuAabvDuSF
         6iRb/o1r+kybWxsJ+2EP7JPspjYf7L5/XW8I9RlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
        Kent Russell <kent.russell@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 316/453] drm/amdkfd: Fix leak in dmabuf import
Date:   Mon, 28 Dec 2020 13:49:12 +0100
Message-Id: <20201228124952.416088441@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1d3cd5c50d5f2..4a0ef9268918c 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1664,6 +1664,7 @@ static int kfd_ioctl_import_dmabuf(struct file *filep,
 	}
 
 	mutex_unlock(&p->mutex);
+	dma_buf_put(dmabuf);
 
 	args->handle = MAKE_HANDLE(args->gpu_id, idr_handle);
 
@@ -1673,6 +1674,7 @@ err_free:
 	amdgpu_amdkfd_gpuvm_free_memory_of_gpu(dev->kgd, (struct kgd_mem *)mem);
 err_unlock:
 	mutex_unlock(&p->mutex);
+	dma_buf_put(dmabuf);
 	return r;
 }
 
-- 
2.27.0



