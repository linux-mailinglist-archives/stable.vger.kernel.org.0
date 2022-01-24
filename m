Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D47749A383
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2368263AbiAXX6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1846131AbiAXXOa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:14:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55802C06176A;
        Mon, 24 Jan 2022 13:23:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E8ABB8105C;
        Mon, 24 Jan 2022 21:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390B6C340E4;
        Mon, 24 Jan 2022 21:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059401;
        bh=6xvV/GFUTTbXguNm6jo1qvCc+irsly4Qs2GXu5oETWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nK/ebRQaPOnh0FR5f4BetNJ6LJHAVowJIeBiAjObhg9yIqermBih771VvJL6VSIqZ
         XZoYkfBCkXCRC/xlvXuFBzZIt3jCqMXNsjlEnzOgSa0hs821zkdS6bviCQnqbJ+4T4
         bMsQZpBVh6zmx07soLfCbUKiFJXNmvmcq2ubf0pg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zack Rusin <zackr@vmware.com>,
        Martin Krastev <krastevm@vmware.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0603/1039] drm/vmwgfx: Release ttm memory if probe fails
Date:   Mon, 24 Jan 2022 19:39:52 +0100
Message-Id: <20220124184145.605920205@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zack Rusin <zackr@vmware.com>

[ Upstream commit 28b5f3b6121b7db2a44be499cfca0b6b801588b6 ]

The ttm mem global state was leaking if the vmwgfx driver load failed.

In case of a driver load failure we have to make sure we also release
the ttm mem global state.

Signed-off-by: Zack Rusin <zackr@vmware.com>
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211105193845.258816-3-zackr@vmware.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index bfd71c86faa58..68f46f9e032dd 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -1617,34 +1617,40 @@ static int vmw_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ret = drm_aperture_remove_conflicting_pci_framebuffers(pdev, &driver);
 	if (ret)
-		return ret;
+		goto out_error;
 
 	ret = pcim_enable_device(pdev);
 	if (ret)
-		return ret;
+		goto out_error;
 
 	vmw = devm_drm_dev_alloc(&pdev->dev, &driver,
 				 struct vmw_private, drm);
-	if (IS_ERR(vmw))
-		return PTR_ERR(vmw);
+	if (IS_ERR(vmw)) {
+		ret = PTR_ERR(vmw);
+		goto out_error;
+	}
 
 	pci_set_drvdata(pdev, &vmw->drm);
 
 	ret = ttm_mem_global_init(&ttm_mem_glob, &pdev->dev);
 	if (ret)
-		return ret;
+		goto out_error;
 
 	ret = vmw_driver_load(vmw, ent->device);
 	if (ret)
-		return ret;
+		goto out_release;
 
 	ret = drm_dev_register(&vmw->drm, 0);
-	if (ret) {
-		vmw_driver_unload(&vmw->drm);
-		return ret;
-	}
+	if (ret)
+		goto out_unload;
 
 	return 0;
+out_unload:
+	vmw_driver_unload(&vmw->drm);
+out_release:
+	ttm_mem_global_release(&ttm_mem_glob);
+out_error:
+	return ret;
 }
 
 static int __init vmwgfx_init(void)
-- 
2.34.1



