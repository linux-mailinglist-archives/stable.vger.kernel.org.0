Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B373D346FD
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 14:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbfFDMhy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 08:37:54 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52677 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727726AbfFDMhy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 08:37:54 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8421B2203E;
        Tue,  4 Jun 2019 08:37:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 04 Jun 2019 08:37:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=rLb5xB
        hES41vA3fp/y9lYRa3To68PL9QlyQR7K/GvFc=; b=nl/9E9scJoawyOUwdF7oLx
        6jpFmemJ3kmfxZhV5+mijpS5bEGSo0C6Lwew5lif8UowlmrSUkrr7kHxFuUQe1+H
        7cDmezqrlDd0fTBzT09PVzNDfdedafgYivWX68qCKAg56ah1RaUvWLa0fTJun8Ay
        qDTVQKySXPDha2fYfqTrtdYqr3Y6ICdbMEyNXL/N6vxeY9whUUMOMPiI81CAWnTd
        xbuybJgwEVqvtFAZSPnWpKYwSDQLMoj05J8QjvowKO0bSvkcZHlINN9vAVKTQ5L4
        GmKVr24YOOuxDLb3P2WYwxl2Rvy69LyrBM4WdKpriP7IiNbd8PB8ChLSGPZ2quKw
        ==
X-ME-Sender: <xms:IWb2XDehIs3gatgtFawMVfH-ijv0h-pp4NOwxPStIwugVsn5_WCpOA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefledgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:IWb2XElBN2KVLBJB1NSrwGoHuiNdUxFd75TGi30wvVlvuXriu58A9w>
    <xmx:IWb2XKRk4gIdevIsXGw3jDH-6dfnmUSayBQ4EvdXjZOE16oOmzXjcw>
    <xmx:IWb2XLdoL274uomEfLXnEFS5og9VVrkYDRdfD-h8xr8-hKYLFidEFA>
    <xmx:IWb2XE8sFykh1ZYzqufefeQvU7vPAy-O8epa_BPdenRbEctbvNs1BA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EA6AF380084;
        Tue,  4 Jun 2019 08:37:52 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/vmwgfx: NULL pointer dereference from" failed to apply to 4.19-stable tree
To:     murray.mcallister@gmail.com, stable@vger.kernel.org,
        thellstrom@vmware.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 04 Jun 2019 14:37:40 +0200
Message-ID: <1559651860221118@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

