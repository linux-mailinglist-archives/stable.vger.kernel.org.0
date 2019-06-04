Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1E5C34702
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 14:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfFDMio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 08:38:44 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36985 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727398AbfFDMio (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 08:38:44 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8041E2211E;
        Tue,  4 Jun 2019 08:38:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 04 Jun 2019 08:38:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xXmP8P
        o5bWOwhROr+tH/towX1v4/3epz57mcuxUFdhQ=; b=C7L/b1UkCvM92uGJhDPtgR
        kvEHaBx4r6HLYT2zu0tbywt7whkdE23ypiXThxdv/RVkunU71F0y2o8vSO6pZcKQ
        8N+2P8ffox4eysRe3qRkUYLhAu/ueqhCViaqXiZZrPC+MXOq1zwY4iuZwr6ZLqty
        LqmSdzQGAyNOpT1vjM+KVIt/cXJOzlkiUmfh363epZiRlSaWCjJG3jhk1ttOXKCr
        ZKzZEUKeOSd4UqnApYTJBENNtkkD36phW1SNVDt0mLCwhqgasJK2dKRXwWwrzxsU
        7TpLxJ7hR6Ac/L+4DbYgUFNCzB1MLmqp7phv6EiNCSwPRlvfnMpo0UHgDp18z/7A
        ==
X-ME-Sender: <xms:U2b2XE_orjIi1QU231-kG9stcBh10ufIiZYz1JWHjLNzBrClsRb6Ng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefledgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgephe
X-ME-Proxy: <xmx:U2b2XO-PSGGTVio4eQnLQgBch32Khr6y1nqCmQmYAiGjYtGkTlDI4A>
    <xmx:U2b2XKEhya1RbAK9LKA31JUrFZkmlqw2pV1TwQliiPvstEdERkJtDg>
    <xmx:U2b2XNb99n1dGbBTvNHHvg4UZEoVu7c9DFBYD-6SScQbyM8YIlf0YQ>
    <xmx:U2b2XESZmAvqnAFAONcuG7uhM8m--lddRUi7ICG2zQUKm2_bGnLtpA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DF5B8380073;
        Tue,  4 Jun 2019 08:38:42 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/vmwgfx: integer underflow in vmw_cmd_dx_set_shader()" failed to apply to 5.1-stable tree
To:     murray.mcallister@gmail.com, stable@vger.kernel.org,
        thellstrom@vmware.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 04 Jun 2019 14:38:41 +0200
Message-ID: <155965192124263@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5ed7f4b5eca11c3c69e7c8b53e4321812bc1ee1e Mon Sep 17 00:00:00 2001
From: Murray McAllister <murray.mcallister@gmail.com>
Date: Mon, 20 May 2019 21:57:34 +1200
Subject: [PATCH] drm/vmwgfx: integer underflow in vmw_cmd_dx_set_shader()
 leading to an invalid read

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

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index b4c7553d2814..33533d126277 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -2206,7 +2206,8 @@ static int vmw_cmd_dx_set_shader(struct vmw_private *dev_priv,
 
 	cmd = container_of(header, typeof(*cmd), header);
 
-	if (cmd->body.type >= SVGA3D_SHADERTYPE_DX10_MAX) {
+	if (cmd->body.type >= SVGA3D_SHADERTYPE_DX10_MAX ||
+	    cmd->body.type < SVGA3D_SHADERTYPE_MIN) {
 		VMW_DEBUG_USER("Illegal shader type %u.\n",
 			       (unsigned int) cmd->body.type);
 		return -EINVAL;

