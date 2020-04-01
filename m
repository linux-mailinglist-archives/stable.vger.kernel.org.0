Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F83C19B440
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 19:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732461AbgDAQVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:21:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732273AbgDAQUz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:20:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE38320658;
        Wed,  1 Apr 2020 16:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758055;
        bh=5XjkFM5wyNFBP6SLOe9dlSinzdyO5temJPYtDJ7S7Ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EKPbn95pjqt5LXWfcdgWNDKemfix1ypownDEKIBSlMBBOUoVGkLD1pZH/LaywUwPh
         4zgS8mfdfUVVW7p8RHPr1eYLnGSRNrMJLv8anXSoWR3pvLmLqz2ngCOlSbwtpG75U6
         3aaBBwms00ftrKqb+hPnIKwmHLLZNZX94s8Ix9TI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 5.5 07/30] vt: switch vt_dont_switch to bool
Date:   Wed,  1 Apr 2020 18:17:11 +0200
Message-Id: <20200401161420.268112172@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161414.345528747@linuxfoundation.org>
References: <20200401161414.345528747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

commit f400991bf872debffb01c46da882dc97d7e3248e upstream.

vt_dont_switch is pure boolean, no need for whole char.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20200219073951.16151-6-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/vt_ioctl.c |    6 +++---
 include/linux/vt_kern.h   |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -39,7 +39,7 @@
 #include <linux/kbd_diacr.h>
 #include <linux/selection.h>
 
-char vt_dont_switch;
+bool vt_dont_switch;
 
 static inline bool vt_in_use(unsigned int i)
 {
@@ -1026,12 +1026,12 @@ int vt_ioctl(struct tty_struct *tty,
 	case VT_LOCKSWITCH:
 		if (!capable(CAP_SYS_TTY_CONFIG))
 			return -EPERM;
-		vt_dont_switch = 1;
+		vt_dont_switch = true;
 		break;
 	case VT_UNLOCKSWITCH:
 		if (!capable(CAP_SYS_TTY_CONFIG))
 			return -EPERM;
-		vt_dont_switch = 0;
+		vt_dont_switch = false;
 		break;
 	case VT_GETHIFONTMASK:
 		ret = put_user(vc->vc_hi_font_mask,
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -135,7 +135,7 @@ extern int do_unbind_con_driver(const st
 			     int deflt);
 int vty_init(const struct file_operations *console_fops);
 
-extern char vt_dont_switch;
+extern bool vt_dont_switch;
 extern int default_utf8;
 extern int global_cursor_default;
 


