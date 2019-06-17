Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB1A2492CB
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729447AbfFQVXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:23:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729805AbfFQVXw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:23:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A188120861;
        Mon, 17 Jun 2019 21:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806632;
        bh=Opv/mSurQ8nj6sHht/tUxAYzrYb+iP1/XHfMYCvjMQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lj+pPv/gLGlckLr6KddC8qEpQV9U1FPhHbSor+QUmflQlgbL7cdHZsWYVdW/L8SDz
         FOw1tz+3iYE9zUMopMI5cNBiDiK9wNOyKCws7tlnDBYyb/ugdMY1AfmWVTBJ6wZpzV
         A3JnRyWN7KKFaIlvtghsMvKBh2mHHY+O06Cljx6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Murray McAllister <murray.mcallister@gmail.com>,
        Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH 5.1 095/115] drm/vmwgfx: integer underflow in vmw_cmd_dx_set_shader() leading to an invalid read
Date:   Mon, 17 Jun 2019 23:09:55 +0200
Message-Id: <20190617210804.767858738@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Murray McAllister <murray.mcallister@gmail.com>

commit 5ed7f4b5eca11c3c69e7c8b53e4321812bc1ee1e upstream.

If SVGA_3D_CMD_DX_SET_SHADER is called with a shader ID
of SVGA3D_INVALID_ID, and a shader type of
SVGA3D_SHADERTYPE_INVALID, the calculated binding.shader_slot
will be 4294967295, leading to an out-of-bounds read in vmw_binding_loc()
when the offset is calculated.

Cc: <stable@vger.kernel.org>
Fixes: d80efd5cb3de ("drm/vmwgfx: Initial DX support")
Signed-off-by: Murray McAllister <murray.mcallister@gmail.com>
Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -2351,7 +2351,8 @@ static int vmw_cmd_dx_set_shader(struct
 
 	cmd = container_of(header, typeof(*cmd), header);
 
-	if (cmd->body.type >= SVGA3D_SHADERTYPE_DX10_MAX) {
+	if (cmd->body.type >= SVGA3D_SHADERTYPE_DX10_MAX ||
+	    cmd->body.type < SVGA3D_SHADERTYPE_MIN) {
 		DRM_ERROR("Illegal shader type %u.\n",
 			  (unsigned) cmd->body.type);
 		return -EINVAL;


