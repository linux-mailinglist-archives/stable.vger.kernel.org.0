Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB2D12C9FE
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbfL2SP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:15:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:44258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727846AbfL2RY7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:24:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5898221744;
        Sun, 29 Dec 2019 17:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640298;
        bh=1kjiACzzmBDRnaMcPKB7BhWUdRlYWY44pWKR3t+0fbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tGuhwH9CyGWuM3CIr9qFvEShbaDJJs6K5ymQbSRIWa9NnQFl4T+psXAlmDuUcw2s7
         FFSdxWaBgOOJ7bDKSB+pDwmPqmkyO25M+8PpMSOT+QqK2PNFMk+jfdh4Jwvsi3hGeh
         bvLy43kYzvOYED/tST2VOVzsucAfThhwMDYFB7/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Pan Bian <bianpan2016@163.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 100/161] drm/amdgpu: fix potential double drop fence reference
Date:   Sun, 29 Dec 2019 18:19:08 +0100
Message-Id: <20191229162426.880998945@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit 946ab8db6953535a3a88c957db8328beacdfed9d ]

The object fence is not set to NULL after its reference is dropped. As a
result, its reference may be dropped again if error occurs after that,
which may lead to a use after free bug. To avoid the issue, fence is
explicitly set to NULL after dropping its reference.

Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Pan Bian <bianpan2016@163.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_test.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_test.c
index ed8c3739015b..b35b0741fd97 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_test.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_test.c
@@ -125,6 +125,7 @@ static void amdgpu_do_test_moves(struct amdgpu_device *adev)
 		}
 
 		dma_fence_put(fence);
+		fence = NULL;
 
 		r = amdgpu_bo_kmap(vram_obj, &vram_map);
 		if (r) {
@@ -170,6 +171,7 @@ static void amdgpu_do_test_moves(struct amdgpu_device *adev)
 		}
 
 		dma_fence_put(fence);
+		fence = NULL;
 
 		r = amdgpu_bo_kmap(gtt_obj[i], &gtt_map);
 		if (r) {
-- 
2.20.1



