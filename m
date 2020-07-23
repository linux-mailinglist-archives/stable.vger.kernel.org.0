Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A59722A9FB
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 09:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgGWHrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 03:47:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgGWHrf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jul 2020 03:47:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 307AC2086A;
        Thu, 23 Jul 2020 07:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595490454;
        bh=5O3CT/V4MjLW3Bl2jOuQzHnmOvMvT8yoRihlAYuLWjc=;
        h=Subject:To:From:Date:From;
        b=NS3uMJQNwXF7XpDzBDyTuholp0U3ygQlXcyL6y42UArveY3H460k6gtho9ClZ8djc
         i1jvP0dheoXY+OQs2jE7jc6E08wIFwbDXtTaT/xHgbj5SHPugOhmVILws+QS2NPCWc
         8y6ub+N9QixZ0RecGq+i2xG53CbRtF7KK81bI5pc=
Subject: patch "/dev/mem: Add missing memory barriers for devmem_inode" added to char-misc-linus
To:     ebiggers@google.com, akpm@linux-foundation.org, arnd@arndb.de,
        dan.j.williams@intel.com, gregkh@linuxfoundation.org,
        keescook@chromium.org, linux@arm.linux.org.uk, mingo@redhat.com,
        stable@vger.kernel.org, willy@infradead.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 Jul 2020 09:47:31 +0200
Message-ID: <15954904511292@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    /dev/mem: Add missing memory barriers for devmem_inode

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b34e7e298d7a5ed76b3aa327c240c29f1ef6dd22 Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Wed, 15 Jul 2020 23:05:53 -0700
Subject: /dev/mem: Add missing memory barriers for devmem_inode

WRITE_ONCE() isn't the correct way to publish a pointer to a data
structure, since it doesn't include a write memory barrier.  Therefore
other tasks may see that the pointer has been set but not see that the
pointed-to memory has finished being initialized yet.  Instead a
primitive with "release" semantics is needed.

Use smp_store_release() for this.

The use of READ_ONCE() on the read side is still potentially correct if
there's no control dependency, i.e. if all memory being "published" is
transitively reachable via the pointer itself.  But this pairing is
somewhat confusing and error-prone.  So just upgrade the read side to
smp_load_acquire() so that it clearly pairs with smp_store_release().

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: 3234ac664a87 ("/dev/mem: Revoke mappings when a driver claims the region")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Cc: stable <stable@vger.kernel.org>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Link: https://lore.kernel.org/r/20200716060553.24618-1-ebiggers@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/mem.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 934c92dcb9ab..687d4af6945d 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -814,7 +814,8 @@ static struct inode *devmem_inode;
 #ifdef CONFIG_IO_STRICT_DEVMEM
 void revoke_devmem(struct resource *res)
 {
-	struct inode *inode = READ_ONCE(devmem_inode);
+	/* pairs with smp_store_release() in devmem_init_inode() */
+	struct inode *inode = smp_load_acquire(&devmem_inode);
 
 	/*
 	 * Check that the initialization has completed. Losing the race
@@ -1028,8 +1029,11 @@ static int devmem_init_inode(void)
 		return rc;
 	}
 
-	/* publish /dev/mem initialized */
-	WRITE_ONCE(devmem_inode, inode);
+	/*
+	 * Publish /dev/mem initialized.
+	 * Pairs with smp_load_acquire() in revoke_devmem().
+	 */
+	smp_store_release(&devmem_inode, inode);
 
 	return 0;
 }
-- 
2.27.0


