Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A2F3C5366
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352362AbhGLHyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350309AbhGLHut (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:50:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 243D5610D1;
        Mon, 12 Jul 2021 07:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075880;
        bh=0w42bEPFlwd3os7d1+1ip8tsGtaU20Wqpn0dgsynL+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CbAMdppxtjUMUFuSGOkrZNit4gyqdCam5RjmAJj2/EwMDRfiv/wj+9HDXxIWKdzFI
         zH8GHgOyJbr/COmHeqbhmh2GVuHEa1j/vGi8lxDXCJ3DzBbbpsgwy4KTzliTvc/wET
         O+NU+ASoX21BA8HNlh1PuJ5bsmK7iPb5rDOEFVC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
        Charmaine Lee <charmainel@vmware.com>,
        Roland Scheidegger <sroland@vmware.com>,
        Zack Rusin <zackr@vmware.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 404/800] drm/vmwgfx: Mark a surface gpu-dirty after the SVGA3dCmdDXGenMips command
Date:   Mon, 12 Jul 2021 08:07:07 +0200
Message-Id: <20210712061010.153732931@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Hellstrom <thellstrom@vmware.com>

[ Upstream commit 75156a887b6cea6e09d83ec19f4ebfd7c86265f0 ]

The SVGA3dCmdDXGenMips command uses a shader-resource view to access
the underlying surface. Normally accesses using that view-type are not
dirtying the underlying surface, but that particular command is an
exception.
Mark the surface gpu-dirty after a SVGA3dCmdDXGenMips command has been
submitted.

This fixes the piglit getteximage-formats test run with
SVGA_FORCE_COHERENT=1

Fixes: a9f58c456e9d ("drm/vmwgfx: Be more restrictive when dirtying resources")
Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Charmaine Lee <charmainel@vmware.com>
Reviewed-by: Roland Scheidegger <sroland@vmware.com>
Signed-off-by: Zack Rusin <zackr@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210505035740.286923-3-zackr@vmware.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index 7a24196f92c3..d6a6d8a3387a 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -2763,12 +2763,24 @@ static int vmw_cmd_dx_genmips(struct vmw_private *dev_priv,
 {
 	VMW_DECLARE_CMD_VAR(*cmd, SVGA3dCmdDXGenMips) =
 		container_of(header, typeof(*cmd), header);
-	struct vmw_resource *ret;
+	struct vmw_resource *view;
+	struct vmw_res_cache_entry *rcache;
 
-	ret = vmw_view_id_val_add(sw_context, vmw_view_sr,
-				  cmd->body.shaderResourceViewId);
+	view = vmw_view_id_val_add(sw_context, vmw_view_sr,
+				   cmd->body.shaderResourceViewId);
+	if (IS_ERR(view))
+		return PTR_ERR(view);
 
-	return PTR_ERR_OR_ZERO(ret);
+	/*
+	 * Normally the shader-resource view is not gpu-dirtying, but for
+	 * this particular command it is...
+	 * So mark the last looked-up surface, which is the surface
+	 * the view points to, gpu-dirty.
+	 */
+	rcache = &sw_context->res_cache[vmw_res_surface];
+	vmw_validation_res_set_dirty(sw_context->ctx, rcache->private,
+				     VMW_RES_DIRTY_SET);
+	return 0;
 }
 
 /**
-- 
2.30.2



