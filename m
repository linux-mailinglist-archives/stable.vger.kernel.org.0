Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4233419B351
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389170AbgDAQjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:39:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388630AbgDAQjJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:39:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A97320658;
        Wed,  1 Apr 2020 16:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759148;
        bh=FGNU3TYBhXMnbZGkwfxzJZXIqiI4/tL2Rs1aZdf+Y2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=07qjBmRgwNVPMyfWloT9wSMIOU6iEP4uhhfsSMTadJz5ozzMl8eATv6GOT4CVWRtg
         TSSEnuK5ZhtDQP5JTiWTvu6qsKbdFNIh7RHCK669rbM4CaymcwbCcPfqADngIBxWcY
         YgfpYVEyq/L9pvmdL89vd1qJ7cdR1EpDRiShURXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 4.9 093/102] vt: ioctl, switch VT_IS_IN_USE and VT_BUSY to inlines
Date:   Wed,  1 Apr 2020 18:18:36 +0200
Message-Id: <20200401161547.738410989@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161530.451355388@linuxfoundation.org>
References: <20200401161530.451355388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

commit e587e8f17433ddb26954f0edf5b2f95c42155ae9 upstream.

These two were macros. Switch them to static inlines, so that it's more
understandable what they are doing.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20200219073951.16151-2-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/vt_ioctl.c |   29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -39,10 +39,25 @@
 #include <linux/selection.h>
 
 char vt_dont_switch;
-extern struct tty_driver *console_driver;
 
-#define VT_IS_IN_USE(i)	(console_driver->ttys[i] && console_driver->ttys[i]->count)
-#define VT_BUSY(i)	(VT_IS_IN_USE(i) || i == fg_console || vc_is_sel(vc_cons[i].d))
+static inline bool vt_in_use(unsigned int i)
+{
+	extern struct tty_driver *console_driver;
+
+	return console_driver->ttys[i] && console_driver->ttys[i]->count;
+}
+
+static inline bool vt_busy(int i)
+{
+	if (vt_in_use(i))
+		return true;
+	if (i == fg_console)
+		return true;
+	if (vc_is_sel(vc_cons[i].d))
+		return true;
+
+	return false;
+}
 
 /*
  * Console (vt and kd) routines, as defined by USL SVR4 manual, and by
@@ -292,7 +307,7 @@ static int vt_disallocate(unsigned int v
 	int ret = 0;
 
 	console_lock();
-	if (VT_BUSY(vc_num))
+	if (vt_busy(vc_num))
 		ret = -EBUSY;
 	else if (vc_num)
 		vc = vc_deallocate(vc_num);
@@ -314,7 +329,7 @@ static void vt_disallocate_all(void)
 
 	console_lock();
 	for (i = 1; i < MAX_NR_CONSOLES; i++)
-		if (!VT_BUSY(i))
+		if (!vt_busy(i))
 			vc[i] = vc_deallocate(i);
 		else
 			vc[i] = NULL;
@@ -651,7 +666,7 @@ int vt_ioctl(struct tty_struct *tty,
 			state = 1;	/* /dev/tty0 is always open */
 			for (i = 0, mask = 2; i < MAX_NR_CONSOLES && mask;
 							++i, mask <<= 1)
-				if (VT_IS_IN_USE(i))
+				if (vt_in_use(i))
 					state |= mask;
 			ret = put_user(state, &vtstat->v_state);
 		}
@@ -664,7 +679,7 @@ int vt_ioctl(struct tty_struct *tty,
 	case VT_OPENQRY:
 		/* FIXME: locking ? - but then this is a stupid API */
 		for (i = 0; i < MAX_NR_CONSOLES; ++i)
-			if (! VT_IS_IN_USE(i))
+			if (!vt_in_use(i))
 				break;
 		uival = i < MAX_NR_CONSOLES ? (i+1) : -1;
 		goto setint;		 


