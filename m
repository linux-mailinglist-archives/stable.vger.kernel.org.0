Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E191B5CD6
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 15:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgDWNrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 09:47:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbgDWNrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 09:47:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C9B820728;
        Thu, 23 Apr 2020 13:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587649626;
        bh=+Ol6oKIhfcOGN/dAF0VQgCqyczrRph8CyZn9CC1dlcM=;
        h=Subject:To:From:Date:From;
        b=KpxROXMWJ6f0iQ1yfbqG+GSm3z6eXfBer6O7duPoSx4DlLVu0Rvu0RFhPNJJrVhrs
         Fx1UGdocKOSkrXRRRNUKHJOT6kx/lH4m1X6R/6U1qofLF+OPy9rt3WJJcWpRCBg//H
         3i+wKvbLbHhlne7bwOdDPJZtIiRDi1LzshJLpZ7E=
Subject: patch "vt: don't use kmalloc() for the unicode screen buffer" added to tty-linus
To:     nico@fluxnic.net, gregkh@linuxfoundation.org, sam@ravnborg.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 Apr 2020 15:47:04 +0200
Message-ID: <158764962413760@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    vt: don't use kmalloc() for the unicode screen buffer

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9a98e7a80f95378c9ee0c644705e3b5aa54745f1 Mon Sep 17 00:00:00 2001
From: Nicolas Pitre <nico@fluxnic.net>
Date: Sat, 28 Mar 2020 22:25:11 -0400
Subject: vt: don't use kmalloc() for the unicode screen buffer

Even if the actual screen size is bounded in vc_do_resize(), the unicode
buffer is still a little more than twice the size of the glyph buffer
and may exceed MAX_ORDER down the kmalloc() path. This can be triggered
from user space.

Since there is no point having a physically contiguous buffer here,
let's avoid the above issue as well as reducing pressure on high order
allocations by using vmalloc() instead.

Signed-off-by: Nicolas Pitre <nico@fluxnic.net>
Cc: <stable@vger.kernel.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://lore.kernel.org/r/nycvar.YSQ.7.76.2003282214210.2671@knanqh.ubzr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 309a39197be0..3272759b1f3c 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -81,6 +81,7 @@
 #include <linux/errno.h>
 #include <linux/kd.h>
 #include <linux/slab.h>
+#include <linux/vmalloc.h>
 #include <linux/major.h>
 #include <linux/mm.h>
 #include <linux/console.h>
@@ -350,7 +351,7 @@ static struct uni_screen *vc_uniscr_alloc(unsigned int cols, unsigned int rows)
 	/* allocate everything in one go */
 	memsize = cols * rows * sizeof(char32_t);
 	memsize += rows * sizeof(char32_t *);
-	p = kmalloc(memsize, GFP_KERNEL);
+	p = vmalloc(memsize);
 	if (!p)
 		return NULL;
 
@@ -366,7 +367,7 @@ static struct uni_screen *vc_uniscr_alloc(unsigned int cols, unsigned int rows)
 
 static void vc_uniscr_set(struct vc_data *vc, struct uni_screen *new_uniscr)
 {
-	kfree(vc->vc_uni_screen);
+	vfree(vc->vc_uni_screen);
 	vc->vc_uni_screen = new_uniscr;
 }
 
-- 
2.26.2


