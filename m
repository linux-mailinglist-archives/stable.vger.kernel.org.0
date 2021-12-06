Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D145469EEE
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377453AbhLFPov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390607AbhLFPmf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F357C0698DC;
        Mon,  6 Dec 2021 07:29:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2A7C61316;
        Mon,  6 Dec 2021 15:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7270C34900;
        Mon,  6 Dec 2021 15:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804551;
        bh=lRMJ9yq44g1RdCNhmzwsoEovQk4Ez0831Ws4j4bs2Wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W7UNLqMsZDrMejKm+m/KYkKXpVd1yNLCORvAlMB7mVXHKxUVXRnt4TIquuS8/zM+0
         Y+b6V8u+RNEoEkVjpmWsa/121bTpW1mPpTV9rv0F4gjdgifT89Eofuy4a+4/kS5XZd
         5uoVtAZN3qYJD1vyoYGXNWhwrGMl2YW1mMRe2sic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wim Osterholt <wim@djo.tudelft.nl>,
        "Pavel V. Panteleev" <panteleev_p@mcst.ru>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH 5.15 188/207] vgacon: Propagate console boot parameters before calling `vc_resize
Date:   Mon,  6 Dec 2021 15:57:22 +0100
Message-Id: <20211206145616.784215577@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit 3dfac26e2ef29ff2abc2a75aa4cd48fce25a2c4b upstream.

Fix a division by zero in `vgacon_resize' with a backtrace like:

vgacon_resize
vc_do_resize
vgacon_init
do_bind_con_driver
do_unbind_con_driver
fbcon_fb_unbind
do_unregister_framebuffer
do_register_framebuffer
register_framebuffer
__drm_fb_helper_initial_config_and_unlock
drm_helper_hpd_irq_event
dw_hdmi_irq
irq_thread
kthread

caused by `c->vc_cell_height' not having been initialized.  This has
only started to trigger with commit 860dafa90259 ("vt: Fix character
height handling with VT_RESIZEX"), however the ultimate offender is
commit 50ec42edd978 ("[PATCH] Detaching fbcon: fix vgacon to allow
retaking of the console").

Said commit has added a call to `vc_resize' whenever `vgacon_init' is
called with the `init' argument set to 0, which did not happen before.
And the call is made before a key vgacon boot parameter retrieved in
`vgacon_startup' has been propagated in `vgacon_init' for `vc_resize' to
use to the console structure being worked on.  Previously the parameter
was `c->vc_font.height' and now it is `c->vc_cell_height'.

In this particular scenario the registration of fbcon has failed and vt
resorts to vgacon.  Now fbcon does have initialized `c->vc_font.height'
somehow, unlike `c->vc_cell_height', which is why this code did not
crash before, but either way the boot parameters should have been copied
to the console structure ahead of the call to `vc_resize' rather than
afterwards, so that first the call has a chance to use them and second
they do not change the console structure to something possibly different
from what was used by `vc_resize'.

Move the propagation of the vgacon boot parameters ahead of the call to
`vc_resize' then.  Adjust the comment accordingly.

Fixes: 50ec42edd978 ("[PATCH] Detaching fbcon: fix vgacon to allow retaking of the console")
Cc: stable@vger.kernel.org # v2.6.18+
Reported-by: Wim Osterholt <wim@djo.tudelft.nl>
Reported-by: Pavel V. Panteleev <panteleev_p@mcst.ru>
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2110252317110.58149@angie.orcam.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/console/vgacon.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -366,11 +366,17 @@ static void vgacon_init(struct vc_data *
 	struct uni_pagedir *p;
 
 	/*
-	 * We cannot be loaded as a module, therefore init is always 1,
-	 * but vgacon_init can be called more than once, and init will
-	 * not be 1.
+	 * We cannot be loaded as a module, therefore init will be 1
+	 * if we are the default console, however if we are a fallback
+	 * console, for example if fbcon has failed registration, then
+	 * init will be 0, so we need to make sure our boot parameters
+	 * have been copied to the console structure for vgacon_resize
+	 * ultimately called by vc_resize.  Any subsequent calls to
+	 * vgacon_init init will have init set to 0 too.
 	 */
 	c->vc_can_do_color = vga_can_do_color;
+	c->vc_scan_lines = vga_scan_lines;
+	c->vc_font.height = c->vc_cell_height = vga_video_font_height;
 
 	/* set dimensions manually if init != 0 since vc_resize() will fail */
 	if (init) {
@@ -379,8 +385,6 @@ static void vgacon_init(struct vc_data *
 	} else
 		vc_resize(c, vga_video_num_columns, vga_video_num_lines);
 
-	c->vc_scan_lines = vga_scan_lines;
-	c->vc_font.height = c->vc_cell_height = vga_video_font_height;
 	c->vc_complement_mask = 0x7700;
 	if (vga_512_chars)
 		c->vc_hi_font_mask = 0x0800;


