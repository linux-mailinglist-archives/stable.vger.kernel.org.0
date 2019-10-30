Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9286EEA018
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbfJ3Pxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:53:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728186AbfJ3Pxd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:53:33 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5525720856;
        Wed, 30 Oct 2019 15:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450813;
        bh=IkLYQnzfqnzRQFMu1Zr8xUgXTKtuTIZGZVf8nzghm+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WLrBLXGb66JqaW0wDYGVPPuUQQiboUXNoGUfMnkgL0kDSs4tPhV6UeBUdv1GArGbz
         mZ9Mx078Vva6axP9FYXooNjKxW8AqBty11+PnEmXTNUD0Gj79x1MYBq/FGlMTU9rjO
         NPX+TGJin1Wqj+FPMihjw3VepWP15BuYwg3pLZ68=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 56/81] drm/amdgpu: fix error handling in amdgpu_bo_list_create
Date:   Wed, 30 Oct 2019 11:49:02 -0400
Message-Id: <20191030154928.9432-56-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

[ Upstream commit de51a5019ff32960218da8fd899fa3f361b031e9 ]

We need to drop normal and userptr BOs separately.

Signed-off-by: Christian König <christian.koenig@amd.com>
Acked-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
index 7bcf86c619995..d4c4785ab5256 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
@@ -140,7 +140,12 @@ int amdgpu_bo_list_create(struct amdgpu_device *adev, struct drm_file *filp,
 	return 0;
 
 error_free:
-	while (i--) {
+	for (i = 0; i < last_entry; ++i) {
+		struct amdgpu_bo *bo = ttm_to_amdgpu_bo(array[i].tv.bo);
+
+		amdgpu_bo_unref(&bo);
+	}
+	for (i = first_userptr; i < num_entries; ++i) {
 		struct amdgpu_bo *bo = ttm_to_amdgpu_bo(array[i].tv.bo);
 
 		amdgpu_bo_unref(&bo);
-- 
2.20.1

