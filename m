Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4ED2483D6
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 13:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgHRLbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 07:31:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726653AbgHRLac (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 07:30:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30E182075E;
        Tue, 18 Aug 2020 11:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597749772;
        bh=8oVMIev0mEl64EGhdFGy0jW2///3dhEt3/+C5T/XE7g=;
        h=Subject:To:From:Date:From;
        b=wmOLvhDXzUMiLG+Y7DD4rjYXYvrPqTwqIgG5uj2iDkNTScvJBFvwvU8UwSbYR+g0g
         mcuphhdwoqnhWpk9wvZWGGwZy8xe0UggczxW4o5dpvC6iGVqUbFB79lqeji2omNYnG
         EynC8y4oWEvJ2KQrQBcj+GzUv6Q2dMPjVMBp3ta8=
Subject: patch "vt_ioctl: change VT_RESIZEX ioctl to check for error return from" added to tty-linus
To:     george.kennedy@oracle.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Aug 2020 13:23:08 +0200
Message-ID: <159774978822578@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    vt_ioctl: change VT_RESIZEX ioctl to check for error return from

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From bc5269ca765057a1b762e79a1cfd267cd7bf1c46 Mon Sep 17 00:00:00 2001
From: George Kennedy <george.kennedy@oracle.com>
Date: Fri, 31 Jul 2020 12:33:12 -0400
Subject: vt_ioctl: change VT_RESIZEX ioctl to check for error return from
 vc_resize()

vc_resize() can return with an error after failure. Change VT_RESIZEX ioctl
to save struct vc_data values that are modified and restore the original
values in case of error.

Signed-off-by: George Kennedy <george.kennedy@oracle.com>
Cc: stable <stable@vger.kernel.org>
Reported-by: syzbot+38a3699c7eaf165b97a6@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/1596213192-6635-2-git-send-email-george.kennedy@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt_ioctl.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 91c301775047..a4e520bdd521 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -806,12 +806,22 @@ static int vt_resizex(struct vc_data *vc, struct vt_consize __user *cs)
 		console_lock();
 		vcp = vc_cons[i].d;
 		if (vcp) {
+			int ret;
+			int save_scan_lines = vcp->vc_scan_lines;
+			int save_font_height = vcp->vc_font.height;
+
 			if (v.v_vlin)
 				vcp->vc_scan_lines = v.v_vlin;
 			if (v.v_clin)
 				vcp->vc_font.height = v.v_clin;
 			vcp->vc_resize_user = 1;
-			vc_resize(vcp, v.v_cols, v.v_rows);
+			ret = vc_resize(vcp, v.v_cols, v.v_rows);
+			if (ret) {
+				vcp->vc_scan_lines = save_scan_lines;
+				vcp->vc_font.height = save_font_height;
+				console_unlock();
+				return ret;
+			}
 		}
 		console_unlock();
 	}
-- 
2.28.0


