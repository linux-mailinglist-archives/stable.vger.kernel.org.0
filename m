Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A482F35401B
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240620AbhDEJQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:16:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239424AbhDEJPf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:15:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3620861002;
        Mon,  5 Apr 2021 09:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614124;
        bh=fIM3T8xvP16U0gI9QGzCA8L2mFV4G3KBVAzxTCxtmdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FUeEiWpMOIFbu6MVx3CAKS9MV6JA6ZV3cZcFNSFMeIPLKAU/Hk3JcZMhnzQgpCD7j
         SZRKrRcuQxh1gtX5O/uFKJZbvNmKzsZcDMAijbdOwZB4QwPKVF9fDbcbT7ITft1x7A
         kMk5tML9g9av4Mhpt1qs2TL5A1DqXP2qUcF0bViE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rui Wang <wangr@lemote.com>,
        Huacai Chen <chenhc@lemote.com>,
        Xi Ruoyao <xry111@mengyan1223.wang>,
        =?UTF-8?q?Dan=20Hor=C3=A1k?= <dan@danny.cz>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.11 092/152] drm/amdgpu: Set a suitable dev_info.gart_page_size
Date:   Mon,  5 Apr 2021 10:54:01 +0200
Message-Id: <20210405085037.242060466@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhc@lemote.com>

commit 566c6e25f957ebdb0b6e8073ee291049118f47fb upstream.

In Mesa, dev_info.gart_page_size is used for alignment and it was
set to AMDGPU_GPU_PAGE_SIZE(4KB). However, the page table of AMDGPU
driver requires an alignment on CPU pages.  So, for non-4KB page system,
gart_page_size should be max_t(u32, PAGE_SIZE, AMDGPU_GPU_PAGE_SIZE).

Signed-off-by: Rui Wang <wangr@lemote.com>
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Link: https://github.com/loongson-community/linux-stable/commit/caa9c0a1
[Xi: rebased for drm-next, use max_t for checkpatch,
     and reworded commit message.]
Signed-off-by: Xi Ruoyao <xry111@mengyan1223.wang>
BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1549
Tested-by: Dan Horák <dan@danny.cz>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -780,9 +780,9 @@ int amdgpu_info_ioctl(struct drm_device
 			dev_info->high_va_offset = AMDGPU_GMC_HOLE_END;
 			dev_info->high_va_max = AMDGPU_GMC_HOLE_END | vm_size;
 		}
-		dev_info->virtual_address_alignment = max((int)PAGE_SIZE, AMDGPU_GPU_PAGE_SIZE);
+		dev_info->virtual_address_alignment = max_t(u32, PAGE_SIZE, AMDGPU_GPU_PAGE_SIZE);
 		dev_info->pte_fragment_size = (1 << adev->vm_manager.fragment_size) * AMDGPU_GPU_PAGE_SIZE;
-		dev_info->gart_page_size = AMDGPU_GPU_PAGE_SIZE;
+		dev_info->gart_page_size = max_t(u32, PAGE_SIZE, AMDGPU_GPU_PAGE_SIZE);
 		dev_info->cu_active_number = adev->gfx.cu_info.number;
 		dev_info->cu_ao_mask = adev->gfx.cu_info.ao_cu_mask;
 		dev_info->ce_ram_size = adev->gfx.ce_ram_size;


