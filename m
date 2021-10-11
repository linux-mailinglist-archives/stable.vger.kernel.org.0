Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DC7429088
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239822AbhJKOJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:09:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238532AbhJKOHj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:07:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3848261220;
        Mon, 11 Oct 2021 14:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960857;
        bh=hoqfVMpKR7UzQH/NVxQZQ2VwJ9PMv5Nmhb1hsi9uhlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n42fO299O8oTzdPTgoQVSnrovgAheQ6sCf6PfgH58CGus5uJ8Bqrbz+xyODnPFPuV
         c7Fhac1XcB8orsjlFFjucpMxdObUm53utO91hHKPvnwzZG5uEpPmxK+usoXtubX0ju
         AwaYq4EklVWc22ANBhTrG8+WZ9UkJ7mzESyJWzw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lang Yu <lang.yu@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 095/151] drm/amdkfd: fix a potential ttm->sg memory leak
Date:   Mon, 11 Oct 2021 15:46:07 +0200
Message-Id: <20211011134520.895570316@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lang Yu <lang.yu@amd.com>

[ Upstream commit b072ef1215aca33186e3a10109e872e528a9e516 ]

Memory is allocated for ttm->sg by kmalloc in kfd_mem_dmamap_userptr,
but isn't freed by kfree in kfd_mem_dmaunmap_userptr. Free it!

Fixes: 264fb4d332f5 ("drm/amdgpu: Add multi-GPU DMA mapping helpers")

Signed-off-by: Lang Yu <lang.yu@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 4fb15750b9bb..b18c0697356c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -563,6 +563,7 @@ kfd_mem_dmaunmap_userptr(struct kgd_mem *mem,
 
 	dma_unmap_sgtable(adev->dev, ttm->sg, direction, 0);
 	sg_free_table(ttm->sg);
+	kfree(ttm->sg);
 	ttm->sg = NULL;
 }
 
-- 
2.33.0



