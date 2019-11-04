Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29ED9EEF33
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387421AbfKDWTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:19:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:58692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388141AbfKDWAs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:00:48 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9962A20659;
        Mon,  4 Nov 2019 22:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904848;
        bh=Dr07u1IWmJ4xY9s/UFzSO3UPZDv9wy6lz4GnA0jH21c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xHnFmuwcXpW7tjodnpo2CGV3Jq3PfpMgPfA+3mD9EY8QMWRsV8drAHgzJc65cA++I
         wUopS8kJ947gNcSFO2hPldoS+dLuxbCIdBRomLqZz2xWvzbdEN6qhr5ZHRBqYtuPbc
         i4VSOUcXlO2qrLzAblBa7iYMYQATMtG+ZNb6Rusw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nirmoy Das <nirmoy.das@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 093/149] drm/amdgpu: fix memory leak
Date:   Mon,  4 Nov 2019 22:44:46 +0100
Message-Id: <20191104212143.005061860@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
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



