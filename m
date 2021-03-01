Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDDA132907A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242943AbhCAUIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:08:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:60384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242424AbhCAT6E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:58:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23CDB6526B;
        Mon,  1 Mar 2021 17:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621376;
        bh=CJYtOkodYJq29j6pX88jZ6fc9sRvew+tyFe6YHLWFAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CvQ+2phAyGW64YZWIFClBql+ominrOW5BxXa0tDkMFSS+fs5YBTXMEsV6cyVTT7UD
         wI7+5POjflv71JUIVudglCLBrVO3AFOIHY01mWwWbsuxj6uS14gBw7Vya9T0u9KWrW
         vKd3NRcquywqaWd5cjfGbpTsOe/NQGWdPfplUEjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Iskren Chernev <iskren.chernev@gmail.com>,
        Alexey Minnekhanov <alexeymin@postmarketos.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 492/775] drm/msm: Fix MSM_INFO_GET_IOVA with carveout
Date:   Mon,  1 Mar 2021 17:11:00 +0100
Message-Id: <20210301161225.831501065@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Iskren Chernev <iskren.chernev@gmail.com>

[ Upstream commit 6cefa31e810404dafdfcdb94874146cea11626c2 ]

The msm_gem_get_iova should be guarded with gpu != NULL and not aspace
!= NULL, because aspace is NULL when using vram carveout.

Fixes: 933415e24bd0d ("drm/msm: Add support for private address space instances")

Signed-off-by: Iskren Chernev <iskren.chernev@gmail.com>
Tested-by: Alexey Minnekhanov <alexeymin@postmarketos.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index 108c405e03dd9..94525ac76d4e6 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -788,9 +788,10 @@ static int msm_ioctl_gem_info_iova(struct drm_device *dev,
 		struct drm_file *file, struct drm_gem_object *obj,
 		uint64_t *iova)
 {
+	struct msm_drm_private *priv = dev->dev_private;
 	struct msm_file_private *ctx = file->driver_priv;
 
-	if (!ctx->aspace)
+	if (!priv->gpu)
 		return -EINVAL;
 
 	/*
-- 
2.27.0



