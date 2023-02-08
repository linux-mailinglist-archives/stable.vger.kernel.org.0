Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACEF968F6A7
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 19:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbjBHSLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 13:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbjBHSLO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 13:11:14 -0500
X-Greylist: delayed 594 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 08 Feb 2023 10:10:53 PST
Received: from letterbox.kde.org (letterbox.kde.org [46.43.1.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3C1C14F
        for <stable@vger.kernel.org>; Wed,  8 Feb 2023 10:10:52 -0800 (PST)
Received: from vertex.localdomain (pool-173-49-113-140.phlapa.fios.verizon.net [173.49.113.140])
        (Authenticated sender: zack)
        by letterbox.kde.org (Postfix) with ESMTPSA id 249BA3204CB;
        Wed,  8 Feb 2023 18:00:55 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kde.org; s=users;
        t=1675879255; bh=rFBMKazwj9Lurn1cPPUSGZczAcpzPaIz4CyNt9XqYUs=;
        h=From:To:Cc:Subject:Date:From;
        b=byO9V/IazNcp+49Smh7++ZYRtZLaWpJtvoooK5BDXtLm/u976A+iorlWqXA5vsMG6
         0OeXEiZGD2Bwq6KevYXdHQShKtt6RAXhLGdRxUzAGrNC6IsFibeVzVO0i13UDdgIi5
         PJBfKq37fe3Z14VDNjewtn/+Oqq1F7TxJc81CTJBkJVv9L3TVMSZfMaqyqvOJmwv9s
         oZ13qNJOPubzPa7PY25Wxzwhmj68zXxSLcuL4gUjyFcqIBZP3rP/yUA9tPvzBkHmv1
         /M5Piqb3436YJt6JMTgs2CMstNj08wKVjuks1YdleCV445toMVijf082Gs3cQMG5bJ
         3inJmZDw9RaSQ==
From:   Zack Rusin <zack@kde.org>
To:     dri-devel@lists.freedesktop.org
Cc:     krastevm@vmware.com, mombasawalam@vmware.com, banackm@vmware.com,
        Zack Rusin <zackr@vmware.com>, stable@vger.kernel.org
Subject: [PATCH] drm/vmwgfx: Stop accessing buffer objects which failed init
Date:   Wed,  8 Feb 2023 13:00:50 -0500
Message-Id: <20230208180050.2093426-1-zack@kde.org>
X-Mailer: git-send-email 2.38.1
Reply-To: Zack Rusin <zackr@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zack Rusin <zackr@vmware.com>

ttm_bo_init_reserved on failure puts the buffer object back which
causes it to be deleted, but kfree was still being called on the same
buffer in vmw_bo_create leading to a double free.

After the double free the vmw_gem_object_create_with_handle was
setting the gem function objects before checking the return status
of vmw_bo_create leading to null pointer access.

Fix the entire path by relaying on ttm_bo_init_reserved to delete the
buffer objects on failure and making sure the return status is checked
before setting the gem function objects on the buffer object.

Signed-off-by: Zack Rusin <zackr@vmware.com>
Fixes: 8afa13a0583f ("drm/vmwgfx: Implement DRIVER_GEM")
Cc: <stable@vger.kernel.org> # v5.17+
---
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c  | 4 +++-
 drivers/gpu/drm/vmwgfx/vmwgfx_gem.c | 4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
index 63486802c8fd..43ffa5c7acbd 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
@@ -431,13 +431,15 @@ int vmw_bo_create(struct vmw_private *vmw,
 		return -ENOMEM;
 	}
 
+	/*
+	 * vmw_bo_init will delete the *p_bo object if it fails
+	 */
 	ret = vmw_bo_init(vmw, *p_bo, params, vmw_bo_free);
 	if (unlikely(ret != 0))
 		goto out_error;
 
 	return ret;
 out_error:
-	kfree(*p_bo);
 	*p_bo = NULL;
 	return ret;
 }
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c b/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
index f042e22b8b59..51bd1f8c5cc4 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
@@ -127,11 +127,11 @@ int vmw_gem_object_create_with_handle(struct vmw_private *dev_priv,
 	};
 
 	ret = vmw_bo_create(dev_priv, &params, p_vbo);
-
-	(*p_vbo)->tbo.base.funcs = &vmw_gem_object_funcs;
 	if (ret != 0)
 		goto out_no_bo;
 
+	(*p_vbo)->tbo.base.funcs = &vmw_gem_object_funcs;
+
 	ret = drm_gem_handle_create(filp, &(*p_vbo)->tbo.base, handle);
 	/* drop reference from allocate - handle holds it now */
 	drm_gem_object_put(&(*p_vbo)->tbo.base);
-- 
2.38.1

