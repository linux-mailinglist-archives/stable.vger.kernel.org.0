Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A36014B8AA
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732814AbgA1O0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:26:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:53438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733150AbgA1O0I (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:26:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EA8224685;
        Tue, 28 Jan 2020 14:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221568;
        bh=UiVvcOxIJPdD8WM6VCX+s3qaxNYb/keReGTjo7C8E3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ao3ns2BRSHbmdWfPhnmjVpHIsd2hcWKZLuoKNJVdQeYRU9M80IB0HKuAgvGuy+APA
         ZZ/MzIsOozc0VnX1JNWBWP8rOc5rs0CfJnQVtrVxNK5zRY8jrM5ku+riZDUwEE5SBv
         LWz+Hw+6qxQgmzebeI4aMzgp4K1Ao1cXnRZdUfGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.9 269/271] bitmap: Add bitmap_alloc(), bitmap_zalloc() and bitmap_free()
Date:   Tue, 28 Jan 2020 15:06:58 +0100
Message-Id: <20200128135912.620442094@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
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
@@ -86,6 +86,14 @@
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
@@ -13,6 +13,7 @@
 #include <linux/bitops.h>
 #include <linux/bug.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/uaccess.h>
 
@@ -1212,3 +1213,22 @@ void bitmap_copy_le(unsigned long *dst,
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


