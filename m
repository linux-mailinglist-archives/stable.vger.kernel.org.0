Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8FAA10B2F3
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 17:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfK0QIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 11:08:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:56376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbfK0QIA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 11:08:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D29C20665;
        Wed, 27 Nov 2019 16:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574870879;
        bh=9BjM+HE34dtXtstK6V2ZO7Gy8iP05NI8ZLmGffdX/Pk=;
        h=Subject:To:From:Date:From;
        b=p41KIoPGfDOaEGDfI4Ce7GJGMm0BUhXhUz01sZdaxyaSOLmedUnvGwikAtOYZbku/
         sjJe06lbydOSbmy5Se5PFlWd0r4ZzYUtcRnWqZV0fevEr27PhQv6zHP/CRlEgi4kDy
         CkIGwEpdkTO45C9hPp93mVj4DDpDlfLY2cF+Nnuk=
Subject: patch "vcs: prevent write access to vcsu devices" added to tty-next
To:     nico@fluxnic.net, gregkh@linuxfoundation.org, jslaby@suse.com,
        npitre@baylibre.com, orcohen@paloaltonetworks.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 27 Nov 2019 17:07:57 +0100
Message-ID: <1574870877251181@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    vcs: prevent write access to vcsu devices

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 0c9acb1af77a3cb8707e43f45b72c95266903cee Mon Sep 17 00:00:00 2001
From: Nicolas Pitre <nico@fluxnic.net>
Date: Tue, 5 Nov 2019 10:33:16 +0100
Subject: vcs: prevent write access to vcsu devices

Commit d21b0be246bf ("vt: introduce unicode mode for /dev/vcs") guarded
against using devices containing attributes as this is not yet
implemented. It however failed to guard against writes to any devices
as this is also unimplemented.

Reported-by: Or Cohen <orcohen@paloaltonetworks.com>
Signed-off-by: Nicolas Pitre <npitre@baylibre.com>
Cc: <stable@vger.kernel.org> # v4.19+
Cc: Jiri Slaby <jslaby@suse.com>
Fixes: d21b0be246bf ("vt: introduce unicode mode for /dev/vcs")
Link: https://lore.kernel.org/r/nycvar.YSQ.7.76.1911051030580.30289@knanqh.ubzr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vc_screen.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index 1f042346e722..778f83ea2249 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -456,6 +456,9 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	size_t ret;
 	char *con_buf;
 
+	if (use_unicode(inode))
+		return -EOPNOTSUPP;
+
 	con_buf = (char *) __get_free_page(GFP_KERNEL);
 	if (!con_buf)
 		return -ENOMEM;
-- 
2.24.0


