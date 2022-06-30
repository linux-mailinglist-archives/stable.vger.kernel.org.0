Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78995561C05
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 15:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235717AbiF3Nvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235434AbiF3NvK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:51:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0C440E6D;
        Thu, 30 Jun 2022 06:49:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 70CB9CE2EB9;
        Thu, 30 Jun 2022 13:49:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60FD6C3411E;
        Thu, 30 Jun 2022 13:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656596947;
        bh=SX5d9fc7xezRnx6EdzirEA4WlPsJIus5S0oM8iz9u9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MVOk2WUkETMMkEi6kxzQ060QS1Z3sJhWZOFNlzWp2Ucpdmlux9jBpdUM0AlW76iOo
         +JjNtGD8mbPrpH9DO/uh1Foajs2B4dBJwzXHkZcHk4AvJ8v/VHhHT0bq3BTs7x5wZB
         JoG/nUAujkZigEMUauQm3cIvqAhwhTJC+pXdA1lM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        guodaxing <guodaxing@huawei.com>
Subject: [PATCH 4.14 01/35] vt: drop old FONT ioctls
Date:   Thu, 30 Jun 2022 15:46:12 +0200
Message-Id: <20220630133232.480167082@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133232.433955678@linuxfoundation.org>
References: <20220630133232.433955678@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

commit ff2047fb755d4415ec3c70ac799889371151796d upstream.

Drop support for these ioctls:
* PIO_FONT, PIO_FONTX
* GIO_FONT, GIO_FONTX
* PIO_FONTRESET

As was demonstrated by commit 90bfdeef83f1 (tty: make FONTX ioctl use
the tty pointer they were actually passed), these ioctls are not used
from userspace, as:
1) they used to be broken (set up font on current console, not the open
   one) and racy (before the commit above)
2) KDFONTOP ioctl is used for years instead

Note that PIO_FONTRESET is defunct on most systems as VGA_CONSOLE is set
on them for ages. That turns on BROKEN_GRAPHICS_PROGRAMS which makes
PIO_FONTRESET just return an error.

We are removing KD_FONT_FLAG_OLD here as it was used only by these
removed ioctls. kd.h header exists both in kernel and uapi headers, so
we can remove the kernel one completely. Everyone includeing kd.h will
now automatically get the uapi one.

