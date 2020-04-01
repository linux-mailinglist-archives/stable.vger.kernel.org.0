Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 372B719B093
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387861AbgDAQ1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:27:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732286AbgDAQ1x (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:27:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46CB320BED;
        Wed,  1 Apr 2020 16:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758472;
        bh=YjbJkWnulZxpZ5AzBSei2JjCsNgi5cGWbkLwlh2FsTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OPa4KHgA5476c6KuqXECkugj3I/+Y9F5tBFsPwJRjvTaCgkRqVay1G1e1vYJD/Fyb
         FxiZYUKdj4tDIt9r89k9UsrudYka66ovrzevHd6C/hALWMokHE8YMmFuCxlr3cXkAC
         6ed+Yqf9RCuM4WKtufKB21l+UB3WuKPZYJySRFnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 4.19 100/116] vt: switch vt_dont_switch to bool
Date:   Wed,  1 Apr 2020 18:17:56 +0200
Message-Id: <20200401161555.068953071@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161542.669484650@linuxfoundation.org>
References: <20200401161542.669484650@linuxfoundation.org>
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
@@ -142,7 +142,7 @@ static inline bool vt_force_oops_output(
 	return false;
 }
 
-extern char vt_dont_switch;
+extern bool vt_dont_switch;
 extern int default_utf8;
 extern int global_cursor_default;
 


