Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D07014B775
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbgA1OOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:14:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:36762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727976AbgA1OOd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:14:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A789A2468D;
        Tue, 28 Jan 2020 14:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220873;
        bh=brjujh9/asiNKUHrWJONIUMMD6cFhdS8tLGrvGYJw6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tlqV7gdCMYN4KEuOJfCquH2JKBF/z+sElFttWTtp344jUqCxRocHLnva9eo7rzY5+
         S5EyhFjFeP2srt8WztrWPePVAYE/+P07065L7F+Hb0Yqt84ETskKk2ZXvCCyBOqKOj
         jkWDUZVGO9sank3l/vZWneqI9WasELa4f6A6MfKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.4 180/183] bitmap: Add bitmap_alloc(), bitmap_zalloc() and bitmap_free()
Date:   Tue, 28 Jan 2020 15:06:39 +0100
Message-Id: <20200128135847.718431075@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit c42b65e363ce97a828f81b59033c3558f8fa7f70 upstream.

A lot of code become ugly because of open coding allocations for bitmaps.

Introduce three helpers to allow users be more clear of intention
and keep their code neat.

Note, due to multiple circular dependencies we may not provide
the helpers as inliners. For now we keep them exported and, perhaps,
at some point in the future we will sort out header inclusion and
inheritance.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/bitmap.h |    8 ++++++++
 lib/bitmap.c           |   20 ++++++++++++++++++++
 2 files changed, 28 insertions(+)

--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -84,6 +84,14 @@
  */
 
 /*
+ * Allocation and deallocation of bitmap.
+ * Provided in lib/bitmap.c to avoid circular dependency.
+ */
+extern unsigned long *bitmap_alloc(unsigned int nbits, gfp_t flags);
+extern unsigned long *bitmap_zalloc(unsigned int nbits, gfp_t flags);
+extern void bitmap_free(const unsigned long *bitmap);
+
+/*
  * lib/bitmap.c provides these functions:
  */
 
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -12,6 +12,7 @@
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <linux/bug.h>
+#include <linux/slab.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -1081,3 +1082,22 @@ void bitmap_copy_le(unsigned long *dst,
 }
 EXPORT_SYMBOL(bitmap_copy_le);
 #endif
+
+unsigned long *bitmap_alloc(unsigned int nbits, gfp_t flags)
+{
+	return kmalloc_array(BITS_TO_LONGS(nbits), sizeof(unsigned long),
+			     flags);
+}
+EXPORT_SYMBOL(bitmap_alloc);
+
+unsigned long *bitmap_zalloc(unsigned int nbits, gfp_t flags)
+{
+	return bitmap_alloc(nbits, flags | __GFP_ZERO);
+}
+EXPORT_SYMBOL(bitmap_zalloc);
+
+void bitmap_free(const unsigned long *bitmap)
+{
+	kfree(bitmap);
+}
+EXPORT_SYMBOL(bitmap_free);


