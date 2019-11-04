Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A145BEED77
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390061AbfKDWHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:07:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:39266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390046AbfKDWHB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:07:01 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01152214D8;
        Mon,  4 Nov 2019 22:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905220;
        bh=M2HzMP+l+Weo8FPbty/bQt2z8x2v4tAHox0FIemkwwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p9TIXF9a8Y28hMDVnVsvvOwNp1Gtne2+pPEIEYEROGWu6dyVMGYHDFDENzWbNMPyp
         eoN0k5ainfVDdkl+G2wPhwWJda1rXoLDQi/vdqOx+vR5W6DXG6hV3/OlWfOO2+Wm29
         cOackZTvjhkRwDR0EIi1njfZ29I/ETohj06YKgqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nirmoy Das <nirmoy.das@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 070/163] drm/amdgpu: fix memory leak
Date:   Mon,  4 Nov 2019 22:44:20 +0100
Message-Id: <20191104212144.991122922@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



