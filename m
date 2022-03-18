Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8A4B4DE030
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 18:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239433AbiCRRpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 13:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238668AbiCRRpP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 13:45:15 -0400
Received: from letterbox.kde.org (letterbox.kde.org [IPv6:2001:41c9:1:41e::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3272BA7778
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 10:43:55 -0700 (PDT)
Received: from vertex.localdomain (pool-108-36-85-85.phlapa.fios.verizon.net [108.36.85.85])
        (Authenticated sender: zack)
        by letterbox.kde.org (Postfix) with ESMTPSA id 8959428909B;
        Fri, 18 Mar 2022 17:43:51 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kde.org; s=users;
        t=1647625432; bh=Pq3m+BVAc4QHE9tP+/Vw24SFr8lOiJbCJYcCL0sQyGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XPGcKNX/p/6Nz7SUrgz317LYuM1TPHWmvGpXR5ge1jF7ZHic/B5bE4PHpl/wj1NoH
         D1mVTjdi2tW7O5TZwZ8QTR8i0Mmn/k20ySelQSGs9Xf4yQIX5vbenP2HT2qwpXOxtb
         57HA/V5wmXE3+lgh9ZjNZ2WwAYCHNrRJH6v70IrtixnArXBy14BvbN9yMGyu/jfiKD
         hGk1/stKO9lW9X3mlOwO7ThuVt0UYCN3eIvWDvdDuUC87+ASUmAhEcjRxevMTmPOs6
         E//PgsUYtKQdWrjSx/+R24LXjDhk8WAEXQC/FomZTUbl9dYuWYunCiTx3G0JsFJKl7
         hG92Zlp6s7vrw==
From:   Zack Rusin <zack@kde.org>
To:     dri-devel@lists.freedesktop.org
Cc:     krastevm@vmware.com, mombasawalam@vmware.com,
        Zack Rusin <zackr@vmware.com>, stable@vger.kernel.org
Subject: [PATCH 4/5] drm/vmwgfx: Disable command buffers on svga3 without gbobjects
Date:   Fri, 18 Mar 2022 13:43:31 -0400
Message-Id: <20220318174332.440068-5-zack@kde.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220318174332.440068-1-zack@kde.org>
References: <20220318174332.440068-1-zack@kde.org>
Reply-To: Zack Rusin <zackr@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zack Rusin <zackr@vmware.com>

With very limited vram on svga3 it's difficult to handle all the surface
migrations. Without gbobjects, i.e. the ability to store surfaces in
guest mobs, there's no reason to support intermediate svga2 features,
especially because we can fall back to fb traces and svga3 will never
support those in-between features.

On svga3 we wither want to use fb traces or screen targets
(i.e. gbobjects), nothing in between. This fixes presentation on a lot
of fusion/esxi tech previews where the exposed svga3 caps haven't been
finalized yet.

Signed-off-by: Zack Rusin <zackr@vmware.com>
Fixes: 2cd80dbd3551 ("drm/vmwgfx: Add basic support for SVGA3")
Cc: <stable@vger.kernel.org> # v5.14+
Reviewed-by: Martin Krastev <krastevm@vmware.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_cmd.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_cmd.c b/drivers/gpu/drm/vmwgfx/vmwgfx_cmd.c
index bf1b394753da..162dfeb1cc5a 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_cmd.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_cmd.c
@@ -675,11 +675,14 @@ int vmw_cmd_emit_dummy_query(struct vmw_private *dev_priv,
  */
 bool vmw_cmd_supported(struct vmw_private *vmw)
 {
-	if ((vmw->capabilities & (SVGA_CAP_COMMAND_BUFFERS |
-				  SVGA_CAP_CMD_BUFFERS_2)) != 0)
-		return true;
+	bool has_cmdbufs =
+		(vmw->capabilities & (SVGA_CAP_COMMAND_BUFFERS |
+				      SVGA_CAP_CMD_BUFFERS_2)) != 0;
+	if (vmw_is_svga_v3(vmw))
+		return (has_cmdbufs &&
+			(vmw->capabilities & SVGA_CAP_GBOBJECTS) != 0);
 	/*
 	 * We have FIFO cmd's
 	 */
-	return vmw->fifo_mem != NULL;
+	return has_cmdbufs || vmw->fifo_mem != NULL;
 }
-- 
2.32.0

