Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32C022EF9B
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731062AbgG0ORp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:17:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731098AbgG0ORl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:17:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C82D820775;
        Mon, 27 Jul 2020 14:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859461;
        bh=W+aZnU5vNg9bWZKBSUOjo0QnhgEt+zvcWQNSDiewMUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pmgYAUM8DXH4ZarW+6lm8tEdUDhixIgl1dqVdB1EVwsrEwIGc1dZWrUnWWPgnAix7
         5++FvrTqmv7WDTHhuPfPbXUt/lQbvc+dl9P4+tD3xCnxUFsUIh53kAGc0jKBp/y47X
         RmgmJ6gPqsZeM31gCfimq23Uu5Wq77uvssB4Us14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Matthew Wilcox <willy@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Biggers <ebiggers@google.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.4 118/138] /dev/mem: Add missing memory barriers for devmem_inode
Date:   Mon, 27 Jul 2020 16:05:13 +0200
Message-Id: <20200727134931.348451262@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit b34e7e298d7a5ed76b3aa327c240c29f1ef6dd22 upstream.

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
 drivers/char/mem.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

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


