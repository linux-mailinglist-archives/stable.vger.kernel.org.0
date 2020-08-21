Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74EED24DB2F
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 18:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbgHUQfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 12:35:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728442AbgHUQVU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:21:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8369F22BEB;
        Fri, 21 Aug 2020 16:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026825;
        bh=mR6oGR+NyHCaBD7rYApwSslo3Nk/GcTOScozNAXPbPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SMjDhs7sA2MmiQm6D3VIgxjHKzi9mkIJVSPh+l7rhXb/2vMixHDyzlCx+y1xKVmGR
         fzmOVYcdp/QBlDlXli5PKN5MuiLazFWeqS7P7kh8DGk6JmvuQcR0TpA5zNV/ZHmaSj
         FXyQ3UEm51WjQaO/GxTRuA5pseGS+N009MUpO+HQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.4 08/22] drm/amd/display: fix ref count leak in amdgpu_drm_ioctl
Date:   Fri, 21 Aug 2020 12:20:00 -0400
Message-Id: <20200821162014.349506-8-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821162014.349506-1-sashal@kernel.org>
References: <20200821162014.349506-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 5509ac65f2fe5aa3c0003237ec629ca55024307c ]

in amdgpu_drm_ioctl the call to pm_runtime_get_sync increments the
counter even in case of failure, leading to incorrect
ref count. In case of failure, decrement the ref count before returning.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 8d6668cedf6db..eb3c54e1f1ca8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -443,11 +443,12 @@ long amdgpu_drm_ioctl(struct file *filp,
 	dev = file_priv->minor->dev;
 	ret = pm_runtime_get_sync(dev->dev);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	ret = drm_ioctl(filp, cmd, arg);
 
 	pm_runtime_mark_last_busy(dev->dev);
+out:
 	pm_runtime_put_autosuspend(dev->dev);
 	return ret;
 }
-- 
2.25.1

