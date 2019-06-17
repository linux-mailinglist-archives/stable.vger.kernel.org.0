Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61B60493B6
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730230AbfFQV0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:26:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729021AbfFQV0e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:26:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42821206B7;
        Mon, 17 Jun 2019 21:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806793;
        bh=rTRSA2ixgXrIK32n3nUn99ovwkIyyyPn4BpR/+aI+fI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G+EkIXw/0cTNB+uDpJDZc7hSQvVLHzUy73SlBQKg17AdGR+9US/bmCpBpN6mCdsQ5
         jc6ATyvSIH8ewKufW4vnKGh5OkznLEfcf3d9CBHrbt3T4DUzUv7/3HptiR7iLe5iwa
         MHkCg/pHthXcp7Cis3bIApySNCEbcqm0XMT6O2w4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Murray McAllister <murray.mcallister@gmail.com>,
        Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH 4.19 58/75] drm/vmwgfx: NULL pointer dereference from vmw_cmd_dx_view_define()
Date:   Mon, 17 Jun 2019 23:10:09 +0200
Message-Id: <20190617210755.106215921@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Murray McAllister <murray.mcallister@gmail.com>

commit bcd6aa7b6cbfd6f985f606c6f76046d782905820 upstream.

If SVGA_3D_CMD_DX_DEFINE_RENDERTARGET_VIEW is called with a surface
ID of SVGA3D_INVALID_ID, the srf struct will remain NULL after
vmw_cmd_res_check(), leading to a null pointer dereference in
vmw_view_add().

Cc: <stable@vger.kernel.org>
Fixes: d80efd5cb3de ("drm/vmwgfx: Initial DX support")
Signed-off-by: Murray McAllister <murray.mcallister@gmail.com>
Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -2733,6 +2733,10 @@ static int vmw_cmd_dx_view_define(struct
 	if (view_type == vmw_view_max)
 		return -EINVAL;
 	cmd = container_of(header, typeof(*cmd), header);
+	if (unlikely(cmd->sid == SVGA3D_INVALID_ID)) {
+		DRM_ERROR("Invalid surface id.\n");
+		return -EINVAL;
+	}
 	ret = vmw_cmd_res_check(dev_priv, sw_context, vmw_res_surface,
 				user_surface_converter,
 				&cmd->sid, &srf_node);


