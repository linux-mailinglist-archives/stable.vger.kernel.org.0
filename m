Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774D41B5CD8
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 15:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgDWNrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 09:47:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbgDWNrR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 09:47:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABA2B2076C;
        Thu, 23 Apr 2020 13:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587649637;
        bh=DqN53sbNTKgipNJhyK1iq/g9yiyejnvoK3VybrpPvEU=;
        h=Subject:To:From:Date:From;
        b=oGQ1mEXRibE+lZTiG9b7iStNGl3bnK15kGi1SSGNxKH9/EmBuSCEDn+FvlBwIjD7Q
         Yp5lHuuqhdo29MFChHfBbsO+4K+seTUabxsNVVAKPYDSpYqPMBJMP9tA4AnRzxCUJF
         AhkjUiR0FUAlBd8Cb9hiC9UJhnZyDo3MwKTyGNoE=
Subject: patch "vt: don't hardcode the mem allocation upper bound" added to tty-linus
To:     nico@fluxnic.net, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 Apr 2020 15:47:05 +0200
Message-ID: <158764962512885@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    vt: don't hardcode the mem allocation upper bound

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 2717769e204e83e65b8819c5e2ef3e5b6639b270 Mon Sep 17 00:00:00 2001
From: Nicolas Pitre <nico@fluxnic.net>
Date: Sat, 28 Mar 2020 17:32:42 -0400
Subject: vt: don't hardcode the mem allocation upper bound

The code in vc_do_resize() bounds the memory allocation size to avoid
exceeding MAX_ORDER down the kzalloc() call chain and generating a
runtime warning triggerable from user space. However, not only is it
unwise to use a literal value here, but MAX_ORDER may also be
configurable based on CONFIG_FORCE_MAX_ZONEORDER.
Let's use KMALLOC_MAX_SIZE instead.

Note that prior commit bb1107f7c605 ("mm, slab: make sure that
KMALLOC_MAX_SIZE will fit into MAX_ORDER") the KMALLOC_MAX_SIZE value
could not be relied upon.

Signed-off-by: Nicolas Pitre <nico@fluxnic.net>
Cc: <stable@vger.kernel.org> # v4.10+

Link: https://lore.kernel.org/r/nycvar.YSQ.7.76.2003281702410.2671@knanqh.ubzr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 3272759b1f3c..e5ffed795e4c 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1207,7 +1207,7 @@ static int vc_do_resize(struct tty_struct *tty, struct vc_data *vc,
 	if (new_cols == vc->vc_cols && new_rows == vc->vc_rows)
 		return 0;
 
-	if (new_screen_size > (4 << 20))
+	if (new_screen_size > KMALLOC_MAX_SIZE)
 		return -EINVAL;
 	newscreen = kzalloc(new_screen_size, GFP_USER);
 	if (!newscreen)
-- 
2.26.2


