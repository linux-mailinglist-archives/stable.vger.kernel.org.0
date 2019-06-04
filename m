Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE99F346FB
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 14:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbfFDMhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 08:37:52 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:38405 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727723AbfFDMhw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 08:37:52 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E6B2321FC1;
        Tue,  4 Jun 2019 08:37:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 04 Jun 2019 08:37:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=FT6P+0
        1rCT5mMs83i5CbYq0RBA9Pve3Gb65hB/r4I4A=; b=YqIT1NJQZMayVniH+OSK0c
        NUo+F0xGtSIECRr/p09AuYrPHf+foVhFiyamuDwgUPVy6DLh3+nPgwsLm5Q8bS+V
        OG/lCcnmmxfQLgRBEIS1fjP7/G3a6YH1mqBf96Gx/VZFDIs9OSrkQGnaD49RxlvI
        5iwM4qye6JPe77WRte/4rTHxN4XJAsq5oTVRHsWl1JPeWc/4/DRXxWglAKw/4IG2
        l8a81B7hMZW6qhfApYGnnQxIVeonROmDTNQ1JzGVpI43diDC/lIeBVDoLA/auMOc
        M5fFe4avqZtlW6Ugq5hp5wY5ZXLuTzuoMI+cRxvrH8xYNheDQ+8VnLUor8BwWGRg
        ==
X-ME-Sender: <xms:HWb2XASWBDN-xagkwiEzVEKb5c5BUaJeScY5VigyOlPbZFWKKjlUcA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefledgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:HWb2XLJu6_EuI4p7Myx2eICa7blyhB2AIvZOc5muyP5nUDoSXv6YPw>
    <xmx:HWb2XJ0CrMMD1XAdgCzzcHy-EC00uUMvof9n35Yzgk-gAmrRITxi6Q>
    <xmx:HWb2XHutHAv4ZSoWPgx8WPkMKdyHOAs8nzRST2sWAqehzIm9lSHwgQ>
    <xmx:Hmb2XEsRDP0sTUTTkCeSLJmSTsDg6QIkvZGegH6JGppjlksSfpH-Ig>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6A64C380084;
        Tue,  4 Jun 2019 08:37:49 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/vmwgfx: NULL pointer dereference from" failed to apply to 4.14-stable tree
To:     murray.mcallister@gmail.com, stable@vger.kernel.org,
        thellstrom@vmware.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 04 Jun 2019 14:37:40 +0200
Message-ID: <155965186089208@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

