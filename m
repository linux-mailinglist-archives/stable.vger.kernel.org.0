Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0DE346FC
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 14:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbfFDMhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 08:37:53 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:43127 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727726AbfFDMhw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 08:37:52 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C570F220BA;
        Tue,  4 Jun 2019 08:37:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 04 Jun 2019 08:37:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=BN89FS
        27q5fyUWZMDV8vThXWKSiKPHwC4CcQVUs3c2o=; b=5Sh4izO3j+Fiyj2dwoTa2E
        RK1caX80PGZ/XRBN8uEohhXCY4gMcQuMG3NdPUivVLxPOjLofINDMDc3+4hDD+IR
        HWcrE43cPUzo27RafUHDcohDwBkFwtYhO4XlpcHo8Ntr9jA63ciQ4rOhhTJ0U4uj
        viWULR0XQ8M5rBnGcW03/pamLXBqZf+F2JNe4S+osg8Dy/UjPZdjZOfh4O+avSZE
        rM+dtIP1djKg+Qm5BEb+82wGkhDZhaZHM0zFiNxqv6vrcYgfZNmRROD8ujAvn4PC
        q1AM+StT6i7suw2YSohyhgfQgD+07AY8KY9CWyGKEBclxzTGaCKrZLNgSV1sImFQ
        ==
X-ME-Sender: <xms:H2b2XLfLEW810U4ujSb6U6midvVdfzfHlD1fev1UXJ6M84W7_nIFxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefledgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:H2b2XLs9WWhOaAtg_kLVtI_yDbLZDug70IanHd7VzOA3nsa-HH4ZQw>
    <xmx:H2b2XBzr1FUfdafvUir-BCvIAi72O3GawZBBzez3k7N9TUkKql9pEw>
    <xmx:H2b2XOpTLUJH85jFPQa3GT4Nu-Z_bjYChQ-LTM0bI3uqOel3mO3BMw>
    <xmx:H2b2XDAWi00YOM4FxZw8rfy2ni_7Ep13dE-0cR1CwhbOsViz0nJiGA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 425C980066;
        Tue,  4 Jun 2019 08:37:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/vmwgfx: NULL pointer dereference from" failed to apply to 4.9-stable tree
To:     murray.mcallister@gmail.com, stable@vger.kernel.org,
        thellstrom@vmware.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 04 Jun 2019 14:37:40 +0200
Message-ID: <155965186019194@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bcd6aa7b6cbfd6f985f606c6f76046d782905820 Mon Sep 17 00:00:00 2001
From: Murray McAllister <murray.mcallister@gmail.com>
Date: Sat, 11 May 2019 18:01:37 +1200
Subject: [PATCH] drm/vmwgfx: NULL pointer dereference from
 vmw_cmd_dx_view_define()

If SVGA_3D_CMD_DX_DEFINE_RENDERTARGET_VIEW is called with a surface
ID of SVGA3D_INVALID_ID, the srf struct will remain NULL after
vmw_cmd_res_check(), leading to a null pointer dereference in
vmw_view_add().

Cc: <stable@vger.kernel.org>
Fixes: d80efd5cb3de ("drm/vmwgfx: Initial DX support")
Signed-off-by: Murray McAllister <murray.mcallister@gmail.com>
Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index 315f9efce765..b4c7553d2814 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -2427,6 +2427,10 @@ static int vmw_cmd_dx_view_define(struct vmw_private *dev_priv,
 		return -EINVAL;
 
 	cmd = container_of(header, typeof(*cmd), header);
+	if (unlikely(cmd->sid == SVGA3D_INVALID_ID)) {
+		VMW_DEBUG_USER("Invalid surface id.\n");
+		return -EINVAL;
+	}
 	ret = vmw_cmd_res_check(dev_priv, sw_context, vmw_res_surface,
 				VMW_RES_DIRTY_NONE, user_surface_converter,
 				&cmd->sid, &srf);

