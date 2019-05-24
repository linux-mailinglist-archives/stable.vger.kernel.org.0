Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 357D429E42
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 20:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbfEXSmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 14:42:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727344AbfEXSmm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 May 2019 14:42:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFC20217D7;
        Fri, 24 May 2019 18:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558723361;
        bh=8PaHzS0XKa1hl7WA1FBav81EdyBrVf38k0yunoYFFVU=;
        h=Subject:To:From:Date:From;
        b=eund92FPFtD7woMy82mqEYlqtzUyMFHEu1rI3ZLPmyYPbdxfMpDzgEMcTPwa3+aLy
         /0rrbsdObPHnuXSTDljomF8DjRdrk5ZqTd5H2X1XxLEx5WqeXSf9i30FxIjVz0ddlh
         hq7FT1e/nFv3h/W6prugMo0Mu1/WgDR4bosemDwQ=
Subject: patch "genwqe: Prevent an integer overflow in the ioctl" added to char-misc-linus
To:     dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 24 May 2019 20:42:31 +0200
Message-ID: <15587233517923@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    genwqe: Prevent an integer overflow in the ioctl

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 110080cea0d0e4dfdb0b536e7f8a5633ead6a781 Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 7 May 2019 11:36:34 +0300
Subject: genwqe: Prevent an integer overflow in the ioctl

There are a couple potential integer overflows here.

	round_up(m->size + (m->addr & ~PAGE_MASK), PAGE_SIZE);

The first thing is that the "m->size + (...)" addition could overflow,
and the second is that round_up() overflows to zero if the result is
within PAGE_SIZE of the type max.

In this code, the "m->size" variable is an u64 but we're saving the
result in "map_size" which is an unsigned long and genwqe_user_vmap()
takes an unsigned long as well.  So I have used ULONG_MAX as the upper
bound.  From a practical perspective unsigned long is fine/better than
trying to change all the types to u64.

Fixes: eaf4722d4645 ("GenWQE Character device and DDCB queue")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/genwqe/card_dev.c   | 2 ++
 drivers/misc/genwqe/card_utils.c | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/misc/genwqe/card_dev.c b/drivers/misc/genwqe/card_dev.c
index 8c1b63a4337b..d2098b4d2945 100644
--- a/drivers/misc/genwqe/card_dev.c
+++ b/drivers/misc/genwqe/card_dev.c
@@ -780,6 +780,8 @@ static int genwqe_pin_mem(struct genwqe_file *cfile, struct genwqe_mem *m)
 
 	if ((m->addr == 0x0) || (m->size == 0))
 		return -EINVAL;
+	if (m->size > ULONG_MAX - PAGE_SIZE - (m->addr & ~PAGE_MASK))
+		return -EINVAL;
 
 	map_addr = (m->addr & PAGE_MASK);
 	map_size = round_up(m->size + (m->addr & ~PAGE_MASK), PAGE_SIZE);
diff --git a/drivers/misc/genwqe/card_utils.c b/drivers/misc/genwqe/card_utils.c
index 89cff9d1012b..7571700abc6e 100644
--- a/drivers/misc/genwqe/card_utils.c
+++ b/drivers/misc/genwqe/card_utils.c
@@ -586,6 +586,10 @@ int genwqe_user_vmap(struct genwqe_dev *cd, struct dma_mapping *m, void *uaddr,
 	/* determine space needed for page_list. */
 	data = (unsigned long)uaddr;
 	offs = offset_in_page(data);
+	if (size > ULONG_MAX - PAGE_SIZE - offs) {
+		m->size = 0;	/* mark unused and not added */
+		return -EINVAL;
+	}
 	m->nr_pages = DIV_ROUND_UP(offs + size, PAGE_SIZE);
 
 	m->page_list = kcalloc(m->nr_pages,
-- 
2.21.0


