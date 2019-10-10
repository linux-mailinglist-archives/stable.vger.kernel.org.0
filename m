Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91FCCD2328
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387932AbfJJIjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:39:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387948AbfJJIjo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:39:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D6092190F;
        Thu, 10 Oct 2019 08:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696783;
        bh=QWfFys8kVI5Ktj7hLu3Mlw2CYHL1/OpBrjhVm2QApV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bWqKucCek85NUtEMs9VZcKJTLuLvUFZtYydcnFduQSmuZ3Xv/SrDpZWF7hjLQ+Ogp
         cOAp5+Ajr2CIJVb77p5vSZznZnnj491O6+XTZ+Rp7jnvzWafrrKGUJlyn/o/HOIrx0
         DuVGD8I32mlz9pEGi6shdwo0h/M+Z2Q5HonD2DBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.3 051/148] usercopy: Avoid HIGHMEM pfn warning
Date:   Thu, 10 Oct 2019 10:35:12 +0200
Message-Id: <20191010083614.257922832@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 314eed30ede02fa925990f535652254b5bad6b65 upstream.

When running on a system with >512MB RAM with a 32-bit kernel built with:

	CONFIG_DEBUG_VIRTUAL=y
	CONFIG_HIGHMEM=y
	CONFIG_HARDENED_USERCOPY=y

all execve()s will fail due to argv copying into kmap()ed pages, and on
usercopy checking the calls ultimately of virt_to_page() will be looking
for "bad" kmap (highmem) pointers due to CONFIG_DEBUG_VIRTUAL=y:

 ------------[ cut here ]------------
 kernel BUG at ../arch/x86/mm/physaddr.c:83!
 invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
 CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.3.0-rc8 #6
 Hardware name: Dell Inc. Inspiron 1318/0C236D, BIOS A04 01/15/2009
 EIP: __phys_addr+0xaf/0x100
 ...
 Call Trace:
  __check_object_size+0xaf/0x3c0
  ? __might_sleep+0x80/0xa0
  copy_strings+0x1c2/0x370
  copy_strings_kernel+0x2b/0x40
  __do_execve_file+0x4ca/0x810
  ? kmem_cache_alloc+0x1c7/0x370
  do_execve+0x1b/0x20
  ...

The check is from arch/x86/mm/physaddr.c:

	VIRTUAL_BUG_ON((phys_addr >> PAGE_SHIFT) > max_low_pfn);

Due to the kmap() in fs/exec.c:

		kaddr = kmap(kmapped_page);
	...
	if (copy_from_user(kaddr+offset, str, bytes_to_copy)) ...

Now we can fetch the correct page to avoid the pfn check. In both cases,
hardened usercopy will need to walk the page-span checker (if enabled)
to do sanity checking.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Fixes: f5509cc18daa ("mm: Hardened usercopy")
Cc: Matthew Wilcox <willy@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://lore.kernel.org/r/201909171056.7F2FFD17@keescook
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/usercopy.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/usercopy.c
+++ b/mm/usercopy.c
@@ -11,6 +11,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/mm.h>
+#include <linux/highmem.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/sched/task.h>
@@ -227,7 +228,12 @@ static inline void check_heap_object(con
 	if (!virt_addr_valid(ptr))
 		return;
 
-	page = virt_to_head_page(ptr);
+	/*
+	 * When CONFIG_HIGHMEM=y, kmap_to_page() will give either the
+	 * highmem page or fallback to virt_to_page(). The following
+	 * is effectively a highmem-aware virt_to_head_page().
+	 */
+	page = compound_head(kmap_to_page((void *)ptr));
 
 	if (PageSlab(page)) {
 		/* Check slab allocator for flags and size. */


