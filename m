Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A20F3540963
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349661AbiFGSHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350503AbiFGSGG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:06:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820DB237D7;
        Tue,  7 Jun 2022 10:47:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 140E46172C;
        Tue,  7 Jun 2022 17:47:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27775C385A5;
        Tue,  7 Jun 2022 17:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624043;
        bh=6JLqq5nJsfk/fwyQoTCHxonMpl4UaSqujM40ft8+ZoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YB5hu5Gc8LoCzwYbkdK+rLtxtbN3CSgtM0yfMLvihL+fXd2bsEcwo5Z20jZeJlXF6
         jSSQa/qYR1aARPd2Jw2EkEb1GZVE+0qOE3q+yntKAM8yPN7ic7DRd8lZ3xrzvY3Giv
         g5bb0AW+fjq/jMYaxjdJS5fWT02u/ShwYEE97rYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zack Rusin <zackr@vmware.com>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Martin Krastev <krastevm@vmware.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 185/667] drm/vmwgfx: Fix an invalid read
Date:   Tue,  7 Jun 2022 18:57:30 +0200
Message-Id: <20220607164940.355852813@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zack Rusin <zackr@vmware.com>

[ Upstream commit 10a26e0d5fc3574f63ce8a6cf28381b126317f40 ]

vmw_move assumed that buffers to be moved would always be
vmw_buffer_object's but after introduction of new placement for mob
pages that's no longer the case.
The resulting invalid read didn't have any practical consequences
because the memory isn't used unless the object actually is a
vmw_buffer_object.
Fix it by moving the cast to the spot where the results are used.

Signed-off-by: Zack Rusin <zackr@vmware.com>
Fixes: f6be23264bba ("drm/vmwgfx: Introduce a new placement for MOB page tables")
Reported-by: Chuck Lever III <chuck.lever@oracle.com>
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Tested-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220318174332.440068-2-zack@kde.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
index 8d1e869cc196..34ab08369e04 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
@@ -862,22 +862,21 @@ void vmw_query_move_notify(struct ttm_buffer_object *bo,
 	struct ttm_device *bdev = bo->bdev;
 	struct vmw_private *dev_priv;
 
-
 	dev_priv = container_of(bdev, struct vmw_private, bdev);
 
 	mutex_lock(&dev_priv->binding_mutex);
 
-	dx_query_mob = container_of(bo, struct vmw_buffer_object, base);
-	if (!dx_query_mob || !dx_query_mob->dx_query_ctx) {
-		mutex_unlock(&dev_priv->binding_mutex);
-		return;
-	}
-
 	/* If BO is being moved from MOB to system memory */
 	if (new_mem->mem_type == TTM_PL_SYSTEM &&
 	    old_mem->mem_type == VMW_PL_MOB) {
 		struct vmw_fence_obj *fence;
 
+		dx_query_mob = container_of(bo, struct vmw_buffer_object, base);
+		if (!dx_query_mob || !dx_query_mob->dx_query_ctx) {
+			mutex_unlock(&dev_priv->binding_mutex);
+			return;
+		}
+
 		(void) vmw_query_readback_all(dx_query_mob);
 		mutex_unlock(&dev_priv->binding_mutex);
 
@@ -891,7 +890,6 @@ void vmw_query_move_notify(struct ttm_buffer_object *bo,
 		(void) ttm_bo_wait(bo, false, false);
 	} else
 		mutex_unlock(&dev_priv->binding_mutex);
-
 }
 
 /**
-- 
2.35.1