There are now unused definitions of the ioctl numbers and "struct
consolefontdesc" in kd.h, but as it is a uapi header, I am not touching
these.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20210105120239.28031-8-jslaby@suse.cz
Cc: guodaxing <guodaxing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c       |   34 ----------
 drivers/tty/vt/vt_ioctl.c |  149 ----------------------------------------------
 include/linux/kd.h        |    8 --
 3 files changed, 3 insertions(+), 188 deletions(-)
 delete mode 100644 include/linux/kd.h

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -4132,16 +4132,8 @@ static int con_font_get(struct vc_data *
 
 	if (op->data && font.charcount > op->charcount)
 		rc = -ENOSPC;
-	if (!(op->flags & KD_FONT_FLAG_OLD)) {
-		if (font.width > op->width || font.height > op->height) 
-			rc = -ENOSPC;
-	} else {
-		if (font.width != 8)
-			rc = -EIO;
-		else if ((op->height && font.height > op->height) ||
-			 font.height > 32)
-			rc = -ENOSPC;
-	}
+	if (font.width > op->width || font.height > op->height)
+		rc = -ENOSPC;
 	if (rc)
 		goto out;
 
@@ -4169,27 +4161,7 @@ static int con_font_set(struct vc_data *
 		return -EINVAL;
 	if (op->charcount > 512)
 		return -EINVAL;
-	if (!op->height) {		/* Need to guess font height [compat] */
-		int h, i;
-		u8 __user *charmap = op->data;
-		u8 tmp;
-		
-		/* If from KDFONTOP ioctl, don't allow things which can be done in userland,
-		   so that we can get rid of this soon */
-		if (!(op->flags & KD_FONT_FLAG_OLD))
-			return -EINVAL;
-		for (h = 32; h > 0; h--)
-			for (i = 0; i < op->charcount; i++) {
-				if (get_user(tmp, &charmap[32*i+h-1]))
-					return -EFAULT;
-				if (tmp)
-					goto nonzero;
-			}
-		return -EINVAL;
-	nonzero:
-		op->height = h;
-	}
-	if (op->width <= 0 || op->width > 32 || op->height > 32)
+	if (op->width <= 0 || op->width > 32 || !op->height || op->height > 32)
 		return -EINVAL;
 	size = (op->width+7)/8 * 32 * op->charcount;
 	if (size > max_font_size)
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -241,48 +241,6 @@ int vt_waitactive(int n)
 #define GPLAST 0x3df
 #define GPNUM (GPLAST - GPFIRST + 1)
 
-
-
-static inline int 
-do_fontx_ioctl(struct vc_data *vc, int cmd, struct consolefontdesc __user *user_cfd, int perm, struct console_font_op *op)
-{
-	struct consolefontdesc cfdarg;
-	int i;
-
-	if (copy_from_user(&cfdarg, user_cfd, sizeof(struct consolefontdesc))) 
-		return -EFAULT;
- 	
-	switch (cmd) {
-	case PIO_FONTX:
-		if (!perm)
-			return -EPERM;
-		op->op = KD_FONT_OP_SET;
-		op->flags = KD_FONT_FLAG_OLD;
-		op->width = 8;
-		op->height = cfdarg.charheight;
-		op->charcount = cfdarg.charcount;
-		op->data = cfdarg.chardata;
-		return con_font_op(vc, op);
-
-	case GIO_FONTX:
-		op->op = KD_FONT_OP_GET;
-		op->flags = KD_FONT_FLAG_OLD;
-		op->width = 8;
-		op->height = cfdarg.charheight;
-		op->charcount = cfdarg.charcount;
-		op->data = cfdarg.chardata;
-		i = con_font_op(vc, op);
-		if (i)
-			return i;
-		cfdarg.charheight = op->height;
-		cfdarg.charcount = op->charcount;
-		if (copy_to_user(user_cfd, &cfdarg, sizeof(struct consolefontdesc)))
-			return -EFAULT;
-		return 0;
-	}
-	return -EINVAL;
-}
-
 static inline int 
 do_unimap_ioctl(int cmd, struct unimapdesc __user *user_ud, int perm, struct vc_data *vc)
 {
@@ -919,30 +877,6 @@ int vt_ioctl(struct tty_struct *tty,
 		break;
 	}
 
-	case PIO_FONT: {
-		if (!perm)
-			return -EPERM;
-		op.op = KD_FONT_OP_SET;
-		op.flags = KD_FONT_FLAG_OLD | KD_FONT_FLAG_DONT_RECALC;	/* Compatibility */
-		op.width = 8;
-		op.height = 0;
-		op.charcount = 256;
-		op.data = up;
-		ret = con_font_op(vc, &op);
-		break;
-	}
-
-	case GIO_FONT: {
-		op.op = KD_FONT_OP_GET;
-		op.flags = KD_FONT_FLAG_OLD;
-		op.width = 8;
-		op.height = 32;
-		op.charcount = 256;
-		op.data = up;
-		ret = con_font_op(vc, &op);
-		break;
-	}
-
 	case PIO_CMAP:
                 if (!perm)
 			ret = -EPERM;
@@ -954,36 +888,6 @@ int vt_ioctl(struct tty_struct *tty,
                 ret = con_get_cmap(up);
 		break;
 
-	case PIO_FONTX:
-	case GIO_FONTX:
-		ret = do_fontx_ioctl(vc, cmd, up, perm, &op);
-		break;
-
-	case PIO_FONTRESET:
-	{
-		if (!perm)
-			return -EPERM;
-
-#ifdef BROKEN_GRAPHICS_PROGRAMS
-		/* With BROKEN_GRAPHICS_PROGRAMS defined, the default
-		   font is not saved. */
-		ret = -ENOSYS;
-		break;
-#else
-		{
-		op.op = KD_FONT_OP_SET_DEFAULT;
-		op.data = NULL;
-		ret = con_font_op(vc, &op);
-		if (ret)
-			break;
-		console_lock();
-		con_set_default_unimap(vc);
-		console_unlock();
-		break;
-		}
-#endif
-	}
-
 	case KDFONTOP: {
 		if (copy_from_user(&op, up, sizeof(op))) {
 			ret = -EFAULT;
@@ -1097,54 +1001,6 @@ void vc_SAK(struct work_struct *work)
 
 #ifdef CONFIG_COMPAT
 
-struct compat_consolefontdesc {
-	unsigned short charcount;       /* characters in font (256 or 512) */
-	unsigned short charheight;      /* scan lines per character (1-32) */
-	compat_caddr_t chardata;	/* font data in expanded form */
-};
-
-static inline int
-compat_fontx_ioctl(struct vc_data *vc, int cmd,
-		   struct compat_consolefontdesc __user *user_cfd,
-		   int perm, struct console_font_op *op)
-{
-	struct compat_consolefontdesc cfdarg;
-	int i;
-
-	if (copy_from_user(&cfdarg, user_cfd, sizeof(struct compat_consolefontdesc)))
-		return -EFAULT;
-
-	switch (cmd) {
-	case PIO_FONTX:
-		if (!perm)
-			return -EPERM;
-		op->op = KD_FONT_OP_SET;
-		op->flags = KD_FONT_FLAG_OLD;
-		op->width = 8;
-		op->height = cfdarg.charheight;
-		op->charcount = cfdarg.charcount;
-		op->data = compat_ptr(cfdarg.chardata);
-		return con_font_op(vc, op);
-
-	case GIO_FONTX:
-		op->op = KD_FONT_OP_GET;
-		op->flags = KD_FONT_FLAG_OLD;
-		op->width = 8;
-		op->height = cfdarg.charheight;
-		op->charcount = cfdarg.charcount;
-		op->data = compat_ptr(cfdarg.chardata);
-		i = con_font_op(vc, op);
-		if (i)
-			return i;
-		cfdarg.charheight = op->height;
-		cfdarg.charcount = op->charcount;
-		if (copy_to_user(user_cfd, &cfdarg, sizeof(struct compat_consolefontdesc)))
-			return -EFAULT;
-		return 0;
-	}
-	return -EINVAL;
-}
-
 struct compat_console_font_op {
 	compat_uint_t op;        /* operation code KD_FONT_OP_* */
 	compat_uint_t flags;     /* KD_FONT_FLAG_* */
@@ -1222,11 +1078,6 @@ long vt_compat_ioctl(struct tty_struct *
 	/*
 	 * these need special handlers for incompatible data structures
 	 */
-	case PIO_FONTX:
-	case GIO_FONTX:
-		ret = compat_fontx_ioctl(vc, cmd, up, perm, &op);
-		break;
-
 	case KDFONTOP:
 		ret = compat_kdfontop_ioctl(up, perm, &op, vc);
 		break;
--- a/include/linux/kd.h
+++ /dev/null
@@ -1,8 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _LINUX_KD_H
-#define _LINUX_KD_H
-
-#include <uapi/linux/kd.h>
-
-#define KD_FONT_FLAG_OLD		0x80000000	/* Invoked via old interface [compat] */
-#endif /* _LINUX_KD_H */


