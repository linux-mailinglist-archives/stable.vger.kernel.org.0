Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40E8740E3DC
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344227AbhIPQwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:52:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345722AbhIPQuj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:50:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D9B960F92;
        Thu, 16 Sep 2021 16:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809707;
        bh=VK4cR/Kme6NffHumA+SnASBM6WDsCiW7w2C6aNEn0NE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rncbJjnw+ebnm3l3boW9pBPAsAr8Rz1cbtOA8fNVP+CssVV28DXixUTYqxzjgXgAA
         CwFRqMPzHo7YLwtf4DwLD9QALsWX1b31G+jCALMNTfnoT7y0nb59nRpOlnwBF0neYu
         TYU3TBf37U/gaPTWDvGwhUeqUpoDXyPl5G+WSKXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Zack Rusin <zackr@vmware.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 254/380] drm/vmwgfx: fix potential UAF in vmwgfx_surface.c
Date:   Thu, 16 Sep 2021 18:00:11 +0200
Message-Id: <20210916155812.722015456@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>

[ Upstream commit 2bc5da528dd570c5ecabc107e6fbdbc55974276f ]

drm_file.master should be protected by either drm_device.master_mutex
or drm_file.master_lookup_lock when being dereferenced. However,
drm_master_get is called on unprotected file_priv->master pointers in
vmw_surface_define_ioctl and vmw_gb_surface_define_internal.

This is fixed by replacing drm_master_get with drm_file_get_master.

Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Zack Rusin <zackr@vmware.com>
Signed-off-by: Zack Rusin <zackr@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210724111824.59266-4-desmondcheongzx@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
index 5ff88f8c2382..0c62cd400b64 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
@@ -869,7 +869,7 @@ int vmw_surface_define_ioctl(struct drm_device *dev, void *data,
 	user_srf->prime.base.shareable = false;
 	user_srf->prime.base.tfile = NULL;
 	if (drm_is_primary_client(file_priv))
-		user_srf->master = drm_master_get(file_priv->master);
+		user_srf->master = drm_file_get_master(file_priv);
 
 	/**
 	 * From this point, the generic resource management functions
@@ -1540,7 +1540,7 @@ vmw_gb_surface_define_internal(struct drm_device *dev,
 
 	user_srf = container_of(srf, struct vmw_user_surface, srf);
 	if (drm_is_primary_client(file_priv))
-		user_srf->master = drm_master_get(file_priv->master);
+		user_srf->master = drm_file_get_master(file_priv);
 
 	ret = ttm_read_lock(&dev_priv->reservation_sem, true);
 	if (unlikely(ret != 0))
-- 
2.30.2



