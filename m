Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F038229B926
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802227AbgJ0PqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:46:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2902169AbgJ0P2M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:28:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69CDC20780;
        Tue, 27 Oct 2020 15:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812492;
        bh=4e9p/9RGJecZjzwk6cILIlPkuo81AdEUtggPfb+TCXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q5h34fRFk2ayP/VhHrh+qoeR91BqP8HtUdq7LjuteaUA/1sZOyu1m1sx4ftuIPbr+
         NbDko7vJKWuuiU48g8LnIPi8TLbSbX1Zq9cctszjv8prMbw2pYb5cLTkyCwTdRw+85
         mCf1iuU6jH7FYFJlEo2QCgMWGAb3/Ng8HeW2yKwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        xinhui pan <xinhui.pan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 228/757] drm/amdgpu: fix max_entries calculation v4
Date:   Tue, 27 Oct 2020 14:47:58 +0100
Message-Id: <20201027135501.302889854@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

[ Upstream commit ee354ff1c7c210fb41952ebf0a820fb714eae7b1 ]

Calculate the correct value for max_entries or we might run after the
page_address array.

v2: Xinhui pointed out we don't need the shift
v3: use local copy of start and simplify some calculation
v4: fix the case that we map less VA range than BO size

Signed-off-by: Christian König <christian.koenig@amd.com>
Fixes: 1e691e244487 drm/amdgpu: stop allocating dummy GTT nodes
Reviewed-by: xinhui pan <xinhui.pan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index 71e005cf29522..479735c448478 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -1691,13 +1691,13 @@ static int amdgpu_vm_bo_split_mapping(struct amdgpu_device *adev,
 		uint64_t max_entries;
 		uint64_t addr, last;
 
+		max_entries = mapping->last - start + 1;
 		if (nodes) {
 			addr = nodes->start << PAGE_SHIFT;
-			max_entries = (nodes->size - pfn) *
-				AMDGPU_GPU_PAGES_IN_CPU_PAGE;
+			max_entries = min((nodes->size - pfn) *
+				AMDGPU_GPU_PAGES_IN_CPU_PAGE, max_entries);
 		} else {
 			addr = 0;
-			max_entries = S64_MAX;
 		}
 
 		if (pages_addr) {
@@ -1727,7 +1727,7 @@ static int amdgpu_vm_bo_split_mapping(struct amdgpu_device *adev,
 			addr += pfn << PAGE_SHIFT;
 		}
 
-		last = min((uint64_t)mapping->last, start + max_entries - 1);
+		last = start + max_entries - 1;
 		r = amdgpu_vm_bo_update_mapping(adev, vm, false, false, resv,
 						start, last, flags, addr,
 						dma_addr, fence);
-- 
2.25.1



