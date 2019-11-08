Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6610BF561A
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391335AbfKHTGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:06:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:37324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733176AbfKHTGq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:06:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30FA320673;
        Fri,  8 Nov 2019 19:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240005;
        bh=RoOwuTEoleM5cqE4Jh826MjpsBVUMzm5KeiWX26H0Vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t7p25BBWs3WMN27yLIpsy3CTSCoTxFZ8nm7Oli/555NlK81vmvi6ZnMMmaucuxmGu
         6MAkRyGORsUEES0nNKr75DxHNhee8KUMAsk+FHJJoIk8SyD520IPBcxBAsADpFJsoo
         Xg5fPs1ZR1+IOjvKPAlpTEDjGzNSlwxXdNv2plG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 055/140] drm/amdgpu: fix error handling in amdgpu_bo_list_create
Date:   Fri,  8 Nov 2019 19:49:43 +0100
Message-Id: <20191108174908.790526222@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 61e38e43ad1d5..85b0515c0fdcf 100644
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



