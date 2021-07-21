Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804953D0CFB
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 13:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235424AbhGUKQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 06:16:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239002AbhGUKBn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Jul 2021 06:01:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB80961009;
        Wed, 21 Jul 2021 10:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626864128;
        bh=f51bf7ScK9jN7XnyGwgVdlPyyuIzZuzZJOxILPTPQY0=;
        h=Subject:To:From:Date:From;
        b=K2dBoHLrY+0Qq/wh6qUkPbNm+eDhkGdypv9i+8vfdLqc38OINulGipcAq/J41WESj
         7DL8qWicZQoZNTBLnC4OR+5xt0Z0ZYEEaVJRIfZt1yfg+ppl1fWeeBrm6KaW4YatNG
         Iwc2kgmRty4OGwaDfP8pr1GWuCQdz9dU4hPdjx2Y=
Subject: patch "tty: Fix out-of-bound vmalloc access in imageblit" added to tty-testing
To:     igormtorrente@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 21 Jul 2021 12:41:58 +0200
Message-ID: <1626864118165226@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: Fix out-of-bound vmalloc access in imageblit

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the tty-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 3b0c406124719b625b1aba431659f5cdc24a982c Mon Sep 17 00:00:00 2001
From: Igor Matheus Andrade Torrente <igormtorrente@gmail.com>
Date: Mon, 28 Jun 2021 10:45:09 -0300
Subject: tty: Fix out-of-bound vmalloc access in imageblit

This issue happens when a userspace program does an ioctl
FBIOPUT_VSCREENINFO passing the fb_var_screeninfo struct
containing only the fields xres, yres, and bits_per_pixel
with values.

If this struct is the same as the previous ioctl, the
vc_resize() detects it and doesn't call the resize_screen(),
leaving the fb_var_screeninfo incomplete. And this leads to
the updatescrollmode() calculates a wrong value to
fbcon_display->vrows, which makes the real_y() return a
wrong value of y, and that value, eventually, causes
the imageblit to access an out-of-bound address value.

To solve this issue I made the resize_screen() be called
even if the screen does not need any resizing, so it will
"fix and fill" the fb_var_screeninfo independently.

Cc: stable <stable@vger.kernel.org> # after 5.15-rc2 is out, give it time to bake
Reported-and-tested-by: syzbot+858dc7a2f7ef07c2c219@syzkaller.appspotmail.com
Signed-off-by: Igor Matheus Andrade Torrente <igormtorrente@gmail.com>
Link: https://lore.kernel.org/r/20210628134509.15895-1-igormtorrente@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index ef981d3b7bb4..484eda1958f5 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1219,8 +1219,25 @@ static int vc_do_resize(struct tty_struct *tty, struct vc_data *vc,
 	new_row_size = new_cols << 1;
 	new_screen_size = new_row_size * new_rows;
 
-	if (new_cols == vc->vc_cols && new_rows == vc->vc_rows)
-		return 0;
+	if (new_cols == vc->vc_cols && new_rows == vc->vc_rows) {
+		/*
+		 * This function is being called here to cover the case
+		 * where the userspace calls the FBIOPUT_VSCREENINFO twice,
+		 * passing the same fb_var_screeninfo containing the fields
+		 * yres/xres equal to a number non-multiple of vc_font.height
+		 * and yres_virtual/xres_virtual equal to number lesser than the
+		 * vc_font.height and yres/xres.
+		 * In the second call, the struct fb_var_screeninfo isn't
+		 * being modified by the underlying driver because of the
+		 * if above, and this causes the fbcon_display->vrows to become
+		 * negative and it eventually leads to out-of-bound
+		 * access by the imageblit function.
+		 * To give the correct values to the struct and to not have
+		 * to deal with possible errors from the code below, we call
+		 * the resize_screen here as well.
+		 */
+		return resize_screen(vc, new_cols, new_rows, user);
+	}
 
 	if (new_screen_size > KMALLOC_MAX_SIZE || !new_screen_size)
 		return -EINVAL;
-- 
2.32.0


