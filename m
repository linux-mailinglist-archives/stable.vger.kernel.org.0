Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C09B4189BCA
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 13:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgCRMQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 08:16:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgCRMQn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 08:16:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8857520724;
        Wed, 18 Mar 2020 12:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584533802;
        bh=RU9Cgq3gPm1TqLf2QcA+vKB/s4yIrOOe84oymunejjs=;
        h=Subject:To:From:Date:From;
        b=jvbsjpIHCZt2aVXuqhcoYlF5Lx/ZGkbEyRHrGtq+1xYVgelmF8ycWxEuPG3eCbqM3
         xeJGTJFtdTBDOsjs2u3kuDnZRZwvqnUBW6DSrspj7IGPWmKXa0szdwhkp7K5b+z0xq
         Hxl72QthxatZD3Y8xXqobFKbKcJe1olCSHoQHmok=
Subject: patch "tty: fix compat TIOCGSERIAL leaking uninitialized memory" added to tty-linus
To:     ebiggers@google.com, gregkh@linuxfoundation.org, jslaby@suse.cz,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 18 Mar 2020 13:16:31 +0100
Message-ID: <1584533791214124@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: fix compat TIOCGSERIAL leaking uninitialized memory

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 17329563a97df3ba474eca5037c1336e46e14ff8 Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Mon, 24 Feb 2020 10:20:43 -0800
Subject: tty: fix compat TIOCGSERIAL leaking uninitialized memory

Commit 77654350306a ("take compat TIOC[SG]SERIAL treatment into
tty_compat_ioctl()") changed the compat version of TIOCGSERIAL to start
copying a whole 'serial_struct32' to userspace rather than individual
fields, but failed to initialize all padding and fields -- namely the
hole after the 'iomem_reg_shift' field, and the 'reserved' field.

Fix this by initializing the struct to zero.

[v2: use sizeof, and convert the adjacent line for consistency.]

Reported-by: syzbot+8da9175e28eadcb203ce@syzkaller.appspotmail.com
Fixes: 77654350306a ("take compat TIOC[SG]SERIAL treatment into tty_compat_ioctl()")
Cc: <stable@vger.kernel.org> # v4.20+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20200224182044.234553-2-ebiggers@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/tty_io.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 1fcf7ad83dfa..db4a13bc855e 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2730,7 +2730,9 @@ static int compat_tty_tiocgserial(struct tty_struct *tty,
 	struct serial_struct32 v32;
 	struct serial_struct v;
 	int err;
-	memset(&v, 0, sizeof(struct serial_struct));
+
+	memset(&v, 0, sizeof(v));
+	memset(&v32, 0, sizeof(v32));
 
 	if (!tty->ops->set_serial)
 		return -ENOTTY;
-- 
2.25.1


