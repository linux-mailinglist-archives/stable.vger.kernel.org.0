Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC1FC34703
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 14:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbfFDMiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 08:38:52 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55473 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727398AbfFDMiw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 08:38:52 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 3224021F9F;
        Tue,  4 Jun 2019 08:38:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 04 Jun 2019 08:38:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=JOnk9i
        PThbLhjLeQXenf8DvfYMLvbMirKtC0aWNYUWw=; b=lF0chvbpwnse4FRHejxxYM
        sBHsSxC4kXypGfTZqJ17Er+PqlItpslU4p1yVp3fOZGYCxN/3BsuWpSonPuuUOQI
        M/MUN4q/Z/r01c2JhtDOXUFBu2t0fAnUEhU4bEkIOhv0X+doG+mfnimuxP9fXVU5
        qLDG3CeVloRUDncJCZF4ZCI4Jkmw02lriN9jeKAJ9hbskNIo8qldYq2cta138e40
        x38IKNq67sOZh1jcWUhKO3E/oxA42X4jT4obU87TAM+xTtaZV7My38L4A+lLKezR
        +dpQis+/ecv19IAtbXlhBXSr7RfnVoZ/3nT52VjC2GzR8OoJgqgsRkpCz0uynjWw
        ==
X-ME-Sender: <xms:W2b2XHVuOyVmjaN1qAFEqjPXiaE_ZeEt9ZwUeEiF_miyaVQEQFntrg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefledgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepie
X-ME-Proxy: <xmx:W2b2XEs8CxNmaQZ_oB1HEOqhOBfIWM9rGYtSccE619OgIV3IG4mP-A>
    <xmx:W2b2XKoXySImKM8gHdrSu1XutFJQ4vfXcs3wmc2Psn0fcTZ-_l79cg>
    <xmx:W2b2XJ6wR7Wt3BDs17Or4Hq7YwD8d3pb6kRvWDgDgXnazPaLQU9HvA>
    <xmx:W2b2XPTqPkCFBhPwW6ZEtid9cYKtI6Meq_yTS05dvEtkqzssv5LupA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 990D0380073;
        Tue,  4 Jun 2019 08:38:50 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/vmwgfx: integer underflow in vmw_cmd_dx_set_shader()" failed to apply to 4.19-stable tree
To:     murray.mcallister@gmail.com, stable@vger.kernel.org,
        thellstrom@vmware.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 04 Jun 2019 14:38:41 +0200
Message-ID: <155965192113519@kroah.com>
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

