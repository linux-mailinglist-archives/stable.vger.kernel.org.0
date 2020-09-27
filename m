Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9413327A0D0
	for <lists+stable@lfdr.de>; Sun, 27 Sep 2020 14:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgI0MSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Sep 2020 08:18:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726185AbgI0MSO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Sep 2020 08:18:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDF2F2399C;
        Sun, 27 Sep 2020 12:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601209091;
        bh=eek+K2XzKXUS6iLr7oMV34m74Q28+vQUTMih1EiaEbI=;
        h=Subject:To:From:Date:From;
        b=H+GYAERTQT7h4U6JCkqNfDn6ng+AasNsFz2QhTV7lL3y+At9fv6mMvssV5uBM6X8f
         i319geiopkP6dNVi+RQezBxUdjEavPhtSWK6OcTVJQdqUMDIs22dR0hM80juIZSkVK
         svJw1cELYJYwYkzIjbVweX8rOBQD6sMOdXNTMHg8=
Subject: patch "vt_ioctl: make VT_RESIZEX behave like VT_RESIZE" added to tty-testing
To:     penguin-kernel@i-love.sakura.ne.jp, gregkh@linuxfoundation.org,
        penguin-kernel@I-love.SAKURA.ne.jp, stable@vger.kernel.org,
        syzbot+16469b5e8e5a72e9131e@syzkaller.appspotmail.com,
        syzbot+b308f5fd049fbbc6e74f@syzkaller.appspotmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Sep 2020 14:18:13 +0200
Message-ID: <160120909378237@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    vt_ioctl: make VT_RESIZEX behave like VT_RESIZE

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the tty-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 988d0763361bb65690d60e2bc53a6b72777040c3 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Date: Sun, 27 Sep 2020 20:46:30 +0900
Subject: vt_ioctl: make VT_RESIZEX behave like VT_RESIZE

syzbot is reporting UAF/OOB read at bit_putcs()/soft_cursor() [1][2], for
vt_resizex() from ioctl(VT_RESIZEX) allows setting font height larger than
actual font height calculated by con_font_set() from ioctl(PIO_FONT).
Since fbcon_set_font() from con_font_set() allocates minimal amount of
memory based on actual font height calculated by con_font_set(),
use of vt_resizex() can cause UAF/OOB read for font data.

VT_RESIZEX was introduced in Linux 1.3.3, but it is unclear that what
comes to the "+ more" part, and I couldn't find a user of VT_RESIZEX.

  #define VT_RESIZE   0x5609 /* set kernel's idea of screensize */
  #define VT_RESIZEX  0x560A /* set kernel's idea of screensize + more */

So far we are not aware of syzbot reports caused by setting non-zero value
to v_vlin parameter. But given that it is possible that nobody is using
VT_RESIZEX, we can try removing support for v_clin and v_vlin parameters.

Therefore, this patch effectively makes VT_RESIZEX behave like VT_RESIZE,
with emitting a message if somebody is still using v_clin and/or v_vlin
parameters.

[1] https://syzkaller.appspot.com/bug?id=32577e96d88447ded2d3b76d71254fb855245837
[2] https://syzkaller.appspot.com/bug?id=6b8355d27b2b94fb5cedf4655e3a59162d9e48e3

Reported-by: syzbot <syzbot+b308f5fd049fbbc6e74f@syzkaller.appspotmail.com>
Reported-by: syzbot <syzbot+16469b5e8e5a72e9131e@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/4933b81b-9b1a-355b-df0e-9b31e8280ab9@i-love.sakura.ne.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt_ioctl.c | 57 +++++++--------------------------------
 1 file changed, 10 insertions(+), 47 deletions(-)

diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 2ea76a09e07f..0a33b8ababe3 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -772,58 +772,21 @@ static int vt_resizex(struct vc_data *vc, struct vt_consize __user *cs)
 	if (copy_from_user(&v, cs, sizeof(struct vt_consize)))
 		return -EFAULT;
 
-	/* FIXME: Should check the copies properly */
-	if (!v.v_vlin)
-		v.v_vlin = vc->vc_scan_lines;
-
-	if (v.v_clin) {
-		int rows = v.v_vlin / v.v_clin;
-		if (v.v_rows != rows) {
-			if (v.v_rows) /* Parameters don't add up */
-				return -EINVAL;
-			v.v_rows = rows;
-		}
-	}
-
-	if (v.v_vcol && v.v_ccol) {
-		int cols = v.v_vcol / v.v_ccol;
-		if (v.v_cols != cols) {
-			if (v.v_cols)
-				return -EINVAL;
-			v.v_cols = cols;
-		}
-	}
-
-	if (v.v_clin > 32)
-		return -EINVAL;
+	if (v.v_vlin)
+		pr_info_once("\"struct vt_consize\"->v_vlin is ignored. Please report if you need this.\n");
+	if (v.v_clin)
+		pr_info_once("\"struct vt_consize\"->v_clin is ignored. Please report if you need this.\n");
 
+	console_lock();
 	for (i = 0; i < MAX_NR_CONSOLES; i++) {
-		struct vc_data *vcp;
+		vc = vc_cons[i].d;
 
-		if (!vc_cons[i].d)
-			continue;
-		console_lock();
-		vcp = vc_cons[i].d;
-		if (vcp) {
-			int ret;
-			int save_scan_lines = vcp->vc_scan_lines;
-			int save_font_height = vcp->vc_font.height;
-
-			if (v.v_vlin)
-				vcp->vc_scan_lines = v.v_vlin;
-			if (v.v_clin)
-				vcp->vc_font.height = v.v_clin;
-			vcp->vc_resize_user = 1;
-			ret = vc_resize(vcp, v.v_cols, v.v_rows);
-			if (ret) {
-				vcp->vc_scan_lines = save_scan_lines;
-				vcp->vc_font.height = save_font_height;
-				console_unlock();
-				return ret;
-			}
+		if (vc) {
+			vc->vc_resize_user = 1;
+			vc_resize(vc, v.v_cols, v.v_rows);
 		}
-		console_unlock();
 	}
+	console_unlock();
 
 	return 0;
 }
-- 
2.28.0


