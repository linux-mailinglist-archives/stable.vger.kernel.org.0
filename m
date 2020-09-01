Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDBD259D0E
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbgIARXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:23:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726938AbgIAPLz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:11:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5414206FA;
        Tue,  1 Sep 2020 15:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973115;
        bh=C7bVzpJYNpCcGkw/lD3GW24TGIEe2rkig+cs8hTpVxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dSFW8/59L8JZBTxi+nFMEUaoQSzNBhHrum1Nk6YbJHCamWgm4jQqEQiDaYMaIrUNm
         6A5ZQ5ShrMS4hWWeBq8+GzR0VlvWC0Zj8s6PwPFdW9EolVdLpJ3Cd4ckGNaAPLmymK
         RCNSfc7mvHJ6COOaEdH4t1T5t2QC7xGH9ipS7QmY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 13/62] drm/amdgpu: fix ref count leak in amdgpu_driver_open_kms
Date:   Tue,  1 Sep 2020 17:09:56 +0200
Message-Id: <20200901150921.358358547@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150920.697676718@linuxfoundation.org>
References: <20200901150920.697676718@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 9ba8923cbbe11564dd1bf9f3602add9a9cfbb5c6 ]

in amdgpu_driver_open_kms the call to pm_runtime_get_sync increments the
counter even in case of failure, leading to incorrect
ref count. In case of failure, decrement the ref count before returning.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
index 5bf98f0195fbd..6025c69871a86 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -522,7 +522,7 @@ int amdgpu_driver_open_kms(struct drm_device *dev, struct drm_file *file_priv)
 
 	r = pm_runtime_get_sync(dev->dev);
 	if (r < 0)
-		return r;
+		goto pm_put;
 
 	fpriv = kzalloc(sizeof(*fpriv), GFP_KERNEL);
 	if (unlikely(!fpriv))
@@ -540,6 +540,7 @@ int amdgpu_driver_open_kms(struct drm_device *dev, struct drm_file *file_priv)
 	file_priv->driver_priv = fpriv;
 
 	pm_runtime_mark_last_busy(dev->dev);
+pm_put:
 	pm_runtime_put_autosuspend(dev->dev);
 	return 0;
 
-- 
2.25.1



