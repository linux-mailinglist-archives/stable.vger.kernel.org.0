Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E330E34ECA3
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 17:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232456AbhC3Pf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 11:35:27 -0400
Received: from mengyan1223.wang ([89.208.246.23]:33060 "EHLO mengyan1223.wang"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232378AbhC3PfL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Mar 2021 11:35:11 -0400
Received: from xry111-X57S1.. (unknown [IPv6:240e:35a:1037:8a00:70b2:e35d:833c:af3e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-384) server-digest SHA384)
        (Client did not present a certificate)
        (Authenticated sender: xry111@mengyan1223.wang)
        by mengyan1223.wang (Postfix) with ESMTPSA id 4833965C14;
        Tue, 30 Mar 2021 11:34:58 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mengyan1223.wang;
        s=mail; t=1617118510;
        bh=xJ1gBuhyT9YFSqyyP3dR34G+tKbCjl47M9fIBJWEhP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nNuEvw7jfD7BiHtgdTD0pBrp2f6S96v0UAaS384nzTVt7iqz4b3f50RR76fanHxBu
         vtThlDtrWvudCRJDAWp+caryNPii4t5iXGTkjCd/8NLA7SfQGhr9w0KlS61/yp5TVM
         d984Bqv/oz2Rvt0GNVrkhsSIVTuVDmy1MoWR3ZANv4Dk7WkStaOH7GYjPPwzDi+Gjg
         cP7reWq4ayypxOeHajV2fUN0vtQWK0wAzYogIeDWT+2ppf2CGxYC6C4he4af+L4Ohl
         aEZLHvIuqJpnJ+LHRPOxcf+wnVwQdsyo4lRtyNnAadsVbLmhbefZCp3s7mN4GsHX4A
         xOxZiaknAURnw==
From:   =?UTF-8?q?X=E2=84=B9=20Ruoyao?= <xry111@mengyan1223.wang>
To:     amd-gfx@lists.freedesktop.org
Cc:     dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        =?UTF-8?q?Dan=20Hor=C3=A1k?= <dan@danny.cz>,
        Alex Deucher <alexander.deucher@amd.com>,
        David Airlie <airlied@linux.ie>,
        Huacai Chen <chenhc@lemote.com>, Rui Wang <wangr@lemote.com>,
        Xi Ruoyao <xry111@mengyan1223.wang>, stable@vger.kernel.org
Subject: [PATCH 1/2] drm/amdgpu: Set a suitable dev_info.gart_page_size
Date:   Tue, 30 Mar 2021 23:33:33 +0800
Message-Id: <20210330153334.44570-2-xry111@mengyan1223.wang>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210330153334.44570-1-xry111@mengyan1223.wang>
References: <20210330153334.44570-1-xry111@mengyan1223.wang>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhc@lemote.com>

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
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
index 86eeeb4f3513..3b0be64e4638 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -791,9 +791,9 @@ int amdgpu_info_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
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
-- 
2.31.1

