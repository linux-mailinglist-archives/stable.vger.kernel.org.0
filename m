Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3AD0F7D69
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730564AbfKKS4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:56:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:54846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729132AbfKKS43 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:56:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 122022184C;
        Mon, 11 Nov 2019 18:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498588;
        bh=/5o7LaMl3y15TxiYn3Ng6YMwWWRx3K5V37qTdQwql9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jBC5ND2naDCT2oOK84o8lKb3k++COb1h9l7PzX5oFKie1v6gtWfG/gZ2s4dhUx6tB
         6O90vEUa9fbt9zhpbthkA/S3OSPidAZM5JDrOr+oAU5SGCuvgtSqGJC7dZYhoSX91Y
         l6xrE5vRkTkBA34RcdC00zIsu20VAuPRKJOGaCOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 164/193] drm/amdgpu/sdma5: do not execute 0-sized IBs (v2)
Date:   Mon, 11 Nov 2019 19:29:06 +0100
Message-Id: <20191111181513.220655267@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>

[ Upstream commit 9bdf63d3579e36942f4b91d3558a90da8116bb40 ]

This seems to help with https://bugs.freedesktop.org/show_bug.cgi?id=111481.

v2: insert a NOP instead of skipping all 0-sized IBs to avoid breaking older hw

Signed-off-by: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
index 5eeb72fcc123a..6a51e6a4a035b 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
@@ -264,6 +264,7 @@ static void gmc_v10_0_flush_gpu_tlb(struct amdgpu_device *adev,
 
 	job->vm_pd_addr = amdgpu_gmc_pd_addr(adev->gart.bo);
 	job->vm_needs_flush = true;
+	job->ibs->ptr[job->ibs->length_dw++] = ring->funcs->nop;
 	amdgpu_ring_pad_ib(ring, &job->ibs[0]);
 	r = amdgpu_job_submit(job, &adev->mman.entity,
 			      AMDGPU_FENCE_OWNER_UNDEFINED, &fence);
-- 
2.20.1



