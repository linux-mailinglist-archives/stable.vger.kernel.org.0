Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F19ADD383
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732550AbfJRWRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:17:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733030AbfJRWHg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:07:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DC442245C;
        Fri, 18 Oct 2019 22:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436456;
        bh=Dr07u1IWmJ4xY9s/UFzSO3UPZDv9wy6lz4GnA0jH21c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CPsydKzTrc5LiDxwsvoOGFXDa0IXRmdDoW+XVp6hW3MVTPFhl7oyKsAbVAn82oppJ
         ENCDtTRmlnZ32IbH+UBQiI95N8DRYnCp4qj6nehuiuE5azkl178+WRPh9PEHILBi6B
         PLUfevcVyV+zwPanyKtFQX+5i+fdQyGn3PSJh1uc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nirmoy Das <nirmoy.das@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 088/100] drm/amdgpu: fix memory leak
Date:   Fri, 18 Oct 2019 18:05:13 -0400
Message-Id: <20191018220525.9042-88-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nirmoy Das <nirmoy.das@amd.com>

[ Upstream commit 083164dbdb17c5ea4ad92c1782b59c9d75567790 ]

cleanup error handling code and make sure temporary info array
with the handles are freed by amdgpu_bo_list_put() on
idr_replace()'s failure.

Signed-off-by: Nirmoy Das <nirmoy.das@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
index b80243d3972e4..ce7f18c5ccb26 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
@@ -264,7 +264,7 @@ int amdgpu_bo_list_ioctl(struct drm_device *dev, void *data,
 
 	r = amdgpu_bo_create_list_entry_array(&args->in, &info);
 	if (r)
-		goto error_free;
+		return r;
 
 	switch (args->in.operation) {
 	case AMDGPU_BO_LIST_OP_CREATE:
@@ -277,8 +277,7 @@ int amdgpu_bo_list_ioctl(struct drm_device *dev, void *data,
 		r = idr_alloc(&fpriv->bo_list_handles, list, 1, 0, GFP_KERNEL);
 		mutex_unlock(&fpriv->bo_list_lock);
 		if (r < 0) {
-			amdgpu_bo_list_put(list);
-			return r;
+			goto error_put_list;
 		}
 
 		handle = r;
@@ -300,9 +299,8 @@ int amdgpu_bo_list_ioctl(struct drm_device *dev, void *data,
 		mutex_unlock(&fpriv->bo_list_lock);
 
 		if (IS_ERR(old)) {
-			amdgpu_bo_list_put(list);
 			r = PTR_ERR(old);
-			goto error_free;
+			goto error_put_list;
 		}
 
 		amdgpu_bo_list_put(old);
@@ -319,8 +317,10 @@ int amdgpu_bo_list_ioctl(struct drm_device *dev, void *data,
 
 	return 0;
 
+error_put_list:
+	amdgpu_bo_list_put(list);
+
 error_free:
-	if (info)
-		kvfree(info);
+	kvfree(info);
 	return r;
 }
-- 
2.20.1

