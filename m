Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3764051CE
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353625AbhIIMik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:38:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352920AbhIIMd5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:33:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDBA261B63;
        Thu,  9 Sep 2021 11:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188407;
        bh=vIOPACp0GIzwiZ78cHSgUvhPGpXcKbTs+u+stPp/E78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P3/LoZVn3GMDhnUyH6oJxwsjoAGkaIeRImJTOWZV5QbiIrTgoZLM6xriVTAsqdcEI
         L1WLmBJnreU+QsrfIb1bgSSDvI3i9da/W1bU3wNyq9wIzMRGT7g27wchB2rqleMzd1
         Kbqy1MRmRb7lo4FnmOvQ++nCNphru6cmj9/3wVLNddTcgzQEP2iEta6gGWWNTh2KRD
         BV/xJwX4bz++ooXNKkKrPKjuQ6n5NSyv7oGkgvxPPblIl/ZdhyBB3yXk+iiFRbmfP4
         CyhLfqyJAmlRYGiFqtKHk5XlukSdt+gJUpXppl9BJHq6OHNNXlvjN+KnSQLamUV4+d
         KNiVv1syTn/Tw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Zack Rusin <zackr@vmware.com>, Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 100/176] drm/vmwgfx: fix potential UAF in vmwgfx_surface.c
Date:   Thu,  9 Sep 2021 07:50:02 -0400
Message-Id: <20210909115118.146181-100-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
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
index f493b20c7a38..f1a51371de5b 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
@@ -866,7 +866,7 @@ int vmw_surface_define_ioctl(struct drm_device *dev, void *data,
 	user_srf->prime.base.shareable = false;
 	user_srf->prime.base.tfile = NULL;
 	if (drm_is_primary_client(file_priv))
-		user_srf->master = drm_master_get(file_priv->master);
+		user_srf->master = drm_file_get_master(file_priv);
 
 	/**
 	 * From this point, the generic resource management functions
@@ -1537,7 +1537,7 @@ vmw_gb_surface_define_internal(struct drm_device *dev,
 
 	user_srf = container_of(srf, struct vmw_user_surface, srf);
 	if (drm_is_primary_client(file_priv))
-		user_srf->master = drm_master_get(file_priv->master);
+		user_srf->master = drm_file_get_master(file_priv);
 
 	ret = ttm_read_lock(&dev_priv->reservation_sem, true);
 	if (unlikely(ret != 0))
-- 
2.30.2

