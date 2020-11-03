Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7112A5374
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732451AbgKCVBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:01:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:37488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733059AbgKCVBJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:01:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06C4721534;
        Tue,  3 Nov 2020 21:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437268;
        bh=dV5HgVQ8i1v1jeoxbx40rf/N/s9JLAL6Hg+cjHksn3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aX39iwKlQ/EnYV5q3tas6nzMY8cMZl7KKEZbjrkgUXJJXdmE7gpve5a1+7HgupWzz
         vApGHlo6n2QLFeOPa0nMiaHnpcwy9k71tgNNyDEhY26/INJajlOA/PFcCjOgyWsOXk
         qNCkTkXXGhaiYY9cysNmHH8rvT8151BzUDdtmNWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minh Yuan <yuanmingbuaa@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jiri Slaby <jirislaby@kernel.org>, Greg KH <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 200/214] tty: make FONTX ioctl use the tty pointer they were actually passed
Date:   Tue,  3 Nov 2020 21:37:28 +0100
Message-Id: <20201103203309.375880823@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
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
@@ -244,7 +244,7 @@ int vt_waitactive(int n)
 
 
 static inline int 
-do_fontx_ioctl(int cmd, struct consolefontdesc __user *user_cfd, int perm, struct console_font_op *op)
+do_fontx_ioctl(struct vc_data *vc, int cmd, struct consolefontdesc __user *user_cfd, int perm, struct console_font_op *op)
 {
 	struct consolefontdesc cfdarg;
 	int i;
@@ -262,15 +262,16 @@ do_fontx_ioctl(int cmd, struct consolefo
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
@@ -278,7 +279,6 @@ do_fontx_ioctl(int cmd, struct consolefo
 		if (copy_to_user(user_cfd, &cfdarg, sizeof(struct consolefontdesc)))
 			return -EFAULT;
 		return 0;
-		}
 	}
 	return -EINVAL;
 }
@@ -924,7 +924,7 @@ int vt_ioctl(struct tty_struct *tty,
 		op.height = 0;
 		op.charcount = 256;
 		op.data = up;
-		ret = con_font_op(vc_cons[fg_console].d, &op);
+		ret = con_font_op(vc, &op);
 		break;
 	}
 
@@ -935,7 +935,7 @@ int vt_ioctl(struct tty_struct *tty,
 		op.height = 32;
 		op.charcount = 256;
 		op.data = up;
-		ret = con_font_op(vc_cons[fg_console].d, &op);
+		ret = con_font_op(vc, &op);
 		break;
 	}
 
@@ -952,7 +952,7 @@ int vt_ioctl(struct tty_struct *tty,
 
 	case PIO_FONTX:
 	case GIO_FONTX:
-		ret = do_fontx_ioctl(cmd, up, perm, &op);
+		ret = do_fontx_ioctl(vc, cmd, up, perm, &op);
 		break;
 
 	case PIO_FONTRESET:
@@ -969,11 +969,11 @@ int vt_ioctl(struct tty_struct *tty,
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
@@ -1100,8 +1100,9 @@ struct compat_consolefontdesc {
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
@@ -1119,7 +1120,8 @@ compat_fontx_ioctl(int cmd, struct compa
 		op->height = cfdarg.charheight;
 		op->charcount = cfdarg.charcount;
 		op->data = compat_ptr(cfdarg.chardata);
-		return con_font_op(vc_cons[fg_console].d, op);
+		return con_font_op(vc, op);
+
 	case GIO_FONTX:
 		op->op = KD_FONT_OP_GET;
 		op->flags = KD_FONT_FLAG_OLD;
@@ -1127,7 +1129,7 @@ compat_fontx_ioctl(int cmd, struct compa
 		op->height = cfdarg.charheight;
 		op->charcount = cfdarg.charcount;
 		op->data = compat_ptr(cfdarg.chardata);
-		i = con_font_op(vc_cons[fg_console].d, op);
+		i = con_font_op(vc, op);
 		if (i)
 			return i;
 		cfdarg.charheight = op->height;
@@ -1217,7 +1219,7 @@ long vt_compat_ioctl(struct tty_struct *
 	 */
 	case PIO_FONTX:
 	case GIO_FONTX:
-		return compat_fontx_ioctl(cmd, up, perm, &op);
+		return compat_fontx_ioctl(vc, cmd, up, perm, &op);
 
 	case KDFONTOP:
 		return compat_kdfontop_ioctl(up, perm, &op, vc);


