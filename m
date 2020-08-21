Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D90124DCFB
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgHURKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:10:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728182AbgHUQRh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:17:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 759CC22CB1;
        Fri, 21 Aug 2020 16:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026648;
        bh=QVygOxjF5CurxzjPkJ/kTBJPINoegtQdrxSKD/OSCcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=om9i0C8LcM22d11scms8vmTsg5udEpmsjcqw5H6h9LYF0glXtRd8CNo/BIrcGqEay
         5RvOwyFZENXs7qllKm8hpyRL7Oi/xZAjuMt3KEzErLG4K21pZV1UFwtNvAarOQdlp4
         zYVMb0AoiFYGrZYzY2OsQf8IUzJkbEfNKdKu6SFs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 19/48] drm/amd/display: fix ref count leak in amdgpu_drm_ioctl
Date:   Fri, 21 Aug 2020 12:16:35 -0400
Message-Id: <20200821161704.348164-19-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161704.348164-1-sashal@kernel.org>
References: <20200821161704.348164-1-sashal@kernel.org>
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
index 05d114a72ca1e..fa2c0f29ad4de 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1286,11 +1286,12 @@ long amdgpu_drm_ioctl(struct file *filp,
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

