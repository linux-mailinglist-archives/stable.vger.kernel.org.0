Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 677C91A5139
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728863AbgDKMYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:24:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728615AbgDKMSX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:18:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F04AA20644;
        Sat, 11 Apr 2020 12:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607503;
        bh=lOVJgWNnz0yKKL4/eQnryAahX/eDEPiacWZDON4qHfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XpMY7i+PAfszn+Yp2pADg1DeyVtAopGU0LBh/+NV0zDl2nmXgKRqIgDg/qRirppyy
         +sF5jbbxt2oT63XeDEZTUJyMJYM976dME6sw2TZd9OIS07xg1fkhpF8MkaIYrz+nI/
         uI9YqmoOow8I89qrs7VtETw8CfJFRF2YLeTJ0S1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+732528bae351682f1f27@syzkaller.appspotmail.com,
        Qiujun Huang <hqjagain@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 5.4 39/41] fbcon: fix null-ptr-deref in fbcon_switch
Date:   Sat, 11 Apr 2020 14:09:48 +0200
Message-Id: <20200411115506.922339261@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115504.124035693@linuxfoundation.org>
References: <20200411115504.124035693@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiujun Huang <hqjagain@gmail.com>

commit b139f8b00db4a8ea75a4174346eafa48041aa489 upstream.

Set logo_shown to FBCON_LOGO_CANSHOW when the vc was deallocated.

syzkaller report: https://lkml.org/lkml/2020/3/27/403
general protection fault, probably for non-canonical address
0xdffffc000000006c: 0000 [#1] SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000360-0x0000000000000367]
RIP: 0010:fbcon_switch+0x28f/0x1740
drivers/video/fbdev/core/fbcon.c:2260

Call Trace:
redraw_screen+0x2a8/0x770 drivers/tty/vt/vt.c:1008
vc_do_resize+0xfe7/0x1360 drivers/tty/vt/vt.c:1295
fbcon_init+0x1221/0x1ab0 drivers/video/fbdev/core/fbcon.c:1219
visual_init+0x305/0x5c0 drivers/tty/vt/vt.c:1062
do_bind_con_driver+0x536/0x890 drivers/tty/vt/vt.c:3542
do_take_over_console+0x453/0x5b0 drivers/tty/vt/vt.c:4122
do_fbcon_takeover+0x10b/0x210 drivers/video/fbdev/core/fbcon.c:588
fbcon_fb_registered+0x26b/0x340 drivers/video/fbdev/core/fbcon.c:3259
do_register_framebuffer drivers/video/fbdev/core/fbmem.c:1664 [inline]
register_framebuffer+0x56e/0x980 drivers/video/fbdev/core/fbmem.c:1832
dlfb_usb_probe.cold+0x1743/0x1ba3 drivers/video/fbdev/udlfb.c:1735
usb_probe_interface+0x310/0x800 drivers/usb/core/driver.c:374

accessing vc_cons[logo_shown].d->vc_top causes the bug.

Reported-by: syzbot+732528bae351682f1f27@syzkaller.appspotmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20200329085647.25133-1-hqjagain@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fbdev/core/fbcon.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -1276,6 +1276,9 @@ finished:
 	if (!con_is_bound(&fb_con))
 		fbcon_exit();
 
+	if (vc->vc_num == logo_shown)
+		logo_shown = FBCON_LOGO_CANSHOW;
+
 	return;
 }
 


