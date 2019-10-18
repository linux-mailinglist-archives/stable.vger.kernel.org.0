Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51C4DDD479
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbfJRWYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:24:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728947AbfJRWE5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:04:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB7E02245A;
        Fri, 18 Oct 2019 22:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436296;
        bh=M2HzMP+l+Weo8FPbty/bQt2z8x2v4tAHox0FIemkwwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rNw6x9AZfiqn74/FDK4j/YtZpihauN+e0ozH2BJohw0gq2RwxpLked+47uzHi6nht
         9hgpyJnY10xYtsbMUhkdaDMONdGxga6XN+/iGY0iH1Wozb+5afXD+jk+1rWFh0uSgz
         +HQWVMDZDakqftpSSVCZnV0Bu3vt7/zwDaitYf08=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nirmoy Das <nirmoy.das@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 68/89] drm/amdgpu: fix memory leak
Date:   Fri, 18 Oct 2019 18:03:03 -0400
Message-Id: <20191018220324.8165-68-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
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
index 7bcf86c619995..61e38e43ad1d5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
@@ -270,7 +270,7 @@ int amdgpu_bo_list_ioctl(struct drm_device *dev, void *data,
 
 	r = amdgpu_bo_create_list_entry_array(&args->in, &info);
 	if (r)
-		goto error_free;
+		return r;
 
 	switch (args->in.operation) {
 	case AMDGPU_BO_LIST_OP_CREATE:
@@ -283,8 +283,7 @@ int amdgpu_bo_list_ioctl(struct drm_device *dev, void *data,
 		r = idr_alloc(&fpriv->bo_list_handles, list, 1, 0, GFP_KERNEL);
 		mutex_unlock(&fpriv->bo_list_lock);
 		if (r < 0) {
-			amdgpu_bo_list_put(list);
-			return r;
+			goto error_put_list;
 		}
 
 		handle = r;
@@ -306,9 +305,8 @@ int amdgpu_bo_list_ioctl(struct drm_device *dev, void *data,
 		mutex_unlock(&fpriv->bo_list_lock);
 
 		if (IS_ERR(old)) {
-			amdgpu_bo_list_put(list);
 			r = PTR_ERR(old);
-			goto error_free;
+			goto error_put_list;
 		}
 
 		amdgpu_bo_list_put(old);
@@ -325,8 +323,10 @@ int amdgpu_bo_list_ioctl(struct drm_device *dev, void *data,
 
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

