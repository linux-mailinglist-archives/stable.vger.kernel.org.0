Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A290B127C3
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 08:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfECGXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 02:23:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbfECGXG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 May 2019 02:23:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A0122089E;
        Fri,  3 May 2019 06:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556864586;
        bh=NCYS4iI7UZW6g9rHFxhzjiWqPaXIPoMB+N5OzZ0/gYs=;
        h=Subject:To:From:Date:From;
        b=qqcIUzKgljKKG+HtRp4kYJCyFvwdwSW0Nfsf0x9XL+ChPzxVfofa9oF3jf/hqwREC
         MdSLEVqHYRgc/IygPWXJPUrISQVtXaIQ/BV4ohPY13S6cx10R7RV5bjcfzgtjMmU8f
         BDleA0YsfiIFPDFMjc8BKBhI/9t1AukBDdjK6PEw=
Subject: patch "staging: most: cdev: fix chrdev_region leak in mod_exit" added to staging-next
To:     sudipi@jp.adit-jv.com, christian.gromm@microchip.com,
        erosca@de.adit-jv.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 May 2019 08:22:55 +0200
Message-ID: <1556864575131241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: most: cdev: fix chrdev_region leak in mod_exit

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From af708900e9a48c0aa46070c8a8cdf0608a1d2025 Mon Sep 17 00:00:00 2001
From: Suresh Udipi <sudipi@jp.adit-jv.com>
Date: Wed, 24 Apr 2019 21:23:43 +0200
Subject: staging: most: cdev: fix chrdev_region leak in mod_exit

It looks like v4.18-rc1 commit [0] which upstreams mld-1.8.0
commit [1] missed to fix the memory leak in mod_exit function.

Do it now.

[0] aba258b7310167 ("staging: most: cdev: fix chrdev_region leak")
[1] https://github.com/microchip-ais/linux/commit/a2d8f7ae7ea381
    ("staging: most: cdev: fix leak for chrdev_region")

Signed-off-by: Suresh Udipi <sudipi@jp.adit-jv.com>
Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Acked-by: Christian Gromm <christian.gromm@microchip.com>
Fixes: aba258b73101 ("staging: most: cdev: fix chrdev_region leak")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/most/cdev/cdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/most/cdev/cdev.c b/drivers/staging/most/cdev/cdev.c
index d98977c57a4b..d0cc0b746107 100644
--- a/drivers/staging/most/cdev/cdev.c
+++ b/drivers/staging/most/cdev/cdev.c
@@ -555,7 +555,7 @@ static void __exit mod_exit(void)
 		destroy_cdev(c);
 		destroy_channel(c);
 	}
-	unregister_chrdev_region(comp.devno, 1);
+	unregister_chrdev_region(comp.devno, CHRDEV_REGION_SIZE);
 	ida_destroy(&comp.minor_id);
 	class_destroy(comp.class);
 }
-- 
2.21.0


