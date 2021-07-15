Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86693C9EA8
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 14:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhGOMe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 08:34:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229707AbhGOMe2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 08:34:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DBCA61380;
        Thu, 15 Jul 2021 12:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626352295;
        bh=WZjadpUPnUzwaJAeb9JRZozuUd/6VOusIk/PdR84wQA=;
        h=Subject:To:Cc:From:Date:From;
        b=Mads0FlGQtu6dEyuJZ11VCtppYGKTEOMUIItTCCJbxykGAr8ITKhTkSQZpg6y6lVZ
         mdK6YzJdQfCgu66IL6Rla9zcSJBaqDCyfK4fDJp45Erc/WTcHJXQJGwj6vzmH18BUE
         s5qimVvEmqZJSV19hhkZfBBGQI2PjPvCbrF9YMrQ=
Subject: FAILED: patch "[PATCH] drm/nouveau: Don't set allow_fb_modifiers explicitly" failed to apply to 5.4-stable tree
To:     daniel.vetter@ffwll.ch, bskeggs@redhat.com,
        daniel.vetter@intel.com, lyude@redhat.com,
        paul.kocialkowski@bootlin.com, pekka.paalanen@collabora.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 15 Jul 2021 14:28:31 +0200
Message-ID: <162635211117346@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cee93c028288b9af02919f3bd8593ba61d1e610d Mon Sep 17 00:00:00 2001
From: Daniel Vetter <daniel.vetter@ffwll.ch>
Date: Tue, 27 Apr 2021 11:20:16 +0200
Subject: [PATCH] drm/nouveau: Don't set allow_fb_modifiers explicitly

Since

commit 890880ddfdbe256083170866e49c87618b706ac7
Author: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Date:   Fri Jan 4 09:56:10 2019 +0100

    drm: Auto-set allow_fb_modifiers when given modifiers at plane init

this is done automatically as part of plane init, if drivers set the
modifier list correctly. Which is the case here.

Note that this fixes an inconsistency: We've set the cap everywhere,
but only nv50+ supports modifiers. Hence cc stable, but not further
back then the patch from Paul.

Reviewed-by: Lyude Paul <lyude@redhat.com>
Cc: stable@vger.kernel.org # v5.1 +
Cc: Pekka Paalanen <pekka.paalanen@collabora.com>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: nouveau@lists.freedesktop.org
Link: https://patchwork.freedesktop.org/patch/msgid/20210427092018.832258-6-daniel.vetter@ffwll.ch

diff --git a/drivers/gpu/drm/nouveau/nouveau_display.c b/drivers/gpu/drm/nouveau/nouveau_display.c
index 14101bd2a0ff..929de41c281f 100644
--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -697,7 +697,6 @@ nouveau_display_create(struct drm_device *dev)
 
 	dev->mode_config.preferred_depth = 24;
 	dev->mode_config.prefer_shadow = 1;
-	dev->mode_config.allow_fb_modifiers = true;
 
 	if (drm->client.device.info.chipset < 0x11)
 		dev->mode_config.async_page_flip = false;

