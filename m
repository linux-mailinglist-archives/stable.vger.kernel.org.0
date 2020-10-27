Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDCB29C2B5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1808754AbgJ0Riu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:38:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760298AbgJ0Oe2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:34:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 343D020709;
        Tue, 27 Oct 2020 14:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809267;
        bh=ukGCmKdVlfLX/vv05S5i6v0UWlpxKaL8OxClYG3OUNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gh2nnahRJGTUPnp/A1pAp1/AoOE3NcHMjdFKlpEZOXQ/oT96pLVuQNOlLFHgEuf5c
         pLCrhZ07eo6VcLJtcSPiybGtUcVhGJsgEhcJZI+xgxjPMDUwTRXT6onCyZrEK71Brl
         T9kFFHS9Z/tFsoIqckAo5F7zkptzzggl1k98n0a4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 135/408] video: fbdev: vga16fb: fix setting of pixclock because a pass-by-value error
Date:   Tue, 27 Oct 2020 14:51:13 +0100
Message-Id: <20201027135501.360734345@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit c72fab81ceaa54408b827a2f0486d9a0f4be34cf ]

The pixclock is being set locally because it is being passed as a
pass-by-value argument rather than pass-by-reference, so the computed
pixclock is never being set in var->pixclock. Fix this by passing
by reference.

[This dates back to 2002, I found the offending commit from the git
history git://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git ]

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jani Nikula <jani.nikula@intel.com>
[b.zolnierkie: minor patch summary fixup]
[b.zolnierkie: removed "Fixes:" tag (not in upstream tree)]
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200723170227.996229-1-colin.king@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/vga16fb.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/video/fbdev/vga16fb.c b/drivers/video/fbdev/vga16fb.c
index 4b83109202b1c..3c4d20618de4c 100644
--- a/drivers/video/fbdev/vga16fb.c
+++ b/drivers/video/fbdev/vga16fb.c
@@ -243,7 +243,7 @@ static void vga16fb_update_fix(struct fb_info *info)
 }
 
 static void vga16fb_clock_chip(struct vga16fb_par *par,
-			       unsigned int pixclock,
+			       unsigned int *pixclock,
 			       const struct fb_info *info,
 			       int mul, int div)
 {
@@ -259,14 +259,14 @@ static void vga16fb_clock_chip(struct vga16fb_par *par,
 		{     0 /* bad */,    0x00, 0x00}};
 	int err;
 
-	pixclock = (pixclock * mul) / div;
+	*pixclock = (*pixclock * mul) / div;
 	best = vgaclocks;
-	err = pixclock - best->pixclock;
+	err = *pixclock - best->pixclock;
 	if (err < 0) err = -err;
 	for (ptr = vgaclocks + 1; ptr->pixclock; ptr++) {
 		int tmp;
 
-		tmp = pixclock - ptr->pixclock;
+		tmp = *pixclock - ptr->pixclock;
 		if (tmp < 0) tmp = -tmp;
 		if (tmp < err) {
 			err = tmp;
@@ -275,7 +275,7 @@ static void vga16fb_clock_chip(struct vga16fb_par *par,
 	}
 	par->misc |= best->misc;
 	par->clkdiv = best->seq_clock_mode;
-	pixclock = (best->pixclock * div) / mul;		
+	*pixclock = (best->pixclock * div) / mul;
 }
 			       
 #define FAIL(X) return -EINVAL
@@ -497,10 +497,10 @@ static int vga16fb_check_var(struct fb_var_screeninfo *var,
 
 	if (mode & MODE_8BPP)
 		/* pixel clock == vga clock / 2 */
-		vga16fb_clock_chip(par, var->pixclock, info, 1, 2);
+		vga16fb_clock_chip(par, &var->pixclock, info, 1, 2);
 	else
 		/* pixel clock == vga clock */
-		vga16fb_clock_chip(par, var->pixclock, info, 1, 1);
+		vga16fb_clock_chip(par, &var->pixclock, info, 1, 1);
 	
 	var->red.offset = var->green.offset = var->blue.offset = 
 	var->transp.offset = 0;
-- 
2.25.1



