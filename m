Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A122AB913
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730490AbgKINEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:04:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:57432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730743AbgKINEY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:04:24 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19AA120789;
        Mon,  9 Nov 2020 13:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927061;
        bh=jP88JYj8Z/AdPCNX+iDECNYYOP9MgaPxV5cN5R2kP8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hOXYe98vhoz8ULs4fl9XRqTPTzGeoQl2I2vrqXc8IC+zHZQUkDsbBgNbLK59afbHD
         kJbYRmndLeyeaFK77PvPpGSmPmIXNuDpRJq5pLCLxS1KIH+RdwpYoUCej45tZaDpj+
         L6IOrqUT2F42b2FAmwv4O5w9C7hexBhUMBSGKx7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minh Yuan <yuanmingbuaa@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jiri Slaby <jirislaby@kernel.org>, Greg KH <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 080/117] tty: make FONTX ioctl use the tty pointer they were actually passed
Date:   Mon,  9 Nov 2020 13:55:06 +0100
Message-Id: <20201109125029.484537118@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 90bfdeef83f1d6c696039b6a917190dcbbad3220 upstream.

Some of the font tty ioctl's always used the current foreground VC for
their operations.  Don't do that then.

This fixes a data race on fg_console.

Side note: both Michael Ellerman and Jiri Slaby point out that all these
ioctls are deprecated, and should probably have been removed long ago,
and everything seems to be using the KDFONTOP ioctl instead.

In fact, Michael points out that it looks like busybox's loadfont
program seems to have switched over to using KDFONTOP exactly _because_
of this bug (ahem.. 12 years ago ;-).

Reported-by: Minh Yuan <yuanmingbuaa@gmail.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Acked-by: Jiri Slaby <jirislaby@kernel.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/vt_ioctl.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -243,7 +243,7 @@ int vt_waitactive(int n)
 
 
 static inline int 
-do_fontx_ioctl(int cmd, struct consolefontdesc __user *user_cfd, int perm, struct console_font_op *op)
+do_fontx_ioctl(struct vc_data *vc, int cmd, struct consolefontdesc __user *user_cfd, int perm, struct console_font_op *op)
 {
 	struct consolefontdesc cfdarg;
 	int i;
@@ -261,15 +261,16 @@ do_fontx_ioctl(int cmd, struct consolefo
 		op->height = cfdarg.charheight;
 		op->charcount = cfdarg.charcount;
 		op->data = cfdarg.chardata;
-		return con_font_op(vc_cons[fg_console].d, op);
-	case GIO_FONTX: {
+		return con_font_op(vc, op);
+
+	case GIO_FONTX:
 		op->op = KD_FONT_OP_GET;
 		op->flags = KD_FONT_FLAG_OLD;
 		op->width = 8;
 		op->height = cfdarg.charheight;
 		op->charcount = cfdarg.charcount;
 		op->data = cfdarg.chardata;
-		i = con_font_op(vc_cons[fg_console].d, op);
+		i = con_font_op(vc, op);
 		if (i)
 			return i;
 		cfdarg.charheight = op->height;
@@ -277,7 +278,6 @@ do_fontx_ioctl(int cmd, struct consolefo
 		if (copy_to_user(user_cfd, &cfdarg, sizeof(struct consolefontdesc)))
 			return -EFAULT;
 		return 0;
-		}
 	}
 	return -EINVAL;
 }
@@ -927,7 +927,7 @@ int vt_ioctl(struct tty_struct *tty,
 		op.height = 0;
 		op.charcount = 256;
 		op.data = up;
-		ret = con_font_op(vc_cons[fg_console].d, &op);
+		ret = con_font_op(vc, &op);
 		break;
 	}
 
@@ -938,7 +938,7 @@ int vt_ioctl(struct tty_struct *tty,
 		op.height = 32;
 		op.charcount = 256;
 		op.data = up;
-		ret = con_font_op(vc_cons[fg_console].d, &op);
+		ret = con_font_op(vc, &op);
 		break;
 	}
 
@@ -955,7 +955,7 @@ int vt_ioctl(struct tty_struct *tty,
 
 	case PIO_FONTX:
 	case GIO_FONTX:
-		ret = do_fontx_ioctl(cmd, up, perm, &op);
+		ret = do_fontx_ioctl(vc, cmd, up, perm, &op);
 		break;
 
 	case PIO_FONTRESET:
@@ -972,11 +972,11 @@ int vt_ioctl(struct tty_struct *tty,
 		{
 		op.op = KD_FONT_OP_SET_DEFAULT;
 		op.data = NULL;
-		ret = con_font_op(vc_cons[fg_console].d, &op);
+		ret = con_font_op(vc, &op);
 		if (ret)
 			break;
 		console_lock();
-		con_set_default_unimap(vc_cons[fg_console].d);
+		con_set_default_unimap(vc);
 		console_unlock();
 		break;
 		}
@@ -1103,8 +1103,9 @@ struct compat_consolefontdesc {
 };
 
 static inline int
-compat_fontx_ioctl(int cmd, struct compat_consolefontdesc __user *user_cfd,
-			 int perm, struct console_font_op *op)
+compat_fontx_ioctl(struct vc_data *vc, int cmd,
+		   struct compat_consolefontdesc __user *user_cfd,
+		   int perm, struct console_font_op *op)
 {
 	struct compat_consolefontdesc cfdarg;
 	int i;
@@ -1122,7 +1123,8 @@ compat_fontx_ioctl(int cmd, struct compa
 		op->height = cfdarg.charheight;
 		op->charcount = cfdarg.charcount;
 		op->data = compat_ptr(cfdarg.chardata);
-		return con_font_op(vc_cons[fg_console].d, op);
+		return con_font_op(vc, op);
+
 	case GIO_FONTX:
 		op->op = KD_FONT_OP_GET;
 		op->flags = KD_FONT_FLAG_OLD;
@@ -1130,7 +1132,7 @@ compat_fontx_ioctl(int cmd, struct compa
 		op->height = cfdarg.charheight;
 		op->charcount = cfdarg.charcount;
 		op->data = compat_ptr(cfdarg.chardata);
-		i = con_font_op(vc_cons[fg_console].d, op);
+		i = con_font_op(vc, op);
 		if (i)
 			return i;
 		cfdarg.charheight = op->height;
@@ -1225,7 +1227,7 @@ long vt_compat_ioctl(struct tty_struct *
 	 */
 	case PIO_FONTX:
 	case GIO_FONTX:
-		ret = compat_fontx_ioctl(cmd, up, perm, &op);
+		ret = compat_fontx_ioctl(vc, cmd, up, perm, &op);
 		break;
 
 	case KDFONTOP:


