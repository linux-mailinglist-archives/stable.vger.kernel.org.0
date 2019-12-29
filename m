Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67C9E12C82A
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732124AbfL2Rvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:51:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:37162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731631AbfL2Rvh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:51:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D24B920718;
        Sun, 29 Dec 2019 17:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641897;
        bh=DqmDIhrrvqBc3ZWRbEYdReFmzm8pCUnfXzL/zJxHLFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H+RIZ0xEGEsVJMcwqvZ2LAolXzk0RACer95QWnB09+FGxHv9jEuNvMIyeFCNwgqLm
         I8iyyzx3Jz6YTggsjSWDi8TBTi1yU7XGifEAIaIWU6QAIJL7OC5DL6f/5Xj1zl6IH4
         ccoGh0RVJdDWNmH/y8Zxw6qs7VuEPK+VeWu7haOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Pan Bian <bianpan2016@163.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 257/434] drm/amdgpu: fix potential double drop fence reference
Date:   Sun, 29 Dec 2019 18:25:10 +0100
Message-Id: <20191229172719.001746409@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
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
index b66d29d5ffa2..b158230af8db 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_test.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_test.c
@@ -138,6 +138,7 @@ static void amdgpu_do_test_moves(struct amdgpu_device *adev)
 		}
 
 		dma_fence_put(fence);
+		fence = NULL;
 
 		r = amdgpu_bo_kmap(vram_obj, &vram_map);
 		if (r) {
@@ -183,6 +184,7 @@ static void amdgpu_do_test_moves(struct amdgpu_device *adev)
 		}
 
 		dma_fence_put(fence);
+		fence = NULL;
 
 		r = amdgpu_bo_kmap(gtt_obj[i], &gtt_map);
 		if (r) {
-- 
2.20.1



