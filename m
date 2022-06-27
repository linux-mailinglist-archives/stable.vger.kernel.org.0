Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7B955D039
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbiF0LW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234006AbiF0LW5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:22:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55926564;
        Mon, 27 Jun 2022 04:22:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DDC7B8111B;
        Mon, 27 Jun 2022 11:22:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B54C3411D;
        Mon, 27 Jun 2022 11:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656328973;
        bh=druKfQQ+iUN1XRcWMiMVcNBVPlu4Pe1u/VFp5Krf1fY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T8XRBtp9XAVnXN+J0nySToyJJHPF23enjpccj1V+IoI/cHX9/Jz36/bn6I0X2AdNm
         El7SHUEEv1pVLADYsIkymmtdTqyVZ5VUVpffxatFc3f0Mdy7d1YUdjISrAiFn6sLcz
         nPX8PlNdYhLFRBdwhdFN8/3A8T34pCrpX0j1mh3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        guodaxing <guodaxing@huawei.com>
Subject: [PATCH 5.10 001/102] vt: drop old FONT ioctls
Date:   Mon, 27 Jun 2022 13:20:12 +0200
Message-Id: <20220627111933.501674990@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
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
 drivers/tty/vt/vt.c       |   39 -----------
 drivers/tty/vt/vt_ioctl.c |  151 ----------------------------------------------
 include/linux/kd.h        |    8 --
 3 files changed, 3 insertions(+), 195 deletions(-)
 delete mode 100644 include/linux/kd.h

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -4625,16 +4625,8 @@ static int con_font_get(struct vc_data *
 
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
 
@@ -4662,7 +4654,7 @@ static int con_font_set(struct vc_data *
 		return -EINVAL;
 	if (op->charcount > 512)
 		return -EINVAL;
-	if (op->width <= 0 || op->width > 32 || op->height > 32)
+	if (op->width <= 0 || op->width > 32 || !op->height || op->height > 32)
 		return -EINVAL;
 	size = (op->width+7)/8 * 32 * op->charcount;
 	if (size > max_font_size)
@@ -4672,31 +4664,6 @@ static int con_font_set(struct vc_data *
 	if (IS_ERR(font.data))
 		return PTR_ERR(font.data);
 
-	if (!op->height) {		/* Need to guess font height [compat] */
-		int h, i;
-		u8 *charmap = font.data;
-
-		/*
-		 * If from KDFONTOP ioctl, don't allow things which can be done
-		 * in userland,so that we can get rid of this soon
-		 */
-		if (!(op->flags & KD_FONT_FLAG_OLD)) {
-			kfree(font.data);
-			return -EINVAL;
-		}
-
-		for (h = 32; h > 0; h--)
-			for (i = 0; i < op->charcount; i++)
-				if (charmap[32*i+h-1])
-					goto nonzero;
-
-		kfree(font.data);
-		return -EINVAL;
-
-	nonzero:
-		op->height = h;
-	}
-
 	font.charcount = op->charcount;
 	font.width = op->width;
 	font.height = op->height;
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -486,70 +486,6 @@ static int vt_k_ioctl(struct tty_struct
 	return 0;
 }
 
-static inline int do_fontx_ioctl(struct vc_data *vc, int cmd,
-		struct consolefontdesc __user *user_cfd,
-		struct console_font_op *op)
-{
-	struct consolefontdesc cfdarg;
-	int i;
-
-	if (copy_from_user(&cfdarg, user_cfd, sizeof(struct consolefontdesc)))
-		return -EFAULT;
-
-	switch (cmd) {
-	case PIO_FONTX:
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
-static int vt_io_fontreset(struct vc_data *vc, struct console_font_op *op)
-{
-	int ret;
-
-	if (__is_defined(BROKEN_GRAPHICS_PROGRAMS)) {
-		/*
-		 * With BROKEN_GRAPHICS_PROGRAMS defined, the default font is
-		 * not saved.
-		 */
-		return -ENOSYS;
-	}
-
-	op->op = KD_FONT_OP_SET_DEFAULT;
-	op->data = NULL;
-	ret = con_font_op(vc, op);
-	if (ret)
-		return ret;
-
-	console_lock();
-	con_set_default_unimap(vc);
-	console_unlock();
-
-	return 0;
-}
-
 static inline int do_unimap_ioctl(int cmd, struct unimapdesc __user *user_ud,
 		bool perm, struct vc_data *vc)
 {
@@ -574,29 +510,7 @@ static inline int do_unimap_ioctl(int cm
 static int vt_io_ioctl(struct vc_data *vc, unsigned int cmd, void __user *up,
 		bool perm)
 {
-	struct console_font_op op;	/* used in multiple places here */
-
 	switch (cmd) {
-	case PIO_FONT:
-		if (!perm)
-			return -EPERM;
-		op.op = KD_FONT_OP_SET;
-		op.flags = KD_FONT_FLAG_OLD | KD_FONT_FLAG_DONT_RECALC;	/* Compatibility */
-		op.width = 8;
-		op.height = 0;
-		op.charcount = 256;
-		op.data = up;
-		return con_font_op(vc, &op);
-
-	case GIO_FONT:
-		op.op = KD_FONT_OP_GET;
-		op.flags = KD_FONT_FLAG_OLD;
-		op.width = 8;
-		op.height = 32;
-		op.charcount = 256;
-		op.data = up;
-		return con_font_op(vc, &op);
-
 	case PIO_CMAP:
                 if (!perm)
 			return -EPERM;
@@ -605,20 +519,6 @@ static int vt_io_ioctl(struct vc_data *v
 	case GIO_CMAP:
                 return con_get_cmap(up);
 
-	case PIO_FONTX:
-		if (!perm)
-			return -EPERM;
-
-		fallthrough;
-	case GIO_FONTX:
-		return do_fontx_ioctl(vc, cmd, up, &op);
-
-	case PIO_FONTRESET:
-		if (!perm)
-			return -EPERM;
-
-		return vt_io_fontreset(vc, &op);
-
 	case PIO_SCRNMAP:
 		if (!perm)
 			return -EPERM;
@@ -1099,54 +999,6 @@ void vc_SAK(struct work_struct *work)
 
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
@@ -1223,9 +1075,6 @@ long vt_compat_ioctl(struct tty_struct *
 	/*
 	 * these need special handlers for incompatible data structures
 	 */
-	case PIO_FONTX:
-	case GIO_FONTX:
-		return compat_fontx_ioctl(vc, cmd, up, perm, &op);
 
 	case KDFONTOP:
 		return compat_kdfontop_ioctl(up, perm, &op, vc);
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


