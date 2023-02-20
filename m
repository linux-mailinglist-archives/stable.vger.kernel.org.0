Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6014069CE74
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbjBTN7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232720AbjBTN7O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:59:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CA61EFDE
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:58:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38C9460E8A
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:58:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49062C4339B;
        Mon, 20 Feb 2023 13:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901533;
        bh=H55/Ryaf3b36bZ0CSG+pxFpvsm0Iwt2EmiPiN1occ/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qDbQMSI5BYYCUSW1y2nXZ75Rabi3qgMm2gLNnxNQUpbzCPgXFqnzNqmbKCIYGuFeQ
         WB5Oegf1mUJEugsma8zzXyJg+bFrXSym9bx3Fedmd0egaBwZwQ7BaGc3m6kARDLlv1
         eXs1689flat7l4v6pVrwyx0gjh3z7nXz+Kv0E/MI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zack Rusin <zackr@vmware.com>,
        Maaz Mombasawala <mombasawalam@vmware.com>,
        Martin Krastev <krastevm@vmware.com>
Subject: [PATCH 6.1 053/118] drm/vmwgfx: Stop accessing buffer objects which failed init
Date:   Mon, 20 Feb 2023 14:36:09 +0100
Message-Id: <20230220133602.581304005@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

commit 1a6897921f52ceb2c8665ef826e405bd96385159 upstream.

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
Reviewed-by: Maaz Mombasawala <mombasawalam@vmware.com>
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230208180050.2093426-1-zack@kde.org
(cherry picked from commit 36d421e632e9a0e8375eaed0143551a34d81a7e3)
Cc: <stable@vger.kernel.org> # v5.17+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c  | 4 +++-
 drivers/gpu/drm/vmwgfx/vmwgfx_gem.c | 4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
index aa1cd5126a32..53da183e2bfe 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
@@ -462,6 +462,9 @@ int vmw_bo_create(struct vmw_private *vmw,
 		return -ENOMEM;
 	}
 
+	/*
+	 * vmw_bo_init will delete the *p_bo object if it fails
+	 */
 	ret = vmw_bo_init(vmw, *p_bo, size,
 			  placement, interruptible, pin,
 			  bo_free);
@@ -470,7 +473,6 @@ int vmw_bo_create(struct vmw_private *vmw,
 
 	return ret;
 out_error:
-	kfree(*p_bo);
 	*p_bo = NULL;
 	return ret;
 }
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c b/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
index ce609e7d758f..83d8f18cc16f 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
@@ -146,11 +146,11 @@ int vmw_gem_object_create_with_handle(struct vmw_private *dev_priv,
 				    &vmw_sys_placement :
 				    &vmw_vram_sys_placement,
 			    true, false, &vmw_gem_destroy, p_vbo);
-
-	(*p_vbo)->base.base.funcs = &vmw_gem_object_funcs;
 	if (ret != 0)
 		goto out_no_bo;
 
+	(*p_vbo)->base.base.funcs = &vmw_gem_object_funcs;
+
 	ret = drm_gem_handle_create(filp, &(*p_vbo)->base.base, handle);
 	/* drop reference from allocate - handle holds it now */
 	drm_gem_object_put(&(*p_vbo)->base.base);
-- 
2.39.1



