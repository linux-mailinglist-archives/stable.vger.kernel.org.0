Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9D0346FE
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 14:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbfFDMh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 08:37:56 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:44563 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727403AbfFDMh4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 08:37:56 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 55C7A2203E;
        Tue,  4 Jun 2019 08:37:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 04 Jun 2019 08:37:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=rXcNhe
        bL6XeA2ObVKjhfvytKUD/TYUVQPS0XDvDckiY=; b=JVCG2cDuyKjxueXl+q9iEB
        0d+AKX/mHzAljmWC1kfBdKXx5qCVe4rQ81V5Nl8EHZRnTDJvqllWsD6jOZOrsGIb
        CGjeGVJ68F7ACHl3/PQ7eMXk4bpcEcIQHSKDGf/ZKtuKdydlxkHu6tXL15urwVKp
        C6Mgz9sbqxeCq5y0w+eimwuY/25QhRCXuPeXMRap7K0gpGEGE6QhXEBeUMxgHqwU
        yJNPUHoZugzsb69DUvaj5TfzrP7Ve3h5VkA7xLy3zt1/T8iEDEEJOY33bzuwFdZn
        /OEzYIJcqXfP+Sq7tzokpVdV7ST9ihb1vUEMWqtm87ake31PB6tLryLxyMkAk9Hw
        ==
X-ME-Sender: <xms:I2b2XHFt3JzMHd4i74g1OiRvl86n81mRWELgPLpHfjroxXrlHqrKAw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefledgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:I2b2XCw861MexGzi352OgHwvUrIHtQm_62bW0p0j1gsRwG6oPfMC7w>
    <xmx:I2b2XLzWl-ONXPrUaDlD04fRlajNqqYwXEtAAkWoTzVrmbqoaDo_Iw>
    <xmx:I2b2XAZsWFp5AGBdwLBzPPoPUHrH64-auia9lNOVBRjYtU2GJlT31Q>
    <xmx:I2b2XLc9D37nQUjxtvjEB1M8SyUhi0OrFHhiYPHTysjt4jGUDD89Qg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B90D2380085;
        Tue,  4 Jun 2019 08:37:54 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/vmwgfx: NULL pointer dereference from" failed to apply to 4.4-stable tree
To:     murray.mcallister@gmail.com, stable@vger.kernel.org,
        thellstrom@vmware.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 04 Jun 2019 14:37:41 +0200
Message-ID: <155965186186230@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

