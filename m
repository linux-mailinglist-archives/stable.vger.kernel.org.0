Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E1D2A57E9
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732391AbgKCVqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:46:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:46892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731982AbgKCUvf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:51:35 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EE0720719;
        Tue,  3 Nov 2020 20:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436694;
        bh=1tj8u2Tmffw8pUz/nV4pYbMINdDUfPE18tCYNPuaUcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NcWAILUiX6vZQ0xTYOfA417iwTwxiA90Bw99RerjlkZ4DUcjJmTgRLjuXsByysi5S
         Iw2HE7SlHH9Y5psv14vDG8UzmyHSrMzlQIy9abDtsMb70dLDzgoLkhjXQW60Ww5AfB
         jW7rvA+WaGoTuU0pnfbfTaMgWKFjwP4xIIkJMLWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minh Yuan <yuanmingbuaa@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jiri Slaby <jirislaby@kernel.org>, Greg KH <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.9 362/391] tty: make FONTX ioctl use the tty pointer they were actually passed
Date:   Tue,  3 Nov 2020 21:36:53 +0100
Message-Id: <20201103203411.569275318@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
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
 drivers/tty/vt/vt_ioctl.c |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -485,7 +485,7 @@ static int vt_k_ioctl(struct tty_struct
 	return 0;
 }
 
-static inline int do_fontx_ioctl(int cmd,
+static inline int do_fontx_ioctl(struct vc_data *vc, int cmd,
 		struct consolefontdesc __user *user_cfd,
 		struct console_font_op *op)
 {
@@ -503,15 +503,16 @@ static inline int do_fontx_ioctl(int cmd
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
@@ -519,12 +520,11 @@ static inline int do_fontx_ioctl(int cmd
 		if (copy_to_user(user_cfd, &cfdarg, sizeof(struct consolefontdesc)))
 			return -EFAULT;
 		return 0;
-		}
 	}
 	return -EINVAL;
 }
 
-static int vt_io_fontreset(struct console_font_op *op)
+static int vt_io_fontreset(struct vc_data *vc, struct console_font_op *op)
 {
 	int ret;
 
@@ -538,12 +538,12 @@ static int vt_io_fontreset(struct consol
 
 	op->op = KD_FONT_OP_SET_DEFAULT;
 	op->data = NULL;
-	ret = con_font_op(vc_cons[fg_console].d, op);
+	ret = con_font_op(vc, op);
 	if (ret)
 		return ret;
 
 	console_lock();
-	con_set_default_unimap(vc_cons[fg_console].d);
+	con_set_default_unimap(vc);
 	console_unlock();
 
 	return 0;
@@ -585,7 +585,7 @@ static int vt_io_ioctl(struct vc_data *v
 		op.height = 0;
 		op.charcount = 256;
 		op.data = up;
-		return con_font_op(vc_cons[fg_console].d, &op);
+		return con_font_op(vc, &op);
 
 	case GIO_FONT:
 		op.op = KD_FONT_OP_GET;
@@ -594,7 +594,7 @@ static int vt_io_ioctl(struct vc_data *v
 		op.height = 32;
 		op.charcount = 256;
 		op.data = up;
-		return con_font_op(vc_cons[fg_console].d, &op);
+		return con_font_op(vc, &op);
 
 	case PIO_CMAP:
                 if (!perm)
@@ -610,13 +610,13 @@ static int vt_io_ioctl(struct vc_data *v
 
 		fallthrough;
 	case GIO_FONTX:
-		return do_fontx_ioctl(cmd, up, &op);
+		return do_fontx_ioctl(vc, cmd, up, &op);
 
 	case PIO_FONTRESET:
 		if (!perm)
 			return -EPERM;
 
-		return vt_io_fontreset(&op);
+		return vt_io_fontreset(vc, &op);
 
 	case PIO_SCRNMAP:
 		if (!perm)
@@ -1067,8 +1067,9 @@ struct compat_consolefontdesc {
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
@@ -1086,7 +1087,8 @@ compat_fontx_ioctl(int cmd, struct compa
 		op->height = cfdarg.charheight;
 		op->charcount = cfdarg.charcount;
 		op->data = compat_ptr(cfdarg.chardata);
-		return con_font_op(vc_cons[fg_console].d, op);
+		return con_font_op(vc, op);
+
 	case GIO_FONTX:
 		op->op = KD_FONT_OP_GET;
 		op->flags = KD_FONT_FLAG_OLD;
@@ -1094,7 +1096,7 @@ compat_fontx_ioctl(int cmd, struct compa
 		op->height = cfdarg.charheight;
 		op->charcount = cfdarg.charcount;
 		op->data = compat_ptr(cfdarg.chardata);
-		i = con_font_op(vc_cons[fg_console].d, op);
+		i = con_font_op(vc, op);
 		if (i)
 			return i;
 		cfdarg.charheight = op->height;
@@ -1184,7 +1186,7 @@ long vt_compat_ioctl(struct tty_struct *
 	 */
 	case PIO_FONTX:
 	case GIO_FONTX:
-		return compat_fontx_ioctl(cmd, up, perm, &op);
+		return compat_fontx_ioctl(vc, cmd, up, perm, &op);
 
 	case KDFONTOP:
 		return compat_kdfontop_ioctl(up, perm, &op, vc);


