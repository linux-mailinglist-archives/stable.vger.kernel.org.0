Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D906F1C793D
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 20:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729589AbgEFSTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 14:19:22 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:18982 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729334AbgEFSTW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 May 2020 14:19:22 -0400
Received: from localhost.localdomain ([93.23.14.107])
        by mwinf5d34 with ME
        id bWKD220022JbCfx03WKDzK; Wed, 06 May 2020 20:19:20 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 06 May 2020 20:19:20 +0200
X-ME-IP: 93.23.14.107
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     rpurdie@rpsys.net, adaplas@pol.net, b.zolnierkie@samsung.com,
        sam@ravnborg.org
Cc:     dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        stable@vger.kernel.org
Subject: [PATCH V2] video: fbdev: w100fb: Fix a potential double free.
Date:   Wed,  6 May 2020 20:19:02 +0200
Message-Id: <20200506181902.193290-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some memory is vmalloc'ed in the 'w100fb_save_vidmem' function and freed in
the 'w100fb_restore_vidmem' function. (these functions are called
respectively from the 'suspend' and the 'resume' functions)

However, it is also freed in the 'remove' function.

In order to avoid a potential double free, set the corresponding pointer
to NULL once freed in the 'w100fb_restore_vidmem' function.

Fixes: aac51f09d96a ("[PATCH] w100fb: Rewrite for platform independence")
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Antonino Daplas <adaplas@pol.net>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: <stable@vger.kernel.org> # v2.6.14+
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
v2: - Add Cc: tags
    - Reword the commit message to give the names of the functions that
      allocate and free the memory. These functions are called from the
      suspend and resume function.
---
 drivers/video/fbdev/w100fb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/fbdev/w100fb.c b/drivers/video/fbdev/w100fb.c
index 2d6e2738b792..d96ab28f8ce4 100644
--- a/drivers/video/fbdev/w100fb.c
+++ b/drivers/video/fbdev/w100fb.c
@@ -588,6 +588,7 @@ static void w100fb_restore_vidmem(struct w100fb_par *par)
 		memsize=par->mach->mem->size;
 		memcpy_toio(remapped_fbuf + (W100_FB_BASE-MEM_WINDOW_BASE), par->saved_extmem, memsize);
 		vfree(par->saved_extmem);
+		par->saved_extmem = NULL;
 	}
 	if (par->saved_intmem) {
 		memsize=MEM_INT_SIZE;
@@ -596,6 +597,7 @@ static void w100fb_restore_vidmem(struct w100fb_par *par)
 		else
 			memcpy_toio(remapped_fbuf + (W100_FB_BASE-MEM_WINDOW_BASE), par->saved_intmem, memsize);
 		vfree(par->saved_intmem);
+		par->saved_intmem = NULL;
 	}
 }
 
-- 
2.25.1

