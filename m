Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D71404F1C
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346443AbhIIMRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:17:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:52736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350915AbhIIMOQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:14:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEF8461A65;
        Thu,  9 Sep 2021 11:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188152;
        bh=VK4cR/Kme6NffHumA+SnASBM6WDsCiW7w2C6aNEn0NE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aZ61KqUyNyPJD1Wqs1DEmh9s796FAAWSa5Wx1Zv4kiSiHVUxy4Sir1sTopAJLGUSO
         67BXHqj5HhQbYe7Be3BEwIvc8RJSdwylSTiRQaGWSGwV6jLVx2y7JjHbRLaKt8E5LV
         3rynVwjqKaQula4Zd4V5tNKJnLbuHpPmVBdvi90/jxLM+Lvy3BKN/ZW/9ixhOU7MKs
         7e1xT3E+98W9EY8Wjr5Yodjw9GtED6q/Xq+FCO2s4j0JOnj0cXfzzJSV6AaP3SFRaR
         LGA/8/Fe7GxIDEgp4JJXB57zrjO2NW10oZ+Bgh/W8/HZHA7Oxi4LSJMaNVaqzpIkJh
         9UgzUkqyEBMzw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Zack Rusin <zackr@vmware.com>, Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 121/219] drm/vmwgfx: fix potential UAF in vmwgfx_surface.c
Date:   Thu,  9 Sep 2021 07:44:57 -0400
Message-Id: <20210909114635.143983-121-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

